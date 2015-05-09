//
//  GrowthGraphViewController.swift
//  prophet
//
//  Created by Venkatesh on 4/25/15.
//  Copyright (c) 2015 Stayzilla. All rights reserved.
//

import UIKit

class GrowthGraphViewController: UIViewController {

        
    @IBOutlet weak var TxtView: UITextView!
    

    @IBOutlet weak var LblPowerOutage: UILabel!
    
    
    @IBOutlet weak var LblPastGrowth: UILabel!
    
    
    @IBOutlet weak var LblInfrastuctureGrowth: UILabel!
    
    
    @IBOutlet weak var LblFutureGrowth: UILabel!
    
    //@IBOutlet weak var LblLegalIssues: UILabel!
    
    @IBOutlet weak var LblLegalIssues: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // LblLegalIssues.sizeToFit()
        LblInfrastuctureGrowth.sizeToFit()
        LblPastGrowth.sizeToFit()
        LblPowerOutage.sizeToFit()
        LblFutureGrowth.sizeToFit()
        
        
        var a = 0;
        
        if(a == 0)
        {
            LblPowerOutage.text = "None"
            LblPastGrowth.text = "High"
            LblInfrastuctureGrowth.text = "Good"
            LblLegalIssues.text = "Resolved. Property Title Clear"
            LblFutureGrowth.text = "Quite Promising"
            
            TxtView.text = "The land has a stable market. The price growth in past years and infrastructure growth tells this land has a promising market! Good Choice user :-) "
        }
            
        else
        {
            LblPowerOutage.text = "High"
            LblPastGrowth.text = "Good"
            LblInfrastuctureGrowth.text = "Fair"
            LblLegalIssues.text = "None in recent past"
            LblFutureGrowth.text = "Not Promising"


            
            TxtView.text = "The market for this land has been growing lately, but doesn't guarentee a promising investment given the power outage frequency and government ignorance to developing proper roadlines. that's the drawback"
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
