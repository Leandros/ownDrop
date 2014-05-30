//
//  AGCloudCommunication.m
//  DropCloud
//
//  Created by Arvid Gerstmann on 17/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGCloudCommunication.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Encode.h"
#import "Ono.h"
#import "AGCredentials.h"

@interface AGCloudCommunication ()

@property (nonatomic, copy) void (^progressBlock)(float percentCompleted);

@end

@implementation AGCloudCommunication

#pragma mark -
#pragma mark Initialization -

+ (id)sharedManager {
    static AGCloudCommunication *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}


#pragma mark -
#pragma mark Public Methods -

- (void)uploadFile:(NSString *)localFilePath
          progress:(void (^)(float percentCompleted))progressBlock
        completion:(void (^)(NSString *remoteFilePath, NSError *error))completionBlock {

    if (!self.baseUrl) {
        NSLog(@"%s | no baseURL", __PRETTY_FUNCTION__);

        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = NSLocalizedString(@"nobaseurl", nil);
        notification.informativeText = NSLocalizedString(@"nobaseurlinfo", nil);

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }

    NSString *imagePath;
    if ([self.remoteDirectoryPath length] > 0) {
        imagePath = [NSString stringWithFormat:@"%@/%@", self.remoteDirectoryPath ?: @"", localFilePath.lastPathComponent];
    } else {
        imagePath = localFilePath.lastPathComponent;
    }
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@%@", self.baseUrl, @"/remote.php/webdav/", imagePath];
    serverUrl = [serverUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    serverUrl = [serverUrl encodeString:NSUTF8StringEncoding];

    NSLog(@"%s | serverUrl: %@", __PRETTY_FUNCTION__, serverUrl);
    NSURLRequest *request = [self requestWithMethod:@"PUT" url:serverUrl body:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request
                                                               fromFile:[NSURL URLWithString:localFilePath]
                                                               progress:&progress
                                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                completionBlock(imagePath, error);
            }];

    [uploadTask resume];
    self.progressBlock = progressBlock;
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:0 context:NULL];
}

- (void)shareFile:(NSString *)remoteFilePath
       completion:(void (^)(NSString *url, NSError *error))completionBlock {

    if (!self.baseUrl) {
        NSLog(@"%s | no baseURL", __PRETTY_FUNCTION__);

        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = NSLocalizedString(@"nobaseurl", nil);
        notification.informativeText = NSLocalizedString(@"nobaseurlinfo", nil);

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }

    NSString *serverUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl, @"/ocs/v1.php/apps/files_sharing/api/v1/shares"];
    NSString *postBody = [NSString stringWithFormat:@"path=%@&shareType=3", remoteFilePath];
    NSURLRequest *request = [self requestWithMethod:@"POST" url:serverUrl body:postBody];

    NSLog(@"%s | serverURL: %@", __PRETTY_FUNCTION__, serverUrl);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager setResponseSerializer:[AFXMLDocumentResponseSerializer serializer]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *url;
        if (!error) {
            NSXMLDocument *xmlDocument = responseObject;
            NSData *xmlData = [xmlDocument XMLData];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:xmlData error:nil];
            url = [[[document.rootElement firstChildWithTag:@"data"] firstChildWithTag:@"url"] stringValue];
        }

        completionBlock(url, error);
    }];

    [dataTask resume];
}


#pragma mark -
#pragma mark Private Methods -

- (NSURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url body:(NSString *)postBody {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:nil error:nil];

    AGCredentials *credentials = [AGCredentials credentials];
    [request setValue:credentials.credentials forHTTPHeaderField:@"Authorization"];
    [request addValue:@"true" forHTTPHeaderField:@"OCS-APIREQUEST"];
    if ([postBody length] > 0) {
        [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    }

    return request;
}


#pragma mark -
#pragma mark KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *) object;
        self.progressBlock((float) (progress.fractionCompleted * 100));
    }
}
@end
