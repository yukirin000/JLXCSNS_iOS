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
        self.nameLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.signLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.timeLabel     = [[CustomLabel alloc] initWithFontSize:13];
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
    self.headImageView.frame      = CGRectMake(5, 5, 40, 40);
    self.nameLabel.frame          = CGRectMake(self.headImageView.right+10, self.headImageView.y, 0, 20);
    self.signLabel.frame          = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom, 250, 20);
    self.timeLabel.frame          = CGRectMake([DeviceManager getDeviceWidth]-120, self.headImageView.y, 100, 20);
    self.timeLabel.textAlignment  = NSTextAlignmentRight;

    self.lineView.frame           = CGRectMake(5, 49, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor = [UIColor darkGrayColor];
    
}

- (void)setContentWithModel:(VisitModel *)model
{
    //头像
    NSURL * imageUrl = [NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"testimage"]];
    //姓名
    NSString * name      = [ToolsManager getRemarkOrOriginalNameWithUid:model.uid andOriginalName:model.name];
    CGSize size          = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 30)];
    self.nameLabel.text  = name;
    self.nameLabel.width = size.width;
    //签名
    self.signLabel.text = model.sign;
    //时间
    self.timeLabel.text = [ToolsManager compareCurrentTime:model.visit_time];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
