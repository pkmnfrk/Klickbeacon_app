//
//  Tuple.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-30.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "NumberTuple.h"

@implementation NumberTuple

+(NumberTuple*)tupleWith:(NSNumber*)item1 and:(NSNumber*)item2
{
    return [[NumberTuple alloc] initWith:item1 and:item2];
    
}

+(NumberTuple*)tupleWith:(NSNumber *)item1 and:(NSNumber *)item2 and:(NSNumber *)item3
{
    return [[NumberTuple alloc] initWith:item1 and:item2 and:item3];
}

-(NumberTuple*)initWith:(NSNumber*)item1 and:(NSNumber*)item2
{
    return [self initWith: item1 and:item2 and:nil];
}

-(NumberTuple*)initWith:(NSNumber*)item1 and:(NSNumber*)item2 and:(NSNumber *)item3
{
    static NSMutableArray * instances = nil;
    
    if(instances == nil) {
        instances = [NSMutableArray arrayWithCapacity:10];
    }
    
    for(NumberTuple * item in instances)
    {
        if((item.item1 == item1 || [item.item1 compare:item1] == NSOrderedSame) &&
           (item.item2 == item2 || [item.item2 compare:item2] == NSOrderedSame) &&
           (item.item3 == item3 || [item.item3 compare:item3] == NSOrderedSame))
        {
            self = item;
            return self;
        }
    }
    
    self = [super init];
    
    _item1 = item1;
    _item2 = item2;
    _item3 = item3;
    
    [instances addObject:self];
    
    return self;
    
}

@end
