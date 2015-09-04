
//
//  HtmlParser.m
//  NarutoReader
//
//  Created by MacBook Pro on 9/25/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "HtmlParser.h"
#import "TFHpple.h"
#import "Job.h"

@implementation HtmlParser


+ (void) parseCompanyFromURL:(NSString *) urlStr successBlock:(void(^)(NSMutableArray*)) successBlock {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *imgLinks = [[NSMutableArray alloc] init];
        TFHpple *parser = [TFHpple hppleWithHTMLData:data];
        
        NSString *xpathQueryString = @"//div[@class='row relative']";
        NSArray *nodes = [parser searchWithXPathQuery:xpathQueryString];
        for (TFHppleElement *element in nodes) {
            Job *article = [[Job alloc] init];
            
            [self setTitleForBlog:article withData:element];
            
            if (![self isStringNil:article.title] && ![self isStringNil:article.urlDetail]) {
                [imgLinks addObject:article];
            } else {
                NSLog(@"can not parse this data");
            }
        }
        
        
        successBlock(imgLinks);
        
    }];
}

+ (NSString *) trimStr:(NSString *) str {
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return str;
}

+ (void) firstWayToParse:(NSMutableArray *) imgLinks urlStr:(NSString *) urlStr {
    NSError *error;
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr] options:0 error:&error];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//div[@class='row relative']";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQueryString];
    for (TFHppleElement *element in nodes) {
        Job *article = [[Job alloc] init];
        
        [self setTitleForBlog:article withData:element];
        
        if (![self isStringNil:article.title] && ![self isStringNil:article.urlDetail]) {
            [imgLinks addObject:article];
        } else {
            NSLog(@"can not parse this data");
        }
    }
}

+ (BOOL) isStringNil:(NSString*) str {
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *) getFullLink:(NSString *) link {
    if ([link rangeOfString:@"http"].location == NSNotFound) {
        return [NSString stringWithFormat:@"http://hcm.m.24h.com.vn%@", link];
    } else {
        return link;
    }
}

+ (NSString*) getObjectContent:(NSArray* ) childNodes appendAll:(BOOL) appendAll fromIndex:(int) fromIndex {
    NSString* result = @"";
    for (int i = fromIndex; i < childNodes.count; i++) {
        TFHppleElement* nodeChild = [childNodes objectAtIndex:i];
        for (TFHppleElement* childElement in nodeChild.children) {
            NSString* title = [self trimStr:childElement.content];
            if (title != nil && ![title isEqualToString:@""]) {
                if (appendAll) {
                    result = [result stringByAppendingString:title];
                } else {
                    return title;
                }
            }
        }
    }
    
    if ([result isEqualToString:@""]) {
        for (int i = fromIndex; i < childNodes.count; i++) {
            TFHppleElement* nodeChild = [childNodes objectAtIndex:i];
            NSString* title = [self trimStr:nodeChild.attributes[@"title"]];
            if (title != nil && ![title isEqualToString:@""]) {
                if (appendAll) {
                    result = [result stringByAppendingString:title];
                } else {
                    return title;
                }
            }
        }
    }
    
    return result;
}

+ (NSString*) getHrefLink:(NSArray*) childNodes {
    for (TFHppleElement* nodeChild in childNodes) {
        NSString* srcStr = nodeChild.attributes[@"href"];
        if (![srcStr isEqualToString:@""]) {
            return [self getFullLink:srcStr];
        }
    }
    
    return @"";
}

+ (NSString*) getImageLink:(NSArray*) childNodes {
    for (TFHppleElement* nodeChild in childNodes) {
        NSString* srcStr = nodeChild.attributes[@"src"];
        if (![srcStr isEqualToString:@""]) {
            return srcStr;
        }
    }
    
    return @"";
}

+ (NSString*) getTitleForArticle:(TFHppleElement*) node xPaths:(NSMutableArray*) xPaths appendAll:(BOOL) appendAll fromIndex:(int) fromIndex {
    NSString *result = @"";
    for (NSString* xPath in xPaths) {
        NSArray* childNodes = [node searchWithXPathQuery:xPath];
        NSString* dataStr = [self getObjectContent:childNodes appendAll:appendAll fromIndex:fromIndex];
        
        if (![dataStr isEqualToString:@""]) {
            result = [result stringByAppendingString:dataStr];
            if (!appendAll) {
                break;
            }
        }
    }
    return result;
}

+ (NSString*) getDetailLinkForArticle:(TFHppleElement*) node xPaths:(NSMutableArray*) xPaths {
    for (NSString* xPath in xPaths) {
        NSArray* childNodes = [node searchWithXPathQuery:xPath];
        NSString* coverImgStr = [self getHrefLink:childNodes];
        
        if (![coverImgStr isEqualToString:@""]) {
            return coverImgStr;
        }
    }
    return @"";
}

+ (NSString*) getCoverImageForArticle:(TFHppleElement*) node xPaths:(NSMutableArray*) xPaths {
    for (NSString* xPath in xPaths) {
        NSArray* childNodes = [node searchWithXPathQuery:xPath];
        NSString* coverImgStr = [self getImageLink:childNodes];
        
        if (![coverImgStr isEqualToString:@""]) {
            return coverImgStr;
        }
    }
    return @"";
}

+ (void) setTitleForBlog:(Job *) article withData:(TFHppleElement *) node {
    article.title = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                          @"//div[@class='bold-red ']/a", @"//a[@class='job-title text-clip text-lg']", nil] appendAll:NO fromIndex:0];
    
    article.address = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                            @"//p[@class='job-info text-clip']/span/span", nil] appendAll:NO fromIndex:0];
    
    article.jobTitle = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                             @"//p[@class='job-info text-clip']/span/span", nil] appendAll:NO fromIndex:1];
    
    article.dateStr = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                            @"//span[@class='views']/span", nil] appendAll:NO fromIndex:0];
    
    article.viewCount = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                                    @"//span[@class='view-number']", nil] appendAll:NO fromIndex:0];
    
    
//    article.salary = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
//                                                           @"//div[@class=' new-job']/a", nil]];
  
//    article.companyName = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
//                                                                @"//div[@class=' new-job']/a", nil]];
    
    article.skill1 = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                           @"//em[@class='text-xs gray col-sm-10 col-xs-10 text-clip']", nil] appendAll:NO fromIndex:0];
    
    article.skill2 = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                            @"//em[@class='text-xs gray col-sm-10 col-xs-10 text-clip']", nil] appendAll:NO fromIndex:1];
    
    article.skill3 = [self getTitleForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                            @"//em[@class='text-xs gray col-sm-10 col-xs-10 text-clip']", nil] appendAll:NO fromIndex:2];
    
    article.urlDetail = [self getDetailLinkForArticle:node xPaths:[NSMutableArray arrayWithObjects:
                                                              @"//div[@class='bold-red ']/a", @"//a[@class='job-title text-clip text-lg']", nil]];
}

+ (NSString *) contentHtmlOfLink:(NSString *) urlStr {
    NSError *error;
    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr] options:0 error:&error];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//div[@class='fck_detail pNormalD fontSizeCss left']";
    NSString *result = @"";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQueryString];
    for (TFHppleElement *element in nodes) {
        result = [result stringByAppendingString:element.raw];
    }
    return result;
}

@end