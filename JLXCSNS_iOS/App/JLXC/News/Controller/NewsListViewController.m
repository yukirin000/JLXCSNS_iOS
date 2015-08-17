//
//  NewsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/15.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsListViewController.h"
#import "PublishNewsViewController.h"
#import "NewsModel.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "LikeModel.h"
#import "BrowseImageListViewController.h"
#import "SendCommentViewController.h"
#import "NewsListCell.h"
#import "NewsDetailViewController.h"
#import "HttpCache.h"

@interface NewsListViewController ()<NewsListDelegate>

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.hidden = YES;
    self.refreshTableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    
    //先使用缓存
    [self useCache];
    
    [self refreshData];
    [self registerNotify];
    
}

//iOS的一些渲染问题 需要在该生命周期的时候将navBar隐藏以便于使用定制Nav
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout

#pragma override
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

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    NewsModel * news                = self.dataArr[indexPath.row];
    ndvc.newsId                     = news.nid;
    [self pushVC:ndvc];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel * news          = self.dataArr[indexPath.row];
    
    return [self getCellHeightWith:news];
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
    SendCommentViewController * scvc = [[SendCommentViewController alloc] init];
    scvc.nid                         = news.nid;
    [self presentViewController:scvc animated:YES completion:nil];
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
//删除评论
- (void)deleteCommentClick:(NewsModel *)news index:(NSInteger)index
{
    NSArray * commentArr     = news.comment_arr;
    CommentModel * model     = commentArr[index];
    
    NSDictionary * params = @{@"cid":[NSString stringWithFormat:@"%ld", model.cid],
                              @"news_id":[NSString stringWithFormat:@"%ld", news.nid]};
    debugLog(@"%@ %@", kDeleteCommentPath, params);
    [self showLoading:@"删除中"];
    
    [HttpService postWithUrlString:kDeleteCommentPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            //成功之后更新
            [news.comment_arr removeObject:model];
            if (news.comment_quantity > 0) {
                news.comment_quantity --;
            }
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataArr indexOfObject:news] inSection:0];
            [self.refreshTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}


#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{

    //最后一次时间
    NSString * first_time = @"";
    if (!self.isReloading && self.dataArr.count > 0) {
        NewsModel * news = self.dataArr.firstObject;
        first_time        = news.publish_time;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&frist_time=%@", kNewsListPath, self.currentPage, [UserService sharedService].user.uid, first_time];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //注入数据刷新页面
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
        [self.dataArr addObject:news];
    }
    
    [self reloadTable];
}
//使用缓存
- (void)useCache
{
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&frist_time=", kNewsListPath, self.currentPage, [UserService sharedService].user.uid];
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

}
//新消息发布成功刷新页面
- (void)newNewsPublish:(NSNotification *)notify
{
    self.refreshTableView.contentOffset = CGPointZero;
    [self refreshData];
}

//获取合适的比例
- (CGRect)getRectWithSize:(CGSize) size
{
    CGFloat x,y,width,height;
    if (size.width > size.height) {
        width  = 200;
        height = size.height*(200/size.width);
    }else{
        width  = 100;
        height = size.height*(100/size.width);
    }
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}

- (CGFloat)getCellHeightWith:(NewsModel *)news
{
    CGSize contentSize        = [ToolsManager getSizeWithContent:news.content_text andFontSize:15 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
    //头像80 评论按钮30 还有10的底线
    NSInteger cellOtherHeight = 80+30+10;
    
    CGFloat height;
    if (news.image_arr.count < 1) {
        //没有图片
        height = cellOtherHeight+contentSize.height;
    }else if (news.image_arr.count == 1) {
        //一张图片 大图
        ImageModel * imageModel = news.image_arr[0];
        CGSize size             = CGSizeMake(imageModel.width, imageModel.height);
        CGRect rect             = [self getRectWithSize:size];
        height                  = cellOtherHeight+contentSize.height+rect.size.height;
    }else{
        //多张图片九宫格
        NSInteger lineNum   = news.image_arr.count/3;
        NSInteger columnNum = news.image_arr.count%3;
        if (columnNum > 0) {
            lineNum++;
        }
        height              = cellOtherHeight+contentSize.height+lineNum*65;
    }
    
    //评论
    for (int i=0; i<news.comment_arr.count; i++) {
        CommentModel * comment = news.comment_arr[i];
        NSString * commentStr  = [NSString stringWithFormat:@"%@:%@", comment.name, comment.comment_content];
        CGSize nameSize        = [ToolsManager getSizeWithContent:commentStr andFontSize:15 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
        height                 = height + nameSize.height+5;
    }
    
    //地址
    if (news.location.length > 0) {
        height += 25;
    }
    //点赞列表
    if (news.like_arr.count > 0) {
        CGFloat width = ([DeviceManager getDeviceWidth]-60)/8;
        height += width+5;
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
