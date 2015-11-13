//
//  ArticleViewController.swift
//  NewsFeed
//
//  Created by Etay Luz on 11/13/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import UIKit
import PKHUD

class ArticleViewController: UIViewController, UIWebViewDelegate {
  @IBOutlet var articleWebView: UIWebView!
  @IBOutlet var articleTitleLabel: UILabel!

  var articleItem:FeedArticleItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    articleTitleLabel.text = articleItem.headline!
    
    let url = NSURL(string: articleItem.webUrl!)
    let requestObj = NSURLRequest(URL: url!)
    articleWebView.loadRequest(requestObj);
    
    PKHUD.sharedHUD.contentView = PKHUDProgressView()
    PKHUD.sharedHUD.show()
    
  }
  
  //MARK: - Web View Protocol
  func webViewDidFinishLoad(webView: UIWebView)
  {
    PKHUD.sharedHUD.hide()
  }
  
  //MARK: - Actions
  @IBAction func backButtonPressed(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)

  }

  
}