//
//  ChatRoomMemberCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomMemberCell.h"
#import "UIImageView+WebCache.h"
@interface ChatRoomMemberCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;

//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;

//学校
@property (nonatomic, strong) CustomLabel * schoolLabel;
//红线
@property (nonatomic, strong) UIView * redLineView;
//删除按钮提示
@property (nonatomic, strong) CustomLabel * deleteLabel;
//删除红叉
@property (nonatomic, strong) CustomImageView * deleteForkImageView;

@property (nonatomic, strong) ChatRoomPersonalModel *model;

@end

@implementation ChatRoomMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //头像
        self.headImageView                       = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
        //删除红叉
        self.deleteForkImageView                 = [[CustomImageView alloc] initWithFrame:CGRectMake(self.headImageView.width-20, 0, 20, 20)];
        self.deleteForkImageView.backgroundColor = [UIColor redColor];
        self.deleteForkImageView.hidden = YES;
        //名字
        self.nameLabel                           = [[CustomLabel alloc] initWithFrame:CGRectMake(self.headImageView.right+5, 10, 80, 20)];
        //学校
        self.schoolLabel                         = [[CustomLabel alloc] initWithFrame:CGRectMake(self.headImageView.right+5, self.nameLabel.bottom+5, 80, 20)];
        self.redLineView                         = [[UIView alloc] initWithFrame:CGRectMake(5, 28, 50, 5)];
        self.redLineView.backgroundColor         = [UIColor redColor];
        self.redLineView.hidden                  = YES;
        //删除按钮提示
        self.deleteLabel                         = [[CustomLabel alloc] initWithFrame:CGRectMake(self.redLineView.right+5, 20, 80, 20)];
        self.deleteLabel.text                    = @"删除成员";
        self.deleteLabel.hidden                  = YES;
        
        [self.headImageView addSubview:self.deleteForkImageView];
        [self.contentView addSubview:self.deleteLabel];
        [self.contentView addSubview:self.redLineView];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.schoolLabel];
        
        //是否是删除状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMemberMode:) name:NOTIFY_DELETE_MEMBER object:nil];
    }
    return self;
}

- (void)setContentWithModel:(ChatRoomPersonalModel *)model
{
    
    self.model = model;
    
    if (model.isDeleteCell) {
        
        self.redLineView.hidden   = NO;
        self.deleteLabel.hidden   = NO;
        self.headImageView.hidden = YES;
        self.nameLabel.hidden     = YES;
        self.schoolLabel.hidden   = YES;
        return;
        
    }else{
        self.redLineView.hidden   = YES;
        self.deleteLabel.hidden   = YES;
        self.headImageView.hidden = NO;
        self.nameLabel.hidden     = NO;
        self.schoolLabel.hidden   = NO;
    }
    
    NSURL * url                     = [NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
    self.nameLabel.text                  = model.name;
    self.schoolLabel.text                = model.school;
}

- (void)setIsDelete:(BOOL)isDelete
{
    if (isDelete) {
        self.redLineView.backgroundColor = [UIColor blueColor];
    }else{
        self.redLineView.backgroundColor = [UIColor redColor];
    }
}

- (void)deleteMemberMode:(NSNotification *)notify
{
    if (self.model.isDeleteCell) {
        return;
    }
    
    if ([notify.object boolValue]) {
        self.deleteForkImageView.hidden = NO;
    }else{
        self.deleteForkImageView.hidden = YES;
    }
    
}

@end
