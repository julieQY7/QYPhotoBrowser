//
//  QYPhotoCell.m
//  QYPhotoBrowser
//
//  Created by 朱利娟 on 17/2/19.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "SDWaitingView.h"

#define D_PhotoBrowser_DefaultImage @"defaultimage_big_icon.png"

#define D_ImageView_ScaleMax 2.0
#define D_ImageView_ScaleMin 0.5

@interface QYPhotoCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, strong) UIImageView               *imageView;
@property (nonatomic, strong) UITapGestureRecognizer    *doubleTapRecognizer;
@property (weak, nonatomic) IBOutlet SDWaitingView      *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel            *errorLabel;

@end

@implementation QYPhotoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self addRecognizer];
}

- (void)setupUI
{
    self.scrollView.maximumZoomScale = D_ImageView_ScaleMax;
    self.scrollView.minimumZoomScale = D_ImageView_ScaleMin;
    self.scrollView.bounces = NO;
    self.scrollView.multipleTouchEnabled = YES;
    self.scrollView.frame = [UIScreen mainScreen].bounds;
    
    self.imageView = [[UIImageView alloc] init];
    [self resetImageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    
    self.errorLabel.layer.cornerRadius = 3;
    self.errorLabel.layer.masksToBounds = YES;
}

#pragma mark - recognizer
- (void)addRecognizer
{
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToDoubleTapRecognizer:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:self.doubleTapRecognizer];
}

- (void)selectorToDoubleTapRecognizer:(UITapGestureRecognizer *)doubleTapRecognizer
{
    if (doubleTapRecognizer != self.doubleTapRecognizer) return;
    
    if (self.scrollView.zoomScale == 1.0) { // 存疑
        CGPoint locationPoint = [doubleTapRecognizer locationInView:doubleTapRecognizer.view];
        [self.scrollView zoomToRect:CGRectMake(locationPoint.x, locationPoint.y, self.scrollView.bounds.size.width / D_ImageView_ScaleMax, self.scrollView.bounds.size.height / D_ImageView_ScaleMax) animated:YES];
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
    CGPoint imageViewDefaultCenter = CGPointMake(self.scrollView.bounds.size.width / 2.0, self.scrollView.bounds.size.height / 2.0);
    CGFloat imageViewCenterX = scrollView.contentSize.width > self.scrollView.bounds.size.width ? scrollView.contentSize.width / 2.0 : imageViewDefaultCenter.x;
    CGFloat imageViewCenterY = scrollView.contentSize.height > self.scrollView.bounds.size.height ? scrollView.contentSize.height / 2.0 : imageViewDefaultCenter.y;
    self.imageView.center = CGPointMake(imageViewCenterX, imageViewCenterY);
}

#pragma updateUI

- (void)updateCellWithImageUrlString:(NSString *)imageUrlString
{
    [self resetImageView];
    self.indicatorView.hidden = NO;
    self.errorLabel.hidden = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
                      placeholderImage:[UIImage imageNamed:D_PhotoBrowser_DefaultImage]
                               options:SDWebImageRetryFailed
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  // 更新进度条
                                  self.indicatorView.progress = receivedSize / expectedSize;
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 self.indicatorView.hidden = YES;
                                 if (error != nil) {
                                     [self resetImageView];
                                     self.errorLabel.hidden = NO;
                                 } else {
                                     self.imageView.bounds = CGRectMake(0, 0, [self sizeWithImageSize:self.imageView.image.size].width, [self sizeWithImageSize:self.imageView.image.size].height);
                                     self.scrollView.contentSize = self.imageView.bounds.size;
                                     CGPoint imageViewDefaultCenter = CGPointMake(self.scrollView.bounds.size.width / 2.0, self.scrollView.bounds.size.height / 2.0);
                                     CGFloat imageViewCenterX = self.scrollView.contentSize.width > self.scrollView.bounds.size.width ? self.scrollView.contentSize.width / 2.0 : imageViewDefaultCenter.x;
                                     CGFloat imageViewCenterY = self.scrollView.contentSize.height > self.scrollView.bounds.size.height ? self.scrollView.contentSize.height / 2.0 : imageViewDefaultCenter.y;
                                     self.imageView.center = CGPointMake(imageViewCenterX, imageViewCenterY);
                                 }
                             }];
}

- (void)resetImageView
{
    self.imageView.image = [UIImage imageNamed:D_PhotoBrowser_DefaultImage];
    self.imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0);
    self.imageView.bounds = CGRectMake(0, 0, [self sizeWithImageSize:self.imageView.image.size].width, [self sizeWithImageSize:self.imageView.image.size].height);
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (CGSize)sizeWithImageSize:(CGSize)imageSize
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, (imageSize.height / imageSize.width) * width);
}

@end
