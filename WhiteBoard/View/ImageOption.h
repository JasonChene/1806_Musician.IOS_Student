//
//  ImageOption.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/8/24.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageOption : NSObject
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
+ (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength :(UIImage *)image;
+ (UIImage *)normalizedImage:(UIImage *)image;
@end
