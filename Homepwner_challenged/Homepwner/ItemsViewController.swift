//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Павел Собянин on 04.10.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    let sectionHeaders = ["Cheap", "Expensive"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemStore.allItems.count
        return itemStore.allItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        /*if indexPath.section == sectionHeaders.count { //&& indexPath.row == 2 {
            let endingCell = TableViewEndingCell()
            return endingCell
        }*/
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        
        //let item = itemStore.allItems[indexPath.row]
        //print (indexPath.section)
        //print (indexPath.row)
        let item = itemStore.allItems[indexPath.section][indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        //cell.textLabel?.font =
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        //cell.backgroundColor = .alpha // = cell.backgroundColor?.withAlphaComponent(0)
        //cell.alpha = 1
        //cell.heightAnchor = 80
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < sectionHeaders.count {
            return sectionHeaders[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /*override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == sectionHeaders.count - 1 {

        }
        return nil
    } */
    
    //override func tableViewFont
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        //tableView.backgroundColor = UIColor.red
        
        let customLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        //customView.backgroundColor = UIColor.red
        customLabel.text = "No more items!"
        customLabel.textAlignment = .center
        tableView.tableFooterView = customLabel
        
        //return customLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemStore.allItems.count
    }
}
