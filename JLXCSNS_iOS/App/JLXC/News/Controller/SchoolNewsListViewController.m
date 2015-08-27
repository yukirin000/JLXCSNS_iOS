//
//  SchoolNewsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//


#import "SchoolNewsListViewController.h"
#import "NewsUtils.h"
#import "HttpCache.h"
#import "OtherPersonalViewController.h"
#import "StudentListViewController.h"
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
#import "StudentListViewController.h"

@interface SchoolNewsListViewController ()<NewsListDelegate,RefreshDataDelegate>

//@property (nonatomic, strong) CustomLabel * currentCommentLabel;

//顶部学生数组
@property (nonatomic, strong) NSMutableArray * studentList;

@end

@implementation SchoolNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden          = YES;
    self.refreshTableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    self.studentList            = [[NSMutableArray alloc] init];
    
    //先使用缓存
    [self useCache];
    
    [self refreshData];
    [self registerNotify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout

#pragma mark- override
- (void)createRefreshView
{
    //展示数据的列表
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        self.refreshTableView                 = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStyleGrouped];
    }else{
        self.refreshTableView                 = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    }
    
    self.refreshTableView.delegate        = self;
    self.refreshTableView.dataSource      = self;
    self.refreshTableView.refreshDelegate = self;
    self.refreshTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.refreshTableView];
    self.refreshTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.refreshTableView.bounds.size.width, 0.01f)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * backView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 100)];
    backView.backgroundColor           = [UIColor redColor];
    //背景图
    CustomImageView * backImageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 120)];
    backImageView.contentMode          = UIViewContentModeScaleAspectFill;
    backImageView.layer.masksToBounds  = YES;
    backImageView.image                = [UIImage imageNamed:@"campus_background"];
    [backView addSubview:backImageView];
    //学校名字
    CustomLabel * schoolLabel          = [[CustomLabel alloc] initWithFontSize:20];
    schoolLabel.backgroundColor        = [UIColor colorWithWhite:0.3 alpha:0.1];
    schoolLabel.frame                  = CGRectMake(0, 45, self.viewWidth, 30);
    schoolLabel.textColor              = [UIColor colorWithHexString:ColorWhite];
    schoolLabel.text                   = [UserService sharedService].user.school;
    schoolLabel.textAlignment          = NSTextAlignmentCenter;
    [schoolLabel setFontBold];
    [backView addSubview:schoolLabel];
    //提示标签
    CustomLabel * schoolStudentLabel   = [[CustomLabel alloc] initWithFontSize:14];
    schoolStudentLabel.userInteractionEnabled = YES;
    schoolStudentLabel.backgroundColor = [UIColor colorWithHexString:ColorWhite];
    schoolStudentLabel.textColor       = [UIColor colorWithHexString:ColorDeepBlack];
    schoolStudentLabel.frame           = CGRectMake(0, backImageView.bottom, self.viewWidth, 30);
    schoolStudentLabel.text            = @"  本校的帅锅与美女 (•'◡'•)ﾉ";
    [backView addSubview:schoolStudentLabel];
    
    CustomImageView * arrowImageView = [[CustomImageView alloc] initWithFrame:CGRectMake([DeviceManager getDeviceWidth]-30, backImageView.bottom, 15, 30)];
    arrowImageView.contentMode       = UIViewContentModeCenter;
    [arrowImageView setImage:[UIImage imageNamed:@"right_arrow"]];
    [backView addSubview:arrowImageView];
    
    //点击头像手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(studentListTap:)];
    [schoolStudentLabel addGestureRecognizer:tap];
    
    //线
    UIView * midLine        = [[UIView alloc] initWithFrame:CGRectMake(0, schoolStudentLabel.bottom-1, self.viewWidth, 1)];
    midLine.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    [backView addSubview:midLine];
    
    //头像列表背景
    UIScrollView * headBackView  = [[UIScrollView alloc] init];
    headBackView.backgroundColor = [UIColor colorWithHexString:ColorWhite];
    headBackView.frame           = CGRectMake(0, schoolStudentLabel.bottom, self.viewWidth, 50);
    [backView addSubview:headBackView];
    
    //头像列表
    for (int i=0; i<self.studentList.count; i++) {
        
        UserModel * student = self.studentList[i];
        CustomImageView * headImageView      = [[CustomImageView alloc] init];
        headImageView.tag                    = i;
        headImageView.frame                  = CGRectMake(10+45*i, 5, 40, 40);
        headImageView.userInteractionEnabled = YES;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:student.head_sub_image]]placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        [headBackView addSubview:headImageView];
        //点击头像手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(studentTap:)];
        [headImageView addGestureRecognizer:tap];
    }
    headBackView.showsHorizontalScrollIndicator = NO;
    headBackView.contentSize                    = CGSizeMake(10+45*self.studentList.count, 0);
    
    //线
    UIView * coarseLine           = [[UIView alloc] initWithFrame:CGRectMake(0, headBackView.bottom, self.viewWidth, 5)];
    coarseLine.backgroundColor    = [UIColor colorWithHexString:ColorLightWhite];
    [backView addSubview:coarseLine];

    //提示标签
    CustomLabel * newsListLabel   = [[CustomLabel alloc] initWithFontSize:14];
    newsListLabel.backgroundColor = [UIColor colorWithHexString:ColorWhite];
    newsListLabel.textColor       = [UIColor colorWithHexString:ColorDeepBlack];
    newsListLabel.frame           = CGRectMake(0, coarseLine.bottom, self.viewWidth, 25);
    newsListLabel.text            = @"  帅锅美女们的日常  (•ㅂ•)/";
    [backView addSubview:newsListLabel];

    //线
    UIView * bottomLine           = [[UIView alloc] initWithFrame:CGRectMake(0, newsListLabel.bottom, self.viewWidth, 1)];
    bottomLine.backgroundColor    = [UIColor colorWithHexString:ColorLightWhite];
    [backView addSubview:bottomLine];
    
    return backView;
}

