//
//  Beacon.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon
-(NSDictionary*)toDictionary {
    return @{
             @"_id": self.beaconId,
             @"uuid": self.uuid,
             @"major": [NSNumber numberWithInteger:self.major],
             @"minor": [NSNumber numberWithInteger:self.minor],
             @"bodyText": self.bodyText,
             @"title": self.title,
             @"image": self.image
             
             };
}
@end
