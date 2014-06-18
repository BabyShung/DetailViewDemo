//
//  Edible_S3.h
//  HaoS3Test
//
//  Created by Hao Zheng on 6/16/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Edible_S3 : NSObject


//read image from S3
-(UIImage *)getImageFromS3:(NSString *)imageName;

-(void)getImageFromS3Async:(NSString *)imageName andSelfy:(id)selfy;

@end
