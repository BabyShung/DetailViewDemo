//
//  HKKTagWriteView.h
//  TagWriteViewTest
//
//  Created by kyokook on 2014. 1. 11..
//  Copyright (c) 2014 rhlab. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TagViewDelegate;
@class TagView;

@protocol TagViewDelegate <NSObject>
@optional
- (void)tagWriteViewDidBeginEditing:(TagView *)view;
- (void)tagWriteViewDidEndEditing:(TagView *)view;

- (void)tagWriteView:(TagView *)view didChangeText:(NSString *)text;
- (void)tagWriteView:(TagView *)view didMakeTag:(NSString *)tag;
- (void)tagWriteView:(TagView *)view didRemoveTag:(NSString *)tag;
@end



@interface TagView : UIView

//
// appearance
//
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, strong) UIColor *tagForegroundColor;
@property (nonatomic, assign) int maxTagLength;
@property (nonatomic, assign) CGFloat tagGap;

//
// data
//
@property (nonatomic, readonly) NSArray *tags;

//
// control
//
@property (nonatomic, assign) BOOL focusOnAddTag;
@property (nonatomic, assign) BOOL allowToUseSingleSpace;

@property (nonatomic, weak) id<TagViewDelegate> delegate;

- (void)clear;
- (void)setTextToInputSlot:(NSString *)text;

- (void)addTags:(NSArray *)tags;
- (void)removeTags:(NSArray *)tags;
- (void)addTagToLast:(NSString *)tag animated:(BOOL)animated;
- (void)removeTag:(NSString *)tag animated:(BOOL)animated;

@end



