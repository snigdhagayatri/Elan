//
//  ViewController.swift
//  Elan
//
//  Created by Snigdha Gayatri on 25/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate,UITableViewDelegate,  UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var squareFeetLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sellerVerifiedLabel: UILabel!
    @IBOutlet weak var soilStabilityLabel: UILabel!
    
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var proneToNaturalCalamityLabel: UILabel!
    
    
    @IBOutlet weak var reviewsOutlet: UIButton!
    @IBOutlet weak var soilStabilityText: UILabel!
    
    @IBOutlet weak var proneToNaturalCalamityText: UILabel!
    
    @IBOutlet weak var moreOptionsOutlet: UIButton!
    var isSignedIn : Bool = false

    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    @IBAction func ButtonProphetOpinion(sender: AnyObject) {

        var storyboard: UIStoryboard!
        storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
       let viewcontroller : GrowthGraphViewController = storyboard.instantiateViewControllerWithIdentifier("GrowthGraph") as GrowthGraphViewController
        
//        self.presentViewController(viewcontroller, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    @IBOutlet weak var mytableView: UITableView!
    
    var id: Int = Int()
    var squareFeet: Int = Int()
    var price: Int = Int()
    var sellerVerified: String = String()
    var startRating: Float?
    var soil: String?
    var proneToCalamity: String?
    
    var imagesArray: Array<String> = ["image1","image2","image3","image4","image5"]
    var namesArray = ["Aditi Gupta","Ashima","Parinaz"]
    var reviewContentArray = ["Good property","Nice locality","Need information"]
    
    var myPopOverController: UIPopoverController?

    
    override func viewDidLoad() {
        var gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("resignTable"))
        gesture.delegate = self

        self.view.addGestureRecognizer(gesture)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        mytableView.delegate = self
//        mytableView.dataSource = self
//        self.mytableView.becomeFirstResponder()
        setUpHorizontalScrollView()
        println("Signed in? \(isSignedIn)")
        

        
        if isSignedIn == false
        {
            moreOptionsOutlet.hidden = false
        reviewsOutlet.hidden = true
        soilStabilityText.hidden = true
        proneToNaturalCalamityText.hidden = true
        soilStabilityLabel.hidden = true
        proneToNaturalCalamityLabel.hidden = true
        }
        else
        {
            moreOptionsOutlet.hidden = true
            reviewsOutlet.hidden = false
            soilStabilityText.hidden = false
            proneToNaturalCalamityText.hidden = false
            soilStabilityLabel.hidden = false
            proneToNaturalCalamityLabel.hidden = false
            

        }
        
    
        squareFeetLabel.text = "\(squareFeet)"
       
        priceLabel.text = "\(price)"
        sellerVerifiedLabel.text = sellerVerified
        starRatingView.setRating(startRating!)
        soilStabilityLabel.text = soil
        proneToNaturalCalamityLabel.text = proneToCalamity
        
        self.mytableView.layer.borderColor = UIColor.blackColor().CGColor
        self.mytableView.layer.borderWidth = 1
        self.mytableView.layer.cornerRadius = 5
        self.view.addSubview(mytableView)
        self.mytableView.registerClass(ReviewerTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        
       
        
        mytableView.reloadData()
        
        self.mytableView.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:ReviewerTableViewCell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as ReviewerTableViewCell
        var receiverName:UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        receiverName.text = namesArray[indexPath.row]
        var recieverContent: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 100))
        recieverContent.text = reviewContentArray[indexPath.row]
        cell.addSubview(receiverName)
        cell.addSubview(recieverContent)

        
        self.preferredContentSize = tableView.contentSize
        return cell
    }
    
    @IBAction func reviewsAction(sender: AnyObject) {
    
        self.mytableView.hidden = false
        
    }
    
    
    func resignTable()
    {
        self.mytableView.hidden = true
    }
    
    @IBAction func moreOptions(sender: AnyObject) {
        var loginViewController:LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as LoginViewController
        loginViewController.squareFeet = squareFeet
        loginViewController.price = price
        loginViewController.sellerVerified = sellerVerified
        loginViewController.startRating = startRating
        loginViewController.soil = soil
        loginViewController.proneToCalamity = proneToCalamity
//        self.presentViewController(loginViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(loginViewController, animated: true)

        
    }

    @IBAction func buuyNowAction(sender: AnyObject) {
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.mytableView.resignFirstResponder()
        self.mytableView.hidden = true
    }
    
    func setUpHorizontalScrollView()
    {
        imagesScrollView.delegate = self
        imagesScrollView.backgroundColor = UIColor.lightGrayColor()
        imagesScrollView.canCancelContentTouches = false
        imagesScrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        imagesScrollView.clipsToBounds = false
        imagesScrollView.scrollEnabled = true
        imagesScrollView.pagingEnabled = true
        
        var nimages: Int = 0
        var tot: Int = 0
        var cx: CGFloat = 0
        var count = imagesArray.count
        for (var i:Int = 0; i < count; i++)
        {
            
            var image: UIImage = UIImage(named: imagesArray[i])!
            if(tot == 5)
            {
                break
            }
            if(4 == nimages)
            {
                nimages = 0
            }
            var imageView:UIImageView = UIImageView(image: image)
            var rect: CGRect = imageView.frame
            rect.size.height = 100
            rect.size.width = 100
            rect.origin.x = cx
            rect.origin.y = 20
            
            imageView.frame = rect
            
            imagesScrollView.addSubview(imageView)
            
            cx += imageView.frame.size.width + 10
            tot++;
            
        }
        
        imagesScrollView.contentSize = CGSizeMake(cx, imagesScrollView.bounds.size.height)
        
    }
    
    @IBAction func compareAction(sender: AnyObject) {
        
        if id1 == nil
        {
            id1 = id
            println("id1=\(id1)")
            println("id2=\(id2)")
        }
        
        if(id1 != nil && id2 == nil)
        {
            if id1 != id
            {
                id2 = id
                println("id1=\(id1)")
                println("id2=\(id2)")
            }
        }
        if(id1 == id2)
        {
            let alert: UIAlertView = UIAlertView(title: "Warning", message: "Please select another property to compare", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            id2 = nil
        }
        else if (id1 != nil && id2 == nil)
        {
            println("id1=\(id1)")
            println("id2=\(id2)")
            var mainTableViewController : MainTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTable") as MainTableViewController
            self.navigationController?.pushViewController(mainTableViewController, animated: true)
        }
            
            
        else if (id1 != nil && id2 != nil)
        {
            var showGraphViewController : ShowGraphViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showGraph") as ShowGraphViewController
            self.presentViewController(showGraphViewController, animated: true, completion: nil)
            
        }
        
    }
    
}

