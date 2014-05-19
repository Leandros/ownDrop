//
// Created by Arvid Gerstmann on 17/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGStatusItemView.h"

@interface AGStatusItemView () <NSMenuDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, assign, setter=setHighlighted:) BOOL isHighlighted;
@property (nonatomic, assign) SEL fileDroppedObserver;
@property (nonatomic, weak) id fileDroppedTarget;

@end

@implementation AGStatusItemView

#pragma mark -
#pragma mark Initialization -

- (id)initWithStatusItem:(NSStatusItem *)statusItem {
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);

    self = [self initWithFrame:itemRect];
    if (self) {
        self.statusItem = statusItem;
    }

    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }

    return self;
}


#pragma mark -
#pragma mark Dragging -

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    if ([[pasteboard types] containsObject:NSFilenamesPboardType]) {

        NSArray *paths = [pasteboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in paths) {
            NSError *error = nil;
            NSString *utiType = [[NSWorkspace sharedWorkspace] typeOfFile:path error:&error];
            if ([[NSWorkspace sharedWorkspace] type:utiType conformsToType:(id) kUTTypeFolder]) {
                return NSDragOperationNone;
            }
        }
    }

    return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    if (self.fileDroppedObserver && self.fileDroppedTarget) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.fileDroppedTarget performSelector:self.fileDroppedObserver withObject:sender];
#pragma clang diagnostic pop
    }

    return YES;
}


#pragma mark -
#pragma mark Observer -

- (void)addObserver:(SEL)observer withTarget:(id)target forEvent:(AGStatusItemEvent)event {
    switch (event) {
        case AGStatusItemEventFileDropped:
            self.fileDroppedObserver = observer;
            self.fileDroppedTarget = target;
            break;

        default:
            break;
    }
}


#pragma mark -
#pragma mark Mouse Events -

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    if (self.isHighlighted) {
        self.isHighlighted = NO;
    } else {
        self.isHighlighted = YES;
        if (self.menu) {
            [self.statusItem popUpStatusItemMenu:self.menu];
        }
    }
}


#pragma mark -
#pragma mark MenuDelegate -

- (void)menuWillOpen:(NSMenu *)menu {
    if (!self.isHighlighted) {
        self.isHighlighted = YES;
    }
}

- (void)menuDidClose:(NSMenu *)menu {
    if (self.isHighlighted) {
        self.isHighlighted = NO;
    }
}


#pragma mark -
#pragma mark Drawing -

- (void)drawRect:(NSRect)dirtyRect {
    [self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];

    NSImage *icon = self.isHighlighted ? self.highlightImage : self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((float) ((NSWidth(bounds) - iconSize.width) / 2));
    CGFloat iconY = roundf((float) ((NSHeight(bounds) - iconSize.height) / 2));
    NSPoint iconPoint = NSMakePoint(iconX, iconY);

    [icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}


#pragma mark -
#pragma mark Mutator -

- (void)setImage:(NSImage *)image {
    if (_image != image) {
        _image = image;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHighlightImage:(NSImage *)highlightImage {
    if (_highlightImage != highlightImage) {
        _highlightImage = highlightImage;
        if (self.isHighlighted) {
            [self setNeedsDisplay:YES];
        }
    }
}

- (void)setMenu:(NSMenu *)menu {
    if (_menu != menu) {
        _menu = menu;
        _menu.delegate = self;
    }
}

- (void)setHighlighted:(BOOL)isHighlighted {
    if (_isHighlighted != isHighlighted) {
        _isHighlighted = isHighlighted;
        [self setNeedsDisplay:YES];
    }
}

@end