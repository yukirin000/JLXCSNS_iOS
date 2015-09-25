//
//  TopicNewsViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicNewsViewController.h"
#import "NewsUtils.h"
#import "HttpCache.h"
#import "OtherPersonalViewController.h"
#import "PublishNewsViewController.h"
#import "NewsModel.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "LikeModel.h"
#import "BrowseImageListViewController.h"
#import "SendCommentViewController.h"
#import "NewsListCell.h"
#import "NewsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "TopicDetailViewController.h"

@interface TopicNewsViewController ()<NewsListDelegate,RefreshDataDelegate>

//需要复制的字符串
@property (nonatomic, copy) NSString * pasteStr;
//发布按钮
@property (nonatomic, strong) CustomButton * publishBtn;
//头部的背景 用于关注
@property (nonatomic, strong) UIView * backHeadView;
//头部描述Label
@property (nonatomic, strong) CustomLabel * descLabel;
//关注按钮
@property (nonatomic, strong) CustomButton * attentButton;

@end

@implementation TopicNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    
    //初始化
    [self initWidget];
    [self configUI];
    
    [self refreshData];
    [self registerNotify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.publishBtn   = [[CustomButton alloc] init];
    self.backHeadView = [[UIView alloc] init];
    self.descLabel    = [[CustomLabel alloc] init];
    self.attentButton = [[CustomButton alloc] init];
    
    [self.view addSubview:self.publishBtn];
    [self.backHeadView addSubview:self.descLabel];
    [self.backHeadView addSubview:self.attentButton];
    
    [self.publishBtn addTarget:self action:@selector(publishNews:) forControlEvents:UIControlEventTouchUpInside];
    [self.attentButton addTarget:self action:@selector(attentTopic:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"" andBlock:^{
        TopicDetailViewController * tdvc = [[TopicDetailViewController alloc] init];
        tdvc.topicID                     = sself.topicID;
        [sself pushVC:tdvc];
    }];
}

- (void)configUI
{
    [self setNavBarTitle:self.topicName];
    
    //右上角按钮
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"topic_info"] forState:UIControlStateNormal];
    
    //发布按钮
    self.publishBtn.frame = CGRectMake(self.viewWidth-85, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight-85, 70, 70);
    [self.publishBtn setImage:[UIImage imageNamed:@"publish_btn_normal"] forState:UIControlStateNormal];
    [self.publishBtn setImage:[UIImage imageNamed:@"publish_btn_press"] forState:UIControlStateHighlighted];
    //顶部背景
    self.backHeadView.frame           = CGRectMake(0, 0, self.viewWidth, 0);
    self.backHeadView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    self.descLabel.frame              = CGRectMake(10, 13, self.viewWidth-90, 0);
    self.descLabel.numberOfLines      = 4;
    self.descLabel.textColor          = [UIColor colorWithHexString:ColorBlue];
    self.descLabel.lineBreakMode      = NSLineBreakByCharWrapping;
    self.descLabel.font               = [UIFont systemFontOfSize:13];
    //关注
    self.attentButton.frame           = CGRectMake(self.viewWidth-60, 0, 45, 25);
    self.attentButton.backgroundColor = [UIColor colorWithHexString:ColorYellow];
    self.attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.attentButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentButton setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    
}

#pragma mark- override
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//下拉刷新
- (void)refreshData
{
    [super refreshData];
    [self loadAndhandleData];
}
//加载更多
- (void)loadingData
{
    [super loadingData];
    [self loadAndhandleData];
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid   = [NSString stringWithFormat:@"%@%ld", @"newsList", indexPath.row];
    NewsListCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell          = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.delegate = self;
    }
    [cell setConentWithModel:self.dataArr[indexPath.row]];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    NewsModel * news                = self.dataArr[indexPath.row];
    ndvc.newsId                     = news.nid;
    [self pushVC:ndvc];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel * news          = self.dataArr[indexPath.row];
    
    return [self getCellHeightWith:news];;
}

#pragma mark- NewsListDelegate
- (void)longPressContent:(NewsModel *)news andGes:(UILongPressGestureRecognizer *)ges
{
    [self becomeFirstResponder];
    self.pasteStr                    = news.content_text;
    UIView * view                    = ges.view;
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem * copyItem            = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContnet)];
    UIMenuItem * cancelItem          = [[UIMenuItem alloc] initWithTitle:@"取消" action:@selector(cancel)];
    [menuController setMenuItems:@[copyItem,cancelItem]];
    [menuController setArrowDirection:UIMenuControllerArrowDown];
    [menuController setTargetRect:view.frame inView:view.superview];
    [menuController setMenuVisible:YES animated:YES];
}
//图片点击
- (void)imageClick:(NewsModel *)news index:(NSInteger)index
{
    
    BrowseImageListViewController * bilvc = [[BrowseImageListViewController alloc] init];
    bilvc.num                             = index;
    bilvc.dataSource                      = news.image_arr;
    [self presentViewController:bilvc animated:YES completion:nil];
    
}

//发送评论
- (void)sendCommentClick:(NewsModel *)news
{
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    ndvc.commentType                = CommentFirst;
    ndvc.newsId                     = news.nid;
    [self pushVC:ndvc];
}

