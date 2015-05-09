//
//  ProphetViewController.swift
//  prophet
//
//  Created by Venkatesh on 4/25/15.
//  Copyright (c) 2015 Stayzilla. All rights reserved.
//

import UIKit

class ProphetViewController: UIViewController {

    
    @IBOutlet weak var TxtView: UITextView!
    
    @IBOutlet weak var GraphView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var obj = LineGraph(frame: CGRect(x: 10, y: 0, width: 330, height: 400))
        var data = [Array<CGFloat>]()

        
        var a = 0;
        
        if(a == 0)
        {

            data = [[100000,130000,170000,245000,500000,800000]]
            obj.initLineGraph(data, xAxislabelArray: ["2010","2012","2014","2016","2018","2020"], yAxislabelArray: ["1000000","800000","600000","400000","200000","0"], gridVisible: true)
            obj.displayLineGraph()
            GraphView.addSubview(obj)
        }
        else
        {
            data = [[100000,120000,120000,110000,130000,135000]]
            obj.initLineGraph(data, xAxislabelArray: ["2010","2012","2014","2016","2018","2020"], yAxislabelArray: ["1000000","800000","600000","400000","200000","0"], gridVisible: true)
            obj.displayLineGraph()
            GraphView.addSubview(obj)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
