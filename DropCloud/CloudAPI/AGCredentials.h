//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AGCredentials : NSObject

@property (nonatomic, strong, readonly) NSString *credentials;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *password;

+ (instancetype)credentials;

- (void)setName:(NSString *)name password:(NSString *)password;

@end