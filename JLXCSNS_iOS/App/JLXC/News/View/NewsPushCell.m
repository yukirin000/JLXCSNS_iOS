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

//底部线
@property (nonatomic, strong) UIView * lineView;

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
        self.lineView         = [[UIView alloc] init];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.newsImageView];
        [self.contentView addSubview:self.newsContentLabel];
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
    self.nameLabel.textColor               = [UIColor colorWithHexString:ColorBrown];

    self.contentLabel.frame                = CGRectMake(self.nameLabel.x, self.nameLabel.bottom, [DeviceManager getDeviceWidth]-140, 20);
    self.contentLabel.font                 = [UIFont systemFontOfSize:13];
    self.contentLabel.numberOfLines        = 0;
    self.contentLabel.textColor            = [UIColor colorWithHexString:ColorDeepBlack];
    self.contentLabel.lineBreakMode        = NSLineBreakByCharWrapping;
    
    self.timeLabel.frame                   = CGRectMake(self.nameLabel.x, 0, 200, 20);
    self.timeLabel.font                    = [UIFont systemFontOfSize:FontListContent];
    self.timeLabel.textColor               = [UIColor colorWithHexString:ColorDeepGary];
    self.timeLabel.textAlignment           = NSTextAlignmentLeft;

    self.newsImageView.frame               = CGRectMake([DeviceManager getDeviceWidth]-60, 10, 50, 50);
    self.newsImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.newsImageView.layer.masksToBounds = YES;
    
    self.newsContentLabel.frame            = CGRectMake([DeviceManager getDeviceWidth]-60, 10, 50, 50);
    self.newsContentLabel.backgroundColor  = [UIColor colorWithHexString:ColorLightGary];
    self.newsContentLabel.numberOfLines    = 0;
    self.newsContentLabel.lineBreakMode    = NSLineBreakByCharWrapping;
    
    //底部线
    self.lineView.frame                    = CGRectMake(10, 0, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor          = [UIColor colorWithHexString:ColorLightGary];
}

- (void)setContentWithModel:(NewsPushModel *)model
{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_image]] placeholderImage:nil];
    //名字
    self.nameLabel.text    = model.name;
    NSString * content = model.comment_content;
    if (model.type == PushLikeNews) {
        //内容
        content = @"为你点了赞";
    }
    
    //动态修改content
    CGSize contentSize       = [ToolsManager getSizeWithContent:content andFontSize:13 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-140, 100)];
    if (contentSize.height < 20) {
        contentSize.height = 20;
    }
    self.contentLabel.width  = contentSize.width;
    self.contentLabel.height = contentSize.height;
    self.contentLabel.text   = content;

    //时间位置修改
    self.timeLabel.y         = self.contentLabel.bottom;
    self.timeLabel.text      = [ToolsManager compareCurrentTime:model.push_time];
    //底部线
    self.lineView.y          = self.timeLabel.bottom+1;
    
    //有图片展示图片
    if (model.news_image.length > 0) {
        self.newsImageView.hidden    = NO;
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.news_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
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
