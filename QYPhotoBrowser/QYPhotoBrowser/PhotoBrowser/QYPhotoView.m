//
//  QYPhotoView.m
//  QYPhotoBrowser
//
//  Created by ZLJuan on 2017/2/17.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYPhotoView.h"

#define D_ImageView_ScaleMax 2.0
#define D_ImageView_ScaleMin 0.5

@interface QYPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *scrollView;
@property (nonatomic, strong) UIImageView               *imageView;
@property (nonatomic, strong) UITapGestureRecognizer    *tapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer    *doubleTapRecognizer;

@end

@implementation QYPhotoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self addRecognizer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self addRecognizer];
    }
    return self;
}

- (void)setupUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, D_ScreenWidth, D_ScreenHeight)];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = D_ImageView_ScaleMax;
    self.scrollView.minimumZoomScale = D_ImageView_ScaleMin;
    self.scrollView.bounces = NO;
    self.scrollView.multipleTouchEnabled = YES;
    [self addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.center = CGPointMake(D_ScreenWidth / 2.0, D_ScreenHeight / 2.0);
    self.imageView.bounds = CGRectMake(0, 0, 320, 208);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageNamed:@"6.png"];
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - recognizer
- (void)addRecognizer
{
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToTapRecognizer:)];
    [self.scrollView addGestureRecognizer:self.tapRecognizer];
    
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToDoubleTapRecognizer:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:self.doubleTapRecognizer];
}

- (void)selectorToTapRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer != self.tapRecognizer) return;
}

- (void)selectorToDoubleTapRecognizer:(UITapGestureRecognizer *)doubleTapRecognizer
{
    if (doubleTapRecognizer != self.doubleTapRecognizer) return;
    
    if (self.scrollView.zoomScale == 1.0) { // 存疑
        CGPoint locationPoint = [doubleTapRecognizer locationInView:doubleTapRecognizer.view];
        [self.scrollView zoomToRect:CGRectMake(locationPoint.x, locationPoint.y, D_ScreenWidth / D_ImageView_ScaleMax, D_ScreenHeight / D_ImageView_ScaleMax) animated:YES];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGPoint imageViewDefaultCenter = CGPointMake(D_ScreenWidth / 2.0, D_ScreenHeight / 2.0);
    CGFloat imageViewCenterX = scrollView.contentSize.width > D_ScreenWidth ? scrollView.contentSize.width / 2.0 : imageViewDefaultCenter.x;
    CGFloat imageViewCenterY = scrollView.contentSize.height > D_ScreenHeight ? scrollView.contentSize.height / 2.0 : imageViewDefaultCenter.y;
    self.imageView.center = CGPointMake(imageViewCenterX, imageViewCenterY);
}

@end
