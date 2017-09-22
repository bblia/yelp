//
//  AnnotationView.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class AnnotationView: UIView {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            setAnnotationViews()
        }
    }
    
    private func setAnnotationViews() {
        thumbView.setImageWith(business.imageURL!)
        ratingsView.setImageWith(business.ratingImageURL!)
        titleLabel.text = business.name
        reviewsLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = business.address
        distanceLabel.text = business.distance
        categoriesLabel.text = business.categories
    }
}
