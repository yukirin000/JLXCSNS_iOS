//
//  InformationChangeViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "InformationChangeViewController.h"

@interface InformationChangeViewController ()

@property (nonatomic, strong) CustomTextField * nameTextFiled;
@property (nonatomic, strong) PlaceHolderTextView * signTextView;

@end

@implementation InformationChangeViewController
{
    ChangeBlock _changeBlock;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0姓名 1签名
    if (self.changeType == 0) {
        //姓名
        [self createNameUI];
    }else{
        //签名
        [self createSignUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createNameUI
{
    __block typeof(_changeBlock) ccblock = _changeBlock;
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:StringCommonSave andBlock:^{
        
        if (sself.nameTextFiled.text.length < 1) {
            [sself showWarn:@"昵称不能为空"];
            return ;
        }
        if (sself.signTextView.text.length>8) {
            [sself showWarn:@"昵称不能超过八个字"];
            return ;
        }
        
        if (ccblock) {
            ccblock(sself.nameTextFiled.text);
        }
        [sself.navigationController popViewControllerAnimated:YES];
    }];
    
    self.nameTextFiled             = [[CustomTextField alloc] initWithFrame:CGRectMake(kCenterOriginX(300), kNavBarAndStatusHeight+20, 300, 30)];
    self.nameTextFiled.text        = self.content;
    self.nameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextFiled.placeholder = @"请输入姓名";
    [self.view addSubview:self.nameTextFiled];
}

- (void)createSignUI
{
    __block typeof(_changeBlock) ccblock = _changeBlock;
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:StringCommonSave andBlock:^{
        
        if (sself.signTextView.text.length > 60) {
            [sself showWarn:@"签名不能超过60字╮(╯_╰)╭"];
            return ;
        }
        
        if (ccblock) {
            ccblock(sself.signTextView.text);
        }
        [sself.navigationController popViewControllerAnimated:YES];
    }];
    self.signTextView             = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(kCenterOriginX(300), kNavBarAndStatusHeight+20, 300, 30) andPlaceHolder:@"在这里写签名~"];
    self.signTextView.text        = self.content;
    self.signTextView.delegate    = self;
    [self.view addSubview:self.signTextView];
}

#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{

    if ([textView isKindOfClass:[PlaceHolderTextView class]]) {

        if (textView.text.length > 0) {
            [((PlaceHolderTextView *)textView) setPlaceHidden:YES];
        }else{
            [((PlaceHolderTextView *)textView) setPlaceHidden:NO];
        }
    }

}

#pragma mark- private method
- (void)setChangeBlock:(ChangeBlock)block
{
    _changeBlock = [block copy];
}

#pragma mark- override
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextFiled resignFirstResponder];
    [self.signTextView resignFirstResponder];
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
