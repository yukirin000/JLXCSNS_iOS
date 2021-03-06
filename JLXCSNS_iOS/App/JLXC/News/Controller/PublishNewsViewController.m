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
#import "ZYQAssetPickerController.h"
#import <CoreFoundation/CoreFoundation.h>
@interface PublishNewsViewController ()<ZYQAssetPickerControllerDelegate>

//图片按钮数组
@property (nonatomic, strong) NSMutableArray * imageArr;

@property (strong, nonatomic) PlaceHolderTextView *textView;

@property (strong, nonatomic) CustomButton *addImageBtn;

@property (strong, nonatomic)  CustomButton *locationBtn;

@property (nonatomic ,copy) NSString * location;

//图片宽度
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation PublishNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.location = @"";
    self.imageArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:ColorWhite];

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
    
    [self setNavBarTitle:@"记录点滴"];
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"发布" andBlock:^{
        [sself publishNewClick];
    }];
    [self.navBar.rightBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    [self.navBar.rightBtn setTitleColor:[UIColor colorWithHexString:ColorLightGary] forState:UIControlStateHighlighted];
    
    self.textView.frame              = CGRectMake(kCenterOriginX((self.viewWidth-60)), kNavBarAndStatusHeight+30, self.viewWidth-60, 130);
    self.textView.textColor          = [UIColor colorWithHexString:ColorDeepBlack];
    self.textView.layer.borderWidth  = 1;
    self.textView.layer.borderColor  = [UIColor colorWithHexString:ColorLightGary].CGColor;
    [self.textView setPlaceHolder:@"宣布点儿什么吧 o(*￣▽￣*)o ..."];
    
    //计算宽度
    self.itemWidth         = (self.viewWidth-90)/4.0;
    self.addImageBtn.frame = CGRectMake(30, self.textView.bottom+20, self.itemWidth, self.itemWidth);
    [self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"publish_add_btn"] forState:UIControlStateNormal];
    [self.addImageBtn addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //地理位置按钮
    self.locationBtn.frame               = CGRectMake(25, self.addImageBtn.bottom+20, 140, 25);
    self.locationBtn.titleLabel.font     = [UIFont systemFontOfSize:12];
    self.locationBtn.layer.cornerRadius  = 13;
    self.locationBtn.layer.masksToBounds = YES;
    [self.locationBtn setBackgroundColor:[UIColor colorWithHexString:ColorLightWhite]];
    [self.locationBtn setImage:[UIImage imageNamed:@"location_content_image"] forState:UIControlStateNormal];
    [self.locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.locationBtn setTitle:@"告诉我你在哪里...." forState:UIControlStateNormal];
    [self.locationBtn setTitleColor:[UIColor colorWithHexString:ColorLightBlack] forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage * image = [ImageHelper getBigImage:tempImg];
        [self handleImage:image];
    }
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage * image = [ImageHelper getBigImage:info[UIImagePickerControllerOriginalImage]];
    [self handleImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_back_image"] forBarMetrics:UIBarMetricsDefault];
//    [navigationController.navigationBar setTintColor:[UIColor colorWithHexString:ColorBrown]];
//}
#pragma mark- Action Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex != 2) {
        
        if (buttonIndex == 1) {
            
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection  = 9-self.imageArr.count;
            picker.assetsFilter              = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups           = NO;
            picker.delegate                  = self;
            picker.selectionFilter           = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
        if (buttonIndex == 0) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            picker.delegate = self;
            
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        
    }
    
}

#pragma mark- method response
- (void)addImageClick:(id)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"图片" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
    [sheet showInView:self.view];
}

- (void)locationClick:(id)sender {
    ChoiceLocationViewController * clvc = [[ChoiceLocationViewController alloc] init];
    [clvc setChoickBlock:^(NSString *str) {
        if (str.length < 1) {
            [self.locationBtn setTitle:@"告诉我你在哪里...." forState:UIControlStateNormal];
            self.locationBtn.width = 140;
            return ;
        }
        CGSize size = [ToolsManager getSizeWithContent:str andFontSize:12 andFrame:CGRectMake(0, 0, 250, 30)];
        if (size.width < 110) {
            size.width = 110;
        }
        self.locationBtn.width = 30+size.width;
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
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"content_text":self.textView.text,
                              @"location":self.location};
    //如果是发到圈子里的
    if (self.topicID > 0) {
        params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                                  @"content_text":self.textView.text,
                                  @"location":self.location,
                                  @"topic_id":[NSString stringWithFormat:@"%ld", self.topicID]};
    }
    
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
            [files addObject:@{FileDataKey:UIImageJPEGRepresentation(image, 0.9),FileNameKey:fileName}];
        }
    }
    
    debugLog(@"%@", kPublishNewsPath);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kPublishNewsPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [self hideLoading];
            //缓存图片 没有返回路径缓存无效 以后处理
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
    
    self.addImageBtn.frame = CGRectMake(30+(self.itemWidth+10)*columnNum, self.textView.bottom+20+(self.itemWidth+10)*lineNum, self.itemWidth, self.itemWidth);

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
    self.addImageBtn.frame  = CGRectMake(30, self.textView.bottom+20, self.itemWidth, self.itemWidth);
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
