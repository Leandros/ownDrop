//
//  AGCloudCommunication.h
//  DropCloud
//
//  Created by Arvid Gerstmann on 17/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGCloudCommunication : NSObject

#pragma mark - Properties -
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *remoteDirectoryPath;

#pragma mark - Initialization -
+ (id)sharedManager;

#pragma mark - Methods -
- (void)uploadFile:(NSString *)localFilePath
          progress:(void (^)(float percentCompleted))progressBlock
        completion:(void (^)(NSString *remoteFilePath, NSError *error))completionBlock;

- (void)shareFile:(NSString *)remoteFilePath
       completion:(void (^)(NSString *url, NSError *error))completionBlock;

@end
