//
//  ColorsVC.swift
//  ColourLoveSwift
//
//  Created by Alexis Creuzot on 17/11/2015.
//  Copyright © 2015 alexiscreuzot. All rights reserved.
//

import UIKit
import SVProgressHUD

class ColorsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var colors:Array<RLMObject> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Colors"
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // We check the database, and proceed to do a web request
        // if the database doesn't return any results
        if (self.colors.count == 0) {
            self.requestColors()
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(self.tableView.indexPathForSelectedRow != nil){
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    // MARK: - Network
    
    func requestColors()
    {
        SVProgressHUD.show()
        Color.fetch(self.searchBar.text!) { (result,error) -> Void in
            if(error != nil){
                SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
            }else{
                self.colors = result!
                self.tableView.reloadData()
                SVProgressHUD.showSuccessWithStatus("Done")
            }
        }
    }
    
    // MARK: - TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.colors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let color:Color = self.colors[indexPath.row] as! Color
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ColorCell.className(), forIndexPath: indexPath)
        (cell as! ColorCell).setColor(color)
        return cell;
    }
    
    // MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ColorCell.height()
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.requestColors()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
