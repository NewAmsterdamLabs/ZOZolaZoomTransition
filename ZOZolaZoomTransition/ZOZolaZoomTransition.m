//
//  ZOZolaZoomTransition.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZOZolaZoomTransition.h"

@interface UIView (ZolaSnapshot)

- (UIImage *)zo_snapshot;

@end

@implementation UIView (ZolaSnapshot)

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

+ (instancetype)transitionFromView:(UIView *)targetView type:(ZOTransitionType)type duration:(NSTimeInterval)duration delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    ZOZolaZoomTransition *transition = [[[self class] alloc] init];
    transition.targetView = targetView;
    transition.type = type;
    transition.duration = duration;
    transition.delegate = delegate;
    transition.backgroundColor = [UIColor whiteColor];
    return transition;
}

#pragma mark - UIViewControllerAnimatedTransitioning Methods

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
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
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
    backgroundView.backgroundColor = _backgroundColor;
    backgroundView.alpha = 1.0;
    [containerView addSubview:backgroundView];
    
    CGRect startRect = [_delegate zolaZoomTransition:self
                                startingFrameForView:_targetView
                                  fromViewController:fromViewController
                                    toViewController:toViewController];
    
    CGRect finishRect = [_delegate zolaZoomTransition:self
                                finishingFrameForView:_targetView
                                   fromViewController:fromViewController
                                     toViewController:toViewController];
    
    if (_type == ZOTransitionTypePresenting) {
        CGFloat scaleFactor = finishRect.size.width / startRect.size.width;
        CGPoint endOriginPoint = CGPointMake((-startRect.origin.x * scaleFactor) + finishRect.origin.x, (-startRect.origin.y * scaleFactor) + finishRect.origin.y);
        
        UIView *colorView = [[UIView alloc] initWithFrame:containerView.bounds];
        colorView.backgroundColor = _backgroundColor;
        colorView.alpha = 0.0;
        
        UIView *targetSnapshot = [_targetView snapshotViewAfterScreenUpdates:NO];
        targetSnapshot.frame = startRect;
        
        UIView *fromControllerSnapshot = [fromControllerView snapshotViewAfterScreenUpdates:NO];
        
        [containerView addSubview:fromControllerSnapshot];
        [containerView addSubview:colorView];
        [containerView addSubview:targetSnapshot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             fromControllerSnapshot.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                             fromControllerSnapshot.frame = CGRectMake(endOriginPoint.x, endOriginPoint.y, fromControllerSnapshot.frame.size.width, fromControllerSnapshot.frame.size.height);
                             
                             colorView.alpha = 1.0;
                             targetSnapshot.frame = finishRect;
                         } completion:^(BOOL finished) {
                             [containerView addSubview:toControllerView];
                             
                             [backgroundView removeFromSuperview];
                             [fromControllerSnapshot removeFromSuperview];
                             [colorView removeFromSuperview];
                             [targetSnapshot removeFromSuperview];
                             
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                             
                             [transitionContext completeTransition:finished];
                         }];
    } else {
        CGFloat scaleFactor = startRect.size.width / finishRect.size.width;
        CGPoint startOriginPoint = CGPointMake((-finishRect.origin.x * scaleFactor) + startRect.origin.x, (-finishRect.origin.y * scaleFactor) + startRect.origin.y);
        
        UIImageView *targetSnapshot = [[UIImageView alloc] initWithImage:[_targetView zo_snapshot]];
        targetSnapshot.frame = startRect;
        
        UIView *colorView = [[UIView alloc] initWithFrame:containerView.bounds];
        colorView.backgroundColor = _backgroundColor;
        colorView.alpha = 1.0;
        
        UIImageView *toControllerSnapshot = [[UIImageView alloc] initWithImage:[toControllerView zo_snapshot]];;
        
        toControllerSnapshot.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        toControllerSnapshot.frame = CGRectMake(startOriginPoint.x, startOriginPoint.y, toControllerSnapshot.frame.size.width, toControllerSnapshot.frame.size.height);
        
        [containerView addSubview:toControllerSnapshot];
        [containerView addSubview:colorView];
        [containerView addSubview:targetSnapshot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             toControllerSnapshot.transform = CGAffineTransformIdentity;
                             toControllerSnapshot.frame = toControllerView.frame;
                             
                             colorView.alpha = 0.0;
                             targetSnapshot.frame = finishRect;
                         } completion:^(BOOL finished) {
                             [containerView addSubview:toControllerView];
                             
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
