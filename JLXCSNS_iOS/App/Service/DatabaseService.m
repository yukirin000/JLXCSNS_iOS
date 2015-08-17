//
//  DatabaseService.m
//  EwChat
//
//  Created by 老邢Thierry on 6/7/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import "DatabaseService.h"

@implementation DatabaseService
{
    /*!
     @property
     @brief 数据库路径
     */
    NSString *_dbPath;
    
    FMDatabaseQueue *queue;
}

static DatabaseService *_shareInstance=nil;

+(DatabaseService *) sharedInstance
{
    if(!_shareInstance)
    {
        _shareInstance=[[DatabaseService alloc] init];
    }
    return _shareInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self copyFileDatabase];
    }
    return self;
}

-(void)copyFileDatabase
{
    NSString *documentsDirectory = PATH_OF_DOCUMENT;
    _dbPath = [documentsDirectory stringByAppendingPathComponent:@"jlxc.db"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_dbPath]) {
        debugLog(@"Database File Exsit");
    }else {
        NSString *resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jlxc.db"];
        debugLog(@"_dbPath=%@",_dbPath);
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        [[NSFileManager defaultManager] createFileAtPath:_dbPath contents:mainBundleFile attributes:nil];
    }
    
    queue =[FMDatabaseQueue databaseQueueWithPath:_dbPath];
}

-(FMResultSet *)executeQuery:(NSString *)sql
{
    __block FMResultSet* rs = nil;
//    FMDatabaseQueue *queue = nil;
//    queue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    [queue inDatabase:^(FMDatabase *db) {
//        [db closeOpenResultSets];
        rs = [db executeQuery:sql];
    }];
    
    return rs;
}

-(int)executeUpdate:(NSString *)sql
{
    __block int rid;
//    FMDatabaseQueue *queue = nil;
//    queue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
        rid = (int)[db lastInsertRowId];
    }];
    return rid;
}

-(void)executeBatchUpdate:(NSArray *)sqls
{
//    debugMethod();
//    FMDatabaseQueue *queue = nil;
//    queue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        for (NSString *sql in sqls) {
//            debugLog(@"sql:%@",sql);
            [db executeUpdate:sql];
        }
    }];
}

@end
