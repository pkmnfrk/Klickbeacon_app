//
//  OptionTableViewCell.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@end
