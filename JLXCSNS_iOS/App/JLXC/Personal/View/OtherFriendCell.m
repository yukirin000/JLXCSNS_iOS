//
//  OtherFriendCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OtherFriendCell.h"
#import "UIImageView+WebCache.h"

@interface OtherFriendCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//签名
@property (nonatomic, strong) CustomLabel * schoolLabel;
//line
@property (nonatomic, strong) UIView * lineView;
//关注按钮
@property (nonatomic, strong) CustomButton * attentBtn;

@property (nonatomic, strong) FriendModel * friendModel;

@end

@implementation OtherFriendCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.headImageView = [[CustomImageView alloc] init];
        self.nameLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.schoolLabel   = [[CustomLabel alloc] initWithFontSize:15];
        self.lineView      = [[UIView alloc] init];
        self.attentBtn     = [[CustomButton alloc] init];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.attentBtn];
        [self.contentView addSubview:self.lineView];
        
        [self configUI];
        
    }
    
    return self;
}

- (void)configUI
{
    self.headImageView.frame               = CGRectMake(10, 10, 45, 45);
    self.headImageView.layer.cornerRadius  = 2;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame                   = CGRectMake(self.headImageView.right+10, self.headImageView.y+3, 200, 20);
    self.nameLabel.font                    = [UIFont systemFontOfSize:FontListName];
    self.nameLabel.textColor               = [UIColor colorWithHexString:ColorDeepBlack];
    
    self.schoolLabel.frame                 = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom+1, 220, 20);
    self.schoolLabel.font                  = [UIFont systemFontOfSize:FontListContent];
    self.schoolLabel.textColor             = [UIColor colorWithHexString:ColorDeepGary];
    
    self.attentBtn.frame                   = CGRectMake([DeviceManager getDeviceWidth]-100, 17, 75, 30);
    self.attentBtn.backgroundColor         = [UIColor colorWithHexString:ColorGary];
    [self.attentBtn setTitleColor:[UIColor colorWithHexString:ColorWhite] forState:UIControlStateNormal];
    [self.attentBtn addTarget:self action:@selector(attentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView.frame                    = CGRectMake(10, 64, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor          = [UIColor colorWithHexString:ColorLightGary];
    
}

#pragma mark- public method
- (void)setContentWithModel:(FriendModel *)model
{
    self.friendModel      = model;
    //头像
    NSURL * imageUrl      = [NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //姓名
    self.nameLabel.text   = model.name;
    //学校
    self.schoolLabel.text = model.school;
    
    if (model.isOrHasAttent) {
        [self.attentBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.attentBtn.backgroundColor = [UIColor colorWithHexString:ColorGary];
        [self.attentBtn setTintColor:[UIColor colorWithHexString:ColorWhite]];
    }else{
        [self.attentBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.attentBtn.backgroundColor = [UIColor colorWithHexString:ColorYellow];
        [self.attentBtn setTintColor:[UIColor colorWithHexString:ColorBrown]];
    }
    
}

#pragma mark- private method
- (void)attentBtnClick:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(attentBtnClickCall:)]) {
            [self.delegate attentBtnClickCall:self.friendModel];
        }
    }
}
@end
