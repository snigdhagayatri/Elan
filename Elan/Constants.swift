//
//  Constants.swift
//  HousingApp
//
//  Created by RAHUL on 4/25/15.
//  Copyright (c) 2015 RAHUL. All rights reserved.
//

import UIKit

struct Constants {
    
    struct url {
        static let googleApiKey = "AIzaSyC6ZzFSm-hGNhary5Dn9FgacTuFL5GHtvQ"
        static func googlePlaceAutoComplete(searchText:String) -> String{
            return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchText)&types=geocode&language=en&components=country:in&types=(cities)&key=\(googleApiKey)"
        }
        static func googlePlaceSearch(place_id:String) -> String{
            return "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=\(place_id)&key=\(googleApiKey)"
        }
    }
}