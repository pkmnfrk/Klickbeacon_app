//
//  BeaconBuilder.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@interface BeaconBuilder : NSObject


+ (Beacon *)beaconFromJSON:(NSData*)objectNotation error:(NSError**)error;

@end
