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
  //  var siteRoot = "https://YOUR_DOMAIN"
  var siteRoot = "http://sigyn.local:5000"
  var appSecretHeader = "X-AppSecret"
  var defaultsKey = "apiToken"
  var appSecret = "YOUR_SECRET"

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.scrollView.scrollEnabled = false
    webView.scrollView.bounces = false

    let url = NSURL(string: "\(siteRoot)/app_dashboard")
    let request = NSURLRequest(URL: url)
    webView.loadRequest(request)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // UIWebView delegate methods
  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    let inOurDomain = request.URL.absoluteString.hasPrefix(siteRoot)
    let headerIsPresent = (nil != request.allHTTPHeaderFields[appSecretHeader])
    if (!inOurDomain || headerIsPresent) {
      return true
    }

    // if header not present, cancel this request, schedule a new one with the header
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      var mutableRequest = NSMutableURLRequest(URL: request.URL)
      mutableRequest.addValue(self.appSecret, forHTTPHeaderField: self.appSecretHeader)

      let defaults = NSUserDefaults.standardUserDefaults()
      if(!defaults.stringForKey(self.defaultsKey).isEmpty) {
        mutableRequest.addValue(defaults.stringForKey(self.defaultsKey), forHTTPHeaderField: "X-ApiToken")
      }

      webView.loadRequest(mutableRequest)
    })
    return false
  }

  func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
    NSLog("webView didFailLoadWithError: %@", error)
  }

  func webViewDidFinishLoad(webView: UIWebView!) {
    NSLog("webViewDidFinishLoad")

    let urlString = webView.request.URL.absoluteString
    if (urlString.hasSuffix("finished_sign_in")) {
      // we should be able to pull the API token from the page & store it
      let js = "document.getElementById('api-info').innerHTML"
      let jsonStr = webView.stringByEvaluatingJavaScriptFromString(js)
      let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
      let jsonDict = NSJSONSerialization.JSONObjectWithData(
        jsonData, options: NSJSONReadingOptions(), error: nil
      ) as? Dictionary<String, String>
      if( nil != jsonDict ) {
        // write the token to defaults for future runs
        let apiToken = jsonDict!["api_token"]
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(apiToken, forKey: defaultsKey)

        // register the device token with the server for notifications
        //TODO
      } else {
        NSLog("Got an unexpected type of object parsing json: %@", jsonStr)
      }
    }
  }

}

