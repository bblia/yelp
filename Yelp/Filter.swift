//
//  Filter.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class Filter {
    
    static let sharedInstance = Filter(dictionary: [:])

    
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
        _ = Filter.sharedInstance.createCategoryFilters(completion)
    }
    
    static func createSortModes(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = Filter.sharedInstance.createSortModes(completion)
    }
    
    static func createDistanceFilters(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = Filter.sharedInstance.createDistanceFilters(completion)
    }
    
    static func createDealFilters(completion: @escaping ([Filter]?, Error?) -> Void) {
        _ = Filter.sharedInstance.createDealFilters(completion)
    }
    
    func createCategoryFilters(_ completion: @escaping ([Filter]?, Error?) -> Void) {
        completion(Filter.filters(array: categories()), nil)
    }
    
    func createSortModes(_ completion: @escaping ([Filter]?, Error?) -> Void) {
        completion(Filter.filters(array: sortModes()), nil)
    }
    
    func createDistanceFilters(_ completion: @escaping ([Filter]?, Error?) -> Void) {
        completion(Filter.filters(array: distances()), nil)
    }
    
    func createDealFilters(_ completion: @escaping ([Filter]?, Error?) -> Void) {
        completion(Filter.filters(array: deals()), nil)
    }
    
    func categories() -> [NSDictionary] {
        return [["title": "Afghan", "value": "afghani"],
                ["title": "African", "value": "african"],
                ["title": "American, New", "value": "newamerican"],
                ["title": "American, Traditional", "value": "tradamerican"],
                ["title": "Arabian", "value": "arabian"],
                ["title": "Argentine", "value": "argentine"],
                ["title": "Armenian", "value": "armenian"],
                ["title": "Asian Fusion", "value": "asianfusion"],
                ["title": "Asturian", "value": "asturian"],
                ["title": "Australian", "value": "australian"],
                ["title": "Austrian", "value": "austrian"],
                ["title": "Baguettes", "value": "baguettes"],
                ["title": "Bangladeshi", "value": "bangladeshi"],
                ["title": "Barbeque", "value": "bbq"],
                ["title": "Basque", "value": "basque"],
                ["title": "Bavarian", "value": "bavarian"],
                ["title": "Beer Garden", "value": "beergarden"],
                ["title": "Beer Hall", "value": "beerhall"],
                ["title": "Beisl", "value": "beisl"],
                ["title": "Belgian", "value": "belgian"],
                ["title": "Bistros", "value": "bistros"],
                ["title": "Black Sea", "value": "blacksea"],
                ["title": "Brasseries", "value": "brasseries"],
                ["title": "Brazilian", "value": "brazilian"],
                ["title": "Breakfast & Brunch", "value": "breakfast_brunch"],
                ["title": "British", "value": "british"],
                ["title": "Buffets", "value": "buffets"],
                ["title": "Bulgarian", "value": "bulgarian"],
                ["title": "Burgers", "value": "burgers"],
                ["title": "Burmese", "value": "burmese"],
                ["title": "Cafes", "value": "cafes"],
                ["title": "Cafeteria", "value": "cafeteria"],
                ["title": "Cajun/Creole", "value": "cajun"],
                ["title": "Cambodian", "value": "cambodian"],
                ["title": "Canadian", "value": "New)"],
                ["title": "Canteen", "value": "canteen"],
                ["title": "Caribbean", "value": "caribbean"],
                ["title": "Catalan", "value": "catalan"],
                ["title": "Chech", "value": "chech"],
                ["title": "Cheesesteaks", "value": "cheesesteaks"],
                ["title": "Chicken Shop", "value": "chickenshop"],
                ["title": "Chicken Wings", "value": "chicken_wings"],
                ["title": "Chilean", "value": "chilean"],
                ["title": "Chinese", "value": "chinese"],
                ["title": "Comfort Food", "value": "comfortfood"],
                ["title": "Corsican", "value": "corsican"],
                ["title": "Creperies", "value": "creperies"],
                ["title": "Cuban", "value": "cuban"],
                ["title": "Curry Sausage", "value": "currysausage"],
                ["title": "Cypriot", "value": "cypriot"],
                ["title": "Czech", "value": "czech"],
                ["title": "Czech/Slovakian", "value": "czechslovakian"],
                ["title": "Danish", "value": "danish"],
                ["title": "Delis", "value": "delis"],
                ["title": "Diners", "value": "diners"],
                ["title": "Dumplings", "value": "dumplings"],
                ["title": "Eastern European", "value": "eastern_european"],
                ["title": "Ethiopian", "value": "ethiopian"],
                ["title": "Fast Food", "value": "hotdogs"],
                ["title": "Filipino", "value": "filipino"],
                ["title": "Fish & Chips", "value": "fishnchips"],
                ["title": "Fondue", "value": "fondue"],
                ["title": "Food Court", "value": "food_court"],
                ["title": "Food Stands", "value": "foodstands"],
                ["title": "French", "value": "french"],
                ["title": "French Southwest", "value": "sud_ouest"],
                ["title": "Galician", "value": "galician"],
                ["title": "Gastropubs", "value": "gastropubs"],
                ["title": "Georgian", "value": "georgian"],
                ["title": "German", "value": "german"],
                ["title": "Giblets", "value": "giblets"],
                ["title": "Gluten-Free", "value": "gluten_free"],
                ["title": "Greek", "value": "greek"],
                ["title": "Halal", "value": "halal"],
                ["title": "Hawaiian", "value": "hawaiian"],
                ["title": "Heuriger", "value": "heuriger"],
                ["title": "Himalayan/Nepalese", "value": "himalayan"],
                ["title": "Hong Kong Style Cafe", "value": "hkcafe"],
                ["title": "Hot Dogs", "value": "hotdog"],
                ["title": "Hot Pot", "value": "hotpot"],
                ["title": "Hungarian", "value": "hungarian"],
                ["title": "Iberian", "value": "iberian"],
                ["title": "Indian", "value": "indpak"],
                ["title": "Indonesian", "value": "indonesian"],
                ["title": "International", "value": "international"],
                ["title": "Irish", "value": "irish"],
                ["title": "Island Pub", "value": "island_pub"],
                ["title": "Israeli", "value": "israeli"],
                ["title": "Italian", "value": "italian"],
                ["title": "Japanese", "value": "japanese"],
                ["title": "Jewish", "value": "jewish"],
                ["title": "Kebab", "value": "kebab"],
                ["title": "Korean", "value": "korean"],
                ["title": "Kosher", "value": "kosher"],
                ["title": "Kurdish", "value": "kurdish"],
                ["title": "Laos", "value": "laos"],
                ["title": "Laotian", "value": "laotian"],
                ["title": "Latin American", "value": "latin"],
                ["title": "Live/Raw Food", "value": "raw_food"],
                ["title": "Lyonnais", "value": "lyonnais"],
                ["title": "Malaysian", "value": "malaysian"],
                ["title": "Meatballs", "value": "meatballs"],
                ["title": "Mediterranean", "value": "mediterranean"],
                ["title": "Mexican", "value": "mexican"],
                ["title": "Middle Eastern", "value": "mideastern"],
                ["title": "Milk Bars", "value": "milkbars"],
                ["title": "Modern Australian", "value": "modern_australian"],
                ["title": "Modern European", "value": "modern_european"],
                ["title": "Mongolian", "value": "mongolian"],
                ["title": "Moroccan", "value": "moroccan"],
                ["title": "New Zealand", "value": "newzealand"],
                ["title": "Night Food", "value": "nightfood"],
                ["title": "Norcinerie", "value": "norcinerie"],
                ["title": "Open Sandwiches", "value": "opensandwiches"],
                ["title": "Oriental", "value": "oriental"],
                ["title": "Pakistani", "value": "pakistani"],
                ["title": "Parent Cafes", "value": "eltern_cafes"],
                ["title": "Parma", "value": "parma"],
                ["title": "Persian/Iranian", "value": "persian"],
                ["title": "Peruvian", "value": "peruvian"],
                ["title": "Pita", "value": "pita"],
                ["title": "Pizza", "value": "pizza"],
                ["title": "Polish", "value": "polish"],
                ["title": "Portuguese", "value": "portuguese"],
                ["title": "Potatoes", "value": "potatoes"],
                ["title": "Poutineries", "value": "poutineries"],
                ["title": "Pub Food", "value": "pubfood"],
                ["title": "Rice", "value": "riceshop"],
                ["title": "Romanian", "value": "romanian"],
                ["title": "Rotisserie Chicken", "value": "rotisserie_chicken"],
                ["title": "Rumanian", "value": "rumanian"],
                ["title": "Russian", "value": "russian"],
                ["title": "Salad", "value": "salad"],
                ["title": "Sandwiches", "value": "sandwiches"],
                ["title": "Scandinavian", "value": "scandinavian"],
                ["title": "Scottish", "value": "scottish"],
                ["title": "Seafood", "value": "seafood"],
                ["title": "Serbo Croatian", "value": "serbocroatian"],
                ["title": "Signature Cuisine", "value": "signature_cuisine"],
                ["title": "Singaporean", "value": "singaporean"],
                ["title": "Slovakian", "value": "slovakian"],
                ["title": "Soul Food", "value": "soulfood"],
                ["title": "Soup", "value": "soup"],
                ["title": "Southern", "value": "southern"],
                ["title": "Spanish", "value": "spanish"],
                ["title": "Steakhouses", "value": "steak"],
                ["title": "Sushi Bars", "value": "sushi"],
                ["title": "Swabian", "value": "swabian"],
                ["title": "Swedish", "value": "swedish"],
                ["title": "Swiss Food", "value": "swissfood"],
                ["title": "Tabernas", "value": "tabernas"],
                ["title": "Taiwanese", "value": "taiwanese"],
                ["title": "Tapas Bars", "value": "tapas"],
                ["title": "Tapas/Small Plates", "value": "tapasmallplates"],
                ["title": "Tex-Mex", "value": "tex-mex"],
                ["title": "Thai", "value": "thai"],
                ["title": "Traditional Norwegian", "value": "norwegian"],
                ["title": "Traditional Swedish", "value": "traditional_swedish"],
                ["title": "Trattorie", "value": "trattorie"],
                ["title": "Turkish", "value": "turkish"],
                ["title": "Ukrainian", "value": "ukrainian"],
                ["title": "Uzbek", "value": "uzbek"],
                ["title": "Vegan", "value": "vegan"],
                ["title": "Vegetarian", "value": "vegetarian"],
                ["title": "Venison", "value": "venison"],
                ["title": "Vietnamese", "value": "vietnamese"],
                ["title": "Wok", "value": "wok"],
                ["title": "Wraps", "value": "wraps"],
                ["title": "Yugoslav", "value": "yugoslav"]]
    }
    
    func sortModes() -> [NSDictionary] {
        return [["title": "Best Match", "value": YelpSortMode.bestMatched.rawValue],
                ["title": "Distance", "value": YelpSortMode.distance.rawValue],
                ["title": "Highest Rated", "value": YelpSortMode.highestRated.rawValue]]
    }
    
    func distances() -> [NSDictionary] {
        return [["title": "Auto", "value": 0],
                ["title": "0.5 miles", "value": 805],
                ["title": "1 mile", "value": 1609],
                ["title": "5 miles", "value": 8047],
                ["title": "10 miles", "value": 16093],
                ["title": "20 miles", "value": 32187]]
    }
    
    func deals() -> [NSDictionary] {
        return [["title": "Offering a Deal", "value": true]]
    }

    
}
