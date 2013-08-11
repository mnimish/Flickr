//
//  FlickrViewController.h
//  Flickr
//
//  Created by Nimish Manjarekar on 8/10/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@end
