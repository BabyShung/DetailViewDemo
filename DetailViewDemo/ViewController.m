//
//  ViewController.m
//  DetailViewDemo
//
//  Created by Hao Zheng on 6/16/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "ViewController.h"

#import "FoodInfoView.h"

@interface ViewController ()

@property (strong,nonatomic) FoodInfoView *foodView;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.foodView = [[FoodInfoView alloc]initWithFrame:self.view.bounds andVC:self];
    /*!!!!!!!!!!!*/
    [self.view addSubview:self.foodView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.foodView.shimmeringView.shimmering =NO;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /*!!!!! delegate set up !!!!!!*/
        [self.foodView configureNetworkComponents];
        
    });
    
    
    
    // Adjust photo collectionview decelerationRate
    self.foodView.photoCollectionView.decelerationRate =  UIScrollViewDecelerationRateFast;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //************ after loading, must reset the contentsize for scrollview *************
    //_mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _commentsTableView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame));
    
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
