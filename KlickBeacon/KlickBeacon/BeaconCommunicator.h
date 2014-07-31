//
//  BeaconCommunicator.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeaconCommunicatorDelegate;
@class Beacon;

@interface BeaconCommunicator : NSObject
@property (weak, nonatomic) id<BeaconCommunicatorDelegate> delegate;

-(void)fetchBeaconWithUUID:(NSUUID*)uuid major:(NSInteger)major minor:(NSInteger)minor;
-(void)fetchBeaconWithId:(NSString*)beaconid;

-(void)fetchImageForBeacon:(Beacon*)beacon;

@end
