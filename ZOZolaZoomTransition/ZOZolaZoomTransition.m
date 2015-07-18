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
@property (assign, nonatomic) CGRect startTargetRect;
@property (assign, nonatomic) CGFloat scaleFactor;
@property (assign, nonatomic) CGPoint endOriginPoint;
@property (assign, nonatomic) CGAffineTransform transform;
@property (strong, nonatomic) UIView *targetView;
@property (strong, nonatomic) UIView *supplementaryContainer;
@property (strong, nonatomic) NSArray *supplementaryViews;
@property (strong, nonatomic) NSArray *supplementarySnapshots;

@end

@implementation ZOZolaZoomTransition

#pragma mark - Constructors

+ (instancetype)transitionFromView:(UIView *)targetView duration:(NSTimeInterval)duration delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    return [self transitionFromView:targetView supplementaryViews:nil duration:duration delegate:delegate];
}

+ (instancetype)transitionFromView:(UIView *)targetView supplementaryViews:(NSArray *)supplementaryViews duration:(NSTimeInterval)duration delegate:(id<ZOZolaZoomTransitionDelegate>)delegate {
    ZOZolaZoomTransition *transition = [[[self class] alloc] init];
    transition.targetView = targetView;
    transition.supplementaryViews = supplementaryViews;
    transition.duration = duration;
    transition.delegate = delegate;
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
    
    if (self.isPresenting) {
        
    } else {
        
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

@end
