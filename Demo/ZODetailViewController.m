//
//  ZODetailViewController.m
//  ZOZolaZoomTransition
//
//  Created by Charles Scalesse on 7/10/15.
//  Copyright (c) 2015 Zola. All rights reserved.
//

#import "ZODetailViewController.h"
#import "ZOProduct.h"

@interface ZODetailViewController ()

@property (strong, nonatomic) ZOProduct *product;

@end

@implementation ZODetailViewController

#pragma mark - Constructors

- (instancetype)initWithProduct:(ZOProduct *)product {
    self = [super init];
    if (self) {
        self.title = @"Product Details";
        self.product = product;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
