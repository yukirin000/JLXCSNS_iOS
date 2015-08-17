//
//  BrowseImageViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BrowseImageViewController.h"
#import "UIImageView+WebCache.h"
#import "BrowseImageView.h"
#import "BrowseImageView.h"
@interface BrowseImageViewController ()

//@property (nonatomic, strong) UIScrollView * backScrollView;

@end

@implementation BrowseImageViewController
{
    DeleteImageBlock _deleteBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [UIColor clearColor];
    
    [self initWidget];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void) initWidget {

    
}

- (void) configUI {
    
    BrowseImageView * browseImageView = [[BrowseImageView alloc] initWithFrame:self.view.bounds];
    browseImageView.urlStr = self.url;
    browseImageView.image = self.image;
    [self.view addSubview:browseImageView];
    
    [self.view sendSubviewToBack:browseImageView];

    if (self.canDelete) {
        __weak typeof(self) sself = self;
        [self.navBar setRightBtnWithContent:@"删除" andBlock:^{
            [sself deleteImage];
        }];
    }

}

//删除图片
- (void)deleteImage
{

    if (_deleteBlock) {
        _deleteBlock(self.num);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//设置删除的block
- (void)setDeleteBlock:(DeleteImageBlock)block
{
    _deleteBlock = [block copy];
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
