//
//  AGPreferences.m
//  DropCloud
//
//  Created by Arvid Gerstmann on 31/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGPreferences.h"

@implementation AGPreferences

#pragma mark - Constants -
NSString *const kPrefSelfSignedCerts = @"kPrefSelfSignedCerts";

+ (instancetype)sharedInstance {
    static AGPreferences *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}


#pragma mark -
#pragma mark Accessor -
- (BOOL)allowSelfSignedSSLCerts {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPrefSelfSignedCerts];
}


#pragma mark -
#pragma mark Mutator -
- (void)setAllowSelfSignedSSLCerts:(BOOL)allowSelfSignedSSLCerts {
    [[NSUserDefaults standardUserDefaults] setBool:allowSelfSignedSSLCerts forKey:kPrefSelfSignedCerts];
}
@end
