//
//  Filter.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

struct Filter {
    
    let name: String?
    let value: Any?
    
    init(dictionary: NSDictionary) {
        name = dictionary["title"] as? String
        value = dictionary["value"]
    }
    
    static func filters(array: [NSDictionary]) -> [Filter] {
        var filters = [Filter]()
        for dictionary in array {
            let filter = Filter(dictionary: dictionary)
            filters.append(filter)
        }
        return filters
    }
    
    static func createCategoryFilters(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = YelpFilters.sharedInstance.createCategoryFilters(completion)
    }
    
    static func createSortModes(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = YelpFilters.sharedInstance.createSortModes(completion)
    }
    
    static func createDistanceFilters(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = YelpFilters.sharedInstance.createDistanceFilters(completion)
    }
    
    static func createDealFilters(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = YelpFilters.sharedInstance.createDealFilters(completion)
    }
    
}
