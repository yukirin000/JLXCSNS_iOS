//
//  MorTopicCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MoreTopicCell.h"
#import "UIImageView+WebCache.h"

@interface MoreTopicCell()

//姓名
@property (nonatomic, strong) CustomLabel * topicNameLabel;
//图片
@property (nonatomic, strong) CustomImageView * topicImageView;
//关注人数
@property (nonatomic, strong) CustomLabel * memberCountLabel;
//内容数量
@property (nonatomic, strong) CustomLabel * newsCountLabel;

@end

@implementation MoreTopicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topicNameLabel   = [[CustomLabel alloc] init];
        self.topicImageView   = [[CustomImageView alloc] init];
        self.memberCountLabel = [[CustomLabel alloc] init];
        self.newsCountLabel   = [[CustomLabel alloc] init];
        
        [self.contentView addSubview:self.topicNameLabel];
        [self.contentView addSubview:self.topicImageView];
        [self.contentView addSubview:self.memberCountLabel];
        [self.contentView addSubview:self.newsCountLabel];
        
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    //图片
    self.topicImageView.frame               = CGRectMake(15, 10, 50, 50);
    self.topicImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.topicImageView.layer.masksToBounds = YES;
    //名字
    self.topicNameLabel.frame     = CGRectMake(self.topicImageView.right+10, 13, 200, 20);
    self.topicNameLabel.font      = [UIFont systemFontOfSize:15];
    self.topicNameLabel.textColor = [UIColor colorWithHexString:ColorDeepBlack];
    //成员
    CustomImageView * memberImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.topicNameLabel.x, self.topicNameLabel.bottom+8, 15, 15)];
    memberImageView.image             = [UIImage imageNamed:@"member_count_icon"];
    [self.contentView addSubview:memberImageView];
    self.memberCountLabel.frame       = CGRectMake(memberImageView.right+5, memberImageView.y, 80, 15);
    self.memberCountLabel.font        = [UIFont systemFontOfSize:13];
    self.memberCountLabel.textColor   = [UIColor colorWithHexString:ColorBrown];
    //内容
    CustomImageView * newsImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.memberCountLabel.right, memberImageView.y, 15, 15)];
    newsImageView.image             = [UIImage imageNamed:@"news_count_icon"];
    [self.contentView addSubview:newsImageView];
    self.newsCountLabel.frame       = CGRectMake(newsImageView.right+5, newsImageView.y, 100, 15);
    self.newsCountLabel.font        = [UIFont systemFontOfSize:13];
    self.newsCountLabel.textColor   = [UIColor colorWithHexString:ColorBrown];
    
    UIView * lineView        = [[UIView alloc] initWithFrame:CGRectMake(0, self.topicImageView.bottom+10, [DeviceManager getDeviceWidth], 5)];
    lineView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    [self.contentView addSubview:lineView];
    
}

- (void)setContentWith:(TopicModel *)topic
{
    //名字
    self.topicNameLabel.text   = topic.topic_name;
    //成员
    self.memberCountLabel.text = [NSString stringWithFormat:@"%ld人关注", topic.member_count];
    //数量
    self.newsCountLabel.text   = [NSString stringWithFormat:@"%ld条内容", topic.news_count];
    if (!topic.has_news) {
        self.newsCountLabel.text   = @"0条内容";        
    }
    //封面
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:topic.topic_cover_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
