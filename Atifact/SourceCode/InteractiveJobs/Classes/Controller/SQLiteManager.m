//
//  SQLiteManager.m
//  NarutoReader
//
//  Created by MacBook Pro on 9/26/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SQLiteManager.h"

#define DB_NAME @"db.sqlite3"
#define db_version @"1"

static SQLiteManager *instance;

@implementation SQLiteManager

+ (id) getInstance {
    if (!instance) {
        instance = [[SQLiteManager alloc] init];
    }
    return instance;
}

- (id) init {
    if (self = [super init]) {
        removeOldImage = NO;
    }
    return self;
}

- (BOOL) openDB:(NSString *) reason {
    [self createDB];
    const char *dbpath = [mDbPath UTF8String];
    if (sqlite3_open(dbpath, &mDB) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

- (void) execCommand:(const char *) sqlStr {
    char *errMsg;
    if (sqlite3_exec(mDB, sqlStr, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"Failed to exec command %s", sqlStr);
    }
}

- (void) closeDB {
    sqlite3_close(mDB);
}

- (NSString *)dataFilePath:(NSString *)filename {
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [paths stringByAppendingPathComponent:filename];
}

- (BOOL) getFileExistence: (NSString *) filename
{
    BOOL IsFileExists = NO;
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *favsFilePath = [paths stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    if ([fileManager fileExistsAtPath:favsFilePath])
    {
        IsFileExists = YES;
    }
    return IsFileExists;
}

- (void)createDB
{
    mDbPath = [self dataFilePath:DB_NAME];
    if (![self getFileExistence:DB_NAME])
    {
        NSError *error;
        NSString *file = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite3"];
        
        if (file)
        {
            if([[NSFileManager defaultManager] copyItemAtPath:file toPath:mDbPath error:&error]){
                NSLog(@"File successfully copied");
            } else {
                NSLog(@"Error description-%@ \n", [error localizedDescription]);
                NSLog(@"Error reason-%@", [error localizedFailureReason]);
            }
        }
    } else {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *dbVer = [userDef objectForKey:@"dbver"];
        if (!dbVer || ![dbVer isEqualToString:db_version]) {
            [userDef setObject:db_version forKey:@"dbver"];
            [userDef synchronize];
            
            NSFileManager *filemgr = [NSFileManager defaultManager];
            [filemgr removeItemAtPath:mDbPath error:nil];
            [self createDB];
        }
    }
}

- (BOOL) logDone:(sqlite3_stmt *) statement type:(NSString *) type {
    if (sqlite3_step(statement) == SQLITE_DONE) {
        //        NSLog(@"DB: %@ success!", type);
        return YES;
    } else {
        NSLog(@"DB: Err %@", [NSString stringWithUTF8String:sqlite3_errmsg(mDB)]);
        return NO;
    }
}

- (NSInteger)numberOfDaysUntil:(NSDate *)aDate fromDate:(NSDate *) fDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:fDate toDate:aDate options:0];
    return [components day];
}

- (NSString *) fullFileName:(NSString *) name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths firstObject];
    return [cachesDir stringByAppendingString:name];
}

- (void) removeOldImage {
    if (!removeOldImage) {
        NSDate *yesterDay = [[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24];
        [self openDB:@""];
        NSString *result = nil;
        sqlite3_stmt *statement;
        const char *query_stmt = [[NSString stringWithFormat: @"select name from image where date < \"%@\"", yesterDay] UTF8String];
        sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            NSString *fullName = [self fullFileName:result];
            
            [fileManager removeItemAtPath:fullName error:NULL];
        }
        sqlite3_finalize(statement);
        
        query_stmt = [[NSString stringWithFormat: @"delete from image where date < \"%@\"", yesterDay] UTF8String];
        sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
        [self logDone:statement type:@"delete old image"];
        sqlite3_finalize(statement);
        
        [self closeDB];
        removeOldImage = YES;
    }
}


- (NSString *) getImageNameFromLink:(NSString *)urlLink {
    [self openDB:@""];
    NSString *result = nil;
    sqlite3_stmt *statement;
    const char *query_stmt = [[NSString stringWithFormat: @"select name from image where link = \"%@\"", urlLink] UTF8String];

    sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);

    if (sqlite3_step(statement) == SQLITE_ROW) {
        result = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
    }
    
    sqlite3_finalize(statement);
    [self closeDB];
    return result;
}

- (void) addImageWithLink:(NSString *)urlLink name:(NSString *)imageName {
    [self removeOldImage];
    [self openDB:@"add image with link"];
    sqlite3_stmt *statement;
    const char *query_stmt = [[NSString stringWithFormat: @"insert into image (link, name, date) values (\"%@\", \"%@\", \"%@\")", urlLink, imageName, [NSDate date]] UTF8String];
    
    sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
    [self logDone:statement type:@"insert new image with link"];
    sqlite3_finalize(statement);
    [self closeDB];
}

- (NSString *) makeNameFromLink:(NSString *) urlLink {
    NSString *result = [urlLink stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    result = [result stringByReplacingOccurrencesOfString:@":" withString:@"."];
    return result;
}

//- (void) addFavourite:(DIYItem *) item {
//    [self openDB:@"add favourite with link"];
//    sqlite3_stmt *statement;
//    const char *query_stmt = [[NSString stringWithFormat: @"insert into favourite (name, source, imageid, time) values (\"%@\", \"%@\", \"%@\", \"%@\")", item.name, item.source, item.imageID, item.date] UTF8String];
//    
//    sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
//    [self logDone:statement type:@"insert new favourite with link"];
//    sqlite3_finalize(statement);
//    [self closeDB];
//}
//
//- (void) removeFavourite:(DIYItem *)item {
//    [self openDB:@"remove favourite with link"];
//    sqlite3_stmt *statement;
//    const char *query_stmt = [[NSString stringWithFormat: @"delete from favourite where imageid = \"%@\"", item.imageID] UTF8String];
//    
//    sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
//    [self logDone:statement type:@"remove favourite with link"];
//    sqlite3_finalize(statement);
//    [self closeDB];
//}
//

- (NSMutableArray *) allCompany {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [self openDB:@""];
    sqlite3_stmt *statement;
    const char *query_stmt = [[NSString stringWithFormat: @"select name, companylogo, companyurl, vuforia, companyweb from companies"] UTF8String];
    sqlite3_prepare_v2(mDB, query_stmt, -1, &statement, NULL);
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *nameDB = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
        NSString *companylogo = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
        NSString *companyurl = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
        NSString *vuforia = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
        
        const char* temp = (const char *)sqlite3_column_text(statement, 4);
        NSString *companyweb = @"";
        
        if (temp != NULL) {
            companyweb = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
        }
        Company *item = [[Company alloc] init];
        [item setName:nameDB];
        item.companylogo = companylogo;
        item.companyurl = companyurl;
        item.vuforia = vuforia;
        item.companyweb = companyweb;
        [result addObject:item];
    }
    sqlite3_finalize(statement);
    [self closeDB];
    return result;
}

@end
