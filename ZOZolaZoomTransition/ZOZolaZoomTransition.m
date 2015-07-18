//
//  ZOZolaZoomTransition.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZOZolaZoomTransition.h"

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
    
    if (_type == ZOTransitionTypePresenting) {
        UIView *fromControllerSnapshot = [fromControllerView snapshotViewAfterScreenUpdates:NO];
        
        CGRect startRect = [_delegate zolaZoomTransition:self startingFrameForView:_targetView fromViewController:fromViewController toViewController:toViewController];
        CGRect finishRect = [_delegate zolaZoomTransition:self finishingFrameForView:_targetView fromViewController:fromViewController toViewController:toViewController];
        
        CGFloat scaleFactor = finishRect.size.width / startRect.size.width;
        CGAffineTransform transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        
        CGPoint endOriginPoint = CGPointMake((-startRect.origin.x * scaleFactor) + finishRect.origin.x, (-startRect.origin.y * scaleFactor) + finishRect.origin.y);
        
        UIView *targetSnapshot = [_targetView snapshotViewAfterScreenUpdates:NO];
        targetSnapshot.frame = startRect;
        
        UIView *colorView = [[UIView alloc] initWithFrame:containerView.bounds];
        colorView.backgroundColor = _backgroundColor;
        colorView.alpha = 0.0;
        
        [containerView addSubview:fromControllerSnapshot];
        [containerView addSubview:colorView];
        [containerView addSubview:targetSnapshot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             fromControllerSnapshot.transform = transform;
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
        
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

@end
