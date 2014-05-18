//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGStatusItemView.h"


@interface AGLoadingStatusItemView : AGStatusItemView

@property (nonatomic, assign, setter=setLoading:) BOOL isLoading;
@property (nonatomic, assign) float progress;

@end