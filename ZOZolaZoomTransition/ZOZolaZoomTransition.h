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

+ (instancetype)transitionFromView:(UIView *)targetView
                          duration:(NSTimeInterval)duration
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

+ (NSArray *)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
supplementaryViewsFromViewController:(UIViewController *)fromViewController
               toViewController:(UIViewController *)toViewController;

+ (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)view
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController;

@end
