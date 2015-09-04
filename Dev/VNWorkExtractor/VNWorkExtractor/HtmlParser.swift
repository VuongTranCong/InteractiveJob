//
//  HtmlParser.swift
//  News
//
//  Created by VuongTC on 6/4/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit
import Foundation
//import AFNetworking

class HtmlParser: NSObject {
    var companyList = [Company]()
    static var xPathDataList: [String]!
    
    static var titlePaths: [String]!
    static var descriptionPaths: [String]!
    static var detailLinkPaths: [String]!
    static var coverImagePaths: [String]!
    static var fullURLPath: String!
    static var firstPageFormat: String!
    static var otherPageFormat: String!
    static var startPageIndex: Int!
    static var appColor: UIColor!
    static var appColorMenu: UIColor!
    
    static func initQueryList () {
        xPathDataList = ["//div[@class='row relative']"]
//        if (xPathDataList == nil) {
//            let dictRoot = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("query_path", ofType: "plist")!)
//            
//            xPathDataList = dictRoot!.valueForKey("xPathDataList") as! [String]
//            
//            titlePaths = dictRoot!.valueForKey("titlePaths") as! [String]
//            descriptionPaths = dictRoot!.valueForKey("descriptionPaths") as! [String]
//            detailLinkPaths = dictRoot!.valueForKey("detailLinkPaths") as! [String]
//            coverImagePaths = dictRoot!.valueForKey("coverImagePaths") as! [String]
//            fullURLPath = dictRoot!.valueForKey("fullURLPath") as! String
//            firstPageFormat = dictRoot!.valueForKey("firstPageFormat") as! String
//            otherPageFormat = dictRoot!.valueForKey("otherPageFormat") as! String
//            startPageIndex = dictRoot!.valueForKey("startPageIndex") as! Int
//            
//            let appColorDict = dictRoot!.valueForKey("appColor") as! NSDictionary
//            let r = appColorDict.valueForKey("r") as! CGFloat
//            let g = appColorDict.valueForKey("g") as! CGFloat
//            let b = appColorDict.valueForKey("b") as! CGFloat
//            let a = appColorDict.valueForKey("a") as! CGFloat
//            appColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
//            
//            if (dictRoot!.valueForKey("appColorMenu") != nil) {
//                let appColorMenuDict = dictRoot!.valueForKey("appColorMenu") as! NSDictionary
//                let r = appColorMenuDict.valueForKey("r") as! CGFloat
//                let g = appColorMenuDict.valueForKey("g") as! CGFloat
//                let b = appColorMenuDict.valueForKey("b") as! CGFloat
//                let a = appColorMenuDict.valueForKey("a") as! CGFloat
//                appColorMenu = UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
//            } else {
//                appColorMenu = appColor
//            }
//
//        }
    }
    
    static func jobsFromUrl(urlStr: String!, page: Int, successBlock: ([Job]) -> Void) {
        let fullLink = self.getFullLink(urlStr, page: page)
        request(NSURLRequest(URL: NSURL(string: fullLink)!)).response { (request, response, data, _) -> Void in
            var data: NSData = data as! NSData
            var parser = TFHpple(HTMLData: data)
            var jobList = [Job]()
            
//            var htmlStr = NSString(data: data as NSData, encoding: NSUTF8StringEncoding)
//            println(htmlStr)
            
            var nodes = [TFHppleElement]()
            var xPathList = self.xPathDataList
            for xPathStr in xPathList {
                let childNodes = parser.searchWithXPathQuery(xPathStr)
                for element in childNodes {
                    nodes.append(element as! TFHppleElement)
                }
            }
            
            for element in nodes {
                var job = Job()
                self.setTitleForBlog(&job, node: element)
                if (job.companyLogo != nil) {
                    jobList.append(job)
                } else {
                    println("can not parse this data")
                }
            }
            
            successBlock(jobList);
        }
    }
    
    static func companyFromUrl(urlStr: String!, page: Int, successBlock: (Company) -> Void) {
        let fullLink = self.getFullLink(urlStr, page: page)
        request(NSURLRequest(URL: NSURL(string: fullLink)!)).response { (request, response, data, _) -> Void in
            var data: NSData = data as! NSData
            var parser = TFHpple(HTMLData: data)
            var company = Company()
            
//            var htmlStr = NSString(data: data as NSData, encoding: NSUTF8StringEncoding)
//            println(htmlStr)
            
            var nodes = [TFHppleElement]()
            var xPathList = ["//div[@class='job-header relative ']"]
            for xPathStr in xPathList {
                let childNodes = parser.searchWithXPathQuery(xPathStr)
                for element in childNodes {
                    nodes.append(element as! TFHppleElement)
                }
            }
            
            for element in nodes {
                company.name = self.getTitleForArticle(element, xPaths: ["//span[@class='company-name text-lg block']"])
                company.companyURL = self.getDetailLinkForArticle(element, xPaths: ["//span[@class='center-block text-center box-limit']/a"])
                company.vuforia = self.encodeTextFromLink(company.companyURL)
                break
            }
            
            successBlock(company);
        }
    }
    
