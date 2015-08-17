//
//  DatabaseService.h
//  EwChat
//
//  Created by 老邢Thierry on 6/7/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DatabaseService : NSObject


+(DatabaseService *) sharedInstance;

/*!
 @method
 @brief 复制数据库
 */
-(void)copyFileDatabase;

/*!
 @method
 @brief 执行查询操作
 @param sql 执行的sql语句
 */
-(FMResultSet *)executeQuery:(NSString *)sql;

/*!
 @method
 @brief 执行更新操作
 @param sql 执行的sql语句
 */
-(int)executeUpdate:(NSString *)sql;

/*!
 @method
 @brief 执行批量更新操作
 @param sql 执行的sql语句
 */
-(void)executeBatchUpdate:(NSArray *)sqls;

@end
