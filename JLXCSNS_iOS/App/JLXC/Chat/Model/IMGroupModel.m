//
//  IMGroupModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/27.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "IMGroupModel.h"

@implementation IMGroupModel


-(void)save{
    
    if ([IMGroupModel findByGroupId:self.groupId]==nil) {
        if (self.groupRemark == nil || self.groupRemark.length < 1) {
            self.groupRemark = @"";
        }
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO jlxc_group values (null,'%@','%@',%d, '%@', '%@', '%d', '%d', '%d','%ld','%@')",self.groupId, self.groupTitle,self.type , self.groupRemark, self.avatarPath, self.currentState, self.isRead, self.isNew, self.owner,self.addDate];
        [[DatabaseService sharedInstance] executeUpdate:sql];
    }
}

+ (void)deleteData
{
//    debugMethod();
    NSString *sql = @"DELETE FROM jlxc_group";
    [[DatabaseService sharedInstance] executeUpdate:sql];
}

- (void)update
{
//    debugMethod();
    if (self.groupRemark == nil || self.groupRemark.length < 1) {
        self.groupRemark = @"";
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE jlxc_group SET groupTitle = '%@', type=%d, avatarPath='%@', groupRemark='%@', isRead='%d' ,currentState='%d', isNew='%d' WHERE groupId='%@' and owner='%ld' and addDate='%@'",self.groupTitle, self.type, self.avatarPath , self.groupRemark, self.isRead, self.currentState, self.isNew, self.groupId, self.owner, self.addDate];
    debugLog(@"sql:%@",sql);
    [[DatabaseService sharedInstance] executeUpdate:sql];
}


- (void)remove
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM jlxc_group WHERE groupId='%@' AND owner='%ld'",self.groupId, self.owner];
    [[DatabaseService sharedInstance] executeUpdate:sql1];
}

+ (NSMutableArray *)findAll
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' ORDER BY id DESC;", [UserService sharedService].user.uid];
    return [IMGroupModel findBySql:sql];
}

+ (NSMutableArray *)findCoverThree
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' ORDER BY id DESC LIMIT 3;", [UserService sharedService].user.uid];
    return [IMGroupModel findBySql:sql];
}

+ (NSMutableArray *)findHasAddAll
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' AND currentState = 1 ORDER BY id DESC;", [UserService sharedService].user.uid];
    
    return [IMGroupModel findBySql:sql];
}


/**
 * 从数据库中查出新的朋友群组 最近的三条
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findThreeNewFriends
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' AND currentState=0 and isNew=1 and isRead=0 ORDER BY addDate DESC LIMIT 3", [UserService sharedService].user.uid];
    return [IMGroupModel findBySql:sql];
}

/**
 * 从数据库中查出全部新的朋友群组
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findAllNewFriends
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' AND isNew=1 ORDER BY addDate DESC", [UserService sharedService].user.uid];
    return [IMGroupModel findBySql:sql];
}



/**
 *
 * @return NSInteger 数字
 */
+ (NSInteger)unReadNewFriendsCount
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE type=1 AND owner='%ld' AND currentState=0 and isNew=1 and isRead=0", [UserService sharedService].user.uid];
    return [IMGroupModel findBySql:sql].count;
}

+ (void)hasRead
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE jlxc_group SET isRead=1 WHERE owner='%ld'", [UserService sharedService].user.uid];
    [[DatabaseService sharedInstance] executeUpdate:sql];
}

+ (IMGroupModel *)findByGroupId:(NSString *)groupId
{
//    debugMethod();
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM jlxc_group WHERE owner='%ld' AND groupId='%@' limit 1", [UserService sharedService].user.uid, groupId];
    NSMutableArray *array = [IMGroupModel findBySql:sql];
    IMGroupModel *group = nil;
    if (array.count>0) {
        group = [array objectAtIndex:0];
    }
    return group;
}

+ (NSMutableArray *)findBySql:(NSString *)sql
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DatabaseService sharedInstance] executeQuery:sql];
    
    while ([rs next]) {
        IMGroupModel *group = [[IMGroupModel alloc] init];
        [group setGroupId:[rs stringForColumn:@"groupId"]];
        [group setGroupTitle:[rs stringForColumn:@"groupTitle"]];
        [group setType:[rs intForColumn:@"type"]];
        [group setAvatarPath:[rs stringForColumn:@"avatarPath"]];
        [group setGroupRemark:[rs stringForColumn:@"groupRemark"]];
        [group setCurrentState:[rs intForColumn:@"currentState"]];
        [group setIsRead:[rs intForColumn:@"isRead"]];
        [group setIsNew:[rs intForColumn:@"isNew"]];
        [group setOwner:[rs intForColumn:@"owner"]];
        [array addObject:group];
    }
    
    [rs close];
    return array;
}


@end
