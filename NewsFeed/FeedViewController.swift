//  NewsFeed
//
//  Created by Etay Luz on 11/12/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import UIKit
import PKHUD

private let feedCellReuseIdentifier: String = "FeedTableViewCell"
private let articleSearchApi = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
private let apiKey = "32a4d3342b658b316d4b1369d04a6e5b:16:73440927"


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var articleListTableView: UITableView!
  
  var articleList = [FeedArticleItem]()
  var fetchErrorShown : Bool? = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchArticleFeed()
  }
  
  func fetchArticleFeed() {
    
    PKHUD.sharedHUD.contentView = PKHUDProgressView()
    PKHUD.sharedHUD.show()
    
    var numberOfPageRequests:Int = 5;
    for page in 1...numberOfPageRequests {
      let url = NSURL(string: articleSearchApi + "&page=" + String(page) + "&fq=document_type:(article)&sort=newest&api-key=" + apiKey)
    
      let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        guard (self.fetchErrorShown == false) else {return}
        guard (data != nil) else {
          self.fetchErrorShown = true
          self.showConnectionErrorAlert()
          return
        }

        do {
          if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
            if let jsonArticleItems = jsonResult["response"]!["docs"]! as? [[String: AnyObject]] {
              for jsonArticleItem in jsonArticleItems {
                let feedArticleItem = FeedArticleItem(jsonArticleItem: jsonArticleItem) 
                self.articleList.append(feedArticleItem)
              }
            }
            
            numberOfPageRequests--
            if (numberOfPageRequests == 0) {
                dispatch_async(dispatch_get_main_queue()) {
                  PKHUD.sharedHUD.hide()
                  self.articleListTableView.reloadData()
                }
            }
            
          }
        } catch {
          guard (self.fetchErrorShown == false) else {return}
          self.showConnectionErrorAlert()
          self.fetchErrorShown = true
        }
      }
      
      task.resume()
    }
  }
  
  func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse!) -> Void) {
    print("willCacheResponse was called")
    
    let response: NSURLResponse = proposedResponse.response
    let httpResponse = response as! NSHTTPURLResponse
    let headers = httpResponse.allHeaderFields
    
    var modifiedHeaders = headers
    modifiedHeaders.updateValue("max-age=300", forKey: "Cache-Control")
    let modifiedResponse = NSHTTPURLResponse(URL: httpResponse.URL!, statusCode: httpResponse.statusCode, HTTPVersion: "HTTP/1.1", headerFields: modifiedHeaders as? [String:String])
    let cachedResponse = NSCachedURLResponse(response: modifiedResponse!, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: proposedResponse.storagePolicy)
    completionHandler(cachedResponse)
  }
  
  func showConnectionErrorAlert(){
    dispatch_async(dispatch_get_main_queue()) {
      PKHUD.sharedHUD.hide()
    }
    let alert = UIAlertController(title: "Error", message: "Could not reach server", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
    dispatch_async(dispatch_get_main_queue()) {
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  //MARK: - Segue to Article View Controller
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "ArticleViewControllerSegue") {
      let indexPath = articleListTableView .indexPathForCell(sender as! FeedTableViewCell)
      let articleViewController  = segue.destinationViewController as! ArticleViewController;
      articleViewController.articleItem = articleList[indexPath!.item]
    }
  }
  
  //MARK: - UITableView Delegates and data sources
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articleList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Fetch Item
    let articleItem = articleList[indexPath.row]

    // Dequeue Table View Cell
    let feedTableViewCell = tableView.dequeueReusableCellWithIdentifier(feedCellReuseIdentifier, forIndexPath: indexPath) as? FeedTableViewCell
    feedTableViewCell?.feedArticleItem = articleItem
    
    return feedTableViewCell!
  }
  
}
