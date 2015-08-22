//
//  NewsListCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/17.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsListCell.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "LikeModel.h"
#import "OtherPersonalViewController.h"
#import "IMGroupModel.h"
#import "NewsUtils.h"
#import "LikeListViewController.h"

@interface NewsListCell()

//新闻模型
@property (nonatomic, strong) NewsModel * news;
//头像
@property (nonatomic, strong) CustomButton * headImageBtn;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//时间
@property (nonatomic, strong) CustomLabel * timeLabel;
//描述
@property (nonatomic, strong) CustomLabel * descLabel;
//学校
@property (nonatomic, strong) CustomLabel * schoolLabel;
//内容
@property (nonatomic, strong) CustomLabel * contentLabel;
//线view
@property (nonatomic, strong) UIView * lineView;
//地址按钮
@property (nonatomic, strong) CustomButton * locationBtn;
//评论按钮
@property (nonatomic, strong) CustomButton * commentBtn;
//点赞按钮
@property (nonatomic, strong) CustomButton * likeBtn;
//点赞icon
@property (nonatomic, strong) CustomImageView * likeImageView;
//点赞过的人按钮
@property (nonatomic, strong) CustomButton * likePeopleBtn;

//可变视图数组 比如评论 图片
@property (nonatomic, strong) NSMutableArray * viewArr;

@end

