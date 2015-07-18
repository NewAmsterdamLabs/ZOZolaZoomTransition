//
//  ZOZolaZoomTransition.h
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZOZolaZoomTransitionDelegate;

typedef NS_ENUM(NSInteger, ZOTransitionType) {
    ZOTransitionTypePresenting,
    ZOTransitionTypeDismissing
};

@interface ZOZolaZoomTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionFromView:(UIView *)targetView
                          duration:(NSTimeInterval)duration
                              type:(ZOTransitionType)type
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate;

@end

@protocol ZOZolaZoomTransitionDelegate <NSObject>

@required

+ (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)view
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

+ (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
     destinationFrameForView:(UIView *)view
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController;

@optional

+ (NSArray *)supplementaryViewsForZolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition;

+ (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)view;

@end
