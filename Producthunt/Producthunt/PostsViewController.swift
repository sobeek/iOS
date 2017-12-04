//
//  PostsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit
import YNDropDownMenu

class PostsViewController: UITableViewController {
    
    var postStore: PostStore!
    var postFetcher: DataFetcher!
    var imageDownloader = ImageDownloader()
    
    @IBAction func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Refreshed")
        loadData()
        refreshControl.endRefreshing()
        //add launch of new request to Producthunt
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.refreshControl(
        return postStore.posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Fill table...")
        
        if indexPath.row == 0 {
            //let cell = tableView.dequeueReusableCell(withIdentifier: "topic")!
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "topics")
            
            cell.detailTextLabel?.text = CategorySelectionViewController.selectedCategory["name"]
            cell.textLabel?.text = "Select topic"
//            let product = productStore.products[indexPath.row]
//
//            cell.textLabel?.text = product.title
//            cell.detailTextLabel?.text = product.desc

            //let imageDownloader = ImageDownloader()
            //imageDownloader.imageDownload(url: product.thumbnailURL, imageView: cell.thumbnail)

            return cell

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostCell
            //cell.thumbnail = UIImageView()
            
            let post = postStore.posts[indexPath.row - 1]
            
            cell.postTitle.text = post.title
            cell.descriptionTitle.text = post.desc
            cell.thumbnail.image = nil
            
//            cell.textLabel?.text = post.title
//            cell.detailTextLabel?.text = post.desc
//            cell.imageView?.image = nil
            
            imageDownloader.imageDownload(url: post.thumbnailURL, imageView: cell.thumbnail)
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        postFetcher.fetch(method: .posts, url: ProductHunterAPI.getPosts) { (fetchingResult) -> Void in
            switch fetchingResult {
            case let .success(posts):
                self.postStore.posts = posts as! [Post]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Successfully found \(posts.count) posts.")
            case let .failure(error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "showCategoryList", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier)
        switch segue.identifier {
        case "showPostDetails"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let post = postStore.posts[row - 1]
                let detailViewController = segue.destination as! PostDetailsViewController
                detailViewController.post = post
            }
        case "showCategoryList"?:
            if (tableView.indexPathForSelectedRow?.row) != nil {
                print("Go to topic list...")
                let vc = segue.destination as! CategorySelectionViewController
                vc.categoriesFetcher = DataFetcher()
                vc.categoryList = CategoryList()
                // Get the item associated with this row and pass it along
                //let product = productStore.products[row]
                //let topicSelectionViewController = segue.destination as! TopicSelectionViewController
                //detailViewController.product = product
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
