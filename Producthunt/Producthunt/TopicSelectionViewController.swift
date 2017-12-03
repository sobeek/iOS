//
//  TopicSelectionViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 02.12.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit
//import YNDropDownMenu

class TopicSelectionViewController: UITableViewController {
    
    var topicList: TopicList!
    var topicsFetcher: DataFetcher!
    static var selectedTopic = "tech"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        loadData()
    }
    
    func loadData() {
        topicsFetcher.fetch(method: .topics, url: ProductHunterAPI.getTopics) { (fetchingResult) -> Void in
            switch fetchingResult {
            case let .success(topics):
                self.topicList.topics = (topics as! [Topic]).sorted(by: {$0.name < $1.name})
                //self.topicList.topics.sort(by: {$0.name < $1.name})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Successfully found \(topics.count) topics.")
            case let .failure(error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.refreshControl(
        return topicList.topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let topic = topicList.topics[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "topics")
        
        //cell.detailTextLabel?.text = TopicSelectionViewController.selectedTopic
        cell.textLabel?.text = topic.name
        
        return cell
        
    }
    
    //YNDropdownmenu()
}
