//
//  TopicMainCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicMainCell.h"
#import "UIImageView+WebCache.h"
@interface TopicMainCell()

//背景
@property (nonatomic, strong) UIView * backView;
//姓名
@property (nonatomic, strong) CustomLabel * topicNameLabel;
//图片
@property (nonatomic, strong) CustomImageView * topicImageView;
//描述
@property (nonatomic, strong) CustomLabel * descLabel;
//关注人数
@property (nonatomic, strong) CustomLabel * memberCountLabel;
//内容数量
@property (nonatomic, strong) CustomLabel * newsCountLabel;

@end

@implementation TopicMainCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backView         = [[UIView alloc] init];
    self.topicNameLabel   = [[CustomLabel alloc] init];
    self.topicImageView   = [[CustomImageView alloc] init];
    self.descLabel        = [[CustomLabel alloc] init];
    self.memberCountLabel = [[CustomLabel alloc] init];
    self.newsCountLabel   = [[CustomLabel alloc] init];
    
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.topicNameLabel];
    [self.contentView addSubview:self.topicImageView];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.memberCountLabel];
    [self.contentView addSubview:self.newsCountLabel];
    
    [self configUI];
    
    return self;
}

- (void)configUI
{
    //通用宽
    CGFloat width = [DeviceManager getDeviceWidth]-40;
    
    self.backView.frame              = CGRectMake(kCenterOriginX(width), 15, width, [DeviceManager getDeviceHeight]-kNavBarAndStatusHeight-kTabBarHeight-35);
    self.backView.layer.cornerRadius = 10;
    self.backView.backgroundColor    = [UIColor colorWithHexString:ColorWhite];
    //名字
    self.topicNameLabel.frame     = CGRectMake(kCenterOriginX((width-20)), 30, width-20, 20);
    self.topicNameLabel.font      = [UIFont systemFontOfSize:16];
    self.topicNameLabel.textColor = [UIColor colorWithHexString:ColorDeepBlack];
    //图片
    self.topicImageView.frame               = CGRectMake(self.backView.x, self.topicNameLabel.bottom+10, self.backView.width, self.height-self.topicNameLabel.bottom-110-40);
    self.topicImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.topicImageView.layer.masksToBounds = YES;
    //描述
    self.descLabel.frame           = CGRectMake(self.topicNameLabel.x, self.topicImageView.bottom, self.topicNameLabel.width, 80);
    self.descLabel.numberOfLines   = 0;
    self.descLabel.font            = [UIFont systemFontOfSize:14];
    self.descLabel.textColor       = [UIColor colorWithHexString:ColorDeepBlack];
    //成员
    CustomImageView * memberImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.descLabel.x, self.backView.bottom-35, 20, 20)];
    memberImageView.image             = [UIImage imageNamed:@"member_count_icon"];
    [self.contentView addSubview:memberImageView];
    self.memberCountLabel.frame       = CGRectMake(memberImageView.right+5, memberImageView.y, 80, 20);
    self.memberCountLabel.font        = [UIFont systemFontOfSize:13];
    self.memberCountLabel.textColor   = [UIColor colorWithHexString:ColorBrown];
    //内容
    CustomImageView * newsImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.memberCountLabel.right, memberImageView.y, 20, 20)];
    newsImageView.image             = [UIImage imageNamed:@"news_count_icon"];
    [self.contentView addSubview:newsImageView];
    self.newsCountLabel.frame       = CGRectMake(newsImageView.right+5, newsImageView.y, 100, 20);
    self.newsCountLabel.font        = [UIFont systemFontOfSize:13];
    self.newsCountLabel.textColor   = [UIColor colorWithHexString:ColorBrown];

}

- (void)setContentWith:(TopicModel *)topic
{
    //描述
    self.descLabel.text        = topic.topic_detail;
    //名字
    self.topicNameLabel.text   = topic.topic_name;
    //成员
    self.memberCountLabel.text = [NSString stringWithFormat:@"%ld人关注", topic.member_count];
    //数量
    self.newsCountLabel.text   = [NSString stringWithFormat:@"%ld条内容", topic.news_count];
    //封面
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:topic.topic_cover_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
}

@end
