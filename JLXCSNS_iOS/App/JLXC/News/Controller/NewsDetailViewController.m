//
//  NewsDetailViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "BrowseImageListViewController.h"
#import "NewsVisitViewController.h"
#import "IMGroupModel.h"
#import "LikeModel.h"
#import "CommentModel.h"
#import "ImageModel.h"
#import "SecondCommentModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "BrowseImageViewController.h"
#import "NewsCommentCell.h"
#import "HPGrowingTextView.h"
#import "SecondCommentModel.h"
#import "OtherPersonalViewController.h"
#import "LikeListViewController.h"
#import "NewsUtils.h"

@interface NewsDetailViewController ()<NewsCommentDelegate,HPGrowingTextViewDelegate>

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
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
////评论tv
//@property (nonatomic, strong) PlaceHolderTextView * commentTextView;
//浏览数
@property (nonatomic, strong) CustomButton * browseCountBtn;
//点赞按钮
@property (nonatomic, strong) CustomButton * likeBtn;
//评论table
@property (nonatomic, strong) UITableView * newsTable;
//装载HPTextView的容器
@property (nonatomic, strong) UIView * containerView;
//HPTextView 回复评论时弹出
@property (nonatomic, strong) HPGrowingTextView * commentTextView;
//当前点击的二级评论
@property (nonatomic, strong) SecondCommentModel * currentSecondComment;
//当前点击的最上级评论
@property (nonatomic, strong) CommentModel * currentTopComment;
//是不是默认评论
@property (nonatomic, assign) BOOL isDefaultComment;
//评论遮罩View
@property (nonatomic, strong) UIView * commentCoverView;

//新闻模型
@property (nonatomic, strong) NewsModel * news;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerNotify];
    [self initWidget];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- layout
- (void)initWidget
{
    //内容scroll
    //头像
    self.headImageView              = [[CustomImageView alloc] init];
    //姓名
    self.nameLabel                  = [[CustomLabel alloc] initWithFontSize:15];
    //时间
    self.timeLabel                  = [[CustomLabel alloc] initWithFontSize:15];
    //学校
    self.schoolLabel                = [[CustomLabel alloc] initWithFontSize:15];
    //内容
    self.contentLabel               = [[CustomLabel alloc] initWithFontSize:15];
    self.contentLabel.numberOfLines = 0;
    //地址
    self.locationBtn                = [[CustomButton alloc] initWithFontSize:15];
    [self.locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //评论
//    self.commentTextView                 = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 300, 30) andPlaceHolder:@"请输入"];
    self.browseCountBtn             = [[CustomButton alloc] initWithFontSize:15];
    //点赞
    self.likeBtn                    = [[CustomButton alloc] initWithFontSize:15];
    [self.likeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //线
    self.lineView                   = [[UIView alloc] init];
    self.lineView.backgroundColor   = [UIColor darkGrayColor];
    
}

- (void)initCommentTextView
{
    
    //评论遮罩
    self.commentCoverView                 = [[UIView alloc] initWithFrame:self.view.bounds];
    self.commentCoverView.backgroundColor = [UIColor darkGrayColor];
    self.commentCoverView.alpha           = 0.3;
    self.commentCoverView.hidden          = YES;
    [self.view addSubview:self.commentCoverView];
    
    //默认是默认评论
    self.isDefaultComment = YES;
    
    //回复评论的textView
    self.containerView                                         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.viewWidth, 40)];
    self.containerView.backgroundColor                         = [UIColor grayColor];
    self.commentTextView                                        = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.viewWidth-80, 40)];
    self.commentTextView.isScrollable                           = NO;
    self.commentTextView.minNumberOfLines                       = 1;
    self.commentTextView.maxNumberOfLines                       = 6;
    self.commentTextView.returnKeyType                          = UIReturnKeySend;
    self.commentTextView.font                                   = [UIFont systemFontOfSize:15.0f];
    self.commentTextView.delegate                               = self;
    self.commentTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.commentTextView.backgroundColor                        = [UIColor whiteColor];
    self.commentTextView.placeholder                            = @"来条神评论吧~";
    [self.containerView addSubview:self.commentTextView];
    [self.view addSubview:self.containerView];
    
    //发送按钮
    CustomButton * sendCommentBtn = [[CustomButton alloc] initWithFrame:CGRectMake(self.commentTextView.right+5, 3, 60, 40)];
    [sendCommentBtn addTarget:self action:@selector(sendCommentPress) forControlEvents:UIControlEventTouchUpInside];
    [sendCommentBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.containerView addSubview:sendCommentBtn];
    
}

