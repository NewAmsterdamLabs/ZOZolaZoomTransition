# ZOZolaZoomTransition

`ZOZolaZoomTransition` is an animated transition used extensively in the Zola iOS application. In addition to zooming a target view, it also animates the entire heirarchy in which the target view is a part of, resulting in a fluid "z-level" animation effect.

<p align="left">
<img src="Demo/demo_1.gif") alt="ZOZolaZoomTransition Demo"/>
</p>

## Example

`ZOZolaZoomTransition` ships with a fully functional demo project, but below are the basic implementation steps. Assume a typical "Master-Detail" scenario where the "master" controller contains a collection view, and the "detail" controller displays addional information when a cell is selected:

1. Implement the `UINavigationControllerDelegate` method:

```objective-c
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController     
                                   animationControllerForOperation:(UINavigationControllerOperation)operation 
                                                fromViewController:(UIViewController *)fromVC 
                                                  toViewController:(UIViewController *)toVC {
    
    // Determine if we're presenting or dismissing
    ZOTransitionType type = (fromVC == self) ? ZOTransitionTypePresenting : ZOTransitionTypeDismissing;
    
    // Create a transition instance with the selected cell's imageView as the target view
    ZOZolaZoomTransition *zoomTransition = [ZOZolaZoomTransition transitionFromView:_selectedCell.imageView
                                                                               type:type
                                                                           duration:0.5
                                                                           delegate:self];
    
    return zoomTransition;
}
```

2. Implement the two required `ZOZolaZoomTransitionDelegate` methods to provide the starting and finishing frames for the target view (see `ZOZolaZolaZoomTransition.h` for detailed documentation):

```objective-c
- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewController == self) {
        // We're pushing to the detail controller. The starting frame is taken from the selected cell's imageView.
        return [_selectedCell.imageView convertRect:_selectedCell.imageView.bounds toView:relativeView];
    } else if ([fromViewController isKindOfClass:[ZODetailViewController class]]) {
        // We're popping back to this master controller. The starting frame is taken from the detailController's imageView.
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
    
    if (fromViewComtroller == self) {
        // We're pushing to the detail controller. The finishing frame is taken from the detailController's imageView.
        ZODetailViewController *detailController = (ZODetailViewController *)toViewController;
        return [detailController.imageView convertRect:detailController.imageView.bounds toView:relativeView];
    } else if ([fromViewComtroller isKindOfClass:[ZODetailViewController class]]) {
        // We're popping back to this master controller. The finishing frame is taken from the selected cell's imageView.
        return [_selectedCell.imageView convertRect:_selectedCell.imageView.bounds toView:relativeView];
    }
    
    return CGRectZero;
}
```

## Supplementary Views

TBD

## Limitations

TBD

## Requirements

`ZOZolaZoomTransition` requires iOS 7.0 or higher.

## License

`ZOZolaZoomTransition` is available under the MIT license. See the `LICENSE` file for more info.