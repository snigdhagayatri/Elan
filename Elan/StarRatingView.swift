//
//  StarRatingView.swift
//  Elan
//
//  Created by Snigdha Gayatri on 25/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class StarRatingView: UIView {
    
    @IBInspectable var maxRating: Int = 5
    @IBInspectable var fullStarImage: UIImage = UIImage()
    @IBInspectable var halfStarImage: UIImage = UIImage()
    @IBInspectable var emptyStarImage: UIImage = UIImage()
    @IBInspectable var getRating: Int!
    
    var currentRating: Float = 0.0
    var starImageViews: [UIImageView] = []
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        // Clear current star array if maxRating changes
        if (starImageViews.count != maxRating) {
            starImageViews.removeAll(keepCapacity: false)
        }
        
        // Set of star array equal to maxRating
        if (starImageViews.count == 0) {
            for index in 0..<maxRating {
                var image = UIImageView(image: emptyStarImage)
                starImageViews.append(image)
                self.addSubview(image)
                image.frame.origin.x = CGFloat(index) * self.frame.width / CGFloat(maxRating)
            }
        }
        
        // set full and half stars based on rating
        var rating = currentRating
        
        for index in 0..<maxRating {
            if (rating >= 0.75) {
                starImageViews[index].image = fullStarImage
                
                rating = rating - 1.0
            } else if ((rating > 0.25) & (rating < 0.75)) {
                starImageViews[index].image = halfStarImage
                rating = rating - 0.5
            } else {
                starImageViews[index].image = emptyStarImage
            }
        }
    }
    
    public func setRating(var rating: Float) {
        println("Rating \(rating)")
        self.currentRating = rating
        self.setNeedsLayout()
    }
    
}