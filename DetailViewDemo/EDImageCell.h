//
//  EDImageCell.h
//  DetailViewDemo
//
//  Created by Hao Zheng on 6/17/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDImageCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong,nonatomic) UIActivityIndicatorView *activityView;


-(void)setLabelString:(NSString *)labelString;

@end
