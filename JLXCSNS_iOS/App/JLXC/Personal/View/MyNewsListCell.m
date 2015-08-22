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
//中部背景
@property (nonatomic, strong) CustomImageView * midImageView;
//底部背景
@property (nonatomic, strong) CustomImageView * bottomImageView;
//删除新闻的功能
//@property (nonatomic, strong) CustomButton * deleteNewsBtn;

//可变视图数组 比如评论 图片
@property (nonatomic, strong) NSMutableArray * viewArr;
//时间线
@property (nonatomic, strong) UIView * timeLineView;

@end

@implementation MyNewsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self) {
        self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        self.contentView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];

        self.viewArr                     = [[NSMutableArray alloc] init];
        //姓名
        self.nameLabel                   = [[CustomLabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        //时间
        self.timeLabel                   = [[CustomLabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        //中部背景
        self.midImageView              = [[CustomImageView alloc] init];
        [self.contentView addSubview:self.midImageView];
        
        //底部背景
        self.bottomImageView           = [[CustomImageView alloc] init];
        [self.contentView addSubview:self.bottomImageView];
        
        //内容
        self.contentLabel                = [[CustomLabel alloc] init];
        self.contentLabel.numberOfLines  = 0;
        [self.contentView addSubview:self.contentLabel];
        //地址
        self.locationBtn                 = [[CustomButton alloc] init];
        [self.contentView addSubview:self.locationBtn];
        //评论
        self.commentBtn                  = [[CustomButton alloc] init];
        [self.contentView addSubview:self.commentBtn];
        //点赞
        self.likeBtn                     = [[CustomButton alloc] init];
        [self.contentView addSubview:self.likeBtn];
        
        //时间线
        self.timeLineView                = [[UIView alloc] init];
        [self.contentView addSubview:self.timeLineView];
        
        [self.likeBtn addTarget:self action:@selector(sendLikeClick) forControlEvents:UIControlEventTouchUpInside];
        [self configUI];
        
    }
    
    return self;
}

- (void)configUI
{
    //时间
    self.timeLabel.frame                = CGRectMake(35, 10, 200, 20);
    self.timeLabel.font                 = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor            = [UIColor colorWithHexString:ColorLightBlack];

    //姓名
    self.nameLabel.frame                = CGRectMake(self.timeLabel.x, self.timeLabel.bottom, 200, 20);
    self.nameLabel.font                 = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor            = [UIColor colorWithHexString:ColorDeepBlack];
    //时间线
    CustomImageView * timeLineImageView = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"time_point"]];
    timeLineImageView.frame             = CGRectMake(13, self.nameLabel.y+2, 15, 15);
    [self.contentView addSubview:timeLineImageView];

    self.timeLineView.frame             = CGRectMake(20, 0, 1, 0);
    self.timeLineView.backgroundColor   = [UIColor colorWithHexString:ColorDeepGary];
    
    self.contentLabel.font              = [UIFont systemFontOfSize:16];
    self.contentLabel.textColor         = [UIColor colorWithHexString:ColorDeepBlack];

    //顶部背景
    CustomImageView * topImageView      = [[CustomImageView alloc] initWithFrame:CGRectMake(self.timeLabel.x, self.nameLabel.bottom, [DeviceManager getDeviceWidth]-10-self.timeLabel.x, 15)];
    topImageView.image                  = [UIImage imageNamed:@"back_head"];
    [self.contentView addSubview:topImageView];
    [self.contentView sendSubviewToBack:topImageView];

    //中部背景
    self.midImageView.frame             = CGRectMake(self.timeLabel.x, topImageView.bottom, topImageView.width, 0);
    self.midImageView.image             = [UIImage imageNamed:@"back_body"];

    //底部背景
    self.bottomImageView.frame          = CGRectMake(self.timeLabel.x, self.midImageView.bottom, topImageView.width, 50);
    self.bottomImageView.image          = [UIImage imageNamed:@"back_bottom"];

    //地理位置
    [self.locationBtn setTitleColor:[UIColor colorWithHexString:ColorLightBlue] forState:UIControlStateNormal];
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    self.locationBtn.titleLabel.font            = [UIFont systemFontOfSize:14];
    self.locationBtn.frame                      = CGRectMake(self.nameLabel.x+10, 0, 190, 20);
    self.locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
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
}

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.news           = news;
    //清空可变数组
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    
    self.nameLabel.text      = news.name;
    
    self.timeLabel.text      = [ToolsManager compareCurrentTime:news.publish_date];
    
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
    CGSize contentSize       = [ToolsManager getSizeWithContent:news.content_text andFontSize:16 andFrame:CGRectMake(0, 0, self.midImageView.width-20, MAXFLOAT)];
    self.contentLabel.frame  = CGRectMake(self.nameLabel.x+10, self.nameLabel.bottom+15, contentSize.width, contentSize.height);
    if (news.content_text == nil || news.content_text.length < 1) {
        self.contentLabel.height = 0;
    }
    self.contentLabel.text   = news.content_text;
    
    //底部位置
    NSInteger bottomPosition = self.contentLabel.bottom ;
    
    //图片处理
    if (news.image_arr.count == 1) {
        //一张图片放大
        ImageModel * imageModel      = news.image_arr[0];
        CGRect rect                  = [NewsUtils getRectWithSize:CGSizeMake(imageModel.width, imageModel.height)];
        rect.origin.x                = self.contentLabel.x;
        rect.origin.y                = self.contentLabel.bottom+5;
        CustomButton * imageBtn      = [[CustomButton alloc] init];
        //加载单张大图
        NSURL * imageUrl             = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
        [imageBtn addGestureRecognizer:tap];
        [imageBtn sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageBtn.frame               = rect;
        [self.contentView addSubview:imageBtn];
        //底部位置
        bottomPosition               = imageBtn.bottom;
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
            //width
            CGFloat itemWidth = [DeviceManager getDeviceWidth]/5.0;
            imageView.frame          = CGRectMake(self.contentLabel.x+(itemWidth+10)*columnNum, self.contentLabel.bottom+5+(itemWidth+10)*lineNum, itemWidth, itemWidth);
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
    
    //背景
    self.midImageView.height     = bottomPosition - self.midImageView.y;
    self.bottomImageView.y       = self.midImageView.bottom;
    
    //评论按钮
    self.commentBtn.frame    = CGRectMake(self.midImageView.right-150, bottomPosition+10, 60, 25);
    NSString * commentTitle  = [NSString stringWithFormat:@"%ld", news.comment_quantity];
    if (news.comment_quantity > 10000) {
        commentTitle = @"1w+";
    }
    [self.commentBtn setTitle:commentTitle forState:UIControlStateNormal];
    
    //点赞按钮
    self.likeBtn.frame      = CGRectMake(self.midImageView.right-75, bottomPosition+10, 60, 25);
    NSString * likeTitle    = [NSString stringWithFormat:@"%ld", news.like_quantity];
    if (news.like_quantity > 10000) {
        likeTitle = @"1w+";
    }
    if (self.news.is_like) {
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_selected"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:likeTitle forState:UIControlStateNormal];
    
    self.timeLineView.height = self.bottomImageView.bottom;
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
        //先修改在进行网络请求
        if (self.news.is_like) {
            self.news.is_like = NO;
            likeOrCancel     = NO;
            self.news.like_quantity --;
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_normal"] forState:UIControlStateNormal];
        }else{
            self.news.is_like = YES;
            self.news.like_quantity ++;
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_like_selected"] forState:UIControlStateNormal];
        }
        
        NSString * likeTitle    = [NSString stringWithFormat:@"%ld", self.news.like_quantity];
        if (self.news.like_quantity > 10000) {
            likeTitle = @"1w+";
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
