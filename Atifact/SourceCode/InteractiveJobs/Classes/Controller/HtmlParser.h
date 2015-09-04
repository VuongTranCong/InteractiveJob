//
//  HtmlParser.h
//  NarutoReader
//
//  Created by MacBook Pro on 9/25/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HtmlParser : NSObject

+ (void) parseCompanyFromURL:(NSString *) urlStr successBlock:(void(^)(NSMutableArray*)) successBlock;

+ (NSString *) contentHtmlOfLink:(NSString *) urlStr;

@end
