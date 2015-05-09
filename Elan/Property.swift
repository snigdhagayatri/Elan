//
//  Property.swift
//  Elan
//
//  Created by Snigdha Gayatri on 26/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

class Property: NSObject {

    var id: Int?
    var squarefeet: Int?
    var price : Int?
    var sellerverify: String?
    var rating: Float?
    var calamity: String?
    var soil: String?
    var image:String?
    var latlong: CGPoint?
    var locality: Float?
    
    init(id:Int, squarefeet: Int, price: Int, sellerverify: String,rating: Float, calamity: String, soil: String,image:String, latlong: CGPoint, locality:Float)
    {
        self.id = id
        self.squarefeet = squarefeet
        self.price = price
        self.sellerverify = sellerverify
        self.rating = rating
        self.calamity = calamity
        self.soil = soil
        self.image = image
        self.latlong = latlong
        self.locality = locality
    }
}

