//
//  ResultsViewController.h
//  ChatDemo
//
//  Created by acumen on 16/8/25.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController<UISearchResultsUpdating>

@property (strong,nonatomic) NSArray *dataSource;

@end
