//
//  ViewController.m
//  DetailViewDemo
//
//  Created by Hao Zheng on 6/16/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "ViewController.h"
#import "EDImageFlowLayout.h"
#import "EDImageCell.h"
#import "UIImageView+M13AsynchronousImageView.h"
#import "RQShineLabel.h"
#import "TagView.h"
#import "CommentCell.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"



@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate,TagViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *externalFileURLs;
}

@property (nonatomic, strong) TagView *tagview;

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *translateLabel;
@property (strong,nonatomic) FBShimmeringView *shimmeringView;

@property (strong,nonatomic) UIScrollView *scrollview;

@property (nonatomic, strong) EDImageFlowLayout *circleLayout;

@property (strong, nonatomic) UICollectionView *myCollectionView;

@property (strong, nonatomic) RQShineLabel *descriptionLabel;
@property (strong, nonatomic) NSArray *textArray;

@property (strong,nonatomic) UIView *commentsViewContainer;
@property (strong,nonatomic) UITableView *commentsTableView;
@property (strong,nonatomic) NSMutableArray *comments;

@end

static NSString *CellIdentifier = @"Cell";

const CGFloat kCommentCellHeight = 50.0f;

const CGFloat CLeftMargin = 15.0f;
const CGFloat TitleTopMargin = 10.0f;
const CGFloat GAP = 6.0f;
const CGFloat MiddleGAP = 20.0f;
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollview.showsVerticalScrollIndicator=YES;
    self.scrollview.scrollEnabled=YES;
    self.scrollview.userInteractionEnabled=YES;
    [self.view addSubview:self.scrollview];
    //should add up all
    self.scrollview.contentSize = CGSizeMake(self.view.bounds.size.width,1100);
    
    
    CGRect titleRect = CGRectMake(CLeftMargin, TitleTopMargin, self.scrollview.bounds.size.width, 30);
    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:titleRect];
    self.shimmeringView.shimmering = YES;   //start shimmering
    self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
    self.shimmeringView.shimmeringOpacity = 0.3;
    self.shimmeringView.backgroundColor = [UIColor clearColor];
    [self.scrollview addSubview:self.shimmeringView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    self.titleLabel.text = @"Blue Cheese";
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25];
    self.titleLabel.textColor = [UIColor blackColor];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = self.titleLabel;
    
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(CLeftMargin, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth(self.scrollview.frame)-2*CLeftMargin, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [self.scrollview addSubview:separator];
    
    self.translateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CLeftMargin, TitleTopMargin + CGRectGetHeight(self.titleLabel.frame)  , self.scrollview.bounds.size.width, 30)];
    self.translateLabel.text = @"蓝芝士";
    self.translateLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    self.translateLabel.textColor = [UIColor blackColor];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.translateLabel.backgroundColor = [UIColor clearColor];
    [self.scrollview addSubview:self.translateLabel];
    //_shimmeringView.contentView = self.translateLabel;

    
    
    self.descriptionLabel = ({
        RQShineLabel *label = [[RQShineLabel alloc] initWithFrame:CGRectMake(CLeftMargin, CGRectGetHeight(self.titleLabel.frame)+ CGRectGetMaxY(self.titleLabel.frame) + MiddleGAP, 320 - CLeftMargin*2, 70)];
        label.numberOfLines = 0;
        label.text = @"蓝芝士是一种听上去很好吃但是味道很恶心的芝士。";
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        //label.center = self.view.center;
        label.textColor = [UIColor grayColor];
        label;
    });
    [self.scrollview addSubview:self.descriptionLabel];
    
    
    _tagview = [[TagView alloc]initWithFrame:CGRectMake(0, 20+CGRectGetMaxY(self.descriptionLabel.frame) , CGRectGetWidth(self.view.bounds), 40)];
    _tagview.allowToUseSingleSpace = YES;
    _tagview.delegate = self;
    [_tagview setFont:[UIFont fontWithName:@"Heiti TC" size:18]];
    [_tagview setBackgroundColor:[UIColor clearColor]];
    [_tagview addTags:@[@"hello", @"UX",@"Edible",@"Blue Cheese", @"congratulation", @"Blue Cheese", @"congratulation", @"google", @"ios", @"android"]];
    [self.scrollview addSubview:_tagview];
    
    
    //collectionView + layout
    EDImageFlowLayout *small = [[EDImageFlowLayout alloc]init];
    
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagview.frame) + GAP, CGRectGetWidth(self.view.bounds), 268) collectionViewLayout:small];
    [self.myCollectionView registerClass:[EDImageCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.scrollview addSubview:self.myCollectionView];
    
    //init all the image paras
    externalFileURLs = [NSMutableArray array];
    
    NSString *namesString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fullURLs" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *fileNamesArray = [namesString componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < fileNamesArray.count; i++) {
        NSString *urlString = fileNamesArray[i];
        NSURL *url = [NSURL URLWithString:urlString];
        [externalFileURLs addObject:url];
    }
    
    //add table view
    //----------------------------comment
    _commentsViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myCollectionView.frame) + GAP, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    //[_commentsViewContainer addGradientMaskWithStartPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 0.03)];
    //************** pay attention to tableview *****************
    _commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) ) style:UITableViewStylePlain];
    _commentsTableView.scrollEnabled = NO;
    _commentsTableView.delegate = self;
    _commentsTableView.dataSource = self;
    _commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _commentsTableView.separatorColor = [UIColor clearColor];
    
    //********* finally put in self.view ************
    [_commentsViewContainer addSubview:_commentsTableView];
    [self.scrollview addSubview:_commentsViewContainer];
    
    // Let's put in some fake data!
    _comments = [@[@"Oh my god! Me too!", @"No way! Spur won!", @"I happened to be one of the coolest guy to learn this shit!", @"More comments", @"Go Toronto Blue Jays!", @"I rather stay home", @"I don't get what you are saying", @"I don't have an iPhone", @"How are you using this then?"] mutableCopy];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adjust photo collectionview decelerationRate
    self.myCollectionView.decelerationRate =  UIScrollViewDecelerationRateFast;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //let shine label shine
    [self.descriptionLabel shine];
    
    //************ after loading, must reset the contentsize for scrollview *************
    //_mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _commentsTableView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame));
}

