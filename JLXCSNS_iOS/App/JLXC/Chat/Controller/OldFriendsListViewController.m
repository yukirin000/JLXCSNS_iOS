//
//  FriendsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/28.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OldFriendsListViewController.h"
#import "IMGroupModel.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "NewFriendsListViewController.h"
#import "OtherPersonalViewController.h"

@interface OldFriendsListViewController ()

//好友列表
@property (nonatomic, strong) UITableView * friendsTableView;
//好友数据源
@property (nonatomic, strong) NSMutableArray * friendsArr;
//排序后的好友字典
@property (nonatomic, strong) NSMutableDictionary * friendsDic;
//新的朋友请求数组
@property (nonatomic, strong) NSMutableArray * recentFriendsArr;
//没有点进添加列表看的新朋友
@property (nonatomic ,assign) NSInteger unReadNum;
//全部的好友首字母缩写
@property (nonatomic, strong) NSArray * allKeys;
//A-Z
@property (nonatomic, strong) NSArray * keys;



@end

@implementation OldFriendsListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    //初始化table
    [self initTableView];
//    //注册通知
//    [self registerNotify];
    //同步好友
    [self syncFriends];
}
//每一次进页面都重新更新数据源
- (void)viewWillAppear:(BOOL)animated
{
    [self refreshFriendsTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark- layout
#define CellIdentifier @"friendCell"
//初始化新的朋友
- (void)initNewsFriends
{
    //未读的新朋友
    self.unReadNum  = [IMGroupModel unReadNewFriendsCount];
    if (self.recentFriendsArr == nil) {
        self.recentFriendsArr = [[NSMutableArray alloc] init];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findThreeNewFriends]];
    }else{
        [self.recentFriendsArr removeAllObjects];
        [self.recentFriendsArr addObjectsFromArray:[IMGroupModel findThreeNewFriends]];
    }
}
//初始化我的好友列表
- (void)initMyFriends
{
    if (self.friendsArr == nil) {
        self.friendsArr = [[NSMutableArray alloc] init];
        [self.friendsArr addObjectsFromArray:[IMGroupModel findHasAddAll]];
        
    }else{
        [self.friendsArr removeAllObjects];
        [self.friendsArr addObjectsFromArray:[IMGroupModel findHasAddAll]];
    }
    
    //处理好友字典
    self.friendsDic = [self sortedArrayWithPinYinDic:self.friendsArr];
}

