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
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) ZOTransitionType type;
@property (strong, nonatomic) UIView *targetView;

@property (strong, nonatomic) UIView *supplementaryContainer;
@property (strong, nonatomic) NSArray *supplementaryViews;
@property (strong, nonatomic) NSArray *supplementarySnapshots;

@end

@implementation ZOZolaZoomTransition

#pragma mark - Constructors

+ (instancetype)transitionFromView:(UIView *)targetView type:(ZOTransitionType)type duration:(NSTimeInterval)duration delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    ZOZolaZoomTransition *transition = [[[self class] alloc] init];
    transition.targetView = targetView;
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
        fromControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromControllerView = fromViewController.view;
        toControllerView = toViewController.view;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
    backgroundView.backgroundColor = self.backgroundColor;
    backgroundView.alpha = 1.0;
    [containerView addSubview:backgroundView];
    
    if (_type == ZOTransitionTypePresenting) {
        UIView *fromSnapshot = [fromControllerView snapshotViewAfterScreenUpdates:NO];
        
        CGRect startRect = [_delegate zolaZoomTransition:self startingFrameForView:_targetView relativeToContainer:containerView fromViewController:fromViewController toViewController:toViewController];
        CGRect finishRect = [_delegate zolaZoomTransition:self finishingFrameForView:_targetView relativeToContainer:containerView fromViewController:fromViewController toViewController:toViewController];
        
        CGFloat scaleFactor = finishRect.size.width / startRect.size.width;
        CGAffineTransform transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        
        CGPoint endOriginPoint = CGPointMake((-startRect.origin.x * scaleFactor) + finishRect.origin.x, (-startRect.origin.y * scaleFactor) + finishRect.origin.y);
        
        UIView *targetSnapshot = [_targetView snapshotViewAfterScreenUpdates:NO];
        targetSnapshot.frame = startRect;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:containerView.bounds];
        whiteView.backgroundColor = _backgroundColor;
        whiteView.alpha = 0.0;
        
        [containerView addSubview:fromSnapshot];
        [containerView addSubview:whiteView];
        [containerView addSubview:targetSnapshot];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             fromSnapshot.transform = transform;
                             fromSnapshot.frame = CGRectMake(endOriginPoint.x, endOriginPoint.y, fromSnapshot.frame.size.width, fromSnapshot.frame.size.height);
                             
                             whiteView.alpha = 1.0;
                             targetSnapshot.frame = finishRect;
                         } completion:^(BOOL finished) {
                             [containerView addSubview:toControllerView];
                             
                             [backgroundView removeFromSuperview];
                             [fromSnapshot removeFromSuperview];
                             [whiteView removeFromSuperview];
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
