//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Павел Собянин on 17.02.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    /* override func loadView() {
        super.loadView()
        webView = WKWebView()
        
        view.addSubview(webView)
        
        
    } */
    
    override func loadView() {
        //let webConfiguration = WKWebViewConfiguration()
        // super.loadView()
        webView = WKWebView()
        view = webView
        print ("Web Controller loaded its view1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("Web Controller loaded its view")
                
        let myURL = URL(string: "https://www.sports.ru")
        let request = URLRequest(url: myURL!)
        
        webView.load(request)
    }
    
}
