//
//  QYPhotoBrowserView.h
//  QYPhotoBrowser
//
//  Created by ZLJuan on 2017/2/17.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QYPhotoBrowserViewDataSource;
@protocol QYPhotoBrowserViewDelegate;

typedef NS_ENUM(NSInteger, QYPhotoBrowserViewShowType) {
    QYPhotoBrowserViewShowType_Push,
    QYPhotoBrowserViewShowType_Modal
};

@interface QYPhotoBrowserView : UIView

@property (nonatomic, assign) NSInteger                         currentIndex;
@property (nonatomic, weak) id<QYPhotoBrowserViewDelegate>      delegate;
@property (nonatomic, weak) id<QYPhotoBrowserViewDataSource>    dataSource;
@property (nonatomic, strong) UIView                            *descriptionView;
@property (nonatomic, strong) UIView                            *navigationBarView;

+ (void)showWithType:(QYPhotoBrowserViewShowType)showType inViewController:(UIViewController *)viewController;

@end

@protocol QYPhotoBrowserViewDataSource <NSObject>

@optional
- (NSArray<NSString *> *)imageUrlStringArrayForPhotoBrowserView:(QYPhotoBrowserView *)photoBrowserView; // 实现当前方法或下面👇两个方法
- (NSInteger)numberOfImageInPhotoBrowserView:(QYPhotoBrowserView *)photoBrowserView;
- (NSString *)photoBrowserView:(QYPhotoBrowserView *)photoBrowserView imageUrlStringAtIndex:(NSUInteger)index;

@end

@protocol QYPhotoBrowserViewDelegate <NSObject>

@optional;
- (void)photoBrowserView:(QYPhotoBrowserView *)photoBrowserView didStartDisplayIndex:(NSInteger)index; // 在此回调中更新descriptionView数据
- (void)photoBrowserView:(QYPhotoBrowserView *)photoBrowserView didEndDisplayIndex:(NSInteger)index;

@end
