//
//  DetailViewController.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KlickBeacon/Beacon.h"
#import "Marker.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) Marker * marker;
@end
