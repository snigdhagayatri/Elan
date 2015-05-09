//
//  CommonFunc.swift
//  StayZilla
//
//  Created by Nitesh on 4/5/15.
//  Copyright (c) 2015 INASRA. All rights reserved.
//

import UIKit

var randNum = 0
class CommonFunc: NSObject {
    
    
    
    class func readJsonFromFile(fileName:String) -> AnyObject{
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        var err:NSError?
        if let data = NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingUncached, error: &err) {
            if err == nil{
                let json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err)
                if err == nil && json != nil{
                    return json
                }
            }
        }
        return []
    }
    
    class func showAlert(title:String,message:String) {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
//    class func convertObjToJson(obj:AnyObject?) -> NSData?{
//        
//        if obj != nil{
//            var err : NSError?
//            var json = NSJSONSerialization.dataWithJSONObject(obj!, options: NSJSONWritingOptions.PrettyPrinted, error: &err)
//            return json
//        }
//        return nil
//    }
    
}
