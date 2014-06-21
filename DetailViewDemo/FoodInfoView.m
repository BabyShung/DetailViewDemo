//
//  FoodInfoView.m
//  DetailViewDemo
//
//  Created by Hao Zheng on 6/21/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "FoodInfoView.h"
#import "EDImageCell.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UIImageView+M13AsynchronousImageView.h"
#import "CommentCell.h"


static NSString *CellIdentifier = @"Cell";

const CGFloat kCommentCellHeight = 50.0f;

const CGFloat CLeftMargin = 15.0f;
const CGFloat TitleTopMargin = 10.0f;
const CGFloat GAP = 6.0f;
const CGFloat MiddleGAP = 20.0f;

@interface FoodInfoView () <UICollectionViewDataSource,UICollectionViewDelegate,TagViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *externalFileURLs;
}

@property (strong,nonatomic) UIViewController *currentVC;


@end

@implementation FoodInfoView

- (id)initWithFrame:(CGRect)frame andVC:(UIViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentVC = vc;
        
        //init all UI controls
        [self loadControls];
        
    }
    return self;
}

-(void)loadControls{
    self.scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollview.showsVerticalScrollIndicator=YES;
    self.scrollview.scrollEnabled=YES;
    self.scrollview.userInteractionEnabled=YES;
    [self addSubview:self.scrollview];
    //should add up all
    self.scrollview.contentSize = CGSizeMake(self.bounds.size.width,1100);
    
    
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
    
    
    
    self.descriptionLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(CLeftMargin, CGRectGetHeight(self.titleLabel.frame)+ CGRectGetMaxY(self.titleLabel.frame) + MiddleGAP, 320 - CLeftMargin*2, 70)];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.text = @"";
    self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    //self.descriptionLabel.hidden = YES;
    //label.center = self.view.center;
    //self.descriptionLabel.textColor = [UIColor grayColor];
    
    [self.scrollview addSubview:self.descriptionLabel];
    
    
    _tagview = [[TagView alloc]initWithFrame:CGRectMake(0, 20+CGRectGetMaxY(self.descriptionLabel.frame) , CGRectGetWidth(self.bounds), 40)];
    _tagview.allowToUseSingleSpace = YES;
    _tagview.delegate = self;
    [_tagview setFont:[UIFont fontWithName:@"Heiti TC" size:18]];
    [_tagview setBackgroundColor:[UIColor clearColor]];
    [self.scrollview addSubview:_tagview];
    
    
    //collectionView + layout
    EDImageFlowLayout *small = [[EDImageFlowLayout alloc]init];
    
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagview.frame) + GAP, CGRectGetWidth(self.bounds), 268) collectionViewLayout:small];
    [self.photoCollectionView registerClass:[EDImageCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.photoCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.scrollview addSubview:self.photoCollectionView];
    
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
    _commentsViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoCollectionView.frame) + GAP, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) )];
    //[_commentsViewContainer addGradientMaskWithStartPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 0.03)];
    //************** pay attention to tableview *****************
    _commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) ) style:UITableViewStylePlain];
    _commentsTableView.scrollEnabled = NO;
    
    _commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _commentsTableView.separatorColor = [UIColor clearColor];
    
    //********* finally put in self.view ************
    [_commentsViewContainer addSubview:_commentsTableView];
    [self.scrollview addSubview:_commentsViewContainer];
    
    // Let's put in some fake data!
    _comments = [@[@"Oh my god! Me too!", @"I happened to be one of the coolest guy to learn this shit!", @"More comments", @"Go Toronto Blue Jays!", @"I rather stay home", @"I don't get what you are saying", @"I don't have an iPhone"] mutableCopy];
}


-(void)configureNetworkComponents{
    NSLog(@"test```");
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    _commentsTableView.delegate = self;
    _commentsTableView.dataSource = self;
    [_commentsTableView reloadData];
    
    [_tagview addTags:@[@"蓝色", @"臭",@"酸",@"软", @"难消化",@"高热量",@"发酵品"]];
    
    self.descriptionLabel.text = @"蓝芝士是一种听上去很好吃但是味道很恶心的芝士。";
    
    [self.descriptionLabel sizeToFit];
    [self.descriptionLabel shine];
    
    
    NSLog(@"visible %d",self.descriptionLabel.isVisible);
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
        
        
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EDImageCell *cell = (EDImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = cell.imageView.image;
    
    imageInfo.referenceRect = cell.imageView.frame;
    
    imageInfo.referenceView = cell.imageView.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self.currentVC transition:JTSImageViewControllerTransition_FromOriginalPosition];
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
    //NSLog(@"added tag = %@", tag);
}

- (void)tagWriteView:(TagView *)view didRemoveTag:(NSString *)tag
{
    //NSLog(@"removed tag = %@", tag);
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



@end
