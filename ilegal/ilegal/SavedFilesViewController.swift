//
//  SavedFilesViewController.swift
//  ilegal
//
//  Created by Tae Ha Lee on 10/16/16.
//  Copyright © 2016 Jordan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SavedFilesViewController: UITableViewController {
    
    var filteredSavedFiles = [Form]()
    var deleteFileIndex:IndexPath? = nil
    
    let searchController = UISearchController(searchResultsController:  nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "savedFileCell")

        //Set-Up searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSavedFiles.count
        }
        return User.currentUser.myFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "savedFileCell"
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let form: Form
        if searchController.isActive && searchController.searchBar.text != "" {
            form = filteredSavedFiles[indexPath.row]
        } else {
            form = User.currentUser.myFiles[indexPath.row]
        }
        cell.textLabel?.text = form.title
        cell.detailTextLabel?.text = form.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "ViewPDFViewController") as! ViewPDFViewController
        destination.title = User.currentUser.myFiles[(indexPath as NSIndexPath).item].title
        let backItem = UIBarButtonItem()
        backItem.title = ""
        let editItem = UIBarButtonItem()
        editItem.title = "Edit"
        destination.navigationItem.backBarButtonItem = backItem
        destination.navigationItem.rightBarButtonItem = editItem
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredSavedFiles = User.currentUser.myFiles.filter {
            form in
            return form.title.lowercased().hasPrefix(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    //Add Delete when cell is swiped to the left
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            deleteFileIndex = indexPath
            let fileToDelete = User.currentUser.myFiles[indexPath.row].title
            confirmDelete(fileToDelete: fileToDelete!)
        }
    }
    
    func confirmDelete(fileToDelete: String) {
        let alert = UIAlertController(title: "Delete Saved File", message: "Are you sure you want to permanently delete \(fileToDelete)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDelete)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteFileIndex {
            tableView.beginUpdates()
            
            User.currentUser.myFiles.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteFileIndex = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteFileIndex = nil
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

extension SavedFilesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
