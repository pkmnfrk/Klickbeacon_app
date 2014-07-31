//
//  User.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Beacon;

@interface User : NSObject
@property (strong, nonatomic) NSString * clientid;
@property (strong,nonatomic) NSString * name;
@property (strong, nonatomic) Beacon * beacon;
@property (strong, nonatomic) NSDate * latestPingDate;
@property (strong, nonatomic) NSString * latestPingBeaconId;

+(User *)userWithName:(NSString *)name andBeacon:(Beacon*)beacon;
+(User *)userFromJSON:(NSDictionary*)json;
+(NSArray *)usersFromJSON:(NSArray*)json;


@end
