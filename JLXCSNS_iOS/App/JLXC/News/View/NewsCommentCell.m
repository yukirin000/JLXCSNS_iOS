//
//  NewsCommentCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsCommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SecondCommentActionSheet.h"
#import "OtherPersonalViewController.h"
#import "IMGroupModel.h"

@interface NewsCommentCell()

//评论模型
@property (nonatomic, strong) CommentModel * comment;
//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//时间
@property (nonatomic, strong) CustomLabel * timeLabel;
//内容
@property (nonatomic, strong) CustomLabel * contentLabel;
//线
@property (nonatomic, strong) UIView * lineView;
//可变view数组
@property (nonatomic, strong) NSMutableArray * viewArr;

@end

@implementation NewsCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
        
        self.viewArr       = [[NSMutableArray alloc] init];
        self.headImageView = [[CustomImageView alloc] init];
        self.nameLabel     = [[CustomLabel alloc] init];
        self.timeLabel     = [[CustomLabel alloc] init];
        self.contentLabel  = [[CustomLabel alloc] init];
        self.lineView      = [[UIView alloc] init];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
        
        UITapGestureRecognizer * headTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewTap:)];
        [self.headImageView addGestureRecognizer:headTap];
        
        //删除或者其他动作
        UITapGestureRecognizer * tap             = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
        [self.contentView addGestureRecognizer:tap];
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    self.selectionStyle                       = UITableViewCellSelectionStyleNone;
    //头像
    self.headImageView.frame                  = CGRectMake(10, 5, 40, 40);
    self.headImageView.layer.cornerRadius     = 2;
    self.headImageView.layer.masksToBounds    = YES;
    self.headImageView.userInteractionEnabled = YES;
    //姓名
    self.nameLabel.frame                      = CGRectMake(self.headImageView.right+10, self.headImageView.y, 150, 20);
    self.nameLabel.textColor                  = [UIColor colorWithHexString:ColorBrown];
    self.nameLabel.font                       = [UIFont systemFontOfSize:FontComment];
    //时间
    self.timeLabel.frame                      = CGRectMake([DeviceManager getDeviceWidth]-120, self.nameLabel.y, 100, 20);
    self.timeLabel.textAlignment              = NSTextAlignmentRight;
    self.timeLabel.font                       = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor                  = [UIColor colorWithHexString:ColorLightBlack];
    //内容
    self.contentLabel.frame                   = CGRectMake(self.nameLabel.x, self.nameLabel.bottom, [DeviceManager getDeviceWidth]-15-self.nameLabel.x, 0);
    self.contentLabel.textColor               = [UIColor colorWithHexString:ColorLightBlack];
    self.contentLabel.font                    = [UIFont systemFontOfSize:FontComment];
    self.contentLabel.userInteractionEnabled  = YES;
    self.contentLabel.numberOfLines           = 0;
    self.contentLabel.lineBreakMode           = NSLineBreakByCharWrapping;
 
    self.lineView.frame = CGRectMake(0, 0, [DeviceManager getDeviceWidth], 1);
    self.lineView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
}

- (void)setConentWithModel:(CommentModel *)comment
{
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    
    self.comment        = comment;
    
    //加载头像
    NSURL * headUrl                          = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, comment.head_sub_image]];
    [self.headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];

    //姓名
    self.nameLabel.text                      = comment.name;
    //时间
    NSString * timeStr                       = [ToolsManager compareCurrentTime:comment.add_date];
    self.timeLabel.text                      = timeStr;
    //内容
    CGSize contentSize                       = [ToolsManager getSizeWithContent:comment.comment_content andFontSize:FontComment andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-15-self.nameLabel.x, MAXFLOAT)];
    self.contentLabel.height                 = contentSize.height;
    self.contentLabel.text                   = comment.comment_content;

    CGFloat bottomLocation = self.contentLabel.bottom;
    
    for (int i=0; i<self.comment.second_comments.count; i++) {

        SecondCommentModel * secondComment     = self.comment.second_comments[i];
        
        //名字
        CustomLabel * secondLabel               = [[CustomLabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, bottomLocation, self.contentLabel.width, 20)];
        [self commentLabelSet:secondLabel];
        secondLabel.tag                         = i;
        secondLabel.textColor                   = [UIColor colorWithHexString:ColorBrown];
        NSString * nameStr                      = [NSString stringWithFormat:@"%@ 回复:%@", secondComment.name, secondComment.reply_name];
        NSMutableAttributedString * attrNameStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, secondComment.name.length+4)];
        [attrNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:ColorLightBlack] range:NSMakeRange(secondComment.name.length, 4)];
        secondLabel.attributedText              = attrNameStr;
        //第一个名字
        CustomLabel * secondFirstLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, bottomLocation, 0, 20)];
        [self commentLabelSet:secondFirstLabel];
        secondFirstLabel.tag           = i;
        secondFirstLabel.textColor     = [UIColor colorWithHexString:ColorBrown];
        secondFirstLabel.text          = secondComment.name;
        CGSize firstSize = [ToolsManager getSizeWithContent:secondComment.name andFontSize:FontComment andFrame:CGRectMake(0, 0, 200, 20)];
        secondFirstLabel.width         = firstSize.width;
        //点击手势
        UITapGestureRecognizer * secondNameTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondNameTap:)];
        [secondLabel addGestureRecognizer:secondNameTap];
        UITapGestureRecognizer * secondNameFirstTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondNameFirstTap:)];
        [secondFirstLabel addGestureRecognizer:secondNameFirstTap];
        [self.contentView addSubview:secondLabel];
        [self.contentView addSubview:secondFirstLabel];
        
        //内容
        CGSize contentSize                          = [ToolsManager getSizeWithContent:secondComment.comment_content andFontSize:FontComment andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-15-self.headImageView.right, MAXFLOAT)];
        //二级评论
        CustomLabel * secondContentLabel          = [[CustomLabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, secondLabel.bottom, self.contentLabel.width, contentSize.height)];
        [self commentLabelSet:secondContentLabel];
        secondContentLabel.numberOfLines          = 0;
        secondContentLabel.text                   = secondComment.comment_content;
        secondContentLabel.tag                    = i;
        //删除或者其他动作
        UITapGestureRecognizer * secondTap             = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondCommentTap:)];
        [secondContentLabel addGestureRecognizer:secondTap];
        [self.contentView addSubview:secondContentLabel];
        bottomLocation = secondContentLabel.bottom;
        
        [self.viewArr addObject:secondLabel];
        [self.viewArr addObject:secondContentLabel];
        
    }
    if (bottomLocation < 45) {
        bottomLocation = 45;
    }
    
    self.lineView.y = bottomLocation+4;
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isKindOfClass:[SecondCommentActionSheet class]]) {
        //删除
        SecondCommentModel * scm = self.comment.second_comments[actionSheet.tag];
        if (buttonIndex == 0) {
            [self deleteSecondComment:scm];
        }
    }else{
        //删除
        if (buttonIndex == 0) {
            [self deleteComment];
        }
    }
    

}

