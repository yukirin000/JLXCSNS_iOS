//
//  MyTopicCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/26.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MyTopicCell.h"
#import "UIImageView+WebCache.h"

@interface MyTopicCell()

//姓名
@property (nonatomic, strong) CustomLabel * topicNameLabel;
//图片
@property (nonatomic, strong) CustomImageView * topicImageView;
//关注人数
@property (nonatomic, strong) CustomLabel * memberCountLabel;
//内容数量
@property (nonatomic, strong) CustomLabel * unreadCountLabel;

@end

@implementation MyTopicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topicNameLabel   = [[CustomLabel alloc] init];
        self.topicImageView   = [[CustomImageView alloc] init];
        self.memberCountLabel = [[CustomLabel alloc] init];
        self.unreadCountLabel   = [[CustomLabel alloc] init];
        
        [self.contentView addSubview:self.topicNameLabel];
        [self.contentView addSubview:self.topicImageView];
        [self.contentView addSubview:self.memberCountLabel];
        [self.contentView addSubview:self.unreadCountLabel];
        
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
    //未读内容
    self.unreadCountLabel.frame               = CGRectMake([DeviceManager getDeviceWidth]-40, 20, 25, 25);
    self.unreadCountLabel.backgroundColor     = [UIColor redColor];
    self.unreadCountLabel.layer.cornerRadius  = 12.5;
    self.unreadCountLabel.layer.masksToBounds = YES;
    self.unreadCountLabel.textAlignment       = NSTextAlignmentCenter;
    self.unreadCountLabel.font                = [UIFont systemFontOfSize:15];
    self.unreadCountLabel.textColor           = [UIColor whiteColor];
    
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
    NSInteger unreadCount = topic.unread_news_count;
    if (unreadCount > 99) {
        unreadCount = 99;
    }
    //未读数量
    self.unreadCountLabel.text = [NSString stringWithFormat:@"%ld", unreadCount];
    if (unreadCount < 1) {
        self.unreadCountLabel.hidden = YES;
    }else{
        self.unreadCountLabel.hidden = NO;
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
