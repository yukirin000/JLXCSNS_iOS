//
//  VisitListCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/1.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "VisitListCell.h"
#import "UIImageView+WebCache.h"

@interface VisitListCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//签名
@property (nonatomic, strong) CustomLabel * signLabel;
//时间
@property (nonatomic, strong) CustomLabel * timeLabel;
//line
@property (nonatomic, strong) UIView * lineView;

@end

@implementation VisitListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.headImageView = [[CustomImageView alloc] init];
        self.nameLabel     = [[CustomLabel alloc] init];
        self.signLabel     = [[CustomLabel alloc] init];
        self.timeLabel     = [[CustomLabel alloc] init];
        self.lineView      = [[UIView alloc] init];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.signLabel];
        [self.contentView addSubview:self.timeLabel];
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

    self.nameLabel.frame                   = CGRectMake(self.headImageView.right+10, self.headImageView.y+3, 0, 20);
    self.nameLabel.font                    = [UIFont systemFontOfSize:FontListName];
    self.nameLabel.textColor               = [UIColor colorWithHexString:ColorDeepBlack];

    self.signLabel.frame                   = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom+1, 220, 20);
    self.signLabel.font                    = [UIFont systemFontOfSize:FontListContent];
    self.signLabel.textColor               = [UIColor colorWithHexString:ColorDeepGary];
    
    self.timeLabel.frame                   = CGRectMake([DeviceManager getDeviceWidth]-120, self.headImageView.y+3, 100, 20);
    self.timeLabel.font                    = [UIFont systemFontOfSize:FontListContent];
    self.timeLabel.textColor               = [UIColor colorWithHexString:ColorDeepGary];
    self.timeLabel.textAlignment           = NSTextAlignmentRight;

    self.lineView.frame                    = CGRectMake(10, 64, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor          = [UIColor colorWithHexString:ColorLightGary];
    
}

- (void)setContentWithModel:(VisitModel *)model
{
    //头像
    NSURL * imageUrl     = [NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //姓名
    NSString * name      = model.name;
    CGSize size          = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 30)];
    self.nameLabel.text  = name;
    self.nameLabel.width = size.width;
    //签名
    self.signLabel.text  = model.sign;
    //时间
    self.timeLabel.text  = [ToolsManager compareCurrentTime:model.visit_time];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
