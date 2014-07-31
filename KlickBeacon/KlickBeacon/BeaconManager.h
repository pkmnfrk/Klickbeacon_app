//
//  BeaconManager.h
//  KlickBeacon
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeaconManagerDelegate.h"
#import "BeaconCommunicatorDelegate.h"

@class BeaconCommunicator;

@interface BeaconManager : NSObject<BeaconCommunicatorDelegate>
@property(strong,nonatomic) BeaconCommunicator* communicator;
@property(weak, nonatomic) id<BeaconManagerDelegate> delegate;

-(void)fetchBeaconsWithUUID:(NSUUID*)uuid major:(NSInteger)major minor:(NSInteger)minor;
-(void)fetchBeaconWithId:(NSString*)beaconId;
@end
