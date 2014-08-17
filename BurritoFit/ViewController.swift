//
//  ViewController.swift
//  BurritoFit
//
//  Created by Will Fleming on 8/17/14.
//  Copyright (c) 2014 Will Fleming. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!
                            
  override func viewDidLoad() {
    super.viewDidLoad()

    let url = NSURL(string: "https://YOUR_DOMAIN")
    let request = NSURLRequest(URL: url)
    webView.loadRequest(request)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

