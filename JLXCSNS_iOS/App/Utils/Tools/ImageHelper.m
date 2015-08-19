//
//  ImageHelper.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

/*! 获取缩放后的大图*/
+(UIImage *)getBigImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    CGSize newSize = imageSize;
    CGFloat bigScale = ([DeviceManager getDeviceWidth]*3)/imageSize.width;
    if (bigScale < 1) {
        newSize = CGSizeMake([DeviceManager getDeviceWidth]*3, (int)(bigScale*imageSize.height));
    }
    
    //缩小原图
    UIImage *scaleBigImage = [self scaleImage:image toScaleSize:newSize];
    return scaleBigImage;
}

///*! 获取缩放后的小图 弃用*/
//+(UIImage *)getSubImage:(UIImage *)image
//{
//    CGSize imageSize = image.size;
//    CGFloat bigScale = ([DeviceManager getDeviceWidth]*1.5)/imageSize.width;
//    //缩略图
//    UIImage *scaleSubImage = [self scaleImage:image toScale:bigScale/10];
//    
//    return scaleSubImage;
//}


//缩放图片
+(UIImage *)scaleImage:(UIImage *)image toScaleSize:(CGSize)newSize
{
//    NSData * jpgImage = UIImageJPEGRepresentation(image, 1.0);
//    NSData * pngImage = UIImagePNGRepresentation(image);
//    
//    debugLog(@"%ld %ld", jpgImage.length, pngImage.length);
    UIImage * jpgImgae = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.0001)];
    UIGraphicsBeginImageContext(newSize);
    
    [jpgImgae drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [UIImage imageWithData:UIImageJPEGRepresentation(scaledImage, 0.8)];
}

@end
