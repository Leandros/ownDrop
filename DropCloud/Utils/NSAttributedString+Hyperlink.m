//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"


@implementation NSAttributedString (Hyperlink)

+ (id)hyperlinkFromString:(NSString *)inString withURL:(NSURL *)aURL attributes:(NSDictionary *)attr {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:inString attributes:attr];
    NSRange range = NSMakeRange(0, [attrString length]);

    [attrString beginEditing];

    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [attrString addAttribute: NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];

    [attrString endEditing];

    return attrString;
}

@end