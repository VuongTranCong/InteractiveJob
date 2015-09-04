//
//  ViewController.swift
//  VNWorkExtractor
//
//  Created by VuongTC on 7/3/15.
//  Copyright (c) 2015 S3Corp. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    @IBOutlet var jobURLLabel: UILabel!
    @IBOutlet var companyURLLabel: UILabel!
    @IBOutlet var indexLabel: UILabel!
    
    var currentJobs = [Job]()
    var currentCompanyLogo: String!
    var vuforiaStr: String!
    var currentIndexParsed = 0
    var currentIndexPage = 0
    let maxRow: Int64 = 100
    var currentRowDB: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        HtmlParser.initQueryList()
        self.createDB()
        
        parseAllJobs()
    }
    
    func parseAllJobs (){
        var url = "http://www.vietnamworks.com/job-search/all-jobs/page-\(currentIndexPage)"
//        var url = "http://www.vietnamworks.com/it-software-jobs-i35-en/page-\(currentIndexPage)"
        println("parse job url \(url)")
        jobURLLabel.text = url;
        HtmlParser.jobsFromUrl(url, page: 1) { (jobs) -> Void in
            self.currentJobs = jobs
            self.currentIndexParsed = 0
            self.parseCompanyInfo()
        }
    }
    
    func parseCompanyInfo () {
        if (currentIndexParsed < currentJobs.count) {
            let job = currentJobs[currentIndexParsed]
            if self.isCompanyExisted (job) == false {
                self.parseCompanyFromJob(job)
            } else {
                currentIndexParsed += 1
                self.parseCompanyInfo()
            }
        } else {
            if (currentRowDB < maxRow) {
                currentIndexPage += 1
                parseAllJobs()
            } else {
                var alert = UIAlertView(title: "", message: "Done", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    //    func saveCompanyToLocal:
    
    func isCompanyExisted (job: Job) -> Bool {
        for company in AppController.sharedInstance().companys {
            if job.companyLogo == company.companyLogo {
                return true
            }
        }
        return false
    }
    
    func parseCompanyFromJob (job: Job) {
        currentCompanyLogo = job.companyLogo
        println("parse company url" + job.jobDetailURL)
        companyURLLabel.text = job.jobDetailURL
        HtmlParser.companyFromUrl(job.jobDetailURL, page: 1) {
            (company) -> Void in
            company.companyLogo = self.currentCompanyLogo
            self.vuforiaStr = company.vuforia
            self.insertCompany(company)
        }
    }
    
    
    
    
    
    
    
    var dbPath: String!
    func createDB () {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        dbPath = documentsPath.stringByAppendingPathComponent("db.sqlite3")
        
        
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            let db = Database(dbPath)
            
            let companies = db["companies"]
            let id = Expression<Int64>("id")
            let name = Expression<String?>("name")
            let companyLogo = Expression<String>("companylogo")
            let companyURL = Expression<String>("companyurl")
            let vuforia = Expression<String>("vuforia")
            
            
            
            db.create(table: companies) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(companyLogo)
                t.column(companyURL)
                t.column(vuforia)
            }
        } else {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            let db = Database(dbPath)
            
            let companies = db["companies"]
            let id = Expression<Int64>("id")
            let name = Expression<String?>("name")
            let companyLogo = Expression<String>("companylogo")
            let companyURL = Expression<String>("companyurl")
            let vuforia = Expression<String>("vuforia")
            
            currentRowDB = Int64(companies.count)
        }
    }
    
    func insertCompany (company: Company) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        let db = Database(dbPath)
        
        let companies = db["companies"]
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let companyLogo = Expression<String>("companylogo")
        let companyURL = Expression<String>("companyurl")
        let vuforia = Expression<String>("vuforia")
        
        
        var alice: Query?
        
        
        var existed = false;
        for user in companies {
            //            println("id: \(user[id]), name: \(user[name])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
            if (user[name] == company.name) {
                existed = true
            }
            if (user[companyLogo] == company.companyLogo) {
                existed = true
            }
        }
        // SELECT * FROM "users"
        
        
        
        if (existed == false && currentRowDB < maxRow) {
            //Convert string to url
            var imgURL: NSURL = NSURL(string: company.companyLogo)!
            //Download an NSData representation of the image from URL
            var request: NSURLRequest = NSURLRequest(URL: imgURL)
            var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
            //Make request to download URL
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if !(error != nil) {
                    //set image to requested resource
                    var image = UIImage(data: data)
                    if (image?.size.width >= 170) {
                        self.vuforiaStr = "\(self.currentRowDB + 1)\(self.vuforiaStr)"
                        if let rowid = companies.insert(name <- company.name, companyLogo <- company.companyLogo, companyURL <- company.companyURL, vuforia <- self.vuforiaStr).rowid {
                            self.currentRowDB = rowid
                            self.indexLabel.text = "inserted id: \(rowid)"
                            println(self.indexLabel.text)
                            //                 inserted id: 1
                            //            alice = companies.filter(id == rowid)
                        }
                        
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
                        let destinationPath = documentsPath.stringByAppendingPathComponent(self.vuforiaStr + ".jpg")
                        println(self.vuforiaStr + ".jpg")
                        UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)
                    }
                    
                    self.currentIndexParsed += 1
                    self.parseCompanyInfo()
                } else {
                    //If request fails...
                    println("error: \(error.localizedDescription)")
                }
            })
            
        } else {
            self.currentIndexParsed += 1
            self.parseCompanyInfo()
        }
        
        
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
        
        //
        //        alice?.update(email <- replace(email, "mac.com", "me.com"))
        //        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        //        // WHERE ("id" = 1)
        //
        //        alice?.delete()
        //        // DELETE FROM "users" WHERE ("id" = 1)
        //        
        //        users.count
    }
}

