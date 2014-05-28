//
//  EditCellViewController.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCellViewController : UITableViewController

@property NSString * title;
@property NSString * label;
@property NSString * editValue;
@property NSString * instructions;
@property (nonatomic, copy) void (^onComplete)(NSString* value);

@end
