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

/**
 `ZOZolaZoomTransition` is an animated transition used extensively in the Zola iOS application.
 In addition to zooming a target view, it also animates the entire heirarchy in which the target
 view is a part of, resulting in a unique "z-level" animation effect. `ZOZolaZoomTransition`
 conforms to `UIViewControllerAnimatedTransitioning` and can be used for both navigation controller
 transitions and modal transitions.
 */
@interface ZOZolaZoomTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Initializes a `ZOZolaZoomTransition` object with a target view.
 
 This is the designated initializer.
 
 @param targetView The view to be zoomed
 @param type The animation type, presenting or dismissing
 @param duration The animation duration
 @param delegate The transition delegate
 
 @return The newly-initialized `ZOZolaZoomTransition` instance
 */
- (instancetype)initWithTargetView:(UIView *)targetView
                              type:(ZOTransitionType)type
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 Convienence initializer for some syntactical sugar.
 
 @param targetView The view to be zoomed
 @param type The animation type, presenting or dismissing
 @param duration The animation duration
 @param delegate The transition delegate
 
 @return The newly-initialized `ZOZolaZoomTransition` instance
 */
+ (instancetype)transitionFromView:(UIView *)targetView
                              type:(ZOTransitionType)type
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate;

/**
 The "fade-through" color used during the animation. Default is `[UIColor whiteColor]`.
 */
@property (strong, nonatomic) UIColor *backgroundColor;

@end

/**
 The delegate of `ZoZolaZoomTransition` must adopt the `ZOZolaZoomTransitionDelegate` protocol.
 Optional methods of the protocol allow the delegate to provide supplementary views to enhance
 the transition.
 */
@protocol ZOZolaZoomTransitionDelegate <NSObject>

@required

/**
 The starting frame for the target view. The coordinates for this frame must be returned relative
 to the fromViewController's view. For example:
 
 `return [targetView convertRect:targetView.bounds toView:fromViewController.view];`
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 @param targetView The target view
 @param fromViewController The "from" view controller
 @param toViewController The "to" view controller
 
 @return The starting frame for the target view, relative to the fromViewController's view
 */
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

/**
 The finishing frame for the target view. The coordinates for this frame must be returned relative
 to the toViewController's view. For example:
 
 `return [targetView convertRect:targetView.bounds toView:toViewController.view];`
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 @param targetView The target view
 @param fromViewController The "from" view controller
 @param toViewController The "to" view controller
 
 @return The finishing frame for the target view, relative to the toViewController's view
 */
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController;

@optional

- (NSArray *)supplementaryViewsForZolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition;

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)supplementaryView;

@end
