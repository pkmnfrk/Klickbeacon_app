//
//  User.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong,nonatomic) NSString * name;
@property (strong, nonatomic) NSString * location;

+(User*)userWithName:(NSString *)name andLocation:(NSString*)location;

@end
