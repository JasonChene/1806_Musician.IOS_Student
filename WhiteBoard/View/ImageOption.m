//
//  ImageOption.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/8/24.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "ImageOption.h"

@implementation ImageOption
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (maxLength > data.length) {
        compression = maxLength * 0.01 / data.length > 0.1 ? maxLength * 0.01 / data.length : 0.1;
    }
    data = UIImageJPEGRepresentation(image, compression);
    
    if (data.length < maxLength) return image;

    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
@end
