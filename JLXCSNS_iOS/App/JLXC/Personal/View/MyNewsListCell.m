//
//  MyNewsListCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//


#import "MyNewsListCell.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "LikeModel.h"
#import "NewsUtils.h"

@interface MyNewsListCell()

//新闻模型
@property (nonatomic, strong) NewsModel * news;
////头像
//@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//时间
@property (nonatomic, strong) CustomLabel * timeLabel;
////学校
//@property (nonatomic, strong) CustomLabel * schoolLabel;
//内容
@property (nonatomic, strong) CustomLabel * contentLabel;

//地址按钮
@property (nonatomic, strong) CustomButton * locationBtn;
//评论按钮
@property (nonatomic, strong) CustomButton * commentBtn;
//点赞按钮
@property (nonatomic, strong) CustomButton * likeBtn;
//删除新闻的功能
//@property (nonatomic, strong) CustomButton * deleteNewsBtn;

//可变视图数组 比如评论 图片
@property (nonatomic, strong) NSMutableArray * viewArr;

@end

@implementation MyNewsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self) {
        self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        self.contentView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];

        self.viewArr                     = [[NSMutableArray alloc] init];
        //姓名
        self.nameLabel                   = [[CustomLabel alloc] initWithFontSize:15];
        [self.contentView addSubview:self.nameLabel];
        //时间
        self.timeLabel                   = [[CustomLabel alloc] initWithFontSize:15];
        [self.contentView addSubview:self.timeLabel];
        //内容
        self.contentLabel                = [[CustomLabel alloc] initWithFontSize:15];
        self.contentLabel.numberOfLines  = 0;
        [self.contentView addSubview:self.contentLabel];
        //地址
        self.locationBtn                 = [[CustomButton alloc] initWithFontSize:15];
        [self.locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.locationBtn];
        //评论
        self.commentBtn                  = [[CustomButton alloc] initWithFontSize:15];
        [self.commentBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentBtn];
        //点赞
        self.likeBtn                     = [[CustomButton alloc] initWithFontSize:15];
        [self.likeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.likeBtn];
        //删除新闻功能
//        self.deleteNewsBtn              = [[CustomButton alloc] initWithFontSize:15];
//        [self.deleteNewsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.deleteNewsBtn];
        
    }
    
    return self;
}

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.news           = news;
    //清空可变数组
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    
    //姓名
    CGSize nameSize          = [ToolsManager getSizeWithContent:news.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.nameLabel.frame     = CGRectMake(15, 8, nameSize.width, 20);
    self.nameLabel.text      = news.name;
    
    //时间
    NSString * timeStr       = [ToolsManager compareCurrentTime:news.publish_date];
    CGSize timeSize          = [ToolsManager getSizeWithContent:timeStr andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.timeLabel.frame     = CGRectMake(self.nameLabel.x, self.nameLabel.bottom, timeSize.width, 20);
    self.timeLabel.text      = timeStr;
    
//    //如果是自己看
//    if (!self.isOther) {
//        //删除
//        self.deleteNewsBtn.frame = CGRectMake([DeviceManager getDeviceWidth]-60, self.nameLabel.y, 40, 20);
//        [self.deleteNewsBtn addTarget:self action:@selector(deleteNewsPress) forControlEvents:UIControlEventTouchUpInside];
//        [self.deleteNewsBtn setTitle:@"删除" forState:UIControlStateNormal];
//    }

//    //学校
//    CGSize schoolSize        = [ToolsManager getSizeWithContent:news.school andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
//    self.schoolLabel.frame   = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom+5, schoolSize.width, 20);
//    self.schoolLabel.text    = news.school;
    
    //内容
    CGSize contentSize       = [ToolsManager getSizeWithContent:news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    self.contentLabel.frame  = CGRectMake(self.nameLabel.x, self.timeLabel.bottom+5, contentSize.width, contentSize.height);
    self.contentLabel.text   = news.content_text;
    
    //底部位置
    NSInteger bottomPosition = self.contentLabel.bottom ;
    //图片处理
    if (news.image_arr.count == 1) {
        //一张图片放大
        ImageModel * imageModel = news.image_arr[0];
        CGRect rect             = [NewsUtils getRectWithSize:CGSizeMake(imageModel.width, imageModel.height)];
        rect.origin.x           = self.nameLabel.x;
        rect.origin.y           = self.contentLabel.bottom+10;
        CustomButton * imageBtn = [[CustomButton alloc] init];
        //加载单张大图
        NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
        [imageBtn addGestureRecognizer:tap];
        [imageBtn sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
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
        self.locationBtn.frame                    = CGRectMake(self.nameLabel.x, bottomPosition+5, 190, 20);
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
    
}

//图片点击
- (void)imageDetailClick:(UITapGestureRecognizer *) ges
{
    if ([self.delegate respondsToSelector:@selector(imageClick:index:)]) {
        [self.delegate imageClick:self.news index:ges.view.tag];
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

//删除这条新闻
//- (void)deleteNewsPress
//{
//    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//    [sheet showInView:[(UIViewController *)self.delegate view]];
//}
//
//#pragma mark- Action Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //删除该条
//    if (buttonIndex == 0) {
//        if ([self.delegate respondsToSelector:@selector(deleteNewsClick:)]) {
//            [self.delegate deleteNewsClick:self.news];
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
