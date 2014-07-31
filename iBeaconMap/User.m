//
//  User.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "User.h"

@implementation User

+(User *)userWithName:(NSString *)name andBeacon:(Beacon *)beacon {
    User* ret = [[User alloc] init];
    ret.name = name;
    ret.beacon = beacon;
    return ret;
}

+(User *)userFromJSON:(NSDictionary*)json {
    User * user = [[User alloc] init];
    
    user.clientid = [json objectForKey:@"clientid"];
    user.name = [json objectForKey:@"name"];
    if(user.name == (NSString*)[NSNull null]) {
        user.name = @"Unnamed";
    }
    user.latestPingDate = nil;
    user.latestPingBeaconId = nil;
    user.beacon = nil;
    
    if([[json objectForKey:@"pings"] count] > 0) {
        
        static NSDateFormatter * formatter = nil;
        if(formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"un_US_POSIX"]];
            [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        
        NSArray * pings = [json objectForKey:@"pings"];
        NSDictionary * ping = [pings firstObject];
        NSString * dateStr = [ping objectForKey:@"date"];
        user.latestPingDate = [formatter dateFromString:dateStr];
        user.latestPingBeaconId = [ping objectForKey:@"beacon_id"];
    }
    
    return user;
}

+(NSArray *)usersFromJSON:(NSArray*)json {
    NSMutableArray * ret = [[NSMutableArray alloc] initWithCapacity:[json count]];
    
    for(NSDictionary * dict in json) {
        User * user = [User userFromJSON:dict];
        [ret addObject:user];
    }
    
    return ret;
}
@end
