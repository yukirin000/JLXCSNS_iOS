//
//  OtherPersonalViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherPersonalViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger uid;

@end