//
//  SwipeInteractionController.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInteractionController : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;

-(void)wireToViewController:(UIViewController*)viewController;

@end
