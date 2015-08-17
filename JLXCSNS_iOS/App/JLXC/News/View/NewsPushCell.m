//
//  NewsPushCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsPushCell.h"
#import "UIImageView+WebCache.h"

@interface NewsPushCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;

//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;

//时间
@property (nonatomic, strong) CustomLabel * timeLabel;

//内容
@property (nonatomic, strong) CustomLabel * contentLabel;

//新闻背景图
@property (nonatomic, strong) CustomImageView * newsImageView;

//新闻内容
@property (nonatomic, strong) CustomLabel * newsContentLabel;

@end

@implementation NewsPushCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.headImageView    = [[CustomImageView alloc] init];
        self.nameLabel        = [[CustomLabel alloc] initWithFontSize:15];
        self.timeLabel        = [[CustomLabel alloc] initWithFontSize:15];
        self.contentLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.newsImageView    = [[CustomImageView alloc] init];
        self.newsContentLabel = [[CustomLabel alloc] initWithFontSize:12];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.newsImageView];
        [self.contentView addSubview:self.newsContentLabel];
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    self.headImageView.frame               = CGRectMake(10, 5, 50, 50);
    self.headImageView.backgroundColor     = [UIColor grayColor];
    self.nameLabel.frame                   = CGRectMake(self.headImageView.right+10, self.headImageView.y, 0, 20);
    self.timeLabel.frame                   = CGRectMake(self.nameLabel.right+5, self.headImageView.y, 100, 20);
    self.contentLabel.frame                = CGRectMake(self.nameLabel.x, self.nameLabel.bottom, [DeviceManager getDeviceWidth]-140, 20);

    self.newsImageView.frame               = CGRectMake([DeviceManager getDeviceWidth]-60, 5, 50, 50);
    self.newsImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.newsImageView.layer.masksToBounds = YES;
    self.newsImageView.backgroundColor     = [UIColor grayColor];
    self.newsContentLabel.frame            = CGRectMake([DeviceManager getDeviceWidth]-60, 5, 50, 50);
    self.newsContentLabel.backgroundColor  = [UIColor lightGrayColor];
    self.newsContentLabel.numberOfLines    = 0;
    self.newsContentLabel.lineBreakMode    = NSLineBreakByCharWrapping;
}

- (void)setContentWithModel:(NewsPushModel *)model
{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_image]] placeholderImage:nil];
    //名字
    self.nameLabel.text    = model.name;
    CGSize size            = [ToolsManager getSizeWithContent:model.name andFontSize:15 andFrame:CGRectMake(0, 0, 100, 20)];
    self.nameLabel.width   = size.width;
    //时间
    self.timeLabel.x       = self.nameLabel.right+5;
    self.timeLabel.text    = [ToolsManager compareCurrentTime:model.push_time];
    if (model.type == PushLikeNews) {
        //内容
        self.contentLabel.text = @"为你点了赞";
    }else{
        //内容
        self.contentLabel.text = model.comment_content;
    }
    
    //有图片展示图片
    if (model.news_image.length > 0) {
        self.newsImageView.hidden    = NO;
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.news_image]] placeholderImage:nil];
        self.newsContentLabel.hidden = YES;
    }else{
        self.newsImageView.hidden    = YES;
        self.newsContentLabel.hidden = NO;
        self.newsContentLabel.text   = model.news_content;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
