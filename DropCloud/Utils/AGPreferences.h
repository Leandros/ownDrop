//
//  AGPreferences.h
//  DropCloud
//
//  Created by Arvid Gerstmann on 31/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGPreferences : NSObject

+ (instancetype)sharedInstance;


#pragma mark - Properties -
@property (nonatomic, assign) BOOL allowSelfSignedSSLCerts;

@end
