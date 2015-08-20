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
//点赞过的人按钮
@property (nonatomic, strong) CustomButton * likePeopleBtn;
//删除新闻的功能
@property (nonatomic, strong) CustomButton * deleteNewsBtn;

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
        self.nameLabel                     = [[CustomLabel alloc] initWithFontSize:15];
        //时间
        self.timeLabel                     = [[CustomLabel alloc] initWithFontSize:15];
        //学校
        self.schoolLabel                   = [[CustomLabel alloc] initWithFontSize:15];
        //内容
        self.contentLabel                  = [[CustomLabel alloc] initWithFontSize:15];
        self.contentLabel.numberOfLines    = 0;
        //地址
        self.locationBtn                   = [[CustomButton alloc] initWithFontSize:15];
        [self.locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //评论
        self.commentBtn                    = [[CustomButton alloc] initWithFontSize:15];
        [self.commentBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        //点赞
        self.likeBtn                       = [[CustomButton alloc] initWithFontSize:15];
        [self.likeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        //点过赞的人
        self.likePeopleBtn                 = [[CustomButton alloc] initWithFontSize:15];
        self.likePeopleBtn.backgroundColor = [UIColor redColor];
        [self.likePeopleBtn addTarget:self action:@selector(likePeopleListClick:) forControlEvents:UIControlEventTouchUpInside];
        //删除新闻功能
        self.deleteNewsBtn                 = [[CustomButton alloc] initWithFontSize:15];
        [self.deleteNewsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //线
        self.lineView                      = [[UIView alloc] init];
        self.lineView.backgroundColor      = [UIColor darkGrayColor];
        
        [self.contentView addSubview:self.headImageBtn];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.locationBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.likePeopleBtn];
        [self.contentView addSubview:self.deleteNewsBtn];
        [self.contentView addSubview:self.lineView];
    }
    
    return self;
}

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news
{
    self.selectionStyle             = UITableViewCellSelectionStyleNone;
    self.news = news;
    
    //清空可变数组
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    
    //头像
    //加载头像
    self.headImageBtn.frame = CGRectMake(15, 8, 60, 60);
    NSURL * headUrl          = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, news.head_sub_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
    //头像点击
    [self.headImageBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //姓名    //是好友查看备注
    NSString * name          = news.name;
    CGSize nameSize          = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.nameLabel.frame     = CGRectMake(self.headImageBtn.right+10, self.headImageBtn.y, nameSize.width, 20);
    self.nameLabel.text      = name;

    //时间
    NSString * timeStr       = [ToolsManager compareCurrentTime:news.publish_date];
    CGSize timeSize          = [ToolsManager getSizeWithContent:timeStr andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.timeLabel.frame     = CGRectMake(self.nameLabel.right+10, self.headImageBtn.y, timeSize.width, 20);
    self.timeLabel.text      = timeStr;
    
    
    NSString * typeStr = news.school;
    if (news.typeDic[@"content"] != nil || [news.typeDic[@"content"] length]>0) {
        typeStr = news.typeDic[@"content"];
    }
    //学校
    CGSize typeSize        = [ToolsManager getSizeWithContent:typeStr andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.schoolLabel.frame   = CGRectMake(self.headImageBtn.right+10, self.nameLabel.bottom+5, typeSize.width, 20);
    self.schoolLabel.text    = typeStr;

    //内容
    CGSize contentSize       = [ToolsManager getSizeWithContent:news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    self.contentLabel.frame  = CGRectMake(self.headImageBtn.x, self.headImageBtn.bottom+5, contentSize.width, contentSize.height);
    self.contentLabel.text   = news.content_text;

    //底部位置
    NSInteger bottomPosition = self.contentLabel.bottom ;
    //图片处理
    if (news.image_arr.count == 1) {
        //一张图片放大
        ImageModel * imageModel = news.image_arr[0];
        CGRect rect             = [NewsUtils getRectWithSize:CGSizeMake(imageModel.width, imageModel.height)];
        rect.origin.x           = self.headImageBtn.x;
        rect.origin.y           = self.contentLabel.bottom+10;
        CustomButton * imageBtn = [[CustomButton alloc] init];
        //加载单张
        NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
        [imageBtn addGestureRecognizer:tap];
        [imageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
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
            imageView.frame          = CGRectMake(20+75*columnNum, self.contentLabel.bottom+20+65*lineNum, 55, 55);
            //加载缩略图
            NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
            [imageView addGestureRecognizer:tap];
            [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"testimage"]];
            
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
        self.locationBtn.frame                    = CGRectMake(self.headImageBtn.x, bottomPosition+5, 190, 20);
        self.locationBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        NSString * locationTitle                  = news.location;
        [self.locationBtn setTitle:locationTitle forState:UIControlStateNormal];
        bottomPosition                            = self.locationBtn.bottom;
    }else{
        self.locationBtn.hidden = YES;
    }

    //评论按钮
    self.commentBtn.frame    = CGRectMake(kCenterOriginX(90), bottomPosition+10, 90, 20);
    NSString * commentTitle  = [@"评论" stringByAppendingFormat:@"%ld", news.comment_quantity];
    [self.commentBtn addTarget:self action:@selector(sendCommentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn setTitle:commentTitle forState:UIControlStateNormal];

    //点赞按钮
    self.likeBtn.frame      = CGRectMake([DeviceManager getDeviceWidth]-100, bottomPosition+10, 90, 20);
    NSString * likeTitle;
    if (self.news.is_like) {
        likeTitle    = [@"已赞" stringByAppendingFormat:@"%ld", news.like_quantity];
    }else{
        likeTitle    = [@"点赞" stringByAppendingFormat:@"%ld", news.like_quantity];
    }
    [self.likeBtn addTarget:self action:@selector(sendLikeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn setTitle:likeTitle forState:UIControlStateNormal];

    //游标
    bottomPosition = self.commentBtn.bottom+5;

    //计算点赞头像尺寸
    CGFloat width  = ([DeviceManager getDeviceWidth]-60)/8;
    //点赞头像 最多8个 大小根据分辨率算
    for (int i=0; i<news.like_arr.count; i++) {

        LikeModel * like           = news.like_arr[i];
        CustomButton * likeHeadBtn = [[CustomButton alloc] initWithFrame:CGRectMake(10+width*i, bottomPosition, width-7, width-7)];
        NSURL * headUrl            = [NSURL URLWithString:[ToolsManager completeUrlStr:like.head_sub_image]];
        [likeHeadBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
        likeHeadBtn.tag            = i;
        //点击事件
        [likeHeadBtn addTarget:self action:@selector(likeImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:likeHeadBtn];
        //插入
        [self.viewArr addObject:likeHeadBtn];
    }
    
    //如果点赞超过7个 那么显示查看全部按钮
    if (news.like_arr.count > 7) {
        self.likePeopleBtn.frame = CGRectMake([DeviceManager getDeviceWidth]-50, bottomPosition, width-7, width-7);
    }else{
        self.likePeopleBtn.hidden = YES;
    }
    
    if (self.news.like_arr.count > 0) {
        bottomPosition += width+5;
    }

    //评论
    for (int i=0; i<news.comment_arr.count; i++) {
        CommentModel * comment                  = news.comment_arr[i];
        
        //评论文本 姓名：内容 //是好友查看备注
        NSString * commentName                  = comment.name;
        NSString * commentStr                   = [NSString stringWithFormat:@"%@:%@", commentName, comment.comment_content];
        
        CustomLabel * commentNameLabel          = [[CustomLabel alloc] initWithFontSize:15];
        commentNameLabel.userInteractionEnabled = YES;
        commentNameLabel.tag                    = i;
        //删除或者其他动作
//        UITapGestureRecognizer * tap            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
//        [commentNameLabel addGestureRecognizer:tap];
        
        //frame
        CGSize nameSize                         = [ToolsManager getSizeWithContent:commentStr andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
        commentNameLabel.text                   = commentStr;
        commentNameLabel.lineBreakMode          = NSLineBreakByCharWrapping;
        commentNameLabel.numberOfLines          = 0;
        commentNameLabel.textColor              = [UIColor blackColor];
        commentNameLabel.frame                  = CGRectMake(self.headImageBtn.x, bottomPosition, nameSize.width, nameSize.height);
        [self.contentView addSubview:commentNameLabel];
        bottomPosition                          = commentNameLabel.bottom + 5;
        //插入
        [self.viewArr addObject:commentNameLabel];
    }
    
    //线
    self.lineView.frame        = CGRectMake(5, bottomPosition, [DeviceManager getDeviceWidth], 1);
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
        NSString * likeTitle;
        //先修改在进行网络请求
        if (self.news.is_like) {
            self.news.is_like = NO;
            likeOrCancel     = NO;
            self.news.like_quantity --;
            likeTitle        = [@"点赞" stringByAppendingFormat:@"%ld", self.news.like_quantity];
        }else{
            self.news.is_like = YES;
            self.news.like_quantity ++;
            likeTitle        = [@"已赞" stringByAppendingFormat:@"%ld", self.news.like_quantity];
        }
        [self.likeBtn setTitle:likeTitle forState:UIControlStateNormal];
        
        [self.delegate likeClick:self.news likeOrCancel:likeOrCancel];
    }
}

//评论点击
- (void)commentTap:(UITapGestureRecognizer *)tap
{
    NSArray * commentArr     = self.news.comment_arr;
    CommentModel * model     = commentArr[tap.view.tag];
    if (model.user_id == [UserService sharedService].user.uid) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        sheet.tag             = tap.view.tag;
        [sheet showInView:[(UIViewController *)self.delegate view]];
    }else{
//        ALERT_SHOW(@"奏凯", @"");
        [self browsePersonalHome:model.user_id];
    }
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

#pragma mark- Action Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(deleteCommentClick:index:)]) {
            [self.delegate deleteCommentClick:self.news index:actionSheet.tag];
        }
    }
    
}

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
