//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersViewController: FiltersViewController,
                                              didUpdateFilters filters: [String:AnyObject],
                                              deals: Bool,
                                              switchStates: [Int:Bool],
                                              sortMode: YelpSortMode,
                                              distanceAuto: Bool,
                                              distancePoint3: Bool,
                                              distance1: Bool,
                                              distance3: Bool,
                                              distance5: Bool
    )
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    var searchDeals: Bool!
    var sortMode: YelpSortMode!
    var distanceAuto: Bool!
    var distancePoint3: Bool!
    var distance1: Bool!
    var distance3: Bool!
    var distance5: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController(filtersViewController: self,
                                        didUpdateFilters: filters,
                                        deals: searchDeals,
                                        switchStates: switchStates,
                                        sortMode: sortMode,
                                        distanceAuto: distanceAuto,
                                        distancePoint3: distancePoint3,
                                        distance1: distance1,
                                        distance3: distance3,
                                        distance5: distance5)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 3
        case 3:
            return categories.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Deals"
        }else if(section == 1){
            return "Distance"
        }else if(section == 2){
            return "Sort By"
        }else if(section == 3){
            return "Categories"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.onSwitch.isOn = false // reset
        if(indexPath.section == 0) {
            cell.delegate = self
            cell.nameLabel.text = "Offering A Deal"
            cell.onSwitch.isOn = searchDeals
        }else if(indexPath.section == 1) {
            cell.delegate = self
            if(indexPath.row == 1) {
                cell.nameLabel.text = "0.3 miles"
                cell.onSwitch.isOn = distancePoint3
            }else if(indexPath.row == 2) {
                cell.nameLabel.text = "1 miles"
                cell.onSwitch.isOn = distance1
            }else if(indexPath.row == 3) {
                cell.nameLabel.text = "3 miles"
                cell.onSwitch.isOn = distance3
            }else if(indexPath.row == 4) {
                cell.nameLabel.text = "5 miles"
                cell.onSwitch.isOn = distance5
            }else if(indexPath.row == 0) {
                cell.nameLabel.text = "Auto"
                cell.onSwitch.isOn = distanceAuto
            }
        }else if(indexPath.section == 2) {
            cell.delegate = self
            if(indexPath.row == 0) {
                cell.nameLabel.text = "Best Matched"
                if(sortMode == .bestMatched) {
                    cell.onSwitch.isOn = true
                }
            }else if(indexPath.row == 1) {
                cell.nameLabel.text = "Distance"
                if(sortMode == .distance){
                    cell.onSwitch.isOn = true
                }
            }else if(indexPath.row == 2) {
                cell.nameLabel.text = "Highest Rated"
                if(sortMode == .highestRated) {
                    cell.onSwitch.isOn = true
                }
            }
            
        }else if(indexPath.section == 3) {
            cell.delegate = self
            cell.nameLabel.text = categories[indexPath.row]["name"]
            if(switchStates[indexPath.row] != nil){
                cell.onSwitch.isOn = switchStates[indexPath.row]!
            } else {
                cell.onSwitch.isOn = false
            }
        }
        return cell
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        let section = indexPath!.section
        switch (section) {
        case 0:
            searchDeals = value
        
        case 1:
            let row = indexPath!.row
            if row == 0 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 0, section: indexPath!.section)
                }
                distanceAuto = value
            } else if row == 1 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 1, section: indexPath!.section)
                }
                distancePoint3 = value
            } else if row == 2 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 2, section: indexPath!.section)
                }
                distance1 = value
            } else if row == 3 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 3, section: indexPath!.section)
                }
                distance3 = value
            } else if row == 4 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 4, section: indexPath!.section)
                }
                distance5 = value
            }
        case 2:
            let row = indexPath!.row
            
            if row == 0 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 0, section: indexPath!.section)
                }
                sortMode = .bestMatched
            } else if row == 1 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 1, section: indexPath!.section)
                }
                sortMode = .distance
            } else if row == 2 {
                if(value == true){
                    disableOtherDistanceCells(selectedCell: 2, section: indexPath!.section)
                }
                sortMode = .highestRated
            }
            
        }
        case 3:
            switchStates[indexPath!.row] = value
        default:
    }
    
    func disableOtherDistanceCells(selectedCell: Int, section: Int){
        if(selectedCell != 0){
            let ip0 = IndexPath(row: 0, section: section)
            if let cell0 = tableView.cellForRow(at: ip0) as? SwitchCell{
                cell0.onSwitch.isOn = false
            }
            distanceAuto = false
        }
        
        if(selectedCell != 1){
            let ip1 = IndexPath(row: 1, section: section)
            if let cell1 = tableView.cellForRow(at: ip1) as? SwitchCell{
                cell1.onSwitch.isOn = false
            }
            distancePoint3 = false
        }
        
        if(selectedCell != 2){
            let ip2 = IndexPath(row: 2, section: section)
            if let cell2 = tableView.cellForRow(at: ip2) as? SwitchCell{
                cell2.onSwitch.isOn = false
            }
            distance1 = false
        }
        
        if(section != 2 && selectedCell != 3){
            let ip3 = IndexPath(row: 3, section: 1)
            if let cell3 = tableView.cellForRow(at: ip3) as? SwitchCell{
                cell3.onSwitch.isOn = false
            }
            distance3 = false
        }
        
        if(section != 2 && selectedCell != 4){
            let ip4 = IndexPath(row: 4, section: 1)
            if let cell4 = tableView.cellForRow(at: ip4) as? SwitchCell{
                cell4.onSwitch.isOn = false
            }
            distance5 = false
        }
    }
    
    func yelpCategories() -> [[String:String]]{
        
        let categories = [["name" : "Afghan", "code": "afghani"],
                          ["name" : "African", "code": "african"],
                          ["name" : "American, New", "code": "newamerican"],
                          ["name" : "American, Traditional", "code": "tradamerican"],
                          ["name" : "Arabian", "code": "arabian"],
                          ["name" : "Argentine", "code": "argentine"],
                          ["name" : "Armenian", "code": "armenian"],
                          ["name" : "Asian Fusion", "code": "asianfusion"],
                          ["name" : "Asturian", "code": "asturian"],
                          ["name" : "Australian", "code": "australian"],
                          ["name" : "Austrian", "code": "austrian"],
                          ["name" : "Baguettes", "code": "baguettes"],
                          ["name" : "Bangladeshi", "code": "bangladeshi"],
                          ["name" : "Barbeque", "code": "bbq"],
                          ["name" : "Basque", "code": "basque"],
                          ["name" : "Bavarian", "code": "bavarian"],
                          ["name" : "Beer Garden", "code": "beergarden"],
                          ["name" : "Beer Hall", "code": "beerhall"],
                          ["name" : "Beisl", "code": "beisl"],
                          ["name" : "Belgian", "code": "belgian"],
                          ["name" : "Bistros", "code": "bistros"],
                          ["name" : "Black Sea", "code": "blacksea"],
                          ["name" : "Brasseries", "code": "brasseries"],
                          ["name" : "Brazilian", "code": "brazilian"],
                          ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                          ["name" : "British", "code": "british"],
                          ["name" : "Buffets", "code": "buffets"],
                          ["name" : "Bulgarian", "code": "bulgarian"],
                          ["name" : "Burgers", "code": "burgers"],
                          ["name" : "Burmese", "code": "burmese"],
                          ["name" : "Cafes", "code": "cafes"],
                          ["name" : "Cafeteria", "code": "cafeteria"],
                          ["name" : "Cajun/Creole", "code": "cajun"],
                          ["name" : "Cambodian", "code": "cambodian"],
                          ["name" : "Canadian", "code": "New)"],
                          ["name" : "Canteen", "code": "canteen"],
                          ["name" : "Caribbean", "code": "caribbean"],
                          ["name" : "Catalan", "code": "catalan"],
                          ["name" : "Chech", "code": "chech"],
                          ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                          ["name" : "Chicken Shop", "code": "chickenshop"],
                          ["name" : "Chicken Wings", "code": "chicken_wings"],
                          ["name" : "Chilean", "code": "chilean"],
                          ["name" : "Chinese", "code": "chinese"],
                          ["name" : "Comfort Food", "code": "comfortfood"],
                          ["name" : "Corsican", "code": "corsican"],
                          ["name" : "Creperies", "code": "creperies"],
                          ["name" : "Cuban", "code": "cuban"],
                          ["name" : "Curry Sausage", "code": "currysausage"],
                          ["name" : "Cypriot", "code": "cypriot"],
                          ["name" : "Czech", "code": "czech"],
                          ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                          ["name" : "Danish", "code": "danish"],
                          ["name" : "Delis", "code": "delis"],
                          ["name" : "Diners", "code": "diners"],
                          ["name" : "Dumplings", "code": "dumplings"],
                          ["name" : "Eastern European", "code": "eastern_european"],
                          ["name" : "Ethiopian", "code": "ethiopian"],
                          ["name" : "Fast Food", "code": "hotdogs"],
                          ["name" : "Filipino", "code": "filipino"],
                          ["name" : "Fish & Chips", "code": "fishnchips"],
                          ["name" : "Fondue", "code": "fondue"],
                          ["name" : "Food Court", "code": "food_court"],
                          ["name" : "Food Stands", "code": "foodstands"],
                          ["name" : "French", "code": "french"],
                          ["name" : "French Southwest", "code": "sud_ouest"],
                          ["name" : "Galician", "code": "galician"],
                          ["name" : "Gastropubs", "code": "gastropubs"],
                          ["name" : "Georgian", "code": "georgian"],
                          ["name" : "German", "code": "german"],
                          ["name" : "Giblets", "code": "giblets"],
                          ["name" : "Gluten-Free", "code": "gluten_free"],
                          ["name" : "Greek", "code": "greek"],
                          ["name" : "Halal", "code": "halal"],
                          ["name" : "Hawaiian", "code": "hawaiian"],
                          ["name" : "Heuriger", "code": "heuriger"],
                          ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                          ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                          ["name" : "Hot Dogs", "code": "hotdog"],
                          ["name" : "Hot Pot", "code": "hotpot"],
                          ["name" : "Hungarian", "code": "hungarian"],
                          ["name" : "Iberian", "code": "iberian"],
                          ["name" : "Indian", "code": "indpak"],
                          ["name" : "Indonesian", "code": "indonesian"],
                          ["name" : "International", "code": "international"],
                          ["name" : "Irish", "code": "irish"],
                          ["name" : "Island Pub", "code": "island_pub"],
                          ["name" : "Israeli", "code": "israeli"],
                          ["name" : "Italian", "code": "italian"],
                          ["name" : "Japanese", "code": "japanese"],
                          ["name" : "Jewish", "code": "jewish"],
                          ["name" : "Kebab", "code": "kebab"],
                          ["name" : "Korean", "code": "korean"],
                          ["name" : "Kosher", "code": "kosher"],
                          ["name" : "Kurdish", "code": "kurdish"],
                          ["name" : "Laos", "code": "laos"],
                          ["name" : "Laotian", "code": "laotian"],
                          ["name" : "Latin American", "code": "latin"],
                          ["name" : "Live/Raw Food", "code": "raw_food"],
                          ["name" : "Lyonnais", "code": "lyonnais"],
                          ["name" : "Malaysian", "code": "malaysian"],
                          ["name" : "Meatballs", "code": "meatballs"],
                          ["name" : "Mediterranean", "code": "mediterranean"],
                          ["name" : "Mexican", "code": "mexican"],
                          ["name" : "Middle Eastern", "code": "mideastern"],
                          ["name" : "Milk Bars", "code": "milkbars"],
                          ["name" : "Modern Australian", "code": "modern_australian"],
                          ["name" : "Modern European", "code": "modern_european"],
                          ["name" : "Mongolian", "code": "mongolian"],
                          ["name" : "Moroccan", "code": "moroccan"],
                          ["name" : "New Zealand", "code": "newzealand"],
                          ["name" : "Night Food", "code": "nightfood"],
                          ["name" : "Norcinerie", "code": "norcinerie"],
                          ["name" : "Open Sandwiches", "code": "opensandwiches"],
                          ["name" : "Oriental", "code": "oriental"],
                          ["name" : "Pakistani", "code": "pakistani"],
                          ["name" : "Parent Cafes", "code": "eltern_cafes"],
                          ["name" : "Parma", "code": "parma"],
                          ["name" : "Persian/Iranian", "code": "persian"],
                          ["name" : "Peruvian", "code": "peruvian"],
                          ["name" : "Pita", "code": "pita"],
                          ["name" : "Pizza", "code": "pizza"],
                          ["name" : "Polish", "code": "polish"],
                          ["name" : "Portuguese", "code": "portuguese"],
                          ["name" : "Potatoes", "code": "potatoes"],
                          ["name" : "Poutineries", "code": "poutineries"],
                          ["name" : "Pub Food", "code": "pubfood"],
                          ["name" : "Rice", "code": "riceshop"],
                          ["name" : "Romanian", "code": "romanian"],
                          ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                          ["name" : "Rumanian", "code": "rumanian"],
                          ["name" : "Russian", "code": "russian"],
                          ["name" : "Salad", "code": "salad"],
                          ["name" : "Sandwiches", "code": "sandwiches"],
                          ["name" : "Scandinavian", "code": "scandinavian"],
                          ["name" : "Scottish", "code": "scottish"],
                          ["name" : "Seafood", "code": "seafood"],
                          ["name" : "Serbo Croatian", "code": "serbocroatian"],
                          ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                          ["name" : "Singaporean", "code": "singaporean"],
                          ["name" : "Slovakian", "code": "slovakian"],
                          ["name" : "Soul Food", "code": "soulfood"],
                          ["name" : "Soup", "code": "soup"],
                          ["name" : "Southern", "code": "southern"],
                          ["name" : "Spanish", "code": "spanish"],
                          ["name" : "Steakhouses", "code": "steak"],
                          ["name" : "Sushi Bars", "code": "sushi"],
                          ["name" : "Swabian", "code": "swabian"],
                          ["name" : "Swedish", "code": "swedish"],
                          ["name" : "Swiss Food", "code": "swissfood"],
                          ["name" : "Tabernas", "code": "tabernas"],
                          ["name" : "Taiwanese", "code": "taiwanese"],
                          ["name" : "Tapas Bars", "code": "tapas"],
                          ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                          ["name" : "Tex-Mex", "code": "tex-mex"],
                          ["name" : "Thai", "code": "thai"],
                          ["name" : "Traditional Norwegian", "code": "norwegian"],
                          ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                          ["name" : "Trattorie", "code": "trattorie"],
                          ["name" : "Turkish", "code": "turkish"],
                          ["name" : "Ukrainian", "code": "ukrainian"],
                          ["name" : "Uzbek", "code": "uzbek"],
                          ["name" : "Vegan", "code": "vegan"],
                          ["name" : "Vegetarian", "code": "vegetarian"],
                          ["name" : "Venison", "code": "venison"],
                          ["name" : "Vietnamese", "code": "vietnamese"],
                          ["name" : "Wok", "code": "wok"],
                          ["name" : "Wraps", "code": "wraps"],
                          ["name" : "Yugoslav", "code": "yugoslav"]]
        
        return(categories)
    }
}