@implementation NewsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.viewArr                       = [[NSMutableArray alloc] init];
        //头像
        self.headImageBtn                  = [[CustomButton alloc] init];
        //姓名
        self.nameLabel                     = [[CustomLabel alloc] init];
        //时间
        self.timeLabel                     = [[CustomLabel alloc] init];
        //描述
        self.descLabel                     = [[CustomLabel alloc] init];
        //学校
        self.schoolLabel                   = [[CustomLabel alloc] init];
        //内容
        self.contentLabel                  = [[CustomLabel alloc] init];
        //地址
        self.locationBtn                   = [[CustomButton alloc] init];
        //评论
        self.commentBtn                    = [[CustomButton alloc] init];
        //点赞
        self.likeBtn                       = [[CustomButton alloc] init];
        //点过赞的人
        self.likePeopleBtn                 = [[CustomButton alloc] init];
        //点赞过的人开始端图标
        self.likeImageView                 = [[CustomImageView alloc] init];
        //线
        self.lineView                      = [[UIView alloc] init];
        
        [self.contentView addSubview:self.headImageBtn];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.locationBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.likeImageView];
        [self.contentView addSubview:self.likePeopleBtn];
        [self.contentView addSubview:self.lineView];
        
        //头像点击
        [self.headImageBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
        //评论
        [self.commentBtn addTarget:self action:@selector(sendCommentClick) forControlEvents:UIControlEventTouchUpInside];
        //点赞
        [self.likeBtn addTarget:self action:@selector(sendLikeClick) forControlEvents:UIControlEventTouchUpInside];
        //点赞的人列表
        [self.likePeopleBtn addTarget:self action:@selector(likePeopleListClick:) forControlEvents:UIControlEventTouchUpInside];
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
//    self.selectionStyle                   = UITableViewCellSelectionStyleNone;
    
    //头像
    self.headImageBtn.frame               = CGRectMake(12, 10, 45, 45);
    self.headImageBtn.layer.cornerRadius  = 2;
    self.headImageBtn.layer.masksToBounds = YES;
    //姓名
    self.nameLabel.frame                  = CGRectMake(self.headImageBtn.right+10, self.headImageBtn.y, 0, 20);
    self.nameLabel.font                   = [UIFont systemFontOfSize:FontListName];
    self.nameLabel.textColor              = [UIColor colorWithHexString:ColorDeepBlack];

    self.descLabel.font                    = [UIFont systemFontOfSize:11];
    self.descLabel.textColor               = [UIColor colorWithHexString:ColorFlesh];
    //学校
    CustomImageView * schoolImageView      = [[CustomImageView alloc] init];
    schoolImageView.frame                  = CGRectMake(self.headImageBtn.right+10, self.nameLabel.bottom+7, 15, 15);
    schoolImageView.image                  = [UIImage imageNamed:@"school_icon"];
    [self.contentView addSubview:schoolImageView];
    
    self.schoolLabel.frame                = CGRectMake(schoolImageView.right+3, schoolImageView.y-3, 250, 20);
    self.schoolLabel.font                 = [UIFont systemFontOfSize:13];
    self.schoolLabel.textColor            = [UIColor colorWithHexString:ColorGary];
    
    self.contentLabel.frame               = CGRectMake(self.headImageBtn.x, self.headImageBtn.bottom+5, [DeviceManager getDeviceWidth]-30, 0);
    self.contentLabel.numberOfLines       = 0;
    self.contentLabel.font                = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor           = [UIColor colorWithHexString:ColorDeepBlack];
    
    //地理位置
    [self.locationBtn setTitleColor:[UIColor colorWithHexString:ColorLightBlue] forState:UIControlStateNormal];
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    self.locationBtn.titleLabel.font            = [UIFont systemFontOfSize:14];
    self.locationBtn.frame                      = CGRectMake(self.nameLabel.x+10, 0, 190, 20);
    self.locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //时间
    self.timeLabel.frame                  = CGRectMake(self.headImageBtn.x, 0, 250, 20);
    self.timeLabel.font                   = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor              = [UIColor colorWithHexString:ColorGary];
    
    //评论按钮
    self.commentBtn.titleLabel.font     = [UIFont systemFontOfSize:14];
    self.commentBtn.titleEdgeInsets     = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"btn_comment_normal"] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    
    //点赞
    self.likeBtn.titleLabel.font        = [UIFont systemFontOfSize:14];
    self.likeBtn.titleEdgeInsets        = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    
    self.likeImageView = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"like_icon"]];
    self.likeImageView.frame = CGRectMake(self.headImageBtn.x, 0, 15, 15);
    [self.contentView addSubview:self.likeImageView];
    
    self.likePeopleBtn.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    self.likePeopleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.likePeopleBtn.frame           = CGRectMake([DeviceManager getDeviceWidth]-45, 0, 30, 20);
    [self.likePeopleBtn setTitleColor:[UIColor colorWithHexString:ColorDeepBlack] forState:UIControlStateNormal];
    
    self.lineView.backgroundColor      = [UIColor colorWithHexString:ColorLightWhite];
}

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news
{
    self.news = news;
    
    //清空可变数组
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    
    //头像
    //加载头像
    NSURL * headUrl          = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, news.head_sub_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    
    //姓名
    NSString * name          = news.name;
    CGSize nameSize          = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.nameLabel.width     = nameSize.width;
    self.nameLabel.text      = name;

    //学校
    self.schoolLabel.text    = news.school;
    
    if (news.typeDic[@"content"] != nil || [news.typeDic[@"content"] length]>0) {
        CGSize nameSize      = [ToolsManager getSizeWithContent:news.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 30)];
        self.nameLabel.width = nameSize.width;
        self.descLabel.x     = self.nameLabel.right;
        NSString * content   = [NSString stringWithFormat:@" %@", news.typeDic[@"content"]];
        self.descLabel.text  = content;
    }


    //内容
    CGSize contentSize       = [ToolsManager getSizeWithContent:news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    if (news.content_text == nil || news.content_text.length < 1) {
        contentSize.height = 0;
    }
    self.contentLabel.height = contentSize.height;
    self.contentLabel.text   = news.content_text;

    //底部位置
    CGFloat bottomPosition = self.contentLabel.bottom ;
    //图片处理
    if (news.image_arr.count == 1) {
        //一张图片放大
        ImageModel * imageModel = news.image_arr[0];
        CGRect rect             = [NewsUtils getRectWithSize:CGSizeMake(imageModel.width, imageModel.height)];
        rect.origin.x           = self.headImageBtn.x;
        rect.origin.y           = self.contentLabel.bottom+5;
        CustomButton * imageBtn = [[CustomButton alloc] init];
        //加载单张
        NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
        [imageBtn addGestureRecognizer:tap];
        [imageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageBtn.frame          = rect;
        [self.contentView addSubview:imageBtn];
        //底部位置
        bottomPosition          = imageBtn.bottom;
        //插入
        [self.viewArr addObject:imageBtn];
    }else{
        //多张图片九宫格
        NSArray * btnArr        = news.image_arr;
        for (int i=0; i<btnArr.count; i++) {
            ImageModel * imageModel = news.image_arr[i];
            NSInteger columnNum     = i%3;
            NSInteger lineNum       = i/3;
            CustomImageView * imageView = [[CustomImageView alloc] init];
            imageView.tag            = i;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode    = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            CGFloat itemWidth = [DeviceManager getDeviceWidth]/5.0;
            imageView.frame          = CGRectMake(self.headImageBtn.x+(itemWidth+10)*columnNum, self.contentLabel.bottom+5+(itemWidth+10)*lineNum, itemWidth, itemWidth);
            
            //加载缩略图
            NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
            [imageView addGestureRecognizer:tap];
            [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
            
            [self.contentView addSubview:imageView];
            //底部位置
            if (btnArr.count == i+1) {
                bottomPosition          = imageView.bottom;
            }
            //插入
            [self.viewArr addObject:imageView];
        }
    }
    
    //地址按钮 没有不显示
    if (news.location.length > 0) {
        NSString * locationTitle                  = [NSString stringWithFormat:@" %@", news.location];
        [self.locationBtn setTitle:locationTitle forState:UIControlStateNormal];
        self.locationBtn.y                        = bottomPosition+5;
        bottomPosition                            = self.locationBtn.bottom;
    }else{
        self.locationBtn.hidden = YES;
    }
    
    //时间
    NSString * timeStr       = [ToolsManager compareCurrentTime:news.publish_date];
    self.timeLabel.y         = bottomPosition+5;
    self.timeLabel.text      = timeStr;
    
    bottomPosition           += 20;
    
    //评论按钮
    self.commentBtn.frame    = CGRectMake([DeviceManager getDeviceWidth]-150, bottomPosition+5, 60, 25);
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    //点赞按钮
    self.likeBtn.frame      = CGRectMake([DeviceManager getDeviceWidth]-75, bottomPosition+5, 60, 25);
    if (self.news.is_like) {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_selected"] forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"已赞" forState:UIControlStateNormal];
    }else{
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
        [self.likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
    }

    //游标
    bottomPosition = self.commentBtn.bottom+5;
    
    //计算点赞头像尺寸
    CGFloat width  = ([DeviceManager getDeviceWidth]-53-self.likeImageView.right)/8;
    //有点赞
    if (news.like_arr.count > 0) {
        self.likeImageView.y      = bottomPosition+(width-5-self.likeImageView.width)/2;
        self.likeImageView.hidden = NO;
    }else{
        self.likeImageView.hidden = YES;
    }

    //点赞头像 最多8个 大小根据分辨率算
    NSInteger likeCout = news.like_arr.count;
    if (likeCout > 8) {
        likeCout = 8;
    }
    for (int i=0; i<likeCout; i++) {

        LikeModel * like           = news.like_arr[i];
        CustomButton * likeHeadBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.likeImageView.right+3+width*i, bottomPosition, width-5, width-5)];
        NSURL * headUrl            = [NSURL URLWithString:[ToolsManager completeUrlStr:like.head_sub_image]];
        [likeHeadBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        likeHeadBtn.tag            = i;
        //点击事件
        [likeHeadBtn addTarget:self action:@selector(likeImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:likeHeadBtn];
        //插入
        [self.viewArr addObject:likeHeadBtn];
    }
    
    //如果点赞超过7个 那么显示查看全部按钮
    if (news.like_arr.count > 7) {
        self.likePeopleBtn.hidden = NO;
        self.likePeopleBtn.y = bottomPosition+(width-5-self.likePeopleBtn.height)/2;
        [self.likePeopleBtn setTitle:[NSString stringWithFormat:@"%ld", news.like_quantity] forState:UIControlStateNormal];
    }else{
        self.likePeopleBtn.hidden = YES;
    }

    if (self.news.like_arr.count > 0) {
        bottomPosition += width+5;
    }

    //评论
    for (int i=0; i<news.comment_arr.count; i++) {
        
        CommentModel * comment              = news.comment_arr[i];
        //评论文本 姓名：内容 //是好友查看备注
        NSString * commentName              = comment.name;
        NSString * commentStr               = [NSString stringWithFormat:@"%@:%@", commentName, comment.comment_content];

        CustomLabel * commentLabel          = [[CustomLabel alloc] initWithFontSize:14];
        commentLabel.userInteractionEnabled = YES;
        commentLabel.tag                    = i;
        //删除或者其他动作
        UITapGestureRecognizer * tap        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
        [commentLabel addGestureRecognizer:tap];

        commentLabel.textColor              = [UIColor colorWithHexString:ColorLightBlack];
        //frame
        CGSize commentSize                  = [ToolsManager getSizeWithContent:commentStr andFontSize:14 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, commentName.length+1)];
        commentLabel.attributedText         = attrStr;
        commentLabel.lineBreakMode          = NSLineBreakByCharWrapping;
        commentLabel.numberOfLines          = 0;
        commentLabel.frame                  = CGRectMake(self.headImageBtn.x, bottomPosition, commentSize.width, commentSize.height);
        [self.contentView addSubview:commentLabel];

        //前面的name
        NSString * nameStr                  = [NSString stringWithFormat:@"%@:", commentName];
        CustomLabel * nameLabel             = [[CustomLabel alloc] initWithFontSize:14];
        nameLabel.userInteractionEnabled    = YES;
        nameLabel.tag                       = i;
        nameLabel.textColor                 = [UIColor colorWithHexString:ColorBrown];
        //frame
        CGSize nameSize                     = [ToolsManager getSizeWithContent:nameStr andFontSize:14 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
        nameLabel.text                      = nameStr;
        nameLabel.lineBreakMode             = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines             = 0;
        nameLabel.frame                     = CGRectMake(self.headImageBtn.x, bottomPosition, nameSize.width, nameSize.height);
        [self.contentView addSubview:nameLabel];

        bottomPosition                      = commentLabel.bottom + 5;
        
        //插入
        [self.viewArr addObject:commentLabel];
    }
    
    //线
    self.lineView.frame        = CGRectMake(0, bottomPosition+5, [DeviceManager getDeviceWidth], 10);
}

#pragma mark- method response
//大头像点击
- (void)headClick:(CustomButton *)btn
{
    [self browsePersonalHome:self.news.uid];
}
//点赞头像点击
- (void)likeImageClick:(CustomButton *)btn
{
    LikeModel * like = self.news.like_arr[btn.tag];
    [self browsePersonalHome:like.user_id];
}

//图片点击
- (void)imageDetailClick:(UITapGestureRecognizer *) ges
{
    if ([self.delegate respondsToSelector:@selector(imageClick:index:)]) {
        [self.delegate imageClick:self.news index:ges.view.tag];
    }
}
//发送评论按钮点击
- (void)sendCommentClick {
    
    if ([self.delegate respondsToSelector:@selector(sendCommentClick:)]) {
        [self.delegate sendCommentClick:self.news];
    }
}

//点赞或者取消赞点击
- (void)sendLikeClick {
    
    if ([self.delegate respondsToSelector:@selector(likeClick:likeOrCancel:)]) {
        BOOL likeOrCancel = YES;
        //先修改在进行网络请求
        if (self.news.is_like) {
            self.news.is_like = NO;
            likeOrCancel     = NO;
            self.news.like_quantity --;
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
        }else{
            self.news.is_like = YES;
            self.news.like_quantity ++;
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_selected"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"已赞" forState:UIControlStateNormal];
        }
        
        [self.delegate likeClick:self.news likeOrCancel:likeOrCancel];
    }
    
    
}

//评论点击
- (void)commentTap:(UITapGestureRecognizer *)tap
{
//    NSArray * commentArr     = self.news.comment_arr;
//    CommentModel * model     = commentArr[tap.view.tag];
//    if (model.user_id == [UserService sharedService].user.uid) {
//        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//        sheet.tag             = tap.view.tag;
//        [sheet showInView:[(UIViewController *)self.delegate view]];
//    }else{
////        ALERT_SHOW(@"奏凯", @"");
//        [self browsePersonalHome:model.user_id];
//    }
}

//浏览其他人的主页
- (void)browsePersonalHome:(NSInteger)userId
{
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid = userId;
    [((BaseViewController *)self.delegate) pushVC:opvc];
    
}
//点赞列表
- (void)likePeopleListClick:(id)sender
{
    LikeListViewController * llVC = [[LikeListViewController alloc] init];
    llVC.news_id = self.news.nid;
    [((BaseViewController *)self.delegate) pushVC:llVC];
}

//#pragma mark- Action Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //选照片
//    if (buttonIndex == 0) {
//        if ([self.delegate respondsToSelector:@selector(deleteCommentClick:index:)]) {
//            [self.delegate deleteCommentClick:self.news index:actionSheet.tag];
//        }
//    }
//    
//}

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
