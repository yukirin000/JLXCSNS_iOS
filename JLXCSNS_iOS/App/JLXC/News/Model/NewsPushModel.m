//
//  NewsPushModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsPushModel.h"

@implementation NewsPushModel


/**
 * 保存数据
 */
- (int)save
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO jlxc_news_push values (null,'%ld','%@','%@' , '%@','%ld','%ld','%@','%@','%@','%d', '%@')",self.uid, self.head_image, self.name, self.comment_content,self.type, self.news_id, self.news_content, self.news_image, self.news_user_name, self.is_read, self.push_time];
    return [[DatabaseService sharedInstance] executeUpdate:sql];
}

/**
 * 更新数据
 */
- (void)update
{
//    NSString *sql = [NSString stringWithFormat:@"UPDATE jlxc_news_push SET is_read=%d WHERE id=%ld", self.is_read, self.pid];
//    [[DatabaseService sharedInstance] executeUpdate:sql];
}

/**
 * 删除
 */
- (void)remove
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM jlxc_news_push WHERE id=%ld",self.pid];
    [[DatabaseService sharedInstance] executeUpdate:sql];
}

+ (void)removeAll
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM jlxc_news_push"];
    [[DatabaseService sharedInstance] executeUpdate:sql];
}

+ (void)setIsRead
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE jlxc_news_push SET is_read=1"];
    [[DatabaseService sharedInstance] executeUpdate:sql];
}

+ (NSMutableArray *)findAll
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_news_push ORDER BY id DESC;"];
    return [self findBySql:sql];
}

+ (NSMutableArray *)findUnreadCount
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_news_push WHERE is_read=0 ORDER BY id DESC;"];
    return [self findBySql:sql];
}

+ (NSMutableArray *)findBySql:(NSString *)sql
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DatabaseService sharedInstance] executeQuery:sql];
    while ([rs next]) {
        NewsPushModel *push = [[NewsPushModel alloc] init];
        [push setPid:[rs intForColumn:@"id"]];
        [push setUid:[rs intForColumn:@"uid"]];
        [push setHead_image:[rs stringForColumn:@"head_image"]];
        [push setName:[rs stringForColumn:@"name"]];
        [push setComment_content:[rs stringForColumn:@"comment_content"]];
        [push setType:[rs intForColumn:@"type"]];
        [push setNews_id:[rs intForColumn:@"news_id"]];
        [push setNews_content:[rs stringForColumn:@"news_content"]];
        [push setNews_image:[rs stringForColumn:@"news_image"]];
        [push setNews_user_name:[rs stringForColumn:@"news_user_name"]];
        [push setIs_read:[rs boolForColumn:@"is_read"]];
        [push setPush_time:[rs stringForColumn:@"push_time"]];
        [array addObject:push];
    }
    [rs close];
    return array;
}

@end
