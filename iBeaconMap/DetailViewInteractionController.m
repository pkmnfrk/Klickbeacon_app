//
//  DetailViewInteractionController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-22.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "DetailViewInteractionController.h"


@interface DetailViewInteractionController () <UIGestureRecognizerDelegate>
@property UIScreenEdgePanGestureRecognizer * gestureRecognizer;

@end

@implementation DetailViewInteractionController

-(id)init {
    self = [super init];
    
    if(self) {
        _gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _gestureRecognizer.edges = UIRectEdgeLeft;
    }
    
    return self;
}

-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    
}

@end
