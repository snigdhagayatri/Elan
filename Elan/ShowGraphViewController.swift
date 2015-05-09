//
//  ShowGraphViewController.swift
//  Elan
//
//  Created by RAHUL on 4/26/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

class ShowGraphViewController: UIViewController {

    var data :[Array<CGFloat>]!
    var data1 :[Array<CGFloat>]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Property count \(arrayOfProperty.count)")
        println(id1)
        println(id2)
        // Do any additional setup after loading the view.
        var obj = BarGraph(frame: CGRect(x: 10,y: 100,width: 200,height: 200))
        var obj1 = BarGraph(frame: CGRect(x: 200,y: 100,width: 200,height: 200))
        
        
        
        
        var propertyDetail1 = arrayOfProperty[id1! - 1]
        println(propertyDetail1.rating)
        
        var propertyDetail2 = arrayOfProperty[id2! - 1]
        println(propertyDetail2.rating)
        
        data = [[CGFloat(propertyDetail1.rating!),CGFloat(propertyDetail1.locality!)]]
        
        obj.initBarGraph(data, xAxislabelArray: ["locality","rating"], yAxislabelArray: ["0","1","2","3","4","5"])
        obj.displayBarGraph()
        self.view.addSubview(obj)
        
        data = [[CGFloat(propertyDetail2.rating!),CGFloat(propertyDetail2.locality!)]]
        obj1.initBarGraph(data, xAxislabelArray: ["locality","rating"], yAxislabelArray: ["0","1","2","3","4","5"])
        obj1.displayBarGraph()
        self.view.addSubview(obj1)
    }
    @IBAction func okAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        id1 = nil
        id2 = nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
