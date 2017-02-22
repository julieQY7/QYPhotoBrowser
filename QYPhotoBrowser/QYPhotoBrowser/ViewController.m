//
//  ViewController.m
//  QYPhotoBrowser
//
//  Created by ZLJuan on 2017/2/17.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "ViewController.h"
#import "QYPhotoBrowserView.h"
#import "QYDescriptionView.h"

@interface ViewController () <QYPhotoBrowserViewDelegate, QYPhotoBrowserViewDataSource>

@property (nonatomic, strong) QYPhotoBrowserView    *photoBrowserView;
@property (nonatomic, strong) NSArray               *imageUrlArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    QYDescriptionView *desView = [[[NSBundle mainBundle] loadNibNamed:@"QYDescriptionView" owner:nil options:nil] lastObject];
    [desView updateWithTitle:@"标题--0"];
    desView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - D_DescriptionViewHeight, [UIScreen mainScreen].bounds.size.width, D_DescriptionViewHeight);
    self.photoBrowserView = [[[NSBundle mainBundle] loadNibNamed:@"QYPhotoBrowserView" owner:nil options:nil] lastObject];
    self.photoBrowserView.frame = [UIScreen mainScreen].bounds;
    self.photoBrowserView.descriptionView = desView;
    self.photoBrowserView.delegate = self;
    self.photoBrowserView.dataSource = self;
    self.photoBrowserView.currentIndex = 3;
    [self.view addSubview:self.photoBrowserView];
}

#pragma mark - QYPhotoBrowserViewDelegate, QYPhotoBrowserViewDataSource

- (NSArray<NSString *> *)imageUrlStringArrayForPhotoBrowserView:(QYPhotoBrowserView *)photoBrowserView
{
    return self.imageUrlArray;
}

- (void)photoBrowserView:(QYPhotoBrowserView *)photoBrowserView didStartDisplayIndex:(NSInteger)index
{
    if ([photoBrowserView.descriptionView isKindOfClass:[QYDescriptionView class]]) {
        QYDescriptionView *descView = (QYDescriptionView *)photoBrowserView.descriptionView;
        [descView updateWithTitle:[NSString stringWithFormat:@"标题--%ld", (long)index]];
    }
}

- (void)photoBrowserView:(QYPhotoBrowserView *)photoBrowserView didEndDisplayIndex:(NSInteger)index
{
    
}

- (NSArray *)imageUrlArray
{
    if (_imageUrlArray == nil) {
        _imageUrlArray = @[
                           @"http://test.img.mzhinan.cn/user/c337769682b4a68ceaabe3e853a39844_w820_h2440.jpg",
                           @"http://test.img.mzhinan.cn/user/aaa99a44eb31446c393aaa91b43f6ff7_w10800_h2332.jpg",
                           @"http://test.img.mzhinan.cn/user/851535108e9d9936ecb396962fb3aa39_w148_h116.jpg",
                           @"http://test.img.mzhinan.cn/user/7829a8675c3994e45c5997b10bea1d2d_w500_h333.jpg",
                           @"http://test.img.mzhinan.cn/user/9012c9182515687ea568c324e299fd08_w2448_h3264.jpg",
                           @"http://test.img.mzhinan.cn/user/fe92faca319511bb301a812b16583f7f_w2448_h3264.jpg"
                           ];
    }
    return _imageUrlArray;
}

@end
