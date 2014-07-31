//
//  iBeaconManager.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-06-13.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "iBeaconManager.h"

@interface iBeaconManager () <CLLocationManagerDelegate> {
    NSMutableDictionary * beaconData;
}

@property CLLocationManager * locationManager;

@end

@interface iBeaconData : NSObject

@property (strong, nonatomic) NSMutableArray * data;
@property (strong, nonatomic) NumberTuple * previousBest;
@property (nonatomic) iBeaconOption options;
@property (nonatomic) BOOL notifiedEntered;
@end

@implementation iBeaconData

-(id)init {
    self = [super init];
    
    if(self) {
        _data = [NSMutableArray new];
    }
    
    return self;
}

@end

@implementation iBeaconManager

-(id)init {
    self = [super init];
    if(self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //beaconData = [NSMutableArray arrayWithCapacity:31];
        beaconData = [NSMutableDictionary new];
    }
    return self;
}

-(void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString *)identifier {
    [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:identifier options:0];
}

-(void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString *)identifier options:(iBeaconOption)options {
    
    CLBeaconRegion * beaconRegion = [beaconData valueForKey:proximityUUID.UUIDString];
    if(beaconRegion) return;
    
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    iBeaconData * data = [iBeaconData new];
    data.options = options;
    
    [beaconData setObject:data forKey:proximityUUID.UUIDString];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    
    [self.locationManager requestStateForRegion:beaconRegion];
    
    if(![CLLocationManager isRangingAvailable]) {
        NSLog(@"Ranging is not available");
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization status changed: %d", status);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Did start monitoring for region");
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring did fail for region: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    iBeaconData * data = [beaconData objectForKey:region.proximityUUID.UUIDString];
    
    if(!data) {
        NSLog(@"Got data for unknown beacon region??");
        return;
    }
    
   // CLBeaconRegion * first = [beacons firstObject];
    NSUInteger added = 0;
    
    if(beacons.count) {
        for(CLBeacon * first in beacons) {
            if([first proximity] > CLProximityUnknown) {
                
                if((data.options & ibeaconOptionMustBeClose) && first.proximity > CLProximityNear) {
                    NSLog(@"Skipping beacon %@.%@", [first major], [first minor]);
                    continue;
                }
                
                NSLog(@"Did range a beacon: %@.%@", [first major], [first minor]);
                [data.data insertObject:[NumberTuple tupleWith:first.major and:first.minor] atIndex:0];
                
                
                added++;
            }
        }
    } else {
        [data.data insertObject:[NSNull null] atIndex:0];
    }

    if(added && !data.notifiedEntered){
        id<iBeaconManagerDelegate> delegate = _delegate;
        if(delegate && [delegate respondsToSelector:@selector(iBeaconManager:didEnterRegion:)]) {
            [delegate iBeaconManager:self didEnterRegion:region];
            data.notifiedEntered = YES;
        }
    } else if(!added) {
        id<iBeaconManagerDelegate> delegate = _delegate;
        if(delegate && [delegate respondsToSelector:@selector(iBeaconManager:didExitRegion:)]) {
            [delegate iBeaconManager:self didExitRegion:region];
            data.notifiedEntered = NO;
        }

    }
    
    while([data.data count] > 10 * added) {
        [data.data removeLastObject];
    }
    
    NSLog(@"Retaining %d samples", [data.data count]);
    
    BOOL isIndeterminate;
    NumberTuple * newest = [self bestBeacon:data.data isIndeterminate:&isIndeterminate];
    
    if(!isIndeterminate && newest != data.previousBest) {
        data.previousBest = newest;
        if(0 == (data.options & iBeaconOptionOnlyMonitorRegion)) {
            id<iBeaconManagerDelegate> delegate = self.delegate;
            if(delegate && [delegate respondsToSelector:@selector(iBeaconManager:didChooseNewBestBeacon:inRegion:)]) {
                [delegate iBeaconManager:self didChooseNewBestBeacon:data.previousBest inRegion:region];
            }
        }
    }
}
/*
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Received region enter");
    id<iBeaconManagerDelegate> delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(iBeaconManager:didEnterRegion:)]) {
        [delegate iBeaconManager:self didEnterRegion:region];
    }
    
    //if([CLLocationManager isRangingAvailable]) {
    //    [manager startRangingBeaconsInRegion:beaconRegion];
    //}
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Received region exit");
    id<iBeaconManagerDelegate> delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(iBeaconManager:didExitRegion:)]) {
        [delegate iBeaconManager:self didExitRegion:region];
    }
    
    [manager stopRangingBeaconsInRegion:beaconRegion];
    [beaconData removeAllObjects];
    previousBestBeacon = nil;
}
 */

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    CLBeaconRegion * beaconRegion = (CLBeaconRegion *)region;
    
    iBeaconData * data = [beaconData objectForKey:beaconRegion.proximityUUID.UUIDString];
    
    if(!data) {
        NSLog(@"Got data for unknown beacon region??");
        return;
    }
    
    NSLog(@"Did determine state of region (it's %d)", state);
    id<iBeaconManagerDelegate> delegate = _delegate;
    
    if(state == CLRegionStateInside) {
        
        //if they don't want to be close to the beacon, then hide the real enter event
        if(0 == (data.options & ibeaconOptionMustBeClose) &&
           delegate &&
           [delegate respondsToSelector:@selector(iBeaconManager:didEnterRegion:)]) {
            
            [delegate iBeaconManager:self didEnterRegion:region];
            data.notifiedEntered = YES;
        }
        
        if([CLLocationManager isRangingAvailable]) {
            [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
        }
    } else if(state == CLRegionStateOutside) {
        if(data.notifiedEntered && delegate && [delegate respondsToSelector:@selector(iBeaconManager:didExitRegion:)]) {
            
            [delegate iBeaconManager:self didExitRegion:region];
            data.notifiedEntered = NO;
        }

        [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
        [data.data removeAllObjects];
        data.previousBest = nil;
        
    }
    
}

-(NumberTuple *)bestBeacon:(NSMutableArray*)beaconDataArray isIndeterminate:(BOOL*)isIndeterminate {
    NSCountedSet * bag = [NSCountedSet setWithArray:beaconDataArray];
    
    id ret;
    NSUInteger highest = 0;
    NSUInteger secondHighest = 0;
    
    for(id b in bag) {
        NSUInteger count = [bag countForObject:b];
        
        if(count > highest) {
            ret = b;
            secondHighest = highest;
            highest = [bag countForObject:b];
        } else if(count > secondHighest) {
            secondHighest = count;
        }
    }
    if(ret == [NSNull null]) {
        *isIndeterminate = NO;
        return nil;
    }
    if(highest * 3 < [beaconDataArray count]) {
        *isIndeterminate = YES;
        return nil;
    }
    
    *isIndeterminate = NO;
    return ret;
}



@end
