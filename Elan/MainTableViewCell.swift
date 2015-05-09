//
//  MainTableViewCell.swift
//  Elan
//
//  Created by Snigdha Gayatri on 26/04/15.
//  Copyright (c) 2015 Snigdha Gayatri. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var squareFeet: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(propertyImage : String, price: Int, squareFeet : Int)
    {
        self.squareFeet.text = String(squareFeet) + " sq ft."
        self.price.text = String(price) + " Lacs"
        self.propertyImage.image = UIImage(named: propertyImage)
    }
}
