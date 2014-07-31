//
//  BeaconManager.m
//  KlickBeacon
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "BeaconManager.h"
#import "BeaconBuilder.h"
#import "BeaconCommunicator.h"

@implementation BeaconManager

-(id)init {
    self = [super init];
    
    if(self) {
        self.communicator = [[BeaconCommunicator alloc] init];
        self.communicator.delegate = self;
    }
    
    return self;
}

-(void)fetchBeaconsWithUUID:(NSUUID *)uuid major:(NSInteger)major minor:(NSInteger)minor {
    [self.communicator fetchBeaconWithUUID:uuid major:major minor:minor];
}

-(void)fetchBeaconWithId:(NSString *)beaconId {
    [self.communicator fetchBeaconWithId:beaconId];
}

-(void)fetchingBeaconFailedWithError:(NSError *)error {
    if(self.delegate) {
        [self.delegate fetchingBeaconFailedWithError:error];
    }
}

-(void)receivedBeaconJSON:(NSData *)objectNotation {
    NSError * error;
    
    Beacon* beacon = [BeaconBuilder beaconFromJSON:objectNotation error:&error];
    if(error && self.delegate) {
        [self.delegate fetchingBeaconFailedWithError:error];
        return;
    }
    
    
    if(beacon) {
        if(beacon.image) {
            [self.communicator fetchImageForBeacon:beacon];
        } else {
            [self.delegate didReceiveBeacon:beacon];
        }
    }
}

-(void)imageLoadedForBeacon:(Beacon *)beacon withError:(NSError *)error
{
    [self.delegate didReceiveBeacon:beacon];
}

@end
