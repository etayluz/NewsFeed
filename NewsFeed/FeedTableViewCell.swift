//
//  FeedTableViewCell.swift
//  NewsFeed
//
//  Created by Etay Luz on 11/12/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var headlineLabel: UILabel!
  @IBOutlet weak var taglineLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var feedArticleItem: FeedArticleItem! {
    didSet {
      headlineLabel.text = feedArticleItem.headline
      taglineLabel.text = feedArticleItem.snippet
      dateLabel.text = feedArticleItem.date
      
      if let thumbnailUrl = feedArticleItem.thumbnailUrl {
        let url = NSURL(string: thumbnailUrl)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

        dispatch_async(dispatch_get_global_queue(priority, 0)) {
          if let imageData = NSData(contentsOfURL: url!) {
            dispatch_async(dispatch_get_main_queue()) {
              self.thumbnailImageView.image = UIImage(data: imageData)
            }
          }
        }
      }
      

    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func prepareForReuse() {
    thumbnailImageView = nil
    thumbnailImageView.backgroundColor = UIColor.redColor()
  }
  
  func configureWithArticleItem(feedArticleItem:FeedArticleItem) {
    headlineLabel.text = feedArticleItem.headline!
    taglineLabel.text = feedArticleItem.snippet
    dateLabel.text = feedArticleItem.date
    
    if let thumbnailUrl = feedArticleItem.thumbnailUrl {
      let url = NSURL(string: thumbnailUrl)
      
      let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
      
      dispatch_async(dispatch_get_global_queue(priority, 0)) {
        if let imageData = NSData(contentsOfURL: url!) {
          dispatch_async(dispatch_get_main_queue()) {
            self.thumbnailImageView.image = UIImage(data: imageData)
          }
        }
      }
    }

  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
