//
//  RecommendCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RecommendCell.h"
#import "UIImageView+WebCache.h"
@interface RecommendCell()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//学校
@property (nonatomic, strong) CustomLabel * schoolLabel;
//ImageView数组
@property (nonatomic, strong) NSMutableArray * imageViewArr;
//好友模型
@property (nonatomic, strong) RecommendFriendModel * friendModel;
//添加按钮
@property (nonatomic, strong) CustomButton * addBtn;

@end

@implementation RecommendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle                = UITableViewCellSelectionStyleNone;
        self.imageViewArr                  = [[NSMutableArray alloc] init];
        //头像
        self.headImageView                 = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.headImageView.backgroundColor = [UIColor grayColor];

        //昵称
        self.nameLabel                     = [[CustomLabel alloc] initWithFontSize:15];
        self.nameLabel.frame               = CGRectMake(self.headImageView.right+10, self.headImageView.y+5, 200, 20);

        //学校
        self.schoolLabel                   = [[CustomLabel alloc] initWithFontSize:15];
        self.schoolLabel.frame             = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom, 200, 20);

        //添加按钮
        self.addBtn              = [[CustomButton alloc] initWithFontSize:15];
        self.addBtn.frame                       = CGRectMake([DeviceManager getDeviceWidth]-60, 15, 50, 30);
        self.addBtn.backgroundColor             = [UIColor yellowColor];
        [self.addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.addBtn];
    }
    return self;
}

- (void)setContentWithModel:(RecommendFriendModel *)model
{
    self.friendModel = model;
    
    [self.imageViewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageViewArr removeAllObjects];
    
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]]];
    self.nameLabel.text   = model.name;
    self.schoolLabel.text = model.school;
    if (model.typeDic[@"content"] != nil || [model.typeDic[@"content"] length]>0) {
        self.schoolLabel.text = model.typeDic[@"content"];
    }
    
    //图片
    for (int i=0; i<model.imageArr.count; i++) {
        CustomImageView * imageView   = [[CustomImageView alloc] init];
        imageView.contentMode         = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.frame               = CGRectMake(self.headImageView.right+10+80*i, self.headImageView.bottom+5, 70, 70);
        NSURL * url                   = [NSURL URLWithString:[ToolsManager completeUrlStr:model.imageArr[i]]];
        [imageView sd_setImageWithURL:url];
        [self.contentView addSubview:imageView];
        [self.imageViewArr addObject:imageView];
    }
    
    
    //如果已经添加了
    if (model.addFriend == YES) {
        
    }
    
    //如果已经添加了
    if (model.addFriend == YES) {
        self.addBtn.backgroundColor = [UIColor darkGrayColor];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
        self.addBtn.backgroundColor = [UIColor yellowColor];
        [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
    }
    
}

- (void)addFriend:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(addFriendClick:)]) {
        [self.delegate addFriendClick:self.friendModel];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