- (void)initTableView
{
    
    //列表
    self.friendsTableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, [DeviceManager getDeviceWidth], self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.friendsTableView.delegate   = self;
    self.friendsTableView.dataSource = self;
    [self.view addSubview:self.friendsTableView];
    [self.friendsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (section == 0) {
//        return 1;
//    }
    
    NSString *key = [self.allKeys objectAtIndex:section];
    NSArray *arr = [self.friendsDic objectForKey:key];
    return [arr count];
}

//pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray * titleArr = [[NSMutableArray alloc] init];
    
//    [titleArr addObject:@""];
    [titleArr addObjectsFromArray:self.allKeys];
    
    return titleArr;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return @"";
//    }
    
    NSString *key = [self.allKeys objectAtIndex:section];
    return key;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle    = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
//    //新的好友部分
//    if (indexPath.section == 0) {
//        
//        //标题
//        CustomLabel * titleLabel = [[CustomLabel alloc] initWithFontSize:15];
//        titleLabel.textColor     = [UIColor blackColor];
//        titleLabel.text          = @"新的请求";
//        titleLabel.frame         = CGRectMake(10, 20, 80, 20);
//        [cell.contentView addSubview:titleLabel];
//        //循环列表
//        for (int i=0; i<self.recentFriendsArr.count; i++) {
//            //新好友
//            IMGroupModel * newModel    = self.recentFriendsArr[i];
//            CGRect frame = CGRectMake(titleLabel.right + 10 + 60*i, 5, 50, 50);
//            CustomImageView * newHeadImageView = [[CustomImageView alloc] initWithFrame:frame];
//            [newHeadImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:newModel.avatarPath]] placeholderImage:[UIImage imageNamed:@"testimage"]];
//            [cell.contentView addSubview:newHeadImageView];
//        }
//        
//        if (self.unReadNum > 0) {
//            CustomLabel * unReadLabel       = [[CustomLabel alloc] initWithFontSize:15];
//            [unReadLabel setFontBold];
//            unReadLabel.layer.cornerRadius  = 10;
//            unReadLabel.layer.masksToBounds = YES;
//            unReadLabel.textAlignment       = NSTextAlignmentCenter;
//            unReadLabel.frame               = CGRectMake([DeviceManager getDeviceWidth]-40, 20, 20, 20);
//            NSInteger num = self.unReadNum;
//            if (num > 99) {
//                num = 99;
//            }
//            unReadLabel.text            = [NSString stringWithFormat:@"%ld",num];
//            unReadLabel.textColor       = [UIColor whiteColor];
//            unReadLabel.backgroundColor = [UIColor redColor];
//            [cell.contentView addSubview:unReadLabel];
//        }
//        
//        return cell;
//        
//    }
    
    //好友
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arr = [self.friendsDic objectForKey:key];
    //好友列表部分
    IMGroupModel * model    = arr[indexPath.row];
    //头像
    CustomImageView * headImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.avatarPath]] placeholderImage:[UIImage imageNamed:@"testimage"]];
    [cell.contentView addSubview:headImageView];
    //姓名
    CustomLabel * nameLabel = [[CustomLabel alloc] initWithFontSize:15];
    nameLabel.textColor     = [UIColor blackColor];
    nameLabel.text          = model.groupTitle;
    //备注
    if (model.groupRemark != nil && model.groupRemark.length > 0) {
        nameLabel.text      = model.groupRemark;
    }
    nameLabel.frame         = CGRectMake(headImageView.right+10, 10, 200, 20);
    [cell.contentView addSubview:nameLabel];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //好友
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arr = [self.friendsDic objectForKey:key];
    //好友列表部分
    IMGroupModel * model    = arr[indexPath.row];
    
    OtherPersonalViewController * opVC = [[OtherPersonalViewController alloc] init];
    opVC.uid                           = [[model.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""] integerValue];
    [self.navigationController pushViewController:opVC animated:YES];
    
//    if (indexPath.section == 0) {
//        
//        NewFriendsListViewController * nflVC = [[NewFriendsListViewController alloc] init];
//        [self.navigationController pushViewController:nflVC animated:YES];
//        
//    }else{
//        
//        //        ChatViewController *conversationVC = [[ChatViewController alloc]init];
//        //        conversationVC.conversationType =ConversationType_PRIVATE;
//        //        conversationVC.targetId = model.groupId;
//        //        conversationVC.targetName =model.groupTitle;
//        //        conversationVC.title = model.groupTitle;
//        //        [self.navigationController pushViewController:conversationVC animated:YES];
//        
//        //好友
//        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
//        NSArray *arr = [self.friendsDic objectForKey:key];
//        //好友列表部分
//        IMGroupModel * model    = arr[indexPath.row];
//        
//        OtherPersonalViewController * opVC = [[OtherPersonalViewController alloc] init];
//        opVC.uid                           = [[model.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""] integerValue];
//        [self.navigationController pushViewController:opVC animated:YES];
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    debugLog(@"%ld", indexPath.row);
}



#pragma mark- method response
//- (void)registerNotify
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendsTable) name:NOTIFY_NEW_GROUP object:nil];
//}

