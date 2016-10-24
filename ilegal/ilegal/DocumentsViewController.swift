//
//  DocumentsViewController.swift
//  ilegal
//
//  Created by Yoo Jin Lee on 9/12/16.
//  Copyright © 2016 Yoo Jin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DocumentsViewController: UITableViewController {

    var formList = [Form]()
    var filteredForms = [Form]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "formCell")
        populateForms()
        
        //Set-Up searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
            return filteredForms.count
        }
        return formList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "formCell"
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let form: Form
        if searchController.isActive && searchController.searchBar.text != "" {
            form = filteredForms[indexPath.row]
        } else {
            form = formList[indexPath.row]
        }
        cell.textLabel?.text = form.title
        cell.detailTextLabel?.text = form.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "PreviewPDFViewController") as! PreviewPDFViewController
        destination.title = formList[(indexPath as NSIndexPath).item].title
        let backItem = UIBarButtonItem()
        backItem.title = ""
        destination.currentForm = formList[(indexPath as NSIndexPath).item]
        destination.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredForms = formList.filter {
            form in
            return form.title.lowercased().hasPrefix(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func populateForms()
    {
        Alamofire.request("http://159.203.67.188:8080/Dev/ListPDF?Type=2&Category=" + self.title!).responseJSON { response in
            switch response.result {
            case .success(let value):
                let outcome = JSON(value)
                print("JSON: \(outcome)")
                var list = outcome["PDFS"].arrayObject
                let pdfCount:Int = (list?.count)!
                for i in 0...(pdfCount-1) {
                    var current = list?[i] as! [String]
                    let tempPDF:Form = Form()
                    tempPDF.title = current[0]
                    tempPDF.location = current[1]
                    tempPDF.id = current[2]
                    self.formList.append(tempPDF)
                }
            case .failure(let error):
                print(error)
            }
        }

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

extension DocumentsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
