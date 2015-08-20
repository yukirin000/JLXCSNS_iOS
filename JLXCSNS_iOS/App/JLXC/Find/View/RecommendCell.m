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
//描述
@property (nonatomic, strong) CustomLabel * descLabel;
//ImageView数组
@property (nonatomic, strong) NSMutableArray * imageViewArr;
//好友模型
@property (nonatomic, strong) RecommendFriendModel * friendModel;
//添加按钮
@property (nonatomic, strong) CustomButton * addBtn;
//底部线
@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation RecommendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageViewArr   = [[NSMutableArray alloc] init];
        //头像
        self.headImageView  = [[CustomImageView alloc] init];
        //昵称
        self.nameLabel      = [[CustomLabel alloc] init];
        //学校
        self.schoolLabel    = [[CustomLabel alloc] init];
        //描述
        self.descLabel      = [[CustomLabel alloc] init];
        //添加按钮
        self.addBtn         = [[CustomButton alloc] init];
        //底部线
        self.bottomLineView = [[UIView alloc] init];
        
        [self.addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.bottomLineView];
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.headImageView.frame               = CGRectMake(10, 10, 50, 50);
    self.nameLabel.frame                   = CGRectMake(self.headImageView.right+10, self.headImageView.y+1, 200, 20);
    self.descLabel.frame                   = CGRectMake(0, self.nameLabel.y, 150, self.nameLabel.height);
    CustomImageView * schoolImageView      = [[CustomImageView alloc] init];
    schoolImageView.frame                  = CGRectMake(self.headImageView.right+10, self.nameLabel.bottom+10, 15, 15);
    schoolImageView.image                  = [UIImage imageNamed:@"school_icon"];
    [self.contentView addSubview:schoolImageView];
    self.schoolLabel.frame                 = CGRectMake(schoolImageView.right+3, schoolImageView.y-1, 200, 17);
    self.addBtn.frame                      = CGRectMake([DeviceManager getDeviceWidth]-65, 17, 50, 23);

    self.bottomLineView.frame              = CGRectMake(0, 70, [DeviceManager getDeviceWidth], 10);
    
    self.headImageView.layer.cornerRadius  = 2;
    self.headImageView.layer.masksToBounds = YES;
    self.nameLabel.font                    = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor               = [UIColor colorWithHexString:ColorDeepBlack];
    self.descLabel.font                    = [UIFont systemFontOfSize:11];
    self.descLabel.textColor               = [UIColor colorWithHexString:ColorFlesh];
    self.schoolLabel.font                  = [UIFont systemFontOfSize:13];
    self.schoolLabel.textColor             = [UIColor colorWithHexString:ColorGary];
    self.bottomLineView.backgroundColor    = [UIColor colorWithHexString:ColorLightWhite];
    
}

- (void)setContentWithModel:(RecommendFriendModel *)model
{
    self.friendModel = model;
    
    [self.imageViewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageViewArr removeAllObjects];
    
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:model.head_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    self.nameLabel.text   = model.name;
    self.schoolLabel.text = model.school;
    if (model.typeDic[@"content"] != nil && [model.typeDic[@"content"] length]>0) {
        
        CGSize nameSize      = [ToolsManager getSizeWithContent:model.name andFontSize:15 andFrame:CGRectMake(0, 0, 200, 30)];
        self.nameLabel.width = nameSize.width;
        self.descLabel.x     = self.nameLabel.right;
        NSString * content   = [NSString stringWithFormat:@" %@", model.typeDic[@"content"]];
        self.descLabel.text  = content;
    }
    
    CGFloat itemWidth = [DeviceManager getDeviceWidth]/4.5;
    //图片
    for (int i=0; i<model.imageArr.count; i++) {
        CustomImageView * imageView   = [[CustomImageView alloc] init];
        imageView.contentMode         = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.frame               = CGRectMake(self.headImageView.right+10+(itemWidth+10)*i, self.headImageView.bottom+5, itemWidth, itemWidth);
        NSURL * url                   = [NSURL URLWithString:[ToolsManager completeUrlStr:model.imageArr[i]]];
        [imageView sd_setImageWithURL:url];
        [self.contentView addSubview:imageView];
        [self.imageViewArr addObject:imageView];
    }
    if (model.imageArr.count > 0) {
        self.bottomLineView.y = 75+itemWidth;
    }
    //如果已经添加了
    if (model.addFriend == YES) {
        [self.addBtn setImage:[UIImage imageNamed:@"friend_btn_isadd"] forState:UIControlStateNormal];
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
        [self.addBtn setImage:[UIImage imageNamed:@"friend_btn_add"] forState:UIControlStateNormal];
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
