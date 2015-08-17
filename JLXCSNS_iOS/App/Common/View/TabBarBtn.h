//
//  TabBarBtn.h
//  TabBtn
//
//  Created by bhczmacmini on 14-11-26.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <UIKit/UIKit.h>


/*tabBar用btn*/
@interface TabBarBtn : UIButton


@property (nonatomic, strong) UILabel * titeLabel;

/*! 
    @method
    @brief 增加一个徽标
*/
- (void)refreshBadgeWith:(NSInteger)num;

/*!
    @method
    @brief 取消徽标 弃用
 */
//- (void)cancelBadge;

@end
