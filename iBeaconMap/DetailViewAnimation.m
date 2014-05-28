//
//  DetailViewAnimation.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "DetailViewAnimation.h"
#import "DetailViewController.h"
#import "UIViewController+hp_layoutGuideFix.h"

@interface DetailViewAnimation ()

@property BOOL isPush;
@property (weak, nonatomic) UIView * transitioningView;
@property (weak, nonatomic) UIViewController * transitioningViewController;
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> context;

@end

@implementation DetailViewAnimation

UIScreenEdgePanGestureRecognizer * _gestureRecognizer;

-(id)initWithDirection:(BOOL)isPush {
    self = [super init];
    if(self) {
        self.isPush = isPush;
    }
    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.75;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    DetailViewController * dtvc = nil;
    
    to.hp_topLayoutGuide = from.hp_topLayoutGuide;
    
    if(self.isPush && [to isKindOfClass:[DetailViewController class]]) {
        
        dtvc = (DetailViewController*)to;
        dtvc.backgroundImageView.transform = CGAffineTransformMakeTranslation(-to.view.bounds.size.width, 0.0);
        
    } else if(!self.isPush && [from isKindOfClass:[DetailViewController class]]) {
        dtvc = (DetailViewController*)from;
        
    }
    
    if(self.isPush) {
        to.view.transform = CGAffineTransformMakeTranslation(to.view.bounds.size.width , 0.0);
    }
    
    if(self.isPush) {
        [[transitionContext containerView] addSubview:to.view];
    } else {
        
        [[transitionContext containerView] insertSubview:to.view belowSubview:from.view];
    }
    
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if(self.isPush) {
            
            to.view.transform = CGAffineTransformIdentity;
            
            if(dtvc) {
                dtvc.backgroundImageView.transform = CGAffineTransformIdentity;
            }
            
        } else {
            from.view.transform = CGAffineTransformMakeTranslation(from.view.bounds.size.width , 0.0);
            
            if(dtvc)
                dtvc.backgroundImageView.transform = CGAffineTransformMakeTranslation(-dtvc.backgroundImageView.bounds.size.width, 0.0);
        }
        
    } completion:^(BOOL finished) {
        
        //from.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
}


-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    to.view.frame = [transitionContext finalFrameForViewController:to];
    [[transitionContext containerView] insertSubview:to.view belowSubview:from.view];
    

    self.transitioningView = from.view;
    self.transitioningViewController = from;
}

-(void)updateWithPercent:(CGFloat)percent {
    self.transitioningView.transform = CGAffineTransformMakeTranslation(percent * self.transitioningView.frame.size.width, 0);
    
    if([self.transitioningViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController * dtvc = (DetailViewController *) self.transitioningViewController;
        
        dtvc.backgroundImageView.transform = CGAffineTransformMakeTranslation(-percent * self.transitioningView.frame.size.width, 0.0);

    }
    
    [self.context updateInteractiveTransition:percent];
    
    
}

-(void)end:(BOOL)cancelled {
    if(cancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            _transitioningView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self.context cancelInteractiveTransition];
            [self.context completeTransition:NO];
            
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _transitioningView.transform = CGAffineTransformMakeTranslation(self.transitioningView.frame.size.width * 2, 0);
        } completion:^(BOOL finished) {
            [self.context finishInteractiveTransition];
            [self.context completeTransition:YES];
            
        }];
    }
}

-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGFloat scale = [gesture translationInView:self.transitioningView.superview].x / self.transitioningView.superview.frame.size.width;
    
    //NSLog(@"Percent: %f", scale);
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            [self updateWithPercent:scale];
            break;
        case UIGestureRecognizerStateEnded: {
            BOOL cancelled = [gesture velocityInView:self.transitioningView.superview].x < 0;
            
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            BOOL cancelled = [gesture velocityInView:self.transitioningView.superview].x < 0;
            
            [self end:cancelled];
            break;
        }
        default:
            break;
    }
}


-(void)setGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    if(_gestureRecognizer) {
        [_gestureRecognizer removeTarget:self action:@selector(handleGesture:)];
        _gestureRecognizer = nil;
    }
    
    _gestureRecognizer = gestureRecognizer;
    
    if(_gestureRecognizer) {
        [_gestureRecognizer addTarget:self action:@selector(handleGesture:)];
    }
}

-(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    return _gestureRecognizer;
}

@end