#pragma mark- method response
//头像点击
- (void)headImageViewTap:(UITapGestureRecognizer *)tap
{
    [self browsePersonalHome:self.comment.user_id];
}

//一级评论点击
- (void)commentTap:(UITapGestureRecognizer *)tap
{
    if (self.comment.user_id == [UserService sharedService].user.uid) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        sheet.tag             = tap.view.tag;
        [sheet showInView:[(UIViewController *)self.delegate view]];
    }else{
        SecondCommentModel * scm = [[SecondCommentModel alloc] init];
        scm.scid                 = self.comment.cid;
        scm.name                 = self.comment.name;
        scm.user_id              = self.comment.user_id;
        scm.reply_comment_id     = self.comment.cid;
        scm.top_comment_id       = self.comment.cid;
        [self replyCommentWithSecondModel:scm];
    }
}

//二级评论点击
- (void)secondCommentTap:(UITapGestureRecognizer *)tap
{
    SecondCommentModel * scm = self.comment.second_comments[tap.view.tag];
    
    if (scm.user_id == [UserService sharedService].user.uid) {
        SecondCommentActionSheet * sheet = [[SecondCommentActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        sheet.tag             = tap.view.tag;
        [sheet showInView:[(UIViewController *)self.delegate view]];
    }else{
        [self replyCommentWithSecondModel:scm];
    }
}
//二级评论姓名点击
- (void)secondNameTap:(UITapGestureRecognizer *)tap
{
    SecondCommentModel * secondComment = self.comment.second_comments[tap.view.tag];
    [self browsePersonalHome:secondComment.reply_uid];
}

//二级评论姓名点击
- (void)secondNameFirstTap:(UITapGestureRecognizer *)tap
{
    SecondCommentModel * secondComment = self.comment.second_comments[tap.view.tag];
    [self browsePersonalHome:secondComment.user_id];
}

#pragma mark- private method
- (void)deleteComment
{
    if ([self.delegate respondsToSelector:@selector(deleteCommentClick:)]) {
        [self.delegate deleteCommentClick:self.comment];
    }
}

- (void)deleteSecondComment:(SecondCommentModel *)secondCommentModel
{
    if ([self.delegate respondsToSelector:@selector(deleteSecondCommentClick:andComment:)]) {
        [self.delegate deleteSecondCommentClick:secondCommentModel andComment:self.comment];
    }
}

//发送二级评论
- (void)replyCommentWithSecondModel:(SecondCommentModel *)secondCommentModel
{
    if ([self.delegate respondsToSelector:@selector(replyComment:andTopComment:)]) {

        [self.delegate replyComment:secondCommentModel andTopComment:self.comment];
    }
}

//浏览其他人的主页
- (void)browsePersonalHome:(NSInteger)userId
{
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid = userId;
    [((BaseViewController *)self.delegate) pushVC:opvc];
    
}

#pragma mark- private method
- (void)commentLabelSet:(UILabel *)label
{
    label.lineBreakMode          = NSLineBreakByCharWrapping;
    label.userInteractionEnabled = YES;
    label.font                   = [UIFont systemFontOfSize:FontComment];
    label.textColor              = [UIColor colorWithHexString:ColorLightBlack];
}

@end
