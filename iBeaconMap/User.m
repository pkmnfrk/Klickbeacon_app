//
//  User.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "User.h"

@implementation User

+(User *)userWithName:(NSString *)name andLocation:(NSString *)location {
    User* ret = [[User alloc] init];
    ret.name = name;
    ret.location = location;
    return ret;
}

@end
