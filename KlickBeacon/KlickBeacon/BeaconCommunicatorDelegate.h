//
//  BeaconCommunicatorDelegate.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeaconCommunicatorDelegate <NSObject>
- (void)receivedBeaconJSON:(NSData*)objectNotation;
- (void)fetchingBeaconFailedWithError:(NSError*)error;
- (void)imageLoadedForBeacon:(Beacon*)beacon withError:(NSError*)error;
@end
