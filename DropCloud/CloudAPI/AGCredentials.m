//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGCredentials.h"
#import "NSData+Base64.h"

@interface AGCredentials ()

@property (nonatomic, strong) NSString *credentials;

@end


@implementation AGCredentials
static AGCredentials *sharedInstance = nil;

+ (instancetype)credentials {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *credentials = [defaults objectForKey:@"CredentialsStorage"];
        if ([credentials length] > 0) {
            sharedInstance.credentials = credentials;
        }

    });

    return sharedInstance;
}


#pragma mark -
#pragma mark Mutator -

- (void)setName:(NSString *)name password:(NSString *)password {
    self.credentials = [self createCredentials:name password:password];
    [[NSUserDefaults standardUserDefaults] setObject:self.credentials forKey:@"CredentialsStorage"];
}


#pragma mark -
#pragma mark Private Methods -

- (NSString *)createCredentials:(NSString *)name password:(NSString *)password {
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", name, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];

    return authValue;
}

@end