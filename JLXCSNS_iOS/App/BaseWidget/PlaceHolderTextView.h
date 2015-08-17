//
//  PlaceHolderTextView.h
//  CustomTextView
//
//  Created by bhczmacmini on 14-12-21.
//  Copyright (c) 2014年 bhcz. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief 带placeHolder的textView
 */
@interface PlaceHolderTextView : UITextView<UITextViewDelegate>

/*!
 @method
 @param frame 该视图的frame
 @param placeHolder 该视图的placeHolder
 @brief 必须调用这个方法进行初始化
*/
- (instancetype)initWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHolder;

/*!
 @method
 @param hidden 是否隐藏
 @brief 隐藏placeHolder
 */
- (void)setPlaceHidden:(BOOL)hidden;

@end
