//
// Created by Arvid Gerstmann on 17/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGStatusItemView : NSView

#define STATUS_ITEM_VIEW_WIDTH 24.0f
typedef NS_ENUM(NSUInteger, AGStatusItemEvent) {
    AGStatusItemEventFileDropped
};

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *highlightImage;
@property (nonatomic, assign, readonly) BOOL isHighlighted;
@property (nonatomic) BOOL isDarkMode;

- (id)initWithStatusItem:(NSStatusItem *)statusItem;
- (void)addObserver:(SEL)observer withTarget:(id)target forEvent:(AGStatusItemEvent)event;

@end