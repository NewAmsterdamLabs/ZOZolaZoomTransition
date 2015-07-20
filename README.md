# ZOZolaZoomTransition

`ZOZolaZoomTransition` is an animated transition used extensively in the Zola iOS application. In addition to zooming a target view, it also animates the entire heirarchy in which the target view is a part of, resulting in a unique "z-level" animation effect.

<p align="left">
<img src="demo_1.gif") alt="ZOZolaZoomTransition Demo"/>
</p>

## Example

1. Implement the `UINavigationControllerDelegate` method:

```objective-c
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    ZOTransitionType type = (fromVC == self) ? ZOTransitionTypePresenting : ZOTransitionTypeDismissing;
    
    return [ZOZolaZoomTransition transitionFromView:_selectedCell.imageView
                                               type:type
                                           duration:0.6
                                           delegate:self];
}
```

2. Implement the two required `ZOZolaZoomTransitionDelegate` methods:

```objective-c
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewController == self) {
        return [targetView convertRect:targetView.bounds toView:relativeView];
    } else if ([fromViewController isKindOfClass:[ZODetailViewController class]]) {
        ZODetailViewController *detailController = (ZODetailViewController *)fromViewController;
        return [detailController.imageView convertRect:detailController.imageView.bounds toView:relativeView];
    }

    return CGRectZero;
}

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController {
    
    if (toViewController == self) {
        return [targetView convertRect:targetView.bounds toView:relativeView];
    } else if ([toViewController isKindOfClass:[ZODetailViewController class]]) {
        ZODetailViewController *detailController = (ZODetailViewController *)toViewController;
        return [detailController.imageView convertRect:detailController.imageView.bounds toView:relativeView];
    }
    
    return CGRectZero;
}
```

## Supplementary Views

TBD

## Notes

TBD

## Requirements

`ZOZolaZoomTransition` requires iOS 7.0 or higher.

## License

`ZOZolaZoomTransition` is available under the MIT license. See the `LICENSE` file for more info.