//
//  ZOProductsViewController.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZOProductsViewController.h"
#import "ZODetailViewController.h"
#import "ZOProduct.h"

static NSString * ZOProductCellId           = @"ZOProductCell";
static CGFloat ZOProductCellMargin          = 10.0;
static CGFloat ZOProductCellSpacing         = 10.0;
static CGFloat ZOProductCellTextAreaHeight  = 40.0;

@interface ZOProductsViewController ()

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) ZOProductCell *selectedCell;

@end

@implementation ZOProductsViewController

#pragma mark - Constructors

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    // Load demo data
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSInteger i=0; i<10; i++) {
        ZOProduct *product = [[ZOProduct alloc] init];
        product.title = [NSString stringWithFormat:@"Product %ld", i];
        product.imageName = [NSString stringWithFormat:@"product_%ld.jpg", i];
        [products addObject:product];
    }
    self.products = products;
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    [self.collectionView registerClass:[ZOProductCell class] forCellWithReuseIdentifier:ZOProductCellId];
}

#pragma mark - Helpers

- (NSArray *)clippedCells {
    // Here we're returning all UICollectionViewCells that are clipped by the edge
    // of the screen. These will be used as "supplementary views" so that the clipped
    // cells will be drawn in their entirety rather than appearing cut off during the
    // transition animation.
    
    NSMutableArray *clippedCells = [NSMutableArray arrayWithCapacity:[[self.collectionView visibleCells] count]];
    for (UICollectionViewCell *visibleCell in self.collectionView.visibleCells) {
        CGRect convertedRect = [visibleCell convertRect:visibleCell.bounds toView:self.view];
        if (!CGRectContainsRect(self.view.frame, convertedRect)) {
            [clippedCells addObject:visibleCell];
        }
    }
    return clippedCells;
}

#pragma mark - UICollectionViewDelegate & Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_products count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZOProductCell *productCell = (ZOProductCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ZOProductCellId forIndexPath:indexPath];
    productCell.product = _products[indexPath.row];
    return productCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCell = (ZOProductCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ZODetailViewController *detailController = [[ZODetailViewController alloc] initWithProduct:_products[indexPath.row]];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Cell width is half the screen width - edge margin - half the center margin
    CGFloat width = (self.collectionView.frame.size.width / 2.0) - ZOProductCellMargin - (ZOProductCellSpacing / 2.0);
    return CGSizeMake(width, width + ZOProductCellTextAreaHeight);
}

#pragma mark - UICollectionViewDelegateFlowLayout Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(ZOProductCellMargin, ZOProductCellMargin, ZOProductCellMargin, ZOProductCellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ZOProductCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ZOProductCellSpacing;
}

#pragma mark - UINavigationControllerDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // Sanity
    if (fromVC != self && toVC != self) return nil;
    
    // Determine if we're presenting or dismissing
    ZOTransitionType type = (fromVC == self) ? ZOTransitionTypePresenting : ZOTransitionTypeDismissing;
    
    // Create the transition
    ZOZolaZoomTransition *zoomTransition = [ZOZolaZoomTransition transitionFromView:_selectedCell.imageView
                                                                               type:type
                                                                           duration:0.6
                                                                           delegate:self];
    zoomTransition.backgroundColor = self.collectionView.backgroundColor;
    
    return zoomTransition;
}

#pragma mark - ZOZolaZoomTransitionDelegate Methods

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

- (NSArray *)supplementaryViewsForZolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition {
    return [self clippedCells];
}

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
   frameForSupplementaryView:(UIView *)supplementaryView
   relativeToView:(UIView *)relativeView {
    
    return [supplementaryView convertRect:supplementaryView.bounds toView:relativeView];
}

@end

#pragma mark - ZOProductCell Implementation

@interface ZOProductCell ()

@property (strong, nonatomic, readwrite) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ZOProductCell

#pragma mark - Constructors

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageView];
        
        self.tgitleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    }
    return self;
}

#pragma mark - Setters

- (void)setProduct:(ZOProduct *)product {
    _product = product;
    _titleLabel.text = product.title;
    _imageView.image = [UIImage imageNamed:product.imageName];
    
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.width);
    
    CGFloat labelWidth = self.contentView.frame.size.width - 5.0 - 5.0;
    CGFloat labelHeight = [_titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height;
    _titleLabel.frame = CGRectMake(5.0, _imageView.frame.origin.y + _imageView.frame.size.height + 5.0, labelWidth, labelHeight);
}

@end
