//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGLoadingView.h"


@implementation AGLoadingView

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *emptyDropPath = NSBezierPath.bezierPath;
    [emptyDropPath moveToPoint:NSMakePoint(9, 16)];
    [emptyDropPath lineToPoint:NSMakePoint(13.4, 7.62)];
    [emptyDropPath curveToPoint:NSMakePoint(13.34, 7.18) controlPoint1:NSMakePoint(13.4, 7.62) controlPoint2:NSMakePoint(13.38, 7.46)];
    [emptyDropPath curveToPoint:NSMakePoint(12.11, 3.84) controlPoint1:NSMakePoint(13.56, 6) controlPoint2:NSMakePoint(13.15, 4.75)];
    [emptyDropPath curveToPoint:NSMakePoint(5.89, 3.84) controlPoint1:NSMakePoint(10.39, 2.34) controlPoint2:NSMakePoint(7.61, 2.34)];
    [emptyDropPath curveToPoint:NSMakePoint(4.65, 7.18) controlPoint1:NSMakePoint(4.85, 4.75) controlPoint2:NSMakePoint(4.44, 6)];
    [emptyDropPath curveToPoint:NSMakePoint(4.6, 7.62) controlPoint1:NSMakePoint(4.62, 7.46) controlPoint2:NSMakePoint(4.6, 7.62)];
    [emptyDropPath lineToPoint:NSMakePoint(9, 16)];
    [emptyDropPath lineToPoint:NSMakePoint(9, 16)];
    [emptyDropPath closePath];
    [NSColor.blackColor setStroke];
    [emptyDropPath setLineWidth:1];
    [emptyDropPath stroke];

    int height = (int) (13 * (self.progress / 100));
    NSBezierPath *bezier2Path = NSBezierPath.bezierPath;

    if (height == 1) {
        [bezier2Path moveToPoint: NSMakePoint(11.66, 3.5)];
        [bezier2Path curveToPoint: NSMakePoint(6.34, 3.5) controlPoint1: NSMakePoint(10.09, 2.45) controlPoint2: NSMakePoint(7.91, 2.45)];
        [bezier2Path lineToPoint: NSMakePoint(11.66, 3.5)];
        [bezier2Path closePath];

    } else if (height == 2) {
        [bezier2Path moveToPoint: NSMakePoint(12.71, 4.5)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(12.54, 4.27) controlPoint2: NSMakePoint(12.34, 4.05)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(5.29, 4.5) controlPoint1: NSMakePoint(5.66, 4.05) controlPoint2: NSMakePoint(5.46, 4.27)];
        [bezier2Path lineToPoint: NSMakePoint(12.71, 4.5)];
        [bezier2Path closePath];

    } else if (height == 3) {
        [bezier2Path moveToPoint: NSMakePoint(13.23, 5.5)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.03, 4.89) controlPoint2: NSMakePoint(12.66, 4.32)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.77, 5.5) controlPoint1: NSMakePoint(5.34, 4.32) controlPoint2: NSMakePoint(4.97, 4.89)];
        [bezier2Path lineToPoint: NSMakePoint(13.23, 5.5)];
        [bezier2Path closePath];

    } else if (height == 4) {
        [bezier2Path moveToPoint: NSMakePoint(13.4, 6.5)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.38, 5.54) controlPoint2: NSMakePoint(12.95, 4.58)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 6.5) controlPoint1: NSMakePoint(5.05, 4.58) controlPoint2: NSMakePoint(4.62, 5.54)];
        [bezier2Path lineToPoint: NSMakePoint(13.4, 6.5)];
        [bezier2Path closePath];

    } else if (height == 5) {
        [bezier2Path moveToPoint: NSMakePoint(13.38, 7.47)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.38, 7.42) controlPoint2: NSMakePoint(13.36, 7.32)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.62, 7.5) controlPoint1: NSMakePoint(4.64, 7.32) controlPoint2: NSMakePoint(4.62, 7.42)];
        [bezier2Path lineToPoint: NSMakePoint(13.38, 7.5)];
        [bezier2Path lineToPoint: NSMakePoint(13.38, 7.47)];
        [bezier2Path closePath];

    } else if (height == 6) {
        [bezier2Path moveToPoint: NSMakePoint(12.94, 8.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(13.22, 7.96) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(5.06, 8.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(4.78, 7.96)];
        [bezier2Path lineToPoint: NSMakePoint(12.94, 8.5)];
        [bezier2Path closePath];

    } else if (height == 7) {
        [bezier2Path moveToPoint: NSMakePoint(12.41, 9.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(12.99, 8.41) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(5.59, 9.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(5.01, 8.41)];
        [bezier2Path lineToPoint: NSMakePoint(12.41, 9.5)];
        [bezier2Path closePath];

    } else if (height == 8) {
        [bezier2Path moveToPoint: NSMakePoint(11.89, 10.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(12.72, 8.92) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(6.11, 10.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(5.28, 8.92)];
        [bezier2Path lineToPoint: NSMakePoint(11.89, 10.5)];
        [bezier2Path closePath];

    } else if (height == 9) {
        [bezier2Path moveToPoint: NSMakePoint(11.36, 11.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(12.41, 9.51) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(6.64, 11.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(5.59, 9.51)];
        [bezier2Path lineToPoint: NSMakePoint(11.36, 11.5)];
        [bezier2Path closePath];

    } else if (height == 10) {
        [bezier2Path moveToPoint: NSMakePoint(13.38, 7.65)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(7.16, 12.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(5.96, 10.2)];
        [bezier2Path lineToPoint: NSMakePoint(10.84, 12.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(12.04, 10.2) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path lineToPoint: NSMakePoint(13.38, 7.65)];
        [bezier2Path closePath];

    } else if (height == 11) {
        [bezier2Path moveToPoint: NSMakePoint(13.38, 7.66)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(7.69, 13.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(6.39, 11.03)];
        [bezier2Path lineToPoint: NSMakePoint(10.31, 13.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(11.61, 11.03) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path lineToPoint: NSMakePoint(13.38, 7.66)];
        [bezier2Path closePath];

    } else if (height == 12) {
        [bezier2Path moveToPoint: NSMakePoint(13.38, 7.65)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(8.21, 14.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(6.95, 12.09)];
        [bezier2Path lineToPoint: NSMakePoint(9.79, 14.5)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(11.05, 12.09) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path lineToPoint: NSMakePoint(13.38, 7.65)];
        [bezier2Path closePath];

    } else if (height == 13) {
        [bezier2Path moveToPoint: NSMakePoint(9.29, 15.46)];
        [bezier2Path curveToPoint: NSMakePoint(13.4, 7.62) controlPoint1: NSMakePoint(10.21, 13.7) controlPoint2: NSMakePoint(13.4, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(13.34, 7.18) controlPoint1: NSMakePoint(13.4, 7.62) controlPoint2: NSMakePoint(13.38, 7.46)];
        [bezier2Path curveToPoint: NSMakePoint(12.11, 3.84) controlPoint1: NSMakePoint(13.56, 6) controlPoint2: NSMakePoint(13.15, 4.75)];
        [bezier2Path curveToPoint: NSMakePoint(5.89, 3.84) controlPoint1: NSMakePoint(10.39, 2.34) controlPoint2: NSMakePoint(7.61, 2.34)];
        [bezier2Path curveToPoint: NSMakePoint(4.65, 7.18) controlPoint1: NSMakePoint(4.85, 4.75) controlPoint2: NSMakePoint(4.44, 6)];
        [bezier2Path curveToPoint: NSMakePoint(4.6, 7.62) controlPoint1: NSMakePoint(4.62, 7.46) controlPoint2: NSMakePoint(4.6, 7.62)];
        [bezier2Path curveToPoint: NSMakePoint(8.74, 15.5) controlPoint1: NSMakePoint(4.6, 7.62) controlPoint2: NSMakePoint(7.79, 13.7)];
        [bezier2Path lineToPoint: NSMakePoint(9.26, 15.5)];
        [bezier2Path lineToPoint: NSMakePoint(9.29, 15.46)];
        [bezier2Path closePath];
    }

    [NSColor.blackColor setFill];
    [bezier2Path fill];
    [NSColor.blackColor setStroke];
    [bezier2Path setLineWidth:1];
    [bezier2Path stroke];
}

- (void)setProgress:(float)progress {
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay:YES];
    }
}
@end