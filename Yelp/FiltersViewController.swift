//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc func filtersViewController(filtersViewController: FiltersViewController,
                                     didUpdateFilters filters: [String:Any],
        categoryFilters: [Int:Bool],
        sortFilters: [Int:Bool],
        distanceFilters: [Int:Bool],
        dealFilters: [Int:Bool])
}

enum FilterSections: String {
    case dealsSection = ""
    case distanceSection = "Distance"
    case sortBySection = "Sort By"
    case categorySection = "Category"
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryFilters: [Filter]!
    var categoryToggles = [Int: Bool]()
    
    var sortModes: [Filter]!
    var sortToggles = [Int: Bool]()
    
    var distanceFilters: [Filter]!
    var distanceToggles = [Int: Bool]()
    
    var dealFilters: [Filter]!
    var dealToggles = [Int: Bool]()
    
    let tableStructure: [FilterSections] = [.dealsSection, .distanceSection, .sortBySection, .categorySection]
    
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        Filter.createCategoryFilters { (filters: [Filter]?, error: Error?) in
            self.categoryFilters = filters
        }
        
        Filter.createSortModes { (filters: [Filter]?, error: Error?) in
            self.sortModes = filters
        }
        
        Filter.createDistanceFilters { (filters: [Filter]?, error: Error?) in
            self.distanceFilters = filters
        }
        
        Filter.createDealFilters { (filters: [Filter]?, error: Error?) in
            self.dealFilters = filters
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true)
        
        var filters = [String: Any]()
        
        var selectedCategories = [String]()
        var selectedSortMode: YelpSortMode?
        var selectedDistance: NSNumber?
        var selectedDeal: Bool?
        
        for (row, isOn) in categoryToggles {
            if isOn {
                selectedCategories.append(categoryFilters[row].value as! String)
            }
        }
        
        for (row, isOn) in sortToggles {
            if isOn {
                selectedSortMode = YelpSortMode(rawValue: sortModes[row].value as! Int)!
            }
        }
        
        for (row, isOn) in distanceToggles {
            if isOn {
                selectedDistance = distanceFilters[row].value as? NSNumber
            }
        }
        
        for (row, isOn) in dealToggles {
            if isOn {
                selectedDeal = dealFilters[row].value as? Bool
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        filters["sortMode"] = selectedSortMode ?? nil
        filters["distance"] = selectedDistance ?? nil
        filters["deals"] = selectedDeal ?? nil
        
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters, categoryFilters: categoryToggles, sortFilters: sortToggles, distanceFilters: distanceToggles, dealFilters: dealToggles)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dealFilters.count
        case 1:
            return distanceFilters.count
        case 2:
            return sortModes.count
        case 3:
            return categoryFilters.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableStructure[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.delegate = self

        switch indexPath.section {
        case 0:
            cell.nameLabel.text = dealFilters[indexPath.row].name
            cell.onSwitch.isOn = dealToggles[indexPath.row] ?? false
        case 1:
            cell.nameLabel.text = distanceFilters?[indexPath.row].name
            cell.onSwitch.isOn = distanceToggles[indexPath.row] ?? false
        case 2:
            cell.nameLabel.text = sortModes[indexPath.row].name
            cell.onSwitch.isOn = sortToggles[indexPath.row] ?? false
        case 3:
            cell.nameLabel.text = categoryFilters[indexPath.row].name
            cell.onSwitch.isOn = categoryToggles[indexPath.row] ?? false
        default:
            break
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
        let indexPath = tableView.indexPath(for: switchCell)!
        switch indexPath.section {
        case 0:
            dealToggles[indexPath.row] = value
        case 1:
            distanceToggles[indexPath.row] = value
            for path in 0...5 {
                if (path != indexPath.row) {
                    distanceToggles[path] = false
                }
            }
            tableView.reloadData()
        case 2:
            sortToggles[indexPath.row] = value
            for path in 0...2 {
                if (path != indexPath.row) {
                    sortToggles[path] = false
                }
            }
            tableView.reloadData()
        case 3:
            categoryToggles[indexPath.row] = value
        default:
            break
        }
    }
    
}
