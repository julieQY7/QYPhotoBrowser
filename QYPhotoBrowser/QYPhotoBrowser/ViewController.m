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
                           @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                           @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                           @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                           @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                           @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                           @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                           @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                           @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                           @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                           ];
    }
    return _imageUrlArray;
}

@end
