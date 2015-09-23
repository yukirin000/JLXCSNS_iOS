//
//  CreateTopicViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CreateTopicViewController.h"
#import "TopicCategoryModel.h"
@interface CreateTopicViewController ()

//封面
@property (nonatomic, strong) CustomImageView * topicImageView;
//封面上的提示label
@property (nonatomic, strong) CustomLabel * coverLabel;

//名
@property (nonatomic, strong) UITextField * topicNameTextField;

//内容
@property (nonatomic, strong) PlaceHolderTextView * descTextView;

//类别label
@property (nonatomic, strong) CustomLabel * categoryLabel;

//类别数组
@property (nonatomic, strong) NSMutableArray * categoryList;

//当前的类别
@property (nonatomic, strong) TopicCategoryModel * currentCategoryModel;

@end

@implementation CreateTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.topicImageView     = [[CustomImageView alloc] init];
    self.topicNameTextField = [[UITextField alloc] init];
    self.descTextView       = [[PlaceHolderTextView alloc] init];
    self.categoryLabel      = [[CustomLabel alloc] init];
    self.coverLabel         = [[CustomLabel alloc] init];
    
    [self.topicImageView addSubview:self.coverLabel];
    [self.view addSubview:self.topicImageView];
    [self.view addSubview:self.topicNameTextField];
    [self.view addSubview:self.descTextView];
    [self.view addSubview:self.categoryLabel];
    
    //选择图片手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicImageTap:)];
    [self.topicImageView addGestureRecognizer:tap];
    //选择类别
    UITapGestureRecognizer * categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryTap:)];
    [self.categoryLabel addGestureRecognizer:categoryTap];
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"完成" andBlock:^{
        [sself createTopic];
    }];
}

- (void)configUI
{
    
    [self setNavBarTitle:@"创建一个新频道"];
    [self.navBar.rightBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    //图片
    self.topicImageView.frame                  = CGRectMake(kCenterOriginX(100), kNavBarAndStatusHeight+40, 100, 100);
    self.topicImageView.backgroundColor        = [UIColor colorWithHexString:ColorGary];
    self.topicImageView.userInteractionEnabled = YES;
    self.topicImageView.layer.masksToBounds    = YES;
    self.topicImageView.contentMode            = UIViewContentModeScaleAspectFill;
    
    self.coverLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    self.coverLabel.frame           = CGRectMake(0, 70, 100, 30);
    self.coverLabel.font            = [UIFont systemFontOfSize:13];
    self.coverLabel.textAlignment   = NSTextAlignmentCenter;
    self.coverLabel.text            = @"选择封面";
    self.coverLabel.textColor       = [UIColor colorWithHexString:ColorWhite];
    
    //名字
    self.topicNameTextField.frame                 = CGRectMake(kCenterOriginX((self.viewWidth-100)), self.topicImageView.bottom+20, self.viewWidth-100, 30);
    self.topicNameTextField.backgroundColor       = [UIColor colorWithHexString:ColorGary];
    self.topicNameTextField.font                  = [UIFont systemFontOfSize:14];
    self.topicNameTextField.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    NSAttributedString * placeStr                 = [[NSAttributedString alloc] initWithString:@"请输入频道名称" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:ColorLightBlack]}];
    self.topicNameTextField.attributedPlaceholder = placeStr;
    //内容
    self.descTextView.frame                      = CGRectMake(kCenterOriginX((self.viewWidth-100)), self.topicNameTextField.bottom+30, self.viewWidth-100, 100);
    self.descTextView.font                       = [UIFont systemFontOfSize:14];
    self.descTextView.textColor                  = [UIColor colorWithHexString:ColorDeepBlack];
    self.descTextView.backgroundColor            = [UIColor colorWithHexString:ColorGary];
    [self.descTextView setPlaceHolder:@"输入简短的介绍或玩法..."];
    self.descTextView.placeHolderLabel.textColor = [UIColor colorWithHexString:ColorLightBlack];
    //类别
    self.categoryLabel.frame                  = CGRectMake(kCenterOriginX((self.viewWidth-100)), self.descTextView.bottom+30, self.viewWidth-100, 30);
    self.categoryLabel.userInteractionEnabled = YES;
    self.categoryLabel.text                   = @"  选择类别";
    self.categoryLabel.backgroundColor        = [UIColor colorWithHexString:ColorGary];
    self.categoryLabel.font                   = [UIFont systemFontOfSize:14];
    self.categoryLabel.textColor              = [UIColor colorWithHexString:ColorDeepBlack];
    
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex != 2) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
        if (buttonIndex == 1) {
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image           = [ImageHelper getBigImage:info[UIImagePickerControllerOriginalImage]];
    self.coverLabel.hidden    = YES;
    self.topicImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        self.currentCategoryModel = self.categoryList[buttonIndex-1];
        self.categoryLabel.text   = [@"  " stringByAppendingString:self.currentCategoryModel.category_name];
    }
}