/**********************************
 
 collectionView delegate
 
 ************************/
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EDImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //dispatch_async(dispatch_get_main_queue(), ^{
    cell.activityView.hidden = NO;
    [cell.activityView startAnimating];
    //});
    //Set the loading image
    //cell.imageView.image = loadingImage;
    
    //Cancel any other previous downloads for the image view.
    [cell.imageView cancelLoadingAllImages];
    
    //Load the new image
    [cell.imageView loadImageFromURLAtAmazonAsync:externalFileURLs[indexPath.row] completion:^(BOOL success, M13AsynchronousImageLoaderImageLoadedLocation location, UIImage *image, NSURL *url, id target) {
        //This is where you would refresh the cell if need be. If a cell of basic style, just call "setNeedsRelayout" on the cell.
        
        cell.activityView.hidden = YES;
        [cell.activityView stopAnimating];
        
        
//        [UIView transitionWithView:cell.imageView
//                          duration:0.6f
//                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
//                        animations:^{
//                            cell.imageView.image = image;
//                        } completion:nil];
        
        
        
        
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return externalFileURLs.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




/**********************************
 
 tagView delegate
 
 ************************/
#pragma mark - HKKTagWriteViewDelegate
- (void)tagWriteView:(TagView *)view didMakeTag:(NSString *)tag
{
    NSLog(@"added tag = %@", tag);
}

- (void)tagWriteView:(TagView *)view didRemoveTag:(NSString *)tag
{
    NSLog(@"removed tag = %@", tag);
}


/**********************************
 
 tableview delegate
 
 ************************/
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [_comments objectAtIndex:[indexPath row]];
    CGRect rect = [text boundingRectWithSize:(CGSize){225, MAXFLOAT}
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]}
                                     context:nil];
    CGSize requiredSize = rect.size;
    return kCommentCellHeight + requiredSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentLabel.frame = (CGRect) {.origin = cell.commentLabel.frame.origin, .size = {CGRectGetMinX(cell.likeButton.frame) - CGRectGetMaxY(cell.iconView.frame) - kCommentPaddingFromLeft - kCommentPaddingFromRight,[self tableView:tableView heightForRowAtIndexPath:indexPath] - kCommentCellHeight}};
        cell.commentLabel.text = _comments[indexPath.row];
        cell.timeLabel.frame = (CGRect) {.origin = {CGRectGetMinX(cell.commentLabel.frame), CGRectGetMaxY(cell.commentLabel.frame)}};
        cell.timeLabel.text = @"1d ago";
        [cell.timeLabel sizeToFit];
        
        // Don't judge my magic numbers or my crappy assets!!!
        cell.likeCountImageView.frame = CGRectMake(CGRectGetMaxX(cell.timeLabel.frame) + 7, CGRectGetMinY(cell.timeLabel.frame) + 3, 10, 10);
        cell.likeCountImageView.image = [UIImage imageNamed:@"like_greyIcon.png"];
        cell.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(cell.likeCountImageView.frame) + 3, CGRectGetMinY(cell.timeLabel.frame), 0, CGRectGetHeight(cell.timeLabel.frame));
    }
    
    return cell;
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
