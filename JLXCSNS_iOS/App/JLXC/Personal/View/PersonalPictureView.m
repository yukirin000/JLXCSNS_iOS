//
//  PersonalPictureView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PersonalPictureView.h"
#import "UIImageView+WebCache.h"
#import "BrowseImageListViewController.h"
#import "ImageModel.h"
//暂定用10张imageView简单处理
@interface PersonalPictureView()

@property (nonatomic, strong) UIScrollView * backScrollView;

@property (nonatomic, strong) CustomImageView * imageView1;
@property (nonatomic, strong) CustomImageView * imageView2;
@property (nonatomic, strong) CustomImageView * imageView3;
@property (nonatomic, strong) CustomImageView * imageView4;
@property (nonatomic, strong) CustomImageView * imageView5;
@property (nonatomic, strong) CustomImageView * imageView6;
@property (nonatomic, strong) CustomImageView * imageView7;
@property (nonatomic, strong) CustomImageView * imageView8;
@property (nonatomic, strong) CustomImageView * imageView9;
@property (nonatomic, strong) CustomImageView * imageView10;

@property (nonatomic, strong) NSArray * imageViewList;
@property (nonatomic, strong) NSMutableArray * imageList;

@end

@implementation PersonalPictureView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWidget];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWidget];
    }
    return self;
}
#pragma mark- layout
- (void)initWidget
{
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth], 70)];
    [self addSubview:self.backScrollView];
    
    self.imageView1  = [[CustomImageView alloc] init];
    self.imageView2  = [[CustomImageView alloc] init];
    self.imageView3  = [[CustomImageView alloc] init];
    self.imageView4  = [[CustomImageView alloc] init];
    self.imageView5  = [[CustomImageView alloc] init];
    self.imageView6  = [[CustomImageView alloc] init];
    self.imageView7  = [[CustomImageView alloc] init];
    self.imageView8  = [[CustomImageView alloc] init];
    self.imageView9  = [[CustomImageView alloc] init];
    self.imageView10 = [[CustomImageView alloc] init];
    
    self.imageViewList = @[self.imageView1, self.imageView2, self.imageView3, self.imageView4, self.imageView5, self.imageView6, self.imageView7, self.imageView8, self.imageView9, self.imageView10];
    self.imageList     = [[NSMutableArray alloc] init];
    [self configUI];
}
//布局
- (void)configUI
{
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<self.imageViewList.count; i++) {
        CustomImageView * imageView      = self.imageViewList[i];
        imageView.frame                  = CGRectMake(5+i*65, 5, 60, 60);
        imageView.tag                    = i;
        imageView.contentMode            = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds    = YES;
        imageView.userInteractionEnabled = YES;
        imageView.hidden                 = YES;
        [self.backScrollView addSubview:imageView];

        UITapGestureRecognizer * tap     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
    }
    
}

#pragma mark- public method
- (void)setImageWithList:(NSArray *)imageList
{
    [self.imageList removeAllObjects];
    [self.imageList addObjectsFromArray:imageList];
    
    for (CustomImageView * imageView in self.imageViewList) {
        imageView.hidden = YES;
    }
    
    NSInteger count = imageList.count;
    if (count > 10) {
        count = 10;
    }
    
    for (int i=0; i<count; i++) {
        CustomImageView * imageView = self.imageViewList[i];
        ImageModel * image             = imageList[i];
        imageView.hidden            = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:image.sub_url]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        self.backScrollView.contentSize = CGSizeMake(imageView.right+10, 0);
    }
}

#pragma mark- private method
- (void)imageTap:(UITapGestureRecognizer *)tap
{
    
    BrowseImageListViewController * bilvc = [[BrowseImageListViewController alloc] init];
    bilvc.num                             = tap.view.tag;
    bilvc.dataSource                      = self.imageList;
    [self.personalVC presentViewController:bilvc animated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
