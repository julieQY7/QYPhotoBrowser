//
//  QYDescriptionView.m
//  QYPhotoBrowser
//
//  Created by ZLJuan on 2017/2/20.
//  Copyright © 2017年 ZLJuan. All rights reserved.
//

#import "QYDescriptionView.h"

@interface QYDescriptionView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QYDescriptionView

- (void)updateWithTitle:(NSString *)title
{
    self.titleLabel.text = title ? title : @"";
}

@end
