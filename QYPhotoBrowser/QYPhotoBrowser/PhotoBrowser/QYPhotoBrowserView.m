//
//  QYPhotoBrowserView.m
//  QYPhotoBrowser
//
//  Created by ZLJuan on 2017/2/17.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYPhotoBrowserView.h"
#import "QYPhotoCell.h"

@interface QYPhotoBrowserView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView           *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) UITapGestureRecognizer            *tapRecognizer;

@end

@implementation QYPhotoBrowserView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self layoutIfNeeded];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self addRecognizer];
}

- (void)setupUI
{
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewFlowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 20, [UIScreen mainScreen].bounds.size.height);
    self.collectionViewFlowLayout.minimumInteritemSpacing = 0;
    self.collectionViewFlowLayout.minimumLineSpacing = 0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"QYPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QYPhotoCell"];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.decelerationRate = 0;
}

+ (void)showWithType:(QYPhotoBrowserViewShowType)showType inViewController:(UIViewController *)viewController
{
    UIViewController *vc = [[UIViewController alloc] init];
    QYPhotoBrowserView *photoBrowserView = [[QYPhotoBrowserView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [vc.view addSubview:photoBrowserView];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - UITapGestureRecognizer
- (void)addRecognizer
{
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorToTapRecognizer:)];
    self.tapRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapRecognizer];
}

- (void)selectorToTapRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer != self.tapRecognizer) return;
    if (self.descriptionView.hidden) {
        [self showNavigationBarViewAnimated:YES];
        [self showDescriptionViewAnimated:YES];
    } else {
        [self hideDescriptionViewAnimated:YES];
        [self hideNavigationBarViewAnimated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *otherTapRecognizer = (UITapGestureRecognizer *)otherGestureRecognizer;
        if (otherTapRecognizer.numberOfTapsRequired == 2) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - navigationBarView

- (void)setNavigationBarView:(UIView *)navigationBarView
{
    _navigationBarView = navigationBarView;
    [self addSubview:_navigationBarView];
}

- (void)showNavigationBarViewAnimated:(BOOL)animated
{
    self.navigationBarView.hidden = NO;
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frame = self.navigationBarView.frame;
                             frame.origin.y = 0;
                             self.navigationBarView.frame = frame;
                             self.navigationBarView.alpha = 1.0;
                             [UIApplication sharedApplication].statusBarHidden = NO;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        CGRect frame = self.navigationBarView.frame;
        frame.origin.y = 0;
        self.navigationBarView.frame = frame;
    }
}

- (void)hideNavigationBarViewAnimated:(BOOL)animated
{
    if (animated) {
        [[UIApplication sharedApplication] isIgnoringInteractionEvents];
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frame = self.navigationBarView.frame;
                             frame.origin.y = -65;
                             self.navigationBarView.frame = frame;
                             self.navigationBarView.alpha = 0;
                             [UIApplication sharedApplication].statusBarHidden = YES;
                         } completion:^(BOOL finished) {
                             self.navigationBarView.hidden = YES;
                         }];
    } else {
        self.navigationBarView.hidden = YES;
    }
}

#pragma mark - descriptionView

- (void)setDescriptionView:(UIView *)descriptionView
{
    _descriptionView = descriptionView;
    [self addSubview:_descriptionView];
}

- (void)showDescriptionViewAnimated:(BOOL)animated
{
    [self bringSubviewToFront:self.descriptionView];
    self.descriptionView.hidden = NO;
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frame = self.descriptionView.frame;
                             frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.descriptionView.bounds.size.height;
                             self.descriptionView.frame = frame;
                             self.descriptionView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        CGRect frame = self.descriptionView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.descriptionView.bounds.size.height;
        self.descriptionView.frame = frame;
    }
}

- (void)hideDescriptionViewAnimated:(BOOL)animated
{
    if (animated) {
        [[UIApplication sharedApplication] isIgnoringInteractionEvents];
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frame = self.descriptionView.frame;
                             frame.origin.y = [UIScreen mainScreen].bounds.size.height + 1;
                             self.descriptionView.frame = frame;
                             self.descriptionView.alpha = 0;
                         } completion:^(BOOL finished) {
                             self.descriptionView.hidden = YES;
                         }];
    } else {
        self.descriptionView.hidden = YES;
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInPhotoBrowserView:)]) {
        return [self.dataSource numberOfImageInPhotoBrowserView:self];
    } else if ([self.dataSource respondsToSelector:@selector(imageUrlStringArrayForPhotoBrowserView:)]) {
        return [self.dataSource imageUrlStringArrayForPhotoBrowserView:self].count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QYPhotoCell" forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(photoBrowserView:imageUrlStringAtIndex:)]) {
        [cell updateCellWithImageUrlString:[self.dataSource photoBrowserView:self imageUrlStringAtIndex:indexPath.row]];
    } else if ([self.dataSource respondsToSelector:@selector(imageUrlStringArrayForPhotoBrowserView:)]) {
        NSArray *imageUrlStringArray = [self.dataSource imageUrlStringArrayForPhotoBrowserView:self];
        [cell updateCellWithImageUrlString:imageUrlStringArray[indexPath.row]];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger nextIndex = offsetX / self.bounds.size.width + 0.5;
    if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
        if ([self.delegate respondsToSelector:@selector(photoBrowserView:didStartDisplayIndex:)]) {
            [self.delegate photoBrowserView:self didStartDisplayIndex:nextIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger nextIndex = offsetX / self.bounds.size.width + 0.5;
    if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
        if ([self.delegate respondsToSelector:@selector(photoBrowserView:didEndDisplayIndex:)]) {
            [self.delegate photoBrowserView:self didEndDisplayIndex:nextIndex];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger nextIndex = offsetX / self.bounds.size.width + 0.5;
        if (nextIndex != _currentIndex) {
            _currentIndex = nextIndex;
            if ([self.delegate respondsToSelector:@selector(photoBrowserView:didEndDisplayIndex:)]) {
                [self.delegate photoBrowserView:self didEndDisplayIndex:nextIndex];
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.descriptionView) {
        [self bringSubviewToFront:self.descriptionView];
    }
    if (self.navigationBarView) {
        [self bringSubviewToFront:self.navigationBarView];
    }
}

@end
