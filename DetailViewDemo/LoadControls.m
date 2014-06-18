//
//  LoadControls.m
//  EdibleCameraApp
//
//  Created by MEI C on 5/30/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "LoadControls.h"

@implementation LoadControls

+(UIImageView *)createImageViewWithRect:(CGRect)rect{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

+(UILabel *)createLabelWithRect:(CGRect)rect andTextAlignment:(NSTextAlignment)ta andFont:(UIFont*)font andTextColor:(UIColor*)color{
    UILabel *label= [[UILabel alloc]initWithFrame:rect];
    label.text = @"";
    label.textAlignment = ta;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    return label;
}

+(UITextView *)createTextViewWithRect:(CGRect)rect{
    UITextView *tv= [[UITextView alloc]initWithFrame:rect];
    tv.text = @"";
    tv.backgroundColor = [UIColor clearColor];
    //label.textAlignment = NSTextAlignmentCenter;
    //label.center = self.view.center;
    tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    return tv;
}


@end