#pragma mark- private method
- (void)refreshFriendsTable
{
    [self initMyFriends];
    [self initNewsFriends];
    [self.friendsTableView reloadData];
    
}
//同步好友
- (void)syncFriends
{
    
    NSInteger friendsCount = [IMGroupModel findHasAddAll].count;
    NSString * path = [NSString stringWithFormat:@"%@?user_id=%ld&friends_count=%ld", kNeedSyncFriendsPath, [UserService sharedService].user.uid, friendsCount];
//    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
    
            BOOL needUpdate = [responseData[HttpResult][@"needUpdate"] boolValue];
            if (needUpdate) {
                [self getFriendsList];
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取好友列表
- (void)getFriendsList
{
    NSString * path = [NSString stringWithFormat:@"%@?user_id=%ld", kGetFriendsListPath, [UserService sharedService].user.uid];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            NSArray * friendsList = responseData[HttpResult][HttpList];
            for (NSDictionary * friendDic in friendsList) {
                IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:[friendDic[@"uid"] intValue]]];
                if (group != nil) {
                    
                    group.groupTitle     = friendDic[@"name"];
                    group.isNew          = NO;
                    group.avatarPath     = friendDic[@"head_image"];
                    group.groupRemark    = friendDic[@"friend_remark"];
                    group.isRead         = YES;
                    group.currentState   = GroupHasAdd;
                    [group update];
                    
                }else{
                    
                    group = [[IMGroupModel alloc] init];
                    group.type           = ConversationType_PRIVATE;
                    //targetId
                    group.groupId        = [ToolsManager getCommonGroupId:[friendDic[@"uid"] intValue]];
                    group.groupTitle     = friendDic[@"name"];
                    group.isNew          = NO;
                    group.avatarPath     = friendDic[@"head_image"];
                    group.groupRemark    = friendDic[@"friend_remark"];
                    group.isRead         = YES;
                    group.currentState   = GroupHasAdd;
                    group.owner          = [UserService sharedService].user.uid;
                    [group save];
                }
               
            }
            
            [self refreshFriendsTable];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 拼音排序

/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
-(NSString *) hanZiToPinYinWithString:(NSString *)hanZi
{
    if(!hanZi) return nil;
    NSString *pinYinResult=[NSString string];
//    for(int j=0;j<hanZi.length;j++){
    if (hanZi.length > 0) {
        NSString * hanyu = [NSString stringWithFormat:@"%C", [hanZi characterAtIndex:0]];
        NSString *singlePinyinLetter= [hanyu hanziZhuanPinYin];
//        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        pinYinResult = [singlePinyinLetter uppercaseString];
    }

        
//    }
    
    return pinYinResult;
    
}


/**
 *  根据转换拼音后的字典排序
 *  #######################算法效率低 以后有时间再优化#######################
 *  @param friends 要转换的数组
 *
 *  @return 对应排序的字典
 */
-(NSMutableDictionary *) sortedArrayWithPinYinDic:(NSArray *) friends
{
    
    self.allKeys                   = [NSArray array];
    NSMutableDictionary *returnDic = [NSMutableDictionary new];

    
    for (NSString *key in self.keys) {
        
        NSMutableArray * tempOtherArr = [NSMutableArray new];
        NSMutableArray *tempArr       = [NSMutableArray new];
        for (IMGroupModel *user in friends) {
            
            NSString *pyResult;
            if (user.groupRemark.length > 0) {
                pyResult = [self hanZiToPinYinWithString:user.groupRemark];
            }else{
                pyResult = [self hanZiToPinYinWithString:user.groupTitle];
            }
            
            NSString *firstLetter = @"";
            char c = '#';
            if (pyResult!=nil && pyResult.length>0) {
                c = [pyResult characterAtIndex:0];
                firstLetter = [pyResult substringToIndex:1];
            }
            if ([firstLetter isEqualToString:key]){
                [tempArr addObject:user];
                continue;
            }

            //非字母
            if (isalpha(c) == 0) {
                
                [tempOtherArr addObject:user];
                continue;
            }
        }
        
        //如果数量大于0
        if (tempArr.count > 0) {
            [returnDic setObject:tempArr forKey:key];
        }
        if (tempOtherArr.count > 0) {
            [returnDic setObject:tempOtherArr forKey:@"#"];
        }
    }
    
    self.allKeys = [[returnDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return returnDic;
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
