//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGLoadingStatusItemView.h"
#import "AGLoadingView.h"

@interface AGLoadingStatusItemView()

@property (nonatomic, strong) AGLoadingView *loadingView;

@end

@implementation AGLoadingStatusItemView

- (id)init {
    self = [super init];
    if (self) {
        self.progress = 0.0f;
    }

    return self;
}

#pragma mark -
#pragma mark Drawing -

- (void)drawRect:(NSRect)dirtyRect {
    [self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];

    NSImage *icon;
    if (self.isLoading) {
        if (!self.loadingView) {
            self.loadingView = [[AGLoadingView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 18.0f, 18.0f)];
            self.loadingView.isDarkMode = true;
        }
        [self.loadingView setProgress:self.progress];
        icon = [self imageFromView:self.loadingView];
    } else if (self.isHighlighted || self.isDarkMode) {
        icon = self.highlightImage;
    } else {
        icon = self.image;
    }

    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((float) ((NSWidth(bounds) - iconSize.width) / 2));
    CGFloat iconY = roundf((float) ((NSHeight(bounds) - iconSize.height) / 2));
    NSPoint iconPoint = NSMakePoint(iconX, iconY);

    [icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (NSImage *)imageFromView:(NSView *)view {
    NSSize size = view.bounds.size;
    NSSize imgSize = NSMakeSize(size.width, size.height);

    NSBitmapImageRep *bir = [view bitmapImageRepForCachingDisplayInRect:[view bounds]];
    [bir setSize:imgSize];
    [view cacheDisplayInRect:[view bounds] toBitmapImageRep:bir];

    NSImage *image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bir];
    return image;
}


#pragma mark -
#pragma mark Mutator -

- (void)setLoading:(BOOL)isLoading {
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
        [self setNeedsDisplay:YES];
    }
}

- (void)setProgress:(float)progress {
    if (_progress != progress) {
        _progress = progress;
        if (self.isLoading) {
            [self setNeedsDisplay:YES];
        }
    }
}
@end