- (void)initTable
{
    //展示数据的列表
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        self.newsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStyleGrouped];
    }else{
        self.newsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    }
    
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTable.delegate       = self;
    self.newsTable.dataSource     = self;
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableView:)];
    [self.newsTable addGestureRecognizer:tap];
    [self.view addSubview:self.newsTable];
    
    //加载回复评论的textView
    [self initCommentTextView];
}

#pragma mark- UITableViewDelegate
//头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self getHeadNewsHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, [self getHeadNewsHeight])];
    [backView addSubview:self.headImageView];
    [backView addSubview:self.nameLabel];
    [backView addSubview:self.timeLabel];
    [backView addSubview:self.schoolLabel];
    [backView addSubview:self.contentLabel];
    [backView addSubview:self.lineView];
    [backView addSubview:self.locationBtn];
//    [backView addSubview:self.commentTextView];
    [backView addSubview:self.likeBtn];
    [backView addSubview:self.browseCountBtn];
    
    //头像
    //加载头像
    self.headImageView.frame                  = CGRectMake(15, 18, 60, 60);
    self.headImageView.userInteractionEnabled = YES;
    NSURL * headUrl                           = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, self.news.head_sub_image]];
    UITapGestureRecognizer * tap              = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsHeadClick:)];
    [self.headImageView addGestureRecognizer:tap];
    [self.headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];

    NSString * name = self.news.name;
    
    //姓名
    CGSize nameSize              = [ToolsManager getSizeWithContent:name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.nameLabel.frame         = CGRectMake(self.headImageView.right+10, self.headImageView.y, nameSize.width, 20);
    self.nameLabel.text          = name;
    
    //时间
    NSString * timeStr           = [ToolsManager compareCurrentTime:self.news.publish_date];
    CGSize timeSize              = [ToolsManager getSizeWithContent:timeStr andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.timeLabel.frame         = CGRectMake(self.nameLabel.right+10, self.headImageView.y, timeSize.width, 20);
    self.timeLabel.text          = timeStr;
    
    //学校
    CGSize schoolSize            = [ToolsManager getSizeWithContent:self.news.school andFontSize:15 andFrame:CGRectMake(0, 0, 200, 20)];
    self.schoolLabel.frame       = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom+5, schoolSize.width, 20);
    self.schoolLabel.text        = self.news.school;
    
    //内容
    CGSize contentSize           = [ToolsManager getSizeWithContent:self.news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    self.contentLabel.frame      = CGRectMake(self.headImageView.x, self.headImageView.bottom+5, contentSize.width, contentSize.height);
    self.contentLabel.text       = self.news.content_text;
    
    //底部位置
    NSInteger bottomPosition = self.contentLabel.bottom ;
    //图片处理
    if (self.news.image_arr.count == 1) {
        //一张图片放大
        ImageModel * imageModel = self.news.image_arr[0];
        CGRect rect             = [NewsUtils getRectWithSize:CGSizeMake(imageModel.width, imageModel.height)];
        rect.origin.x           = self.headImageView.x;
        rect.origin.y           = self.contentLabel.bottom+10;
        CustomButton * imageBtn = [[CustomButton alloc] init];
        //加载单张大图
        NSURL * imageUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.url]];
        //点击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
        [imageBtn addGestureRecognizer:tap];
        [imageBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageBtn.frame          = rect;
        [backView addSubview:imageBtn];
        //底部位置
        bottomPosition          = imageBtn.bottom;
    }else{
        //多张图片九宫格
        NSArray * btnArr        = self.news.image_arr;
        for (int i=0; i<btnArr.count; i++) {
            ImageModel * imageModel          = self.news.image_arr[i];
            NSInteger columnNum              = i%3;
            NSInteger lineNum                = i/3;
            CustomImageView * imageView      = [[CustomImageView alloc] init];
            imageView.tag                    = i;
            imageView.contentMode            = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds    = YES;
            imageView.userInteractionEnabled = YES;
            imageView.frame                  = CGRectMake(20+75*columnNum, self.contentLabel.bottom+20+65*lineNum, 55, 55);
            //加载缩略图
            NSURL * imageUrl                 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imageModel.sub_url]];
            //点击手势
            UITapGestureRecognizer * tap     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailClick:)];
            [imageView addGestureRecognizer:tap];
            [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
            [backView addSubview:imageView];
            //底部位置
            if (btnArr.count == i+1) {
                bottomPosition          = imageView.bottom;
            }
        }
    }
    
    //地址按钮 没有不显示
    if (self.news.location.length > 0) {
        self.locationBtn.frame   = CGRectMake(self.headImageView.x, bottomPosition+5, 190, 20);
        NSString * locationTitle = self.news.location;
        [self.locationBtn setTitle:locationTitle forState:UIControlStateNormal];
        bottomPosition           = self.locationBtn.bottom;
    }
    
    //点赞按钮
    self.likeBtn.frame      = CGRectMake([DeviceManager getDeviceWidth]-100, bottomPosition+10, 90, 20);
    NSString * likeTitle;
    if (self.news.is_like) {
        likeTitle    = [@"已赞" stringByAppendingFormat:@"%ld", self.news.like_quantity];
    }else{
        likeTitle    = [@"点赞" stringByAppendingFormat:@"%ld", self.news.like_quantity];
    }
    [self.likeBtn addTarget:self action:@selector(sendLikeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn setTitle:likeTitle forState:UIControlStateNormal];
    //游标
    bottomPosition = self.likeBtn.bottom+5;
    
//    //评论TextView
//    self.commentTextView.frame                   = CGRectMake(kCenterOriginX(200), bottomPosition, 200, 50);
//    self.commentTextView.delegate                = self;
//    self.commentTextView.returnKeyType           = UIReturnKeySend;
//
//    //游标
//    bottomPosition                               = self.commentTextView.bottom+5;

    self.browseCountBtn.frame                    = CGRectMake(self.headImageView.x, bottomPosition, 100, 20);
    self.browseCountBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    NSString * browseStr                         = [NSString stringWithFormat:@"浏览%ld", self.news.browse_quantity];
    [self.browseCountBtn addTarget:self action:@selector(browseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.browseCountBtn setTitle:browseStr forState:UIControlStateNormal];
    [self.browseCountBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];

    //游标
    bottomPosition                               = self.browseCountBtn.bottom+5;
    
    //点赞头像 计算点赞头像大小
    CGFloat width  = ([DeviceManager getDeviceWidth]-60)/8;
    for (int i=0; i<self.news.like_arr.count; i++) {
        LikeModel * like           = self.news.like_arr[i];
        CustomButton * likeHeadBtn = [[CustomButton alloc] initWithFrame:CGRectMake(10+width*i, bottomPosition, width-7, width-7)];
        likeHeadBtn.tag            = i;
        NSURL * headUrl            = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, like.head_sub_image]];
        //点击事件
        [likeHeadBtn addTarget:self action:@selector(likeHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        [likeHeadBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        [backView addSubview:likeHeadBtn];
    }
    
    //如果点赞超过7个 那么显示查看全部按钮
    if (self.news.like_arr.count > 7) {
        //点过赞的人
        CustomButton * likePeopleBtn  = [[CustomButton alloc] initWithFontSize:15];
        likePeopleBtn.backgroundColor = [UIColor redColor];
        [likePeopleBtn addTarget:self action:@selector(likePeopleListClick:) forControlEvents:UIControlEventTouchUpInside];
        likePeopleBtn.frame           = CGRectMake([DeviceManager getDeviceWidth]-50, bottomPosition, width-7, width-7);
        [backView addSubview:likePeopleBtn];
    }
    
    if (self.news.like_arr.count > 0) {
        bottomPosition += width+5;
    }
    //线
    self.lineView.frame        = CGRectMake(5, bottomPosition, [DeviceManager getDeviceWidth], 1);
    
    return backView;
}

//数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.comment_arr.count;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CommentModel * comment = self.news.comment_arr[indexPath.row];
   CGSize contentSize     = [ToolsManager getSizeWithContent:comment.comment_content andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    
    CGFloat second_comment_height = 0;
    //二级评论高度
    for (int i=0; i<comment.second_comments.count; i++) {
        
        SecondCommentModel * secondComment = comment.second_comments[i];
        //内容
        CGSize contentSize                = [ToolsManager getSizeWithContent:secondComment.comment_content andFontSize:15 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-15-55, MAXFLOAT)];
        second_comment_height += contentSize.height+20;
    }
    
    return 55+contentSize.height+second_comment_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld", indexPath.row]];
    if (!cell) {
        cell = [[NewsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld", indexPath.row]];
        cell.delegate = self;
    }
    [cell setConentWithModel:self.news.comment_arr[indexPath.row]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.commentTextView resignFirstResponder];
}

#pragma mark- HPGrowingTextViewDelegate
-(void) keyboardWillShow:(NSNotification *)note{

    self.commentCoverView.hidden = NO;
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = containerFrame;
    }];
    
}

-(void) keyboardWillHide:(NSNotification *)note{

    self.commentCoverView.hidden     = YES;
    self.commentTextView.placeholder = @"来条神评论吧~";
    self.commentTextView.text        = @"";
    self.isDefaultComment            = YES;

    CGRect containerFrame            = self.containerView.frame;
    containerFrame.origin.y          = self.view.bounds.size.height-40;
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = containerFrame;
    }];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff               = (growingTextView.frame.size.height - height);
    CGRect r                 = self.containerView.frame;
    r.size.height            -= diff;
    r.origin.y               += diff;
    self.containerView.frame = r;
}

//判断发送
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (growingTextView == self.commentTextView) {
        if ([text isEqualToString:@"\n"]) {
            //发送评论
            [self sendCommentPress];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark- NewsCommentDelegate
//删除评论
- (void)deleteCommentClick:(CommentModel *)comment
{
    
    NSDictionary * params = @{@"cid":[NSString stringWithFormat:@"%ld", comment.cid],
                              @"news_id":[NSString stringWithFormat:@"%ld", self.news.nid]};
    debugLog(@"%@ %@", kDeleteCommentPath, params);
    [self showLoading:@"删除中"];
    [HttpService postWithUrlString:kDeleteCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            //成功之后更新
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.news.comment_arr indexOfObject:comment]inSection:0];
            [self.news.comment_arr removeObject:comment];
            [self.newsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

- (void)deleteSecondCommentClick:(SecondCommentModel *)secondCommentModel andComment:(CommentModel *)comment
{
    NSDictionary * params = @{@"cid":[NSString stringWithFormat:@"%ld", secondCommentModel.scid],
                              @"news_id":[NSString stringWithFormat:@"%ld", self.news.nid]};
    debugLog(@"%@ %@", kDeleteSecondCommentPath, params);
    [self showLoading:@"删除中"];
    [HttpService postWithUrlString:kDeleteSecondCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            [comment.second_comments removeObject:secondCommentModel];
           //成功之后更新
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.news.comment_arr indexOfObject:comment]inSection:0];
            [self.newsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//回复评论
- (void)replyComment:(SecondCommentModel *)secondComment andTopComment:(CommentModel *)comment
{
    //默认评论取消
    self.isDefaultComment     = NO;

    self.currentSecondComment = secondComment;
    self.currentTopComment    = comment;
    
    //是好友查看备注
    NSString * name = secondComment.name;
    self.commentTextView.placeholder = [NSString stringWithFormat:@"回复：%@",name];
    
    [self.commentTextView becomeFirstResponder];
}

//#pragma mark- UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if ([textView isKindOfClass:[PlaceHolderTextView class]]) {
//        
//        if (textView.text.length > 0) {
//            [((PlaceHolderTextView *)textView) setPlaceHidden:YES];
//        }else{
//            [((PlaceHolderTextView *)textView) setPlaceHidden:NO];
//        }
//    }
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    if (textView == self.commentTextView) {
//        if ([text isEqualToString:@"\n"]) {
//            //发送状态
//            [self publishCommentClick];
//            [self.commentTextView resignFirstResponder];
//            self.commentTextView.text = @"";
//            return NO;
//        }
//    }
//    
//    return YES;
//}

#pragma mark- method response
//最近浏览点击
- (void)browseClick:(CustomButton *)btn
{
    NewsVisitViewController * nvvc = [[NewsVisitViewController alloc] init];
    nvvc.newsId                    = self.news.nid;
    [self pushVC:nvvc];
}

//图片点击
- (void)imageDetailClick:(UITapGestureRecognizer *) ges {
//    ImageModel * image               = self.news.image_arr[ges.view.tag];
//    NSString * url                   = [NSString stringWithFormat:@"%@%@", kAttachmentAddr, image.url];
//    BrowseImageViewController * bivc = [[BrowseImageViewController alloc] init];
//    bivc.url                         = url;
//    bivc.needDownLoad                = YES;
//    [self pushVC:bivc];
    
    BrowseImageListViewController * bilvc = [[BrowseImageListViewController alloc] init];
    bilvc.num                             = ges.view.tag;
    bilvc.dataSource                      = self.news.image_arr;
    [self presentViewController:bilvc animated:YES completion:nil];
    
}

//点赞或者取消赞点击
- (void)sendLikeClick {
    
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
    
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"news_id":[NSString stringWithFormat:@"%ld", self.news.nid],
                              @"isLike":[NSString stringWithFormat:@"%d", likeOrCancel],
                              @"is_second":@"0"};
    debugLog(@"%@ %@", kLikeOrCancelPath, params);
    //成功失败都没反应
    [HttpService postWithUrlString:kLikeOrCancelPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//tableView手势
- (void)tapTableView:(UITapGestureRecognizer *)ges
{
//    [self.commentTextView resignFirstResponder];
    [self.commentTextView resignFirstResponder];
}
//点赞头像点击
- (void)likeHeadClick:(CustomButton *)sender
{
    LikeModel * like           = self.news.like_arr[sender.tag];
    [self browsePersonalHome:like.user_id];
}
//新闻头像点击
- (void)newsHeadClick:(UITapGestureRecognizer *)ges
{
    [self browsePersonalHome:self.news.uid];
}

#pragma mark- private method
//发送评论
- (void)sendCommentPress
{
    if (self.commentTextView.text.length < 1) {
        return;
    }
    
    //如果是默认评论
    if (self.isDefaultComment) {
        [self publishCommentClick];
        [self.commentTextView resignFirstResponder];
        self.commentTextView.text = @"";
        return;
    }
    
    //如果不是 发送二级评论
    [self publishSecondCommentClick];
    [self.commentTextView resignFirstResponder];
    self.commentTextView.text = @"";
}

//浏览其他人的主页
- (void)browsePersonalHome:(NSInteger)userId
{
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid = userId;
    [self pushVC:opvc];
}



- (void)getData
{
    NSString * url = [NSString stringWithFormat:@"%@?news_id=%ld&user_id=%ld", kNewsDetailPath, self.newsId, [UserService sharedService].user.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSDictionary * newsDic = responseData[HttpResult];
            //数据处理
            NewsModel * news = [[NewsModel alloc] init];
            [news setContentWithDic:newsDic];
            //二级评论处理
            NSArray * comments    = newsDic[@"comments"];
            for (int i=0; i<comments.count; i++) {
                NSDictionary * commentDic = comments[i];
                CommentModel * comment    = news.comment_arr[i];
                NSArray * secondComments  = commentDic[@"secondComment"];
                //二级评论
                for (NSDictionary * secondCommentDic in secondComments) {
                    SecondCommentModel * scm = [[SecondCommentModel alloc] init];
                    scm.scid                 = [secondCommentDic[@"id"] integerValue];
                    scm.comment_content      = secondCommentDic[@"comment_content"];
                    scm.name                 = secondCommentDic[@"name"];
                    scm.user_id              = [secondCommentDic[@"user_id"] integerValue];
                    scm.add_date             = secondCommentDic[@"add_date"];
                    scm.reply_comment_id     = [secondCommentDic[@"reply_comment_id"] integerValue];
                    scm.top_comment_id       = [secondCommentDic[@"top_comment_id"] integerValue];
                    scm.reply_uid            = [secondCommentDic[@"reply_uid"] integerValue];
                    scm.reply_name           = secondCommentDic[@"reply_name"];
                    
                    [comment.second_comments addObject:scm];
                }
            }
            
            self.news = news;
            [self initTable];
        }else{
            [self showWarn:responseData[HttpMessage]];
            
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

//        [self showWarn:StringCommonNetException];
    }];
}

//评论
- (void)publishCommentClick
{
    if (self.commentTextView.text.length > 140) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能超过140字");
        return;
    }
    
    if (self.commentTextView.text.length < 1) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能为空");
        return;
    }
    
    //[NSString stringWithFormat:@"%d", [UserService sharedService].user.uid]
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"comment_content":self.commentTextView.text,
                              @"news_id":[NSString stringWithFormat:@"%ld", self.newsId]};
    
    [self showLoading:nil];
    debugLog(@"%@ %@", kSendCommentPath, params);
    [HttpService postWithUrlString:kSendCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            //生成评论模型
            CommentModel * comment = [[CommentModel alloc] init];
            [comment setContentWithDic:responseData[HttpResult]];
            [self.news.comment_arr addObject:comment];
            comment.name           = [UserService sharedService].user.name;
            comment.head_image     = [UserService sharedService].user.head_image;
            comment.head_sub_image = [UserService sharedService].user.head_sub_image;
            
            
            //更新table
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.news.comment_arr.count-1 inSection:0];
            [self.newsTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//点赞列表
- (void)likePeopleListClick:(id)sender
{
    LikeListViewController * llVC = [[LikeListViewController alloc] init];
    llVC.news_id                  = self.news.nid;
    [self pushVC:llVC];
}

//发布二级评论
- (void)publishSecondCommentClick
{
    
    debugLog(@"%@", self.commentTextView.text);
    if (self.commentTextView.text.length > 140) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能超过140字");
        return;
    }
    
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"comment_content":self.commentTextView.text,
                              @"news_id":[NSString stringWithFormat:@"%ld", self.newsId],
                              @"reply_uid":[NSString stringWithFormat:@"%ld", self.currentSecondComment.user_id],
                              @"reply_comment_id":[NSString stringWithFormat:@"%ld", self.currentSecondComment.scid],
                              @"top_comment_id":[NSString stringWithFormat:@"%ld", self.currentSecondComment.top_comment_id]};
    
    //当前的位置 这两个属性是为了防止私有属性currentTopComment因为点击其他而变化所以保存
    NSInteger topCommentIndex = [self.news.comment_arr indexOfObject:self.currentTopComment];
    NSString * name           = self.currentSecondComment.name;
    
    [self showLoading:nil];
    debugLog(@"%@ %@", kSendSecondCommentPath, params);
    [HttpService postWithUrlString:kSendSecondCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            
            NSDictionary * secondCommentDic = responseData[HttpResult];
            
            SecondCommentModel * scm = [[SecondCommentModel alloc] init];
            scm.scid                 = [secondCommentDic[@"id"] integerValue];
            scm.comment_content      = secondCommentDic[@"comment_content"];
            scm.name                 = [UserService sharedService].user.name;
            scm.user_id              = [secondCommentDic[@"user_id"] integerValue];
            scm.add_date             = secondCommentDic[@"add_date"];
            scm.reply_comment_id     = [secondCommentDic[@"reply_comment_id"] integerValue];
            scm.top_comment_id       = [secondCommentDic[@"top_comment_id"] integerValue];
            scm.reply_uid            = [secondCommentDic[@"reply_uid"] integerValue];
            scm.reply_name           = name;
            
            CommentModel * comment   = self.news.comment_arr[topCommentIndex];
            [comment.second_comments addObject:scm];
            //成功之后更新
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:topCommentIndex inSection:0];
            [self.newsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

- (CGFloat)getHeadNewsHeight
{
    CGSize contentSize        = [ToolsManager getSizeWithContent:self.news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
    NSInteger cellOtherHeight = 30+30+10+60+25;
    
    CGFloat height;
    if (self.news.image_arr.count < 1) {
        //没有图片
        height = cellOtherHeight+contentSize.height;
    }else if (self.news.image_arr.count == 1) {
        //一张图片 大图
        ImageModel * imageModel = self.news.image_arr[0];
        CGSize size             = CGSizeMake(imageModel.width, imageModel.height);
        CGRect rect             = [NewsUtils getRectWithSize:size];
        height                  = cellOtherHeight+contentSize.height+rect.size.height;
    }else{
        //多张图片九宫格
        NSInteger lineNum   = self.news.image_arr.count/3;
        NSInteger columnNum = self.news.image_arr.count%3;
        if (columnNum > 0) {
            lineNum++;
        }
        height              = cellOtherHeight+contentSize.height+lineNum*65;
    }

    //地址
    if (self.news.location.length > 0) {
        height += 25;
    }
    if (self.news.like_arr.count > 0) {
        CGFloat width  = ([DeviceManager getDeviceWidth]-60)/8;
        height += width + 5;
    }
    
    return height;
}

- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}

#pragma mark- override
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.commentTextView resignFirstResponder];
    [self.commentTextView resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
