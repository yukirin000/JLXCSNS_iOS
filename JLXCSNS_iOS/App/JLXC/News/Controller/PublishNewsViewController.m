//
//  PublishNewsViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PublishNewsViewController.h"
#import "BrowseImageViewController.h"
#import "ChoiceLocationViewController.h"
#import "UIImageView+WebCache.h"
#import "ImageFilterViewController.h"
@interface PublishNewsViewController ()<TuSDKPFEditFilterControllerDelegate,TuSDKPFCameraDelegate>

//图片按钮数组
@property (nonatomic, strong) NSMutableArray * imageArr;

@property (strong, nonatomic) PlaceHolderTextView *textView;

@property (strong, nonatomic) CustomButton *addImageBtn;

@property (strong, nonatomic)  CustomButton *locationBtn;

@property (nonatomic ,copy) NSString * location;

@end

@implementation PublishNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.location = @"";
    self.imageArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor grayColor];
    //24 76 272 100
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
    self.addImageBtn = [[CustomButton alloc] init];
    self.locationBtn = [[CustomButton alloc] init];
    self.textView    = [[PlaceHolderTextView alloc] init];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.locationBtn];
    [self.view addSubview:self.addImageBtn];
}

- (void)configUI {
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"发布" andBlock:^{
        [sself publishNewClick];
    }];
    
    self.textView.frame              = CGRectMake(24, 76, 272, 100);
    
    self.addImageBtn.frame           = CGRectMake(20, self.textView.bottom+20, 55, 55);
    self.addImageBtn.backgroundColor = [UIColor yellowColor];
    [self.addImageBtn setTitle:@"图片" forState:UIControlStateNormal];
    [self.addImageBtn addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationBtn.frame           = CGRectMake(25, self.addImageBtn.bottom+20, 100, 25);
    [self.locationBtn setTitle:@"选择地理位置" forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark- TuSDKPFEditFilterControllerDelegate
//图片渲染结束
- (void)onTuSDKPFEditFilter:(TuSDKPFEditFilterController *)controller result:(TuSDKResult *)result
{
    
    UIImage * image = [ImageHelper getBigImage:result.image];
    [self handleImage:image];

}
/**
 *  获取组件返回错误信息
 *
 *  @param controller 控制器
 *  @param result     返回结果
 *  @param error      异常信息
 */
- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error
{
    lsqLDebug(@"onComponent: controller - %@, result - %@, error - %@", controller, result, error);
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    ImageFilterViewController * ifVC = [[ImageFilterViewController alloc] init];
    ifVC.delegate                    = self;
    ifVC.inputImage                  = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:ifVC animated:YES completion:nil];
    }];
    
//    UIImage * image = [ImageHelper getBigImage:info[UIImagePickerControllerOriginalImage]];
//    [self handleImage:image];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
- (void)showCameraController;
{
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFCameraOptions.html
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 是否保存最后一次使用的滤镜
    opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    opt.autoSelectGroupDefaultFilter = YES;
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 开启持续自动对焦 (默认: NO)
    opt.enableContinueFoucs = YES;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = RGB(51, 51, 51);
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    UIImage * image = [ImageHelper getBigImage:result.image];
    [self handleImage:image];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark- Action Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex != 2) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {
            
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self showCameraController];
                return;
            }
        }
        
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
}

#pragma mark- method response
- (void)addImageClick:(id)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"图片" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [sheet showInView:self.view];
}

- (void)locationClick:(id)sender {
    ChoiceLocationViewController * clvc = [[ChoiceLocationViewController alloc] init];
    [clvc setChoickBlock:^(NSString *str) {
        [self.locationBtn setTitle:str forState:UIControlStateNormal];
        self.location = str;
    }];
    [self pushVC:clvc];
}

//图片查看大图
- (void)bigImageClick:(UITapGestureRecognizer *)ges
{
    BrowseImageViewController * bivc = [[BrowseImageViewController alloc] init];
    bivc.canDelete                   = YES;
    bivc.image                       = ((CustomImageView *)ges.view).image;
    bivc.num                         = [self.imageArr indexOfObject:ges.view];
    __weak typeof(self) sself        = self;
    [bivc setDeleteBlock:^(NSInteger num) {
        [sself deleteImageWithNum:num];
    }];
    [self pushVC:bivc];
    
}

