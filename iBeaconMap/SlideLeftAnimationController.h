//
//  SlideLeftAnimationController.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideLeftAnimationController : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>
@property (nonatomic) int type;

+(SlideLeftAnimationController *)allocWithType:(int)type curved:(BOOL)curved;
@end

#define AnimationTypePresent 0
#define AnimationTypeDismiss 1
