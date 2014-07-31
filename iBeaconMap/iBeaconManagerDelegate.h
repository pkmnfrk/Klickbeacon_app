//
//  iBeaconManagerDelegate.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-06-13.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NumberTuple.h"

@class iBeaconManager;

@protocol iBeaconManagerDelegate <NSObject>

@optional

-(void)iBeaconManager:(iBeaconManager*)manager didEnterRegion:(CLRegion*)region;
-(void)iBeaconManager:(iBeaconManager*)manager didExitRegion:(CLRegion*)region;
-(void)iBeaconManager:(iBeaconManager*)manager didChooseNewBestBeacon:(NumberTuple*)beacon inRegion:(CLRegion*)region;

@end
