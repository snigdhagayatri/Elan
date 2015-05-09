//
//  MainTableViewController.swift
//  Elan
//
//  Created by Snigdha Gayatri on 26/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

var id1: Int?
var id2: Int?

var arrayOfProperty: [Property] = [Property]()

class MainTableViewController: UITableViewController {


    var id: Array<Int> = [1,2,3,4,5,6,7,8,9,10]
    var squarefeetArray: Array<Int> = [500,600,1600,2500,4500,5400,7200,8400,9250,1000]
    var priceArray: Array<Int> = [10,12,22,30,40,52,65,74,80,85]
    var sellerverifyArray: Array<String> = ["Yes","Yes","Yes","Yes","No","Yes","No","Yes","Yes","Yes"]
    var ratingArrray: Array<Float> = [4.5,3.5,4.0,4.5,5.0,4.5,3.0,3.5,5.0,4.5]
    var localityArrray: Array<Float> = [4.0,3.0,4.0,5.0,3.0,4.0,3.5,3.0,4.0,5.0]

    var calamityArray: Array<String> = ["Yes","No","Yes","No","Yes","Yes","Yes","No","No","Yes"]
    var soilArray: Array<String> = ["Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes","Yes"]
    var imageArray: Array<String> = ["image1","image2","image3","image4","image5","image1","image2","image3","image4","image5"]
    var latlongArray: Array<CGPoint> = [CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279142, 77.62710769), CGPointMake(12.9279232, 77.62710749), CGPointMake(12.9279222, 76.62710789), CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279232, 77.62710779), CGPointMake(12.9279232, 77.62710779)]
//    [<12.9279232,77.62710779]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpProperty()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setUpProperty()
    {   if arrayOfProperty.count != 10
    {
        for(var i=0; i<10; i++)
        {
            var property = Property(id: id[i], squarefeet: squarefeetArray[i], price: priceArray[i], sellerverify: sellerverifyArray[i], rating: ratingArrray[i], calamity: calamityArray[i], soil: soilArray[i], image: imageArray[i], latlong: latlongArray[i], locality: localityArrray[i])
            
            arrayOfProperty.append(property)
        }
    }
    else
    {
        println("Count exceeded")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println(arrayOfProperty.count)
        
        return arrayOfProperty.count
        
    }
    
    

  //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //return 0
  //  }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as MainTableViewCell

        let property = arrayOfProperty[indexPath.row]
        
       // cell.setCell(property.id, squarefeet: property.squarefeet, imageName: property.imageName)
        
        cell.setCell(property.image!, price: property.price!, squareFeet: property.squarefeet!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let property = arrayOfProperty[indexPath.row]
        var detailedViewController: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detail") as DetailViewController
        
        detailedViewController.id = property.id!

        detailedViewController.squareFeet = property.squarefeet!
        println("Squarefeet \(detailedViewController.squareFeet)")
        detailedViewController.price = property.price!
        detailedViewController.sellerVerified = property.sellerverify!
        detailedViewController.startRating = property.rating
        detailedViewController.soil = property.soil
        detailedViewController.proneToCalamity = property.calamity
        

//        self.presentViewController(detailedViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
