//
//  APIClient.swift
//  StayZilla
//
//  Created by saravanan.p on 3/20/15.
//  Copyright (c) 2015 INASRA. All rights reserved.
//

import UIKit

private let _sharedInstance = APIClient()

class APIClient
{
    
    class var sharedInstance: APIClient
    {
        struct Singleton
        {
            static let instance = APIClient()
        }
        return Singleton.instance
    }
    
    func fetchGetUrl(url:NSURL, params:[String:AnyObject]?, onSuccess:((data: AnyObject) -> Void)?, onFail:((message:String) -> Void)?){
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(params != nil){
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        }
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if error == nil{
                var err:NSError?
                if data != nil{
                    if var jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err){
                        onSuccess!(data: jsonResult)
                    }
                    else
                    {
                        onFail!(message: "error on parsing")
                    }
                }
                else
                {
                    onFail!(message: "No data received")
                }
            }
            else{
                onFail!(message:error.description)
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
}
