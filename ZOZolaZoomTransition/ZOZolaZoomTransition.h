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
                              type:(ZOTransitionType)type
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate;

@property (strong, nonatomic) UIColor *backgroundColor;

@end

@protocol ZOZolaZoomTransitionDelegate <NSObject>

@required

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
         relativeToContainer:(UIView *)containerView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
         relativeToContainer:(UIView *)containerView
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController;

@optional

- (NSArray *)supplementaryViewsForZolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
                                 relativeToContainer:(UIView *)containerView;

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)supplementaryView
         relativeToContainer:(UIView *)containerView;

@end