    static func encodeTextFromLink (link: String!) -> String!{
        var result = link
        result = result.stringByReplacingOccurrencesOfString(":", withString: ".", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("/", withString: ".", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("http...www.vietnamworks.com.", withString: "", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("jobs-at-", withString: "", options: nil, range: nil)
        
        if (count(result) > 60) {
            result = result.substringFromIndex(advance(result.startIndex, count(result) - 60))
        }
        
        println(count(result))
        
        return result
    }
    
    func contentHtmlOfLink(urlStr: String!) -> String {
        return ""
    }
    
    static func getObjectContent(childNodes: [TFHppleElement]) -> String {
        for nodeChild in childNodes {
            for childElement in nodeChild.children {
                let title = self.trimStr(childElement.content)
                if (title != "") {
                    return title
                }
            }
            
        }
        
        for nodeChild in childNodes {
            let title = self.trimStr(nodeChild.attributes["title"] as! String);
            if (title != "") {
                return title;
            }
        }
        
        return "";
    }
    
    static func getHrefLink(childNodes: [TFHppleElement]) -> String {
        for nodeChild in childNodes {
            let srcStr = nodeChild.attributes["href"] as! String
            if (srcStr != "") {
                return self.fullURL(srcStr);
            }
        }
        
        return ""
    }
    
    static func getImageLink(childNodes: [TFHppleElement]) -> String {
        for nodeChild in childNodes {
            let srcStr = nodeChild.attributes["src"] as! String
            if (srcStr != "") {
                return srcStr
            }
        }
        
        return "";
    }
    
    static func getTitleForArticle(node: TFHppleElement, xPaths: [String]) -> String!{
        for xPath in xPaths {
            let childNodes = node.searchWithXPathQuery(xPath) as! [TFHppleElement]
            let dataStr = self.getObjectContent(childNodes)
            
            if (dataStr != "") {
                return dataStr
            }
        }
        return nil
    }
//
//    static func getDescriptionForArticle(inout job: Job, node: TFHppleElement, xPaths: [String]){
//        for xPath in xPaths {
//            let childNodes = node.searchWithXPathQuery(xPath) as! [TFHppleElement]
//            let dataStr = self.getObjectContent(childNodes)
//            
//            if (dataStr != "") {
//                article.articleDescription = dataStr
//                return;
//            }
//        }
//    }
//    
    static func getDetailLinkForArticle(node: TFHppleElement, xPaths: [String]) -> String!{
        for xPath in xPaths {
            let childNodes = node.searchWithXPathQuery(xPath) as! [TFHppleElement]
            let coverImgStr = self.getHrefLink(childNodes)
            
            if (coverImgStr != "") {
                return coverImgStr
            }
        }
        return nil
    }
    
    static func getImageSrcForArticle(node: TFHppleElement, xPaths: [String]) -> String!{
        for xPath in xPaths {
            let childNodes = node.searchWithXPathQuery(xPath) as! [TFHppleElement]
            let coverImgStr = self.getImageLink(childNodes)
            
            if (coverImgStr != "") {
                return coverImgStr
            }
        }
        return nil
    }
    
    static func setTitleForBlog(inout job: Job, node: TFHppleElement) {
        job.jobDetailURL = self.getDetailLinkForArticle(node, xPaths: ["//div[@class='col-sm-3 col-sm-push-9 text-center']/a"])
        job.companyLogo = self.getImageSrcForArticle(node, xPaths: ["//img[@class='img-responsive']"])
    }
    
    static func trimStr(str: String) -> String {
        var resultStr = str
        resultStr = resultStr.stringByReplacingOccurrencesOfString("\r", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        resultStr = resultStr.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        resultStr = resultStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return resultStr;
    }
    
    
    static func fullURL(url: String) -> String {
        if url.rangeOfString("http", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) == nil {
            return "\(fullURLPath)\(url)"
        }
        return url
    }
    
    static func getFullLink(link: String, page: Int) -> String {
        return link;
    }
}
