//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)

+ (id)hyperlinkFromString:(NSString *)inString withURL:(NSURL *)aURL attributes:(NSDictionary *)attr;

@end