//点赞
- (void)likeClick:(NewsModel *)news likeOrCancel:(BOOL)flag
{
    //news_id=23&user_id=1&is_second=0&isLike=1
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"news_id":[NSString stringWithFormat:@"%ld", news.nid],
                              @"isLike":[NSString stringWithFormat:@"%d", flag],
                              @"is_second":@"0"};
    debugLog(@"%@ %@", kLikeOrCancelPath, params);
    
    //成功失败都没反应
    [HttpService postWithUrlString:kLikeOrCancelPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        //        debugLog(@"%@", responseData);
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark- method response
//发布消息
- (void)publishNews:(id)sender
{
    PublishNewsViewController * pnvc = [[PublishNewsViewController alloc] init];
    pnvc.topicID                     = self.topicID;
    pnvc.topicName                   = self.topicName;
    [self pushVC:pnvc];
}
//关注圈子
- (void)attentTopic:(id)sender
{
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"topic_id":[NSString stringWithFormat:@"%ld", self.topicID]};
    
    [self showLoading:@"加入中..."];
    [HttpService postWithUrlString:kJoinTopicPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            self.refreshTableView.tableHeaderView = nil;
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//复制
- (void)copyContnet
{
    //得到剪切板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string        = self.pasteStr;
    self.pasteStr       = @"";
    debugLog(@"%@",[UIPasteboard generalPasteboard].string);
}
//取消menu
- (void)cancel
{}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    //如果没有学校 不能查询
    if (self.topicID < 1) {
        [self showWarn:@"没有该圈子"];
        return;
    }
    
    //最后一次时间
    NSString * first_time = @"0";
    if (!self.isReloading && self.dataArr.count > 0) {
        NewsModel * news = self.dataArr.firstObject;
        first_time       = news.publish_time;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&topic_id=%ld&frist_time=%@", kGetTopicNewsListPath, self.currentPage, [UserService sharedService].user.uid, self.topicID, first_time];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        //        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            NSDictionary * resultDic = responseData[HttpResult];
            NSInteger isAttent       = [resultDic[@"is_attent"] integerValue];
            if (!isAttent) {
                self.descLabel.text      = resultDic[@"topic_detail"];
                CGSize size              = [ToolsManager getSizeWithContent:self.descLabel.text andFontSize:13 andFrame:CGRectMake(0, 0, self.descLabel.width, 70)];
                self.descLabel.height    = size.height;
                self.backHeadView.height = self.descLabel.bottom+13;
                self.attentButton.y      = (self.backHeadView.height-self.attentButton.height)/2;
                //设置背景
                self.refreshTableView.tableHeaderView = self.backHeadView;
            }else {
                self.refreshTableView.tableHeaderView = nil;
            }
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            [self injectDataSourceWith:list];
        }else{
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
        [self showWarn:StringCommonNetException];
    }];
    
}

//数据注入
- (void)injectDataSourceWith:(NSArray *)list
{
    //数据处理
    for (NSDictionary * newsDic in list) {
        NewsModel * news      = [[NewsModel alloc] init];
        [news setContentWithDic:newsDic];
        //去掉评论
        [news.comment_arr removeAllObjects];
        [self.dataArr addObject:news];
    }
    
    [self reloadTable];
    
}

//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNewsPublish:) name:NOTIFY_PUBLISH_NEWS object:nil];
}
//新消息发布成功刷新页面
- (void)newNewsPublish:(NSNotification *)notify
{
    self.refreshTableView.contentOffset = CGPointZero;
    [self refreshData];
}

- (CGFloat)getCellHeightWith:(NewsModel *)news
{
    CGSize contentSize        = [ToolsManager getSizeWithContent:news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
    if (news.content_text == nil || news.content_text.length < 1) {
        contentSize.height = 0;
    }
    //头像60 时间25 评论按钮30 还有15的底线
    NSInteger cellOtherHeight = 55+25+30+15;
    
    CGFloat height;
    if (news.image_arr.count < 1) {
        //没有图片
        height = cellOtherHeight+contentSize.height+5;
    }else if (news.image_arr.count == 1) {
        //一张图片 大图
        ImageModel * imageModel = news.image_arr[0];
        CGSize size             = CGSizeMake(imageModel.width, imageModel.height);
        CGRect rect             = [NewsUtils getRectWithSize:size];
        height                  = cellOtherHeight+contentSize.height+rect.size.height+10;
    }else{
        //多张图片九宫格
        NSInteger lineNum   = news.image_arr.count/3;
        NSInteger columnNum = news.image_arr.count%3;
        if (columnNum > 0) {
            lineNum++;
        }
        CGFloat itemWidth = [DeviceManager getDeviceWidth]/5.0;
        height            = cellOtherHeight+contentSize.height+lineNum*(itemWidth+10);
    }
    
    //地址
    if (news.location.length > 0) {
        height += 25;
    }
    //点赞列表
    if (news.like_arr.count > 0) {
        CGFloat width = ([DeviceManager getDeviceWidth]-53-27)/8;
        height += width+5;
    }
    
    //评论
    for (int i=0; i<news.comment_arr.count; i++) {
        CommentModel * comment = news.comment_arr[i];
        NSString * commentStr  = [NSString stringWithFormat:@"%@:%@", comment.name, comment.comment_content];
        CGSize nameSize        = [ToolsManager getSizeWithContent:commentStr andFontSize:14 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
        height                 = height + nameSize.height+5;
    }
    
    return height;
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