//发表状态
- (void)publishNewClick
{
    if (self.textView.text.length < 1 && self.imageArr.count < 1) {
        ALERT_SHOW(StringCommonPrompt, @"内容和图片至少有一个不能为空=_=");
        return;
    }
    
    if (self.textView.text.length > 140) {
        ALERT_SHOW(StringCommonPrompt, @"内容不能超过140字=_=");
        return;
    }
    
    //[NSString stringWithFormat:@"%d", [UserService sharedService].user.uid]
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"content_text":self.textView.text,
                              @"location":self.location};
    NSMutableArray * files = [[NSMutableArray alloc] init];
    
    //头像处理
    int timeInterval = [NSDate date].timeIntervalSince1970;
    //图片数组处理
    if (self.imageArr.count > 0) {
        for (CustomImageView * imageView in self.imageArr) {
            NSString * fileName = [NSString stringWithFormat:@"%ld%d.png", [UserService sharedService].user.uid, timeInterval++];
            UIImage * image = [ImageHelper getBigImage:imageView.image];
//            NSString * fileName = [ToolsManager getUploadImageName];
//            [files addObject:@{FileDataKey:UIImagePNGRepresentation(image),FileNameKey:fileName}];
            [files addObject:@{FileDataKey:UIImageJPEGRepresentation(image, 0.8),FileNameKey:fileName}];
        }
    }
    
    debugLog(@"%@", kPublishNewsPath);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kPublishNewsPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [self hideLoading];
            //缓存图片 没有返回路径缓存无效
//            [self cacheImageWithFiles:files andResultUrls:responseData[HttpResult]];
            [self.navigationController popViewControllerAnimated:YES];
            //发送发送成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PUBLISH_NEWS object:nil];
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

#pragma mark- private Method
//处理图片
- (void)handleImage:(UIImage *)image
{
    
    CustomImageView * imageView = [[CustomImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageClick:)];
    [imageView addGestureRecognizer:tap];
    imageView.contentMode    = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    [self.view addSubview:imageView];
    
    [self moveImageView:imageView];
}

//修改btn的位置
- (void)moveImageView:(CustomImageView *)imageView
{
    [self.imageArr addObject:imageView];
    imageView.frame        = self.addImageBtn.frame;
    NSInteger columnNum    = self.imageArr.count%4;
    NSInteger lineNum      = self.imageArr.count/4;
    self.addImageBtn.frame = CGRectMake(20+75*columnNum, self.textView.bottom+20+65*lineNum, 55, 55);
    [self.locationBtn setY:self.addImageBtn.bottom+20];
    
    if (self.imageArr.count >= 9) {
        self.addImageBtn.hidden = YES;
    }else{
        self.addImageBtn.hidden = NO;
    }
}

//上传成功后缓存图片
- (void)cacheImageWithFiles:(NSArray *)files andResultUrls:(NSDictionary *)results
{

    for (int i=0; i<files.count; i++) {
        NSDictionary * filesDic = files[i];
        NSString * imagePath    = results[filesDic[FileNameKey]];
        NSURL * imageurl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, imagePath]];
        //缓存图片
        UIImage * image         = [UIImage imageWithData:filesDic[FileDataKey]];
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageurl];
    }

}

//删除图片
- (void)deleteImageWithNum:(NSInteger)num
{
    //删除该iv
    CustomImageView * deleteImageView = self.imageArr[num];
    [self.imageArr removeObject:deleteImageView];
    [deleteImageView removeFromSuperview];
    
    //重新排位
    NSArray * fileArr = [self.imageArr copy];
    [self.imageArr removeAllObjects];
    self.addImageBtn.frame  = CGRectMake(20, self.textView.bottom+20, 55, 55);
    for (CustomImageView * imageView in fileArr) {
        [self moveImageView:imageView];
    }
    
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.textView resignFirstResponder];
}


@end
