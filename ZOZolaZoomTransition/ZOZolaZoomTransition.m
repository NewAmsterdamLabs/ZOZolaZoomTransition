//
//  ZOZolaZoomTransition.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZOZolaZoomTransition.h"

@interface UIView (ZolaZoomSnapshot)

/**
 * The screenshot APIs introduced in iOS7 only work when the target
 * view is already part of the hierarchy. We're defaulting to the newer
 * API whenever possible (especially since it's faster), but we're falling
 * back to this category whenever we need to snapshot a view that's
 * offscreen. As a general rule for ZOZolaZoomTransition, all views when
 * presenting are already in the hierarchy and can use the newer API. The
 * opposite is true when dismissing, so we rely on this category.
 *
 */
- (UIImage *)zo_snapshot;

@end

@implementation UIView (ZolaZoomSnapshot)

- (UIImage *)zo_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end

@interface ZOZolaZoomTransition ()

@property (weak, nonatomic) id<ZOZolaZoomTransitionDelegate> delegate;
@property (strong, nonatomic) UIView *targetView;
@property (assign, nonatomic) ZOTransitionType type;
@property (assign, nonatomic) NSTimeInterval duration;

@end

@implementation ZOZolaZoomTransition

#pragma mark - Constructors

- (instancetype)initWithTargetView:(UIView *)targetView
                              type:(ZOTransitionType)type
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.type = type;
        self.duration = duration;
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (instancetype)transitionFromView:(UIView *)targetView
                              type:(ZOTransitionType)type
                          duration:(NSTimeInterval)duration
                          delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    
    return [[[self class] alloc] initWithTargetView:targetView
                                               type:type
                                           duration:duration
                                           delegate:delegate];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // iOS7 and iOS8+ have different ways of obtaining the view from the view controller.
    // Here we're taking care of that inconsistency upfront, so we don't have to deal with
    // it later.
    UIView *fromControllerView = nil;
    UIView *toControllerView = nil;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        // iOS8+
        fromControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        // iOS7
        fromControllerView = fromViewController.view;
        toControllerView = toViewController.view;
    }
    
    // Setup a background view to prevent content from peeking through while our
    // animation is in progress
    UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
    backgroundView.backgroundColor = _backgroundColor;
    [containerView addSubview:backgroundView];
    
    // Ask the delegate for the target view's starting frame
    CGRect startFrame = [_delegate zolaZoomTransition:self
                                 startingFrameForView:_targetView
                                       relativeToView:fromControllerView
                                   fromViewController:fromViewController
                                     toViewController:toViewController];
    
    // Ask the delegate for the target view's finishing frame
    CGRect finishFrame = [_delegate zolaZoomTransition:self
                                 finishingFrameForView:_targetView
                                        relativeToView:toControllerView
                                    fromViewController:fromViewController
                                      toViewController:toViewController];
    
    if (_type == ZOTransitionTypePresenting) {
        // The "from" snapshot
        UIView *fromControllerSnapshot = [fromControllerView snapshotViewAfterScreenUpdates:NO];
        
        // The color view will sit between the "from" snapshot and the target snapshot.
        // This is what is used to create the fade effect.
        UIView *colorView = [[UIView alloc] initWithFrame:containerView.bounds];
        colorView.backgroundColor = _backgroundColor;
        colorView.alpha = 0.0;
        
        // The star of the show
        UIView *targetSnapshot = [_targetView snapshotViewAfterScreenUpdates:NO];
        targetSnapshot.frame = startFrame;
        
        // Check if the delegate provides any supplementary views
        NSArray *supplementaryViews = nil;
        if ([_delegate respondsToSelector:@selector(supplementaryViewsForZolaZoomTransition:)]) {
            NSAssert([_delegate respondsToSelector:@selector(zolaZoomTransition:frameForSupplementaryView:relativeToView:)], @"supplementaryViewsForZolaZoomTransition: requires zolaZoomTransition:frameForSupplementaryView:relativeToView: to be implemented by the delegate. Implement zolaZoomTransition:frameForSupplementaryView:relativeToView: and try again.");
            supplementaryViews = [_delegate supplementaryViewsForZolaZoomTransition:self];
        }

        // All supplementary snapshots are added to a container, and then the same transform
        // that we're going to apply to the "from" controller snapshot will be applied to the
        // supplementary container
        UIView *supplementaryContainer = [[UIView alloc] initWithFrame:containerView.bounds];
        supplementaryContainer.backgroundColor = [UIColor clearColor];
        for (UIView *supplementaryView in supplementaryViews) {
            UIView *supplementarySnapshot = [supplementaryView snapshotViewAfterScreenUpdates:NO];
            
            supplementarySnapshot.frame = [_delegate zolaZoomTransition:self
                                              frameForSupplementaryView:supplementaryView
                                                         relativeToView:fromControllerView];
            
            [supplementaryContainer addSubview:supplementarySnapshot];
        }
        
        // Assemble the hierarchy in the container
        [containerView addSubview:fromControllerSnapshot];
        [containerView addSubview:colorView];
        [containerView addSubview:targetSnapshot];
        [containerView addSubview:supplementaryContainer];
        
        // Determine how much we need to scale
        CGFloat scaleFactor = finishFrame.size.width / startFrame.size.width;
        
        // Calculate the ending origin point for the "from" snapshot taking into account the scale transformation
        CGPoint endPoint = CGPointMake((-startFrame.origin.x * scaleFactor) + finishFrame.origin.x, (-startFrame.origin.y * scaleFactor) + finishFrame.origin.y);
        
        // Animate presentation
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Move and transform the "from" snapshot
                             fromControllerSnapshot.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                             fromControllerSnapshot.frame = CGRectMake(endPoint.x, endPoint.y, fromControllerSnapshot.frame.size.width, fromControllerSnapshot.frame.size.height);
                             
                             // Move and transform the supplementary container with the "from" snapshot
                             supplementaryContainer.transform = fromControllerSnapshot.transform;
                             supplementaryContainer.frame = fromControllerSnapshot.frame;
                             
                             // Fade
                             colorView.alpha = 1.0;
                             supplementaryContainer.alpha = 0.0;
                             
                             // Move our target snapshot into position
                             targetSnapshot.frame = finishFrame;
                         } completion:^(BOOL finished) {
                             // Add "to" controller view
                             [containerView addSubview:toControllerView];
                             
                             // Cleanup our animation views
                             [backgroundView removeFromSuperview];
                             [fromControllerSnapshot removeFromSuperview];
                             [colorView removeFromSuperview];
                             [targetSnapshot removeFromSuperview];
                             
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                             
                             [transitionContext completeTransition:finished];
                         }];
    } else {
        // Since the "to" controller isn't currently part of the view hierarchy, we need to use the
        // old snapshot API
        UIImageView *toControllerSnapshot = [[UIImageView alloc] initWithImage:[toControllerView zo_snapshot]];
        
        // Used to perform the fade, just like when presenting
        UIView *colorView = [[UIView alloc] initWithFrame:containerView.bounds];
        colorView.backgroundColor = _backgroundColor;
        colorView.alpha = 1.0;
        
        // The star of the show again, this time with the old snapshot API
        UIImageView *targetSnapshot = [[UIImageView alloc] initWithImage:[_targetView zo_snapshot]];
        targetSnapshot.frame = startFrame;
        
        // Check if the delegate provides any supplementary views
        NSArray *supplementaryViews = nil;
        if ([_delegate respondsToSelector:@selector(supplementaryViewsForZolaZoomTransition:)]) {
            NSAssert([_delegate respondsToSelector:@selector(zolaZoomTransition:frameForSupplementaryView:relativeToView:)], @"supplementaryViewsForZolaZoomTransition: requires zolaZoomTransition:frameForSupplementaryView:relativeToView: to be implemented by the delegate. Implement zolaZoomTransition:frameForSupplementaryView:relativeToView: and try again.");
            supplementaryViews = [_delegate supplementaryViewsForZolaZoomTransition:self];
        }
        
        // Same as for presentation, except this time with the old snapshot API
        UIView *supplementaryContainer = [[UIView alloc] initWithFrame:containerView.bounds];
        supplementaryContainer.backgroundColor = [UIColor clearColor];
        for (UIView *supplementaryView in supplementaryViews) {
            UIImageView *supplementarySnapshot = [[UIImageView alloc] initWithImage:[supplementaryView zo_snapshot]];
            
            supplementarySnapshot.frame = [_delegate zolaZoomTransition:self
                                              frameForSupplementaryView:supplementaryView
                                                         relativeToView:toControllerView];
            
            [supplementaryContainer addSubview:supplementarySnapshot];
        }
        
        // We're switching the values such that the scale factor returns the same result
        // as when we were presenting
        CGFloat scaleFactor = startFrame.size.width / finishFrame.size.width;
        
        // This is also the same equation used when presenting and will result in the same point,
        // except this time it's the start point for the animation
        CGPoint startPoint = CGPointMake((-finishFrame.origin.x * scaleFactor) + startFrame.origin.x, (-finishFrame.origin.y * scaleFactor) + startFrame.origin.y);
        
        // Apply the transformation and set the origin before the animation begins
        toControllerSnapshot.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        toControllerSnapshot.frame = CGRectMake(startPoint.x, startPoint.y, toControllerSnapshot.frame.size.width, toControllerSnapshot.frame.size.height);
        
        // Apply the same starting position and transform to the supplementary container
        supplementaryContainer.transform = toControllerSnapshot.transform;
        supplementaryContainer.frame = toControllerSnapshot.frame;
        supplementaryContainer.alpha = 0.0;
        
        // Assemble the view hierarchy in the container
        [containerView addSubview:toControllerSnapshot];
        [containerView addSubview:colorView];
        [containerView addSubview:targetSnapshot];
        [containerView addSubview:supplementaryContainer];
        
        // Animate dismissal
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Put the "to" snapshot back to it's original state
                             toControllerSnapshot.transform = CGAffineTransformIdentity;
                             toControllerSnapshot.frame = toControllerView.frame;
                             
                             // Move and transform the supplementary container with the "to" snapshot
                             supplementaryContainer.transform = toControllerSnapshot.transform;
                             supplementaryContainer.frame = toControllerSnapshot.frame;
                             
                             // Fade
                             colorView.alpha = 0.0;
                             supplementaryContainer.alpha = 1.0;
                             
                             // Move the target snapshot into place
                             targetSnapshot.frame = finishFrame;
                         } completion:^(BOOL finished) {
                             // Add "to" controller view
                             [containerView addSubview:toControllerView];
                             
                             // Cleanup our animation views
                             [backgroundView removeFromSuperview];
                             [toControllerSnapshot removeFromSuperview];
                             [colorView removeFromSuperview];
                             [targetSnapshot removeFromSuperview];
                             
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                             
                             [transitionContext completeTransition:finished];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

@end