#pragma mark- method response
- (void)topicImageTap:(UITapGestureRecognizer *)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [sheet showInView:self.view];
}
//类别点击
- (void)categoryTap:(UITapGestureRecognizer *)sender
{
    //存在显示 不存在请求
    if (self.categoryList.count > 0) {
        [self showCategoryList];
    }else{
        if (self.categoryList == nil) {
            self.categoryList = [[NSMutableArray alloc] init];
        }
        [self showLoading:@""];
        [HttpService getWithUrlString:kGetTopicCategoryPath andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
            [self hideLoading];
            NSInteger state = [responseData[HttpStatus] integerValue];
            if (state == HttpStatusCodeSuccess) {
                NSArray * categorys = responseData[HttpResult][HttpList];
                for (NSDictionary * dic in categorys) {
                    TopicCategoryModel * topic = [[TopicCategoryModel alloc] init];
                    topic.category_id          = [dic[@"category_id"] integerValue];
                    topic.category_name        = dic[@"category_name"];
                    topic.category_desc        = dic[@"category_desc"];
                    topic.category_cover       = dic[@"category_cover"];
                    [self.categoryList addObject:topic];
                }
                [self showCategoryList];
            }else{
                [self showWarn:responseData[HttpMessage]];
            }
            
        } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showWarn:StringCommonNetException];
        }];
    }
}

#pragma mark- private method
- (void)createTopic
{
    if (self.topicImageView.image == nil) {
        [self showWarn:@"封面怎么可以没有 ∪︿∪"];
        return;
    }
    if (self.topicNameTextField.text.length < 1) {
        [self showWarn:@"标题怎么可以没有 ∪︿∪"];
        return;
    }
    if (self.topicNameTextField.text.length > 16) {
        [self showWarn:@"题不能超过16个字 ∪︿∪"];
        return;
    }
    if (self.descTextView.text.length < 26) {
        [self showWarn:@"描述不能少于26个字 ∪︿∪"];
        return;
    }
    if (self.descTextView.text.length > 200) {
        [self showWarn:@"描述不能超过200个字 ∪︿∪"];
        return;
    }
    if (self.currentCategoryModel == nil) {
        [self showWarn:@"类型还没选呢 ∪︿∪"];
        return;
    }
    
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"topic_name":[self.topicNameTextField.text trim],
                              @"topic_desc":self.descTextView.text,
                              @"category_id":[NSString stringWithFormat:@"%ld", self.currentCategoryModel.category_id]};
    
    NSString * fileName = [ToolsManager getUploadImageName];
    NSArray * files = @[@{FileDataKey:UIImageJPEGRepresentation(self.topicImageView.image, 0.9),FileNameKey:fileName}];

    [self showLoading:@"创建中..."];
    [HttpService postFileWithUrlString:kPostNewTopicPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
    
}

- (void)showCategoryList
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"选择类别" message:@"" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:nil, nil];
    for (TopicCategoryModel * topic in self.categoryList) {
        [alert addButtonWithTitle:topic.category_name];
    }
    [alert show];
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.topicNameTextField resignFirstResponder];
    [self.descTextView resignFirstResponder];
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
