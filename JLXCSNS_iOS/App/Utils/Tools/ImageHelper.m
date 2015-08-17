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
    CGFloat bigScale = ([DeviceManager getDeviceWidth]*3.0)/imageSize.width;
    //缩小原图
    UIImage *scaleBigImage = [self scaleImage:image toScale:bigScale];
    return scaleBigImage;

}

/*! 获取缩放后的小图 弃用*/
+(UIImage *)getSubImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    CGFloat bigScale = ([DeviceManager getDeviceWidth]*1.5)/imageSize.width;
    //缩略图
    UIImage *scaleSubImage = [self scaleImage:image toScale:bigScale/10];
    
    return scaleSubImage;
}


//缩放图片
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
//    NSData * jpgImage = UIImageJPEGRepresentation(image, 1.0);
//    NSData * pngImage = UIImagePNGRepresentation(image);
    
//    debugLog(@"%ld %ld", jpgImage.length, pngImage.length);
    UIImage * jpgImgae = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];
    //    debugLog(@"%@", NSStringFromCGSize(image.size));
    UIGraphicsBeginImageContext(CGSizeMake(jpgImgae.size.width*scaleSize,jpgImgae.size.height*scaleSize));
    [jpgImgae drawInRect:CGRectMake(0, 0, jpgImgae.size.width * scaleSize, jpgImgae.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    debugLog(@"%@", NSStringFromCGSize(scaledImage.size));
    
    
    return scaledImage;
}

@end
