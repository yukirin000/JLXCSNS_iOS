//
//  ChatRoomCell.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomCell.h"
#import "UIImageView+WebCache.h"
@interface ChatRoomCell()

//背景图片
@property (nonatomic, strong) CustomImageView * backImageView;
//标题
@property (nonatomic, strong) CustomLabel * titleLabel;
//剩余时间
@property (nonatomic, strong) CustomLabel * leftTimeLabel;
//人数情况
@property (nonatomic, strong) CustomLabel * memberLabel;
//标签label数组
@property (nonatomic, strong) NSMutableArray * tagLabelArr;

@property (nonatomic, strong) ChatRoomModel * chatroomModel;

//倒计时计时器
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation ChatRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle              = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        self.tagLabelArr                 = [[NSMutableArray alloc] init];
        self.backImageView               = [[CustomImageView alloc] init];
        self.titleLabel                  = [[CustomLabel alloc] initWithFontSize:17];
        self.memberLabel                 = [[CustomLabel alloc] initWithFontSize:15];
        self.leftTimeLabel               = [[CustomLabel alloc] initWithFontSize:15];
        
        [self.contentView addSubview:self.backImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftTimeLabel];
        [self.contentView addSubview:self.memberLabel];
        
        [self configUI];
        
        //计时器初始化
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(leftTimer) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)configUI
{
    self.backImageView.frame         = CGRectMake(5, 5, [DeviceManager getDeviceWidth]-10, 90);
    self.titleLabel.frame            = CGRectMake(kCenterOriginX(300), 40, 300, 20);
    self.titleLabel.textAlignment    = NSTextAlignmentCenter;
    self.memberLabel.frame           = CGRectMake(self.backImageView.right-80, self.backImageView.y+10, 70, 20);
    self.memberLabel.backgroundColor = [UIColor grayColor];
    self.memberLabel.textAlignment   = NSTextAlignmentRight;
    self.leftTimeLabel.frame         = CGRectMake(kCenterOriginX(300), self.backImageView.y+5, 300, 20);
    self.leftTimeLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setContentWithModel:(ChatRoomModel *)model
{
    self.chatroomModel = model;
    
    NSURL * url = [NSURL URLWithString:[ToolsManager completeUrlStr:model.chatroom_background]];
    [self.backImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
    self.titleLabel.text = model.chatroom_title;
    
    //清除原有label
    for (CustomLabel * label in self.tagLabelArr) {
        [label removeFromSuperview];
    }
    [self.tagLabelArr removeAllObjects];
    
    //增加新label
    for (int i=0; i<model.tagArr.count; i++) {
        NSString * tagStr = model.tagArr[i];
        //标签
        CustomLabel * tagLabel          = [[CustomLabel alloc] initWithFontSize:FONT_SIZE_TAG];
        tagLabel.userInteractionEnabled = YES;
        tagLabel.backgroundColor        = [UIColor darkGrayColor];
        tagLabel.textColor              = [UIColor blackColor];
        tagLabel.text                   = tagStr;
        
        //设置位置
        CGSize size = [ToolsManager getSizeWithContent:tagLabel.text andFontSize:FONT_SIZE_TAG andFrame:CGRectMake(0, 0, 100, 20)];
        if (i == 0) {
            tagLabel.frame = CGRectMake(5, self.backImageView.height-30, size.width, 20);
        }else{
            CustomLabel * previousLabel = self.tagLabelArr[i-1];
            tagLabel.frame = CGRectMake(previousLabel.right+5, previousLabel.y, size.width, 20);
        }
        
        [self.backImageView addSubview:tagLabel];
        [self.tagLabelArr addObject:tagLabel];
    }
    
    //成员数量
    self.memberLabel.text = [NSString stringWithFormat:@"%ld/%ld", model.current_quantity, model.max_quantity];
    //处理时间
    [self handleTime:model];
    
}
//处理时间
- (void)handleTime:(ChatRoomModel *)model
{
    if (model == nil) {
        return;
    }

    NSInteger currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSInteger leftTimeInterval = model.chatroom_create_time.integerValue+model.chatroom_duration.integerValue-currentTimeInterval;
    NSInteger hour = leftTimeInterval/3600;
    NSInteger minute = leftTimeInterval/60;
    NSString * timeTitle;
    if (hour > 0) {
        timeTitle = [NSString stringWithFormat:@"剩余%ld小时",hour];
        //当前时间
        self.leftTimeLabel.text = timeTitle;
    }else if (minute > 0) {
        timeTitle = [NSString stringWithFormat:@"剩余%ld分钟",minute];
        self.leftTimeLabel.text = timeTitle;
    }else{
        if (leftTimeInterval>0) {
            timeTitle = [NSString stringWithFormat:@"剩余%ld秒",leftTimeInterval];
        }else{
            timeTitle = @"聊天室已经到期辣~";
            [self.timer invalidate];
        }
        
        self.leftTimeLabel.text = timeTitle;
        
    }
    
}

- (void)leftTimer
{
    [self handleTime:self.chatroomModel];
}


@end
