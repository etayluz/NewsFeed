//  NewsFeed
//
//  Created by Etay Luz on 11/12/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import UIKit

private let feedCellReuseIdentifier: String = "FeedCellReuseIdentifier"
private let articleSearchApi = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
private let apiKey = "32a4d3342b658b316d4b1369d04a6e5b:16:73440927"

struct FeedArticleItem  {
  
  var identifier : String?
  var webUrl : String?
  var thumbnailUrl : String?
  var date : String?
  var headline : String?
  var snippet : String?
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var articleListTableView: UITableView!
  
  var articleList = [FeedArticleItem]()
  var fetchErrorShown : Bool? = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchArticleFeed()
    
    // Register Class for Cell Reuse
    articleListTableView.registerClass(FeedTableViewCell.self, forCellReuseIdentifier: feedCellReuseIdentifier)
  }
  
  func fetchArticleFeed() {
    for page in 1...5 {
      let url = NSURL(string: articleSearchApi + "&page=" + String(page) + "&fq=document_type:(article)&sort=newest&api-key=" + apiKey)
      
      let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        do {
          if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
            if let jsonArticleItems = jsonResult["response"]!["docs"]! as? [[String: AnyObject]] {
              for jsonArticleItem in jsonArticleItems {
                var feedArticleItem = FeedArticleItem()
                feedArticleItem.identifier = jsonArticleItem["_id"]! as? String
                feedArticleItem.webUrl = jsonArticleItem["web_url"] as? String
                if let multimediaArray = jsonArticleItem["multimedia"] as? NSArray {
                  if let thumbnailMetadata = multimediaArray.lastObject {
                    feedArticleItem.thumbnailUrl = thumbnailMetadata["url"] as? String
 
                  }
                }
                feedArticleItem.date = jsonArticleItem["pub_date"]! as? String
                feedArticleItem.date = feedArticleItem.date!.substringToIndex(feedArticleItem.date!.startIndex.advancedBy(10))
                feedArticleItem.headline = jsonArticleItem["headline"]!["main"]! as? String
                feedArticleItem.snippet = jsonArticleItem["snippet"]! as? String

                self.articleList.append(feedArticleItem)
              }
            }
            
            if (page == 5) {
                dispatch_async(dispatch_get_main_queue()) {
                  self.articleListTableView.reloadData()
                }
            }
            
          }
        } catch {
          guard (self.fetchErrorShown == false) else {return}
          
          let alert = UIAlertController(title: "Error", message: "Could not reach server", preferredStyle: UIAlertControllerStyle.Alert)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
          dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
          }
          self.fetchErrorShown = true
        }
      }
      
      task.resume()
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

    feedTableViewCell!.configureWithArticleItem(articleItem)
    // Configure Table View Cell
    //    tableViewCell.textLabel?.text = item
    
    return feedTableViewCell!
  }
  
}
