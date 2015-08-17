//
//  OtherPeopleFriendCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/2.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OtherPeopleFriendCell.h"
#import "UIImageView+WebCache.h"


@interface OtherPeopleFriendCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//签名
@property (nonatomic, strong) CustomLabel * schoolLabel;
//line
@property (nonatomic, strong) UIView * lineView;

@end

@implementation OtherPeopleFriendCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.headImageView = [[CustomImageView alloc] init];
        self.nameLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.schoolLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.lineView      = [[UIView alloc] init];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.lineView];
        
        [self configUI];
        
    }
    
    return self;
}

- (void)configUI
{
    self.headImageView.frame      = CGRectMake(5, 5, 40, 40);
    self.nameLabel.frame          = CGRectMake(self.headImageView.right+10, self.headImageView.y, 0, 20);
    self.schoolLabel.frame          = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom, 250, 20);
    
    self.lineView.frame           = CGRectMake(5, 49, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor = [UIColor darkGrayColor];
    
}

- (void)setContentWithModel:(OtherPeopleFriendModel *)model
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
    self.schoolLabel.text = model.school;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
