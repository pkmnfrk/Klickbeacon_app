//
//  iBeaconManager.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-06-13.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iBeaconManagerDelegate.h"

typedef enum : NSUInteger {
    iBeaconOptionOnlyMonitorRegion = 1,
    ibeaconOptionMustBeClose = 2
} iBeaconOption;

@interface iBeaconManager : NSObject

@property (weak, nonatomic) id<iBeaconManagerDelegate> delegate;

-(void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString *)identifier;
-(void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString *)identifier options:(iBeaconOption)options;


@end
