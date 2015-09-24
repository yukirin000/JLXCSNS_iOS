//
//  TopicCategoryView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicCategoryView.h"
#import "TopicCategoryModel.h"

@interface TopicCategoryView()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;
//色值
@property (nonatomic, strong) NSArray * colorList;

@end

@implementation TopicCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorList         = @[@"FF9966", @"FFcc66", @"b6b6b6", @"99ccFF", @"61a8dd", @"43ba8f", @"ffcc99"];
        
        self.tableView                = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate       = self;
        self.tableView.dataSource     = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.row < self.colorList.count) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:self.colorList[indexPath.row]];
    }
    TopicCategoryModel * category = self.dataSource[indexPath.row];
    //标题
    CustomLabel * titleLabel      = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 30)];
    titleLabel.textAlignment      = NSTextAlignmentCenter;
    titleLabel.font               = [UIFont systemFontOfSize:18];
    titleLabel.textColor          = [UIColor whiteColor];
    [cell.contentView addSubview:titleLabel];
    //描述
    CustomLabel * descLabel      = [[CustomLabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.width, 20)];
    descLabel.textAlignment      = NSTextAlignmentCenter;
    descLabel.font               = [UIFont systemFontOfSize:13];
    descLabel.textColor          = [UIColor whiteColor];
    [cell.contentView addSubview:descLabel];
    
    //设置内容
    titleLabel.text = category.category_name;
    descLabel.text  = category.category_desc;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegete respondsToSelector:@selector(categorySelect:)]) {
        [self.delegete performSelector:@selector(categorySelect:) withObject:self.dataSource[indexPath.row]];
    }
}

- (void)setCategoryList:(NSArray *)categoryList
{
    if ([self.delegete respondsToSelector:@selector(colorChange:)]) {
        [self.delegete performSelector:@selector(colorChange:) withObject:self.colorList[0]];
    }
    self.dataSource = categoryList;
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger position = scrollView.contentOffset.y/100;
    if (position < self.dataSource.count) {
        if ([self.delegete respondsToSelector:@selector(colorChange:)]) {
            [self.delegete performSelector:@selector(colorChange:) withObject:self.colorList[position]];
        }
    }
}

@end
