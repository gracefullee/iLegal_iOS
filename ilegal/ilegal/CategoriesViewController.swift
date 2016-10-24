//
//  CategoriesViewController.swift
//  ilegal
//
//  Created by ITP on 9/12/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoriesViewController: UITableViewController {

    var categoriesList = [String]()
    var filteredCategories = [String]()
    
    let searchController = UISearchController(searchResultsController:  nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoriesCell")
        
        Alamofire.request("http://159.203.67.188:8080/Dev/ListPDF?Type=1").responseJSON { response in
            switch response.result {
            case .success(let value):
                let outcome = JSON(value)
                self.categoriesList = outcome["Categories"].arrayObject as! [String]
            case .failure(let error):
                print(error)
            }
        }
        
        //Set-Up searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCategories.count
        }
        return categoriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        let category: String
        if searchController.isActive && searchController.searchBar.text != "" {
            category = filteredCategories[indexPath.row]
        } else {
            category = categoriesList[indexPath.row]
        }
        cell.textLabel?.text = category
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        destination.title = categoriesList[(indexPath as NSIndexPath).item]
        navigationController?.pushViewController(destination, animated: true)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredCategories = categoriesList.filter {
            category in
            return category.lowercased().hasPrefix(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
