//
//  ZOZolaZoomTransition.h
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZOZolaZoomTransitionDelegate;

@interface ZOZolaZoomTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL isPresenting;

+ (instancetype)transitionFromView:(UIView *)fromView
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate;

@end

@protocol ZOZolaZoomTransitionDelegate <NSObject>

@required

+ (CGRect)zoomTransition:(ZOZolaZoomTransition *)zoomTransition destinationRectForView:(UIView *)view;
+ (CGRect)zoomTransition:(ZOZolaZoomTransition *)zoomTransition startingRectForView:(UIView *)view;

@end
