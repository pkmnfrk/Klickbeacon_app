//
//  SwipeInteractionController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "SwipeInteractionController.h"

@implementation SwipeInteractionController {
    UIScreenEdgePanGestureRecognizer * _gesture;
    UIViewController * _viewController;
    BOOL _shouldCompleteTransition;
}

-(void)wireToViewController:(UIViewController*)viewController
{
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

-(void)prepareGestureRecognizerInView:(UIView*)view {
    _gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    _gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:_gesture];
}

-(void)handleGesture:(UIScreenEdgePanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    //CGPoint vel = [gesture velocityInView:gesture.view];
    
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            self.interactionInProgress = YES;
            
            [_viewController.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if(self.interactionInProgress) {
                CGFloat fraction = fabsf(translation.x / gesture.view.bounds.size.width);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldCompleteTransition = fraction > 0.5;
                
                if(fraction >= 1.0)
                    fraction = 0.9;
                
                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if(self.interactionInProgress) {
                self.interactionInProgress = NO;
                if(!_shouldCompleteTransition || gesture.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                } else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
