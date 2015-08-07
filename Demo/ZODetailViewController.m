//
//  ZODetailViewController.m
//  Copyright (c) 2015 Zola, Inc.
//
//  Created by Charles Scalesse
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ZODetailViewController.h"
#import "ZOProduct.h"

static CGFloat ZODescriptionLabelMargin = 14.0;

@interface ZODetailViewController ()

@property (strong, nonatomic) ZOProduct *product;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic, readwrite) UIImageView *imageView;

@end

@implementation ZODetailViewController

#pragma mark - Constructors

- (instancetype)initWithProduct:(ZOProduct *)product {
    self = [super init];
    if (self) {
        self.product = product;
        self.title = _product.title;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_product.imageName]];
    _imageView.frame = CGRectMake(0.0, 0.0, _scrollView.frame.size.width, _scrollView.frame.size.width);
    
    [_scrollView addSubview:_imageView];
    
    self.descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:16.0];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = @"Helvetica scenester deep v fixie. Austin messenger bag cliche slow-carb, umami Shoreditch pop-up bicycle rights brunch vinyl viral narwhal disrupt pug. Godard cliche crucifix typewriter 8-bit ugh. Raw denim freegan pork belly direct trade gentrify you probably haven't heard of them.\n\nSartorial retro tattooed asymmetrical Williamsburg, hoodie locavore leggings roof party umami. Forage bitters polaroid freegan master cleanse jean shorts. Wes Anderson hella wolf, retro Blue Bottle literally leggings gluten-free DIY fap bespoke fashion axe Helvetica quinoa direct trade.\n\nFour dollar toast ennui Thundercats, chillwave single-origin coffee hashtag sustainable irony Intelligentsia. Whatever chia meditation 90's drinking vinegar, migas Williamsburg deep v typewriter kitsch. Small batch cold-pressed Pitchfork direct trade occupy sartorial, blog 8-bit mustache readymade Marfa cred butcher meggings hella. Asymmetrical photo booth pork belly, semiotics banjo pug health goth Vice farm-to-table Banksy.\n\nPortland fashion axe meditation sartorial gluten-free seitan. Cold-pressed deep v 90's, literally iPhone hashtag Bushwick banh mi organic put a bird on it bicycle rights ugh paleo stumptown. Photo booth quinoa Banksy, Intelligentsia deep v literally fingerstache lomo distillery raw denim taxidermy asymmetrical gluten-free.";
    [_scrollView addSubview:_descriptionLabel];
    
    CGSize descriptionSize = [_descriptionLabel sizeThatFits:CGSizeMake((_scrollView.frame.size.width - ZODescriptionLabelMargin * 2.0), CGFLOAT_MAX)];
    _descriptionLabel.frame = CGRectMake(ZODescriptionLabelMargin, _imageView.frame.origin.y + _imageView.frame.size.height + ZODescriptionLabelMargin, descriptionSize.width, descriptionSize.height);
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + ZODescriptionLabelMargin);
}

@end
