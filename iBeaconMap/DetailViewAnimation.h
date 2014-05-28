//
//  DetailViewAnimation.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewAnimation : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (weak, nonatomic) UIScreenEdgePanGestureRecognizer * gestureRecognizer;

-(id)initWithDirection:(BOOL)isPush;

@end
