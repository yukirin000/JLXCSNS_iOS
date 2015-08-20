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

@end

@implementation NewsCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImageView = [[CustomImageView alloc] init];
        self.nameLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.timeLabel     = [[CustomLabel alloc] initWithFontSize:15];
        self.contentLabel  = [[CustomLabel alloc] initWithFontSize:15];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}

- (void)setConentWithModel:(CommentModel *)comment
{
    self.comment        = comment;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //头像
    //加载头像
    self.headImageView.frame                  = CGRectMake(15, 5, 40, 40);
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * headTap              = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewTap:)];
    [self.headImageView addGestureRecognizer:headTap];
    
    NSURL * headUrl                          = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, comment.head_sub_image]];
    [self.headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];

    //姓名 好友查看备注
    NSString * name                          = comment.name;
    CGSize nameSize                          = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.nameLabel.frame                     = CGRectMake(self.headImageView.right+10, self.headImageView.y, nameSize.width, 20);
    self.nameLabel.text                      = name;

    //时间
    NSString * timeStr                       = [ToolsManager compareCurrentTime:comment.add_date];
    CGSize timeSize                          = [ToolsManager getSizeWithContent:timeStr andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.timeLabel.frame                     = CGRectMake(self.nameLabel.x, self.nameLabel.bottom, timeSize.width, 20);
    self.timeLabel.text                      = timeStr;

    //内容
    CGSize contentSize                       = [ToolsManager getSizeWithContent:comment.comment_content andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-15-self.headImageView.right, MAXFLOAT)];
    self.contentLabel.frame                  = CGRectMake(self.headImageView.right, self.headImageView.bottom+5, [DeviceManager getDeviceWidth]-15-self.headImageView.right, contentSize.height);
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.numberOfLines          = 0;
    self.contentLabel.backgroundColor        = [UIColor grayColor];
    self.contentLabel.lineBreakMode          = NSLineBreakByCharWrapping;
    self.contentLabel.text                   = comment.comment_content;
    //删除或者其他动作
    UITapGestureRecognizer * tap             = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
    [self.contentLabel addGestureRecognizer:tap];
    
    CGFloat bottomLocation = self.contentLabel.bottom;
    
    for (int i=0; i<self.comment.second_comments.count; i++) {

        SecondCommentModel * secondComment     = self.comment.second_comments[i];
        //名字
        CustomLabel * secondLabel              = [[CustomLabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, bottomLocation, self.contentLabel.width, 20)];
        secondLabel.userInteractionEnabled     = YES;
        secondLabel.tag                        = i;
        //点击手势
        UITapGestureRecognizer * secondNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondNameTap:)];
        [secondLabel addGestureRecognizer:secondNameTap];
        secondLabel.font                       = [UIFont systemFontOfSize:15];
        secondLabel.textColor                  = [UIColor grayColor];
        //是好友显示备注
        NSString * name                        = secondComment.name;
        NSString * reply_name                  = secondComment.reply_name;
        secondLabel.text                       = [NSString stringWithFormat:@"%@ 回复:%@", name, reply_name];
        [self.contentView addSubview:secondLabel];
        
        //内容
        CGSize contentSize                          = [ToolsManager getSizeWithContent:secondComment.comment_content andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-15-self.headImageView.right, MAXFLOAT)];
        //二级评论
        CustomLabel * secondContentLabel          = [[CustomLabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, secondLabel.bottom, self.contentLabel.width, contentSize.height)];
        secondContentLabel.lineBreakMode          = NSLineBreakByCharWrapping;
        secondContentLabel.userInteractionEnabled = YES;
        secondContentLabel.font                   = [UIFont systemFontOfSize:15];
        secondContentLabel.backgroundColor        = [UIColor grayColor];
        secondContentLabel.numberOfLines          = 0;
        secondContentLabel.textColor              = [UIColor blackColor];
        secondContentLabel.text                   = secondComment.comment_content;
        secondContentLabel.tag                    = i;
        //删除或者其他动作
        UITapGestureRecognizer * secondTap             = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondCommentTap:)];
        [secondContentLabel addGestureRecognizer:secondTap];
        [self.contentView addSubview:secondContentLabel];
        bottomLocation = secondContentLabel.bottom;
        
    }

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


@end
