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
 conforms to `UIViewControllerAnimatedTransitioning` and is intended to be used with navigation
 controller transitions.
 */
@interface ZOZolaZoomTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 Initializes a `ZOZolaZoomTransition` instance with a target view.
 
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
 Convienence initializer for syntactical sugar.
 
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
 @warning Only the designated initializer or the convienece initializer
 should be used to create a new `ZOZolaZoomTransition` instance
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 The "fade-through" color used during the animation. Default is `[UIColor whiteColor]`.
 */
@property (strong, nonatomic) UIColor *backgroundColor;

@end

/**
 The delegate of `ZOZolaZoomTransition` must adopt the `ZOZolaZoomTransitionDelegate` protocol.
 Optional methods of the protocol allow the delegate to provide supplementary views to enhance
 the transition.
 */
@protocol ZOZolaZoomTransitionDelegate <NSObject>

@required

/**
 The starting frame for the target view. This frame must be returned relative to the
 fromViewController's view. For convienence, this view is provided explicitly.
 For example:
 
 `return [targetView convertRect:targetView.bounds toView:relativeView];`
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 @param targetView The target view
 @param relativeView The "from" view controller's view
 @param fromViewController The "from" view controller
 @param toViewController The "to" view controller
 
 @return The starting frame for the target view, relative to the fromViewController's view
 */
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController;

/**
 The finishing frame for the target view. This frame must be returned relative to the
 toViewController's view. For convienence, this view is provided explicitly.
 For example, consider the scenario where the targetView is zooming to the frame of
 some arbitrary destination view in the "to" view controller's view:
 
 `return [destinationView convertRect:destinationView.bounds toView:relativeView];`
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 @param targetView The target view
 @param relativeView The "to" view controller's view
 @param fromViewController The "from" view controller
 @param toViewController The "to" view controller
 
 @return The finishing frame for the target view, relative to the toViewController's view
 */
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController;

@optional

/**
 `ZOZolaZoomTransition` supports an optional array of supplementary views that will be drawn
 on top of, and animated with, the other views in the animation. Two common use cases for 
 supplementary views are:
 
 1. To draw views that are on top of, but not a child of, the target view.
 2. To draw views that are clipped by the edge of the screen when the transition begins
    and therefore appear cut off during the animation.
 
 @warning If `supplementaryViewsForZolaZoomTransition:` is implemented,
 `zolaZoomTransition:frameForSupplementaryView:` must be implemented as well.
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 
 @return The array of supplementary views
 */
- (NSArray *)supplementaryViewsForZolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition;

/**
 The frame for a supplementary view. This frame must be returned relative to the originating
 view controller's view. The originating view controller is the "from" view controller during
 presentation, and the "to" view controller during dismissal. For convienence, this view is
 provided explicitly. For example:
 
 `return [supplementaryView convertRect:supplementaryView.bounds toView:relativeView];`
 
 @param zoomTransition The `ZOZolaZoomTransition` instance
 @param supplementaryView The supplementary view
 @param relativeView The originating view controller's view
 
 @return The frame for the supplementary view, relative to the originating view controller's view
 */
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)supplementaryView
              relativeToView:(UIView *)relativeView;

@end
