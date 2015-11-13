//
//  FeedTableViewCell.swift
//  NewFeed
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func prepareForReuse() {
    thumbnailImageView = nil
    thumbnailImageView.backgroundColor = UIColor.redColor()
  }
  
  func configureWithArticleItem(feedArticleItem:FeedArticleItem) {
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
