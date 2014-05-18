//
//  NSString+Encode.m
//  DropCloud
//
//  Created by Arvid Gerstmann on 17/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)encodeString:(NSStringEncoding)encoding {

    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) self,
            NULL, (CFStringRef) @";?@&=$+{}<>,",
            CFStringConvertNSStringEncodingToEncoding(encoding));

    NSString *output = (NSString *) CFBridgingRelease(stringRef);
    int countCharactersAfterPercent = -1;

    for (int i = 0; i < [output length]; i++) {
        NSString *newString = [output substringWithRange:NSMakeRange(i, 1)];

        if (countCharactersAfterPercent >= 0) {
            output = [output stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[newString lowercaseString]];
            countCharactersAfterPercent++;
        }

        if ([newString isEqualToString:@"%"]) {
            countCharactersAfterPercent = 0;
        }

        if (countCharactersAfterPercent == 2) {
            countCharactersAfterPercent = -1;
        }
    }

    return output;
}

@end
