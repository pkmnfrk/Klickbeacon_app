//
//  FirstViewController.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KlickBeacon/BeaconManagerDelegate.h"

@interface MapViewController : UIViewController <BeaconManagerDelegate>
-(void)loadMap;
@end