#pragma mark- NewsListDelegate
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

////删除评论
//- (void)deleteCommentClick:(NewsModel *)news index:(NSInteger)index
//{
//    NSArray * commentArr     = news.comment_arr;
//    CommentModel * model     = commentArr[index];
//    
//    NSDictionary * params = @{@"cid":[NSString stringWithFormat:@"%ld", model.cid],
//                              @"news_id":[NSString stringWithFormat:@"%ld", news.nid]};
//    debugLog(@"%@ %@", kDeleteCommentPath, params);
//    [self showLoading:@"删除中"];
//    
//    [HttpService postWithUrlString:kDeleteCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        //        debugLog(@"%@", responseData);
//        int status = [responseData[HttpStatus] intValue];
//        if (status == HttpStatusCodeSuccess) {
//            [self showComplete:responseData[HttpMessage]];
//            //成功之后更新
//            [news.comment_arr removeObject:model];
//            if (news.comment_quantity > 0) {
//                news.comment_quantity --;
//            }
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataArr indexOfObject:news] inSection:0];
//            [self.refreshTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//        }else{
//            
//            [self showWarn:responseData[HttpMessage]];
//        }
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showWarn:StringCommonNetException];
//    }];
//}


#pragma mark- method response
- (void)studentListTap:(UITapGestureRecognizer *)ges
{
    StudentListViewController * slVC = [[StudentListViewController alloc] init];
    slVC.school_code                 = [UserService sharedService].user.school_code;
    [self pushVC:slVC];
}

- (void)studentTap:(UITapGestureRecognizer *)ges
{
    OtherPersonalViewController * opVC = [[OtherPersonalViewController alloc] init];
    UserModel * user                   = self.studentList[ges.view.tag];
    opVC.uid                           = user.uid;
    [self pushVC:opVC];
}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    //如果没有学校 不能查询
    if ([UserService sharedService].user.school_code.length < 1) {
        
        ALERT_SHOW(StringCommonPrompt, @"请填写学校才能查看校园广场~");
        return;
    }

    //最后一次时间
    NSString * first_time = @"";
    if (!self.isReloading && self.dataArr.count > 0) {
        NewsModel * news = self.dataArr.firstObject;
        first_time       = news.publish_time;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&school_code=%@&frist_time=%@", kSchoolNewsListPath, self.currentPage, [UserService sharedService].user.uid, [UserService sharedService].user.school_code, first_time];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        //        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
                [self.studentList removeAllObjects];
                NSArray * infoList = responseData[HttpResult][@"info"];
                //学生数组
                for (NSDictionary * studentDic in infoList) {
                    UserModel * student    = [[UserModel alloc] init];
                    student.uid            = [studentDic[@"uid"] integerValue];
                    student.head_sub_image = studentDic[@"head_sub_image"];
                    [self.studentList addObject:student];
                }
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
//使用缓存
- (void)useCache
{
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&school_code=%@&frist_time=", kSchoolNewsListPath, self.currentPage, [UserService sharedService].user.uid, [UserService sharedService].user.school_code];
    NSDictionary * dic = [HttpCache getCacheWithUrl:url];
    if (dic != nil) {
        NSArray * list = dic[HttpResult][HttpList];
        //注入数据刷新页面
        [self injectDataSourceWith:list];
    }
    
}

//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNewsPublish:) name:NOTIFY_PUBLISH_NEWS object:nil];
    //首页tab点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabPress:) name:NOTIFY_TAB_PRESS object:nil];
}
//新消息发布成功刷新页面
- (void)newNewsPublish:(NSNotification *)notify
{
    self.refreshTableView.contentOffset = CGPointZero;
    [self refreshData];
}

- (void)tabPress:(NSNotification *)notify
{
    if (self.refreshTableView.contentOffset.y > 0) {
        if (self.refreshTableView != nil && [self.refreshTableView numberOfRowsInSection:0]>0) {
            [self.refreshTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else{
        [self.refreshTableView refreshingTop];
    }
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
