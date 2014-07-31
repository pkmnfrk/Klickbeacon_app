//
//  KlickAPI.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-30.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlickAPI : NSObject
+(KlickAPI*)default;

-(void)pingBeaconWithUUID:(NSString*)uuid major:(NSUInteger)major minor:(NSUInteger)minor;
-(void)setClientName:(NSString*)name;
@end
