//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var businesses: [Business]!
    var filters: [String : Any]!
    
    var categoryToggles = [Int:Bool]()
    var sortToggles = [Int:Bool]()
    var dealToggles = [Int:Bool]()
    var distanceToggles = [Int:Bool]()
    
    var limit = 0
    var offset = 0

    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        
        Business.searchWithTerm(term: "Restaurants", limit: limit, offset: offset) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
            self.offset = businesses?.count ?? 0
        }
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
        if let barButton = sender as? UIBarButtonItem {
            if barButton.title == "Filters" {
                //Do what you want
   
                let filtersViewController = navigationController.topViewController as! FiltersViewController
        
                filtersViewController.delegate = self
                filtersViewController.categoryToggles = self.categoryToggles
                filtersViewController.sortToggles = self.sortToggles
                filtersViewController.distanceToggles = self.distanceToggles
                filtersViewController.dealToggles = self.dealToggles
            } else {
                let mapViewController = navigationController.topViewController as! MapViewController
                
                mapViewController.businesses = self.businesses
            }
        }
    }
    
    
    @IBAction func onMapSelected(_ sender: Any) {
        
    }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any], categoryFilters categoryToggles: [Int:Bool],
                               sortFilters sortToggles: [Int:Bool],
                               distanceFilters distanceToggles: [Int:Bool],
                               dealFilters dealToggles: [Int:Bool]) {
        let categories = filters["categories"] as? [String]
        let sort = filters["sortMode"] as? YelpSortMode
        let distance = filters["distance"] as? Int
        let deals = filters["deals"] as? Bool
        
        self.categoryToggles = categoryToggles;
        self.sortToggles = sortToggles;
        self.distanceToggles = distanceToggles;
        self.dealToggles = dealToggles;
        
        self.filters = filters
        
        offset = 0
        
        Business.searchWithTerm(term: "Restaurants " + self.searchBar.text!, limit: limit, offset: offset, sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offset = 0
        searchBar.resignFirstResponder()
        loadData(searchText: self.searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        offset = 0
        loadData(searchText: searchBar.text!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData(searchText: searchBar.text!)
            }
        }
    }
    
    func loadData(searchText: String) {
        if filters != nil {
            let categories = filters["categories"] as? [String] ?? nil
            let sort = filters["sortMode"] as? YelpSortMode ?? nil
            let distance = filters["distance"] as? Int ?? nil
            let deals = filters["deals"] as? Bool ?? nil
            
            Business.searchWithTerm(term: "Restaurants " + searchText, limit: limit, offset: self.offset, sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error: Error?) in
                self.businesses = businesses
                self.offset = (businesses?.count)!
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            }
        } else {
            Business.searchWithTerm(term: "Restaurants " + searchText, limit: limit , offset: self.offset, completion: { (businesses: [Business]?, error: Error?) in
                self.businesses = businesses
                self.offset = (businesses?.count)!
                self.tableView.reloadData()
                self.isMoreDataLoading = false

            })
        }
        

    }
    
    func loadMoreData(searchText: String) {
        if filters != nil {
            let categories = filters["categories"] as? [String] ?? nil
            let sort = filters["sortMode"] as? YelpSortMode ?? nil
            let distance = filters["distance"] as? Int ?? nil
            let deals = filters["deals"] as? Bool ?? nil
            
            Business.searchWithTerm(term: "Restaurants " + searchText, limit: limit, offset: self.offset, sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]?, error: Error?) in
                for business in businesses! {
                    self.businesses.append(business)
                }
                self.offset = (self.businesses?.count)!
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            }
        } else {
            Business.searchWithTerm(term: "Restaurants " + searchText, limit: limit , offset: self.offset, completion: { (businesses: [Business]?, error: Error?) in
                for business in businesses! {
                    self.businesses.append(business)
                }
                self.offset = (self.businesses?.count)!
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            })
        }

    }
}
