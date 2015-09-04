//
//  SQLiteManager.h
//  NarutoReader
//
//  Created by MacBook Pro on 9/26/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Company.h"

@interface SQLiteManager : NSObject {
    NSString *mDbPath;
    sqlite3 *mDB;
    BOOL removeOldImage;
}

+ (id) getInstance;
- (BOOL) openDB:(NSString *) reason;
- (void) closeDB;
- (void) createDB;

- (NSString *) getImageNameFromLink:(NSString *) urlLink;
- (void) addImageWithLink:(NSString *) urlLink name:(NSString *) imageName;
- (NSString *) makeNameFromLink:(NSString *) urlLink;
- (void) removeOldImage;

//- (void) addJob:(Job *) item;
//- (void) removeFavourite:(DIYItem *) item;
- (NSMutableArray *) allCompany;
@end
