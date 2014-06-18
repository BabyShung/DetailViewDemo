//
//  EDImageCell.m
//  DetailViewDemo
//
//  Created by Hao Zheng on 6/17/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "EDImageCell.h"
#import "LoadControls.h"

@interface EDImageCell ()

@end

@implementation EDImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        
        //add indicator
        self.activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center=self.contentView.center;
        //[self.activityView startAnimating];
        [self.contentView addSubview:self.activityView];
        
        //add imageView
        self.imageView = [LoadControls createImageViewWithRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView addSubview:self.imageView];
        
        
        //add a label
//        self.label = [LoadControls createLabelWithRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) andTextAlignment:NSTextAlignmentCenter andFont:[UIFont boldSystemFontOfSize:24] andTextColor:[UIColor blackColor]];
//
//        [self.contentView addSubview:self.label];
    }
    return self;
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    [self setLabelString:@""];
}

//only useful when switch to flow mode,
//-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    [super applyLayoutAttributes:layoutAttributes];
// 
//    //NSLog(@"new cell?");
//    
//    self.label.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2.0f, CGRectGetHeight(self.contentView.bounds) / 2.0f);
//}

-(void)setLabelString:(NSString *)labelString
{
    self.label.text = labelString;
}

@end
