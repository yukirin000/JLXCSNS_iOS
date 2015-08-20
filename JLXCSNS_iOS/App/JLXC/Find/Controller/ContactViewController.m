//
//  ContactViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ContactViewController.h"
#import "IMGroupModel.h"
#import <AddressBook/AddressBook.h>
#import "UIImageView+WebCache.h"
#import "OtherPersonalViewController.h"
#import "FindUtils.h"

//联系人Model
@interface ContactModel : NSObject

//用户id
@property (nonatomic, assign) NSInteger uid;

//姓名
@property (nonatomic, copy) NSString * name;

//电话号
@property (nonatomic, copy) NSString * phone;

//头像图
@property (nonatomic, copy) NSString * head_image;

//头像缩略图
@property (nonatomic, copy) NSString * head_sub_image;

//是否是好友
@property (nonatomic, assign) BOOL is_friend;

@end

@implementation ContactModel

@end

@interface ContactViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableDictionary * contactDic;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"通讯录中的小伙伴 (・ω・=)"];
    
    [self readAllPeoples];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define CellIdentifier @"contactCell"
- (void)initTableView
{
    //列表
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, [DeviceManager getDeviceWidth], self.view.height-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark- UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell      = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor        = [UIColor colorWithHexString:ColorWhite];
    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    ContactModel * contact      = self.dataSource[indexPath.row];
    //头像
    CustomImageView * imageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    imageView.layer.cornerRadius   = 2;
    imageView.layer.masksToBounds  = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:contact.head_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    [cell.contentView addSubview:imageView];
    
    //昵称
    CustomLabel * nameLabel        = [[CustomLabel alloc] initWithFontSize:15];
    nameLabel.frame                = CGRectMake(imageView.right+10, imageView.y+3, 200, 20);
    nameLabel.font                 = [UIFont systemFontOfSize:FontListName];
    nameLabel.textColor            = [UIColor colorWithHexString:ColorDeepBlack];
    nameLabel.text                 = contact.name;
    [cell.contentView addSubview:nameLabel];

    //通讯录名
    CustomLabel * contactLabel        = [[CustomLabel alloc] initWithFontSize:14];
    contactLabel.frame                = CGRectMake(nameLabel.x, nameLabel.bottom+1, 200, 20);
    contactLabel.font                 = [UIFont systemFontOfSize:FontListContent];
    contactLabel.textColor            = [UIColor colorWithHexString:ColorDeepGary];
    contactLabel.text                 = [NSString stringWithFormat:@"通讯录：%@", self.contactDic[contact.phone]];;
    [cell.contentView addSubview:contactLabel];
    
    //添加按钮
    CustomButton * addBtn          = [[CustomButton alloc] initWithFontSize:15];
    addBtn.frame                   = CGRectMake(self.viewWidth-65, 17, 50, 23);
    //如果已经添加了
    if (contact.is_friend == GroupHasAdd) {
        [addBtn setImage:[UIImage imageNamed:@"friend_btn_isadd"] forState:UIControlStateNormal];
        addBtn.enabled = NO;
    }else{
        addBtn.enabled = YES;
        [addBtn setImage:[UIImage imageNamed:@"friend_btn_add"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:addBtn];
    
    UIView * lineView        = [[UIView alloc] initWithFrame:CGRectMake(10, 64, [DeviceManager getDeviceWidth], 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];
    
    return cell;
}
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactModel * contact             = self.dataSource[indexPath.row];
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    opvc.uid                           = contact.uid;
    [self pushVC:opvc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark- method response
- (void)addFriend:(CustomButton *)sender
{
    
    ContactModel * contact = self.dataSource[sender.tag];
    [self addFriendCommitWith:contact];
}

#pragma mark- private method
//读取所有联系人

-(void)readAllPeoples
{
 
//    [self showLoading:@"正在读取通讯录*_*"];
    
    self.dataSource                 = [[NSMutableArray alloc] init];
    self.contactDic                 = [[NSMutableDictionary alloc] init];
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook            = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        ALERT_SHOW(StringCommonPrompt, @"联系人读取失败T_T");
        return ;
    };
    
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        if (tmpFirstName == nil) {
            tmpFirstName = @"";
        }
        
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        if (tmpLastName == nil) {
            tmpLastName = @"";
        }
        
        ABRecordID personRecordID = ABRecordGetRecordID((__bridge ABRecordRef)(tmpPerson));
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        //通过ABRecordID属性找到ABRecord
        ABRecordRef personRecord = ABAddressBookGetPersonWithRecordID(addressBook, personRecordID);
        //通过ABRecord 查找多值属性
        ABMultiValueRef emailProperty = ABRecordCopyValue(personRecord, kABPersonPhoneProperty);
        //将多值属性的多个值转化为数组
        NSArray * emailArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(emailProperty));
        for (NSString * numberStr in emailArray) {
            NSString * tmpNumberStr = [numberStr copy];
            tmpNumberStr = [tmpNumberStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            tmpNumberStr = [tmpNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            tmpNumberStr = [tmpNumberStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //是手机号 ok
            if ([ToolsManager validateMobile:tmpNumberStr]) {
                //填入字典
                [self.contactDic setObject:[NSString stringWithFormat:@"%@%@", tmpLastName, tmpFirstName] forKey:tmpNumberStr];
            }
        }
    }
    CFRelease(tmpAddressBook);
    
    [self getContactUser];
}

//获取通讯录用户
- (void)getContactUser
{
    
    [self showLoading:@"数据同步中+_+"];
//    [self.contactDic setObject:@"测试一" forKey:@"13500065922"];
//    [self.contactDic setObject:@"测试二" forKey:@"13244448888"];
    
    NSMutableArray * tmpPhoneArr = [[NSMutableArray alloc] initWithArray:self.contactDic.allKeys];
    NSData * jsonData            = [NSJSONSerialization dataWithJSONObject:tmpPhoneArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr           = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * params        = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"contact":jsonStr};
    
    debugLog(@"%@ %@", kGetContactUserPath, params);
    [HttpService postWithUrlString:kGetContactUserPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        [self hideLoading];
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSArray * list = responseData[HttpResult][HttpList];
            //联系人字典
            for (NSDictionary * contactDic in list) {
                ContactModel * contact = [[ContactModel alloc] init];
                contact.name           = contactDic[@"name"];
                contact.uid            = [contactDic[@"uid"] integerValue];
                contact.phone          = contactDic[@"phone"];
                contact.head_sub_image = contactDic[@"head_sub_image"];
                contact.head_image     = contactDic[@"head_image"];
                contact.is_friend      = [contactDic[@"is_friend"] boolValue];
                [self.dataSource addObject:contact];
            }
            
        }else{
//            [self showWarn:responseData[HttpMessage]];
        }
        
        [self.tableView reloadData];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];

    }];
    
}

//添加好友
- (void)addFriendCommitWith:(ContactModel *)contactModel
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", contactModel.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            //添加好友处理
            IMGroupModel * group = [[IMGroupModel alloc] init];
            group.groupId        = [ToolsManager getCommonGroupId:contactModel.uid];
            group.groupTitle     = contactModel.name;
            group.avatarPath     = contactModel.head_image;
            [FindUtils addFriendWith:group];
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
            contactModel.is_friend = YES;
            
        }else{
            //添加过不能在添加了
            [self showWarn:responseData[HttpMessage]];
        }
        //刷新列表
        [self.tableView reloadData];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

@end
