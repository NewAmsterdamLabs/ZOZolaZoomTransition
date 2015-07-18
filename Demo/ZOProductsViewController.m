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

#pragma mark - UICollectionViewDelegate & Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_products count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZOProductCell *productCell = (ZOProductCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ZOProductCellId forIndexPath:indexPath];
    productCell.product = _products[indexPath.row];
    return productCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZODetailViewController *detailController = [[ZODetailViewController alloc] initWithProduct:_products[indexPath.row]];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cell width is half the screen width - edge margin - half the center margin
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

@end

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
        
        self.titleLabel = [[UILabel alloc] init];
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
