//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var businesses: [Business]!
    var filters: [String : AnyObject]!
    
    var switchStates: [Int:Bool]!
    var searchCategories: [String]!
    var searchDeals: Bool!
    var sortMode: YelpSortMode!
    var distanceAuto: Bool!
    var distancePoint3: Bool!
    var distance1: Bool!
    var distance3: Bool!
    var distance5: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        switchStates = [Int:Bool]()
        searchDeals = false
        sortMode = YelpSortMode.bestMatched
        distanceAuto = true
        distancePoint3 = false
        distance1 = false
        distance3 = false
        distance5 = false
        
        searchWithTermAndFilters(searchTerm: "", filters: ["categories": "" as AnyObject])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell;
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        let navigationController = segue.destination as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        filtersViewController.switchStates = switchStates
        filtersViewController.searchDeals = searchDeals
        filtersViewController.sortMode = sortMode
        filtersViewController.distanceAuto = distanceAuto
        filtersViewController.distancePoint3 = distancePoint3
        filtersViewController.distance1 = distance1
        filtersViewController.distance3 = distance3
        filtersViewController.distance5 = distance5
     }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject],
                               deals: Bool,
                               switchStates: [Int:Bool],
                               sortMode: YelpSortMode,
                               distanceAuto: Bool,
                               distancePoint3: Bool,
                               distance1: Bool,
                               distance3: Bool,
                               distance5: Bool) {
        self.filters = filters
        self.switchStates = switchStates
        searchDeals = deals
        self.sortMode = sortMode
        self.distanceAuto = distanceAuto
        self.distancePoint3 = distancePoint3
        self.distance1 = distance1
        self.distance3 = distance3
        self.distance5 = distance5
        searchWithTermAndFilters(searchTerm: searchBar.text ?? "", filters: filters)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if filters == nil {
            searchWithTermAndFilters(searchTerm: searchText, filters: ["categories" : "" as AnyObject])
        } else {
            searchWithTermAndFilters(searchTerm: searchText, filters: filters)
        }
    }
    
    func searchWithTermAndFilters(searchTerm: String, filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let distance = getDistance()
        Business.searchWithTerm(term: searchTerm, sort: sortMode, categories: categories, deals: searchDeals, distance: distance) { (businesses: [Business]!, error: Error!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    func getDistance() -> Int? {
        var distance: Int?
        
        if (distance5 == true){
            distance = 8050
        } else if (distance3 == true){
            distance = 1610
        } else if (distance1 == true){
            distance = 1200
        } else if (distancePoint3 == true){
            distance = 400
        } else if (distanceAuto == true){
            distance = 0
        } else{
            distance = nil
        }
        return distance
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchWithTermAndFilters(searchTerm: "", filters: filters)
    }
}
