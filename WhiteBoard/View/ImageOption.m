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

+ (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength :(UIImage *)image {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}
+ (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
