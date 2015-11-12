//  NewsFeed
//
//  Created by Etay Luz on 11/12/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import UIKit

struct GlobalConstants {
  static let articleSearchApi = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
  static let apiKey = "32a4d3342b658b316d4b1369d04a6e5b:16:73440927"
  
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var tableView: UITableView!
  
  var articleList = [[NSObject: AnyObject]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchArticleFeed()
    
    // Register Class for Cell Reuse
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
  }
  
  func fetchArticleFeed() {
    for page in 1...5 {
      let url = NSURL(string: GlobalConstants.articleSearchApi + "&page=" + String(page) + "&fq=document_type:(article)&sort=newest&api-key=" + GlobalConstants.apiKey)
      
      let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        do {
          if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
            if let articleItems = jsonResult["response"]!["docs"]! as? [[NSObject: AnyObject]] {
              self.articleList = self.articleList + articleItems
            }
          }
        } catch {
          print(error)
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
    let item = articleList[indexPath.row]

    
    // Dequeue Table View Cell
    let tableViewCell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
    
    // Configure Table View Cell
    //    tableViewCell.textLabel?.text = item
    
    return tableViewCell
  }
  
}
