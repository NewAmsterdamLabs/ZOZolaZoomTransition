//
//  ZOProductsViewController.h
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOZolaZoomTransition.h"

@interface ZOProductsViewController : UICollectionViewController <ZOZolaZoomTransitionDelegate, UINavigationControllerDelegate>

@end

@class ZOProduct;

@interface ZOProductCell : UICollectionViewCell

@property (strong, nonatomic) ZOProduct *product;
@property (strong, nonatomic, readonly) UIImageView *imageView;

@end
