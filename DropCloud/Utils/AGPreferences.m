//
//  AGPreferences.m
//  DropCloud
//
//  Created by Arvid Gerstmann on 31/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGPreferences.h"

@interface AGPreferences()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation AGPreferences

#pragma mark - Constants -
NSString *const kPrefSelfSignedCerts = @"kPrefSelfSignedCerts";
NSString *const kPrefServerUrl = @"kPrefServerUrl";
NSString *const kPrefServerPath = @"kPrefServerPath";

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kPrefServerUrl : @"",
                                                              kPrefServerPath : @"",
                                                              @"CredentialsStorage" : @""
                                                              }];
}

+ (instancetype)sharedInstance {
    static AGPreferences *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}


#pragma mark -
#pragma mark Accessor -
- (BOOL)allowSelfSignedSSLCerts {
    return [self.defaults boolForKey:kPrefSelfSignedCerts];
}

- (NSString *)baseURL {
    return [self.defaults stringForKey:kPrefServerUrl];
}

- (NSString *)remoteDirectoryPath {
    return [self.defaults stringForKey:kPrefServerPath];
}


#pragma mark -
#pragma mark Mutator -
- (void)setAllowSelfSignedSSLCerts:(BOOL)allowSelfSignedSSLCerts {
    [self.defaults setBool:allowSelfSignedSSLCerts forKey:kPrefSelfSignedCerts];
}

- (void)setBaseURL:(NSString *)baseURL {
    [self.defaults setObject:baseURL forKey:kPrefServerUrl];
}

- (void)setRemoteDirectoryPath:(NSString *)remoteDirectoryPath {
    [self.defaults setObject:remoteDirectoryPath forKey:kPrefServerPath];
}
@end
