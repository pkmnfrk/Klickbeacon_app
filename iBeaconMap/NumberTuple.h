//
//  Tuple.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-30.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberTuple : NSObject
@property (strong, nonatomic, readonly) NSNumber * item1;
@property (strong, nonatomic, readonly) NSNumber * item2;
@property (strong, nonatomic, readonly) NSNumber * item3;

+(NumberTuple*)tupleWith:(NSNumber*)item1 and:(NSNumber*)item2;
+(NumberTuple*)tupleWith:(NSNumber *)item1 and:(NSNumber *)item2 and:(NSNumber *)item3;

-(NumberTuple*)initWith:(NSNumber*)item1 and:(NSNumber*)item2;
-(NumberTuple*)initWith:(NSNumber*)item1 and:(NSNumber*)item2 and:(NSNumber *)item3;
@end
