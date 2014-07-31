//
//  BeaconManagerDelegate.h
//  KlickBeacon
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@protocol BeaconManagerDelegate <NSObject>

-(void)didReceiveBeacon:(Beacon*)beacon;
-(void)fetchingBeaconFailedWithError:(NSError*)error;

@end
