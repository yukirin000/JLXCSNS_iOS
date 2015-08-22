//
//  MyNewsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.

#import "MyNewsListViewController.h"
#import "NewsUtils.h"
#import "PublishNewsViewController.h"
#import "NewsModel.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "LikeModel.h"
#import "BrowseImageViewController.h"
#import "SendCommentViewController.h"
#import "MyNewsListCell.h"
#import "NewsDetailViewController.h"
#import "BrowseImageListViewController.h"

@interface MyNewsListViewController ()<MyNewsListDelegate>

//@property (nonatomic, strong) CustomLabel * currentCommentLabel;

@end

@implementation MyNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavBarTitle:@"生活小点滴  (●'◡'●)ﾉ♥"];
    
    self.refreshTableView.frame           = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    self.refreshTableView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    
    [self loadAndhandleData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
//- (void)setLeftSide
//{
//    CusTabBarViewController * tab = (CusTabBarViewController *)self.tabBarController;
//    [tab setLeftBtnSlideWithNavBar:self.navBar];
//}

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
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", @"newsList", indexPath.row];
    MyNewsListCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MyNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.delegate  = self;
    }
    cell.isOther = self.isOther;
    [cell setConentWithModel:self.dataArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel * news          = self.dataArr[indexPath.row];
    CGSize contentSize        = [ToolsManager getSizeWithContent:news.content_text andFontSize:16 andFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth]-30, MAXFLOAT)];
    if (news.content_text == nil || news.content_text.length < 1) {
        contentSize.height = 0;
    }
    //名字20 时间30 顶部背景图15 底部操作部分50
    NSInteger cellOtherHeight = 30+20+15+50;
    
    CGFloat height;
    if (news.image_arr.count < 1) {
        //没有图片
        height = cellOtherHeight+contentSize.height;
    }else if (news.image_arr.count == 1) {
        //一张图片 大图
        ImageModel * imageModel = news.image_arr[0];
        CGSize size             = CGSizeMake(imageModel.width, imageModel.height);
        CGRect rect             = [NewsUtils getRectWithSize:size];
        height                  = cellOtherHeight+contentSize.height+rect.size.height+5;
    }else{
        //多张图片九宫格
        NSInteger lineNum   = news.image_arr.count/3;
        NSInteger columnNum = news.image_arr.count%3;
        if (columnNum > 0) {
            lineNum++;
        }
        CGFloat itemWidth = [DeviceManager getDeviceWidth]/5.0;
        height            = cellOtherHeight+contentSize.height+lineNum*(itemWidth+10)+5;
        //减去第一行的10
        height           -= 10;
    }

    //地址
    if (news.location.length > 0) {
        height += 25;
    }
    
    return height;
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
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*! 删除该条状态 暂时关闭*/
- (void)deleteNewsClick:(NewsModel *)news
{
//    NSDictionary * params = @{@"news_id":[NSString stringWithFormat:@"%ld", news.nid]};
//    debugLog(@"%@ %@", kDeleteNewsListPath, params);
//    [self showLoading:@"删除中"];
//    
//    [HttpService postWithUrlString:kDeleteNewsListPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
//        int status = [responseData[HttpStatus] intValue];
//        if (status == HttpStatusCodeSuccess) {
//            [self showComplete:responseData[HttpMessage]];
//            //成功之后更新
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataArr indexOfObject:news] inSection:0];
//            [self.dataArr removeObject:news];
//            [self.refreshTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            
//        }else{
//            
//            [self showWarn:responseData[HttpMessage]];
//        }
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showWarn:StringCommonNetException];
//    }];

}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url;
    
    if (self.isOther) {
        url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld", kUserNewsListPath, self.currentPage, self.uid];
    }else{
        url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld", kUserNewsListPath, self.currentPage, [UserService sharedService].user.uid];
    }
    
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * newsDic in list) {
                NewsModel * news      = [[NewsModel alloc] init];
                [news setContentWithDic:newsDic];
                [self.dataArr addObject:news];
            }
            
            [self reloadTable];
        }else{
            [self showWarn:responseData[HttpMessage]];
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
        }
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
        [self showWarn:StringCommonNetException];
    }];
    
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
