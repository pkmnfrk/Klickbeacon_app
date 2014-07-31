//
//  PulseViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-10.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "PulseViewController.h"
#import "AVAnimatorView.h"
#import "AVAnimatorMedia.h"
#import "AVAppResourceLoader.h"
#import "AVMvidFrameDecoder.h"

@interface PulseViewController ()
@property (weak, nonatomic) IBOutlet AVAnimatorView *animationView;

@property (strong, nonatomic) AVAnimatorMedia *media;
@end

@implementation PulseViewController

-(void)viewDidLoad
{
    self.media = [AVAnimatorMedia aVAnimatorMedia];
    
    AVAppResourceLoader *resLoad = [AVAppResourceLoader aVAppResourceLoader];
    
    resLoad.movieFilename = @"Pulse_Welcome.mvid";
    
    self.media.resourceLoader = resLoad;
    
    AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
    
    self.media.frameDecoder = frameDecoder;
    
    [self.media prepareToAnimate];
    

    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(animationDoneNotification:) name:AVAnimatorDoneNotification object:self.media];
    
    if(!self.media.isReadyToAnimate)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(animatorDoneNotification:)
                                                     name:AVAnimatorPreparedToAnimateNotification object:self.media];
    } else {

        [self animatorDoneNotification:[NSNotification notificationWithName:AVAnimatorPreparedToAnimateNotification object:self.media]];
    }
    /*
    [self.view removeConstraints:self.view.constraints];
    [self setupLetter:self.imgP];
    [self setupLetter:self.imgU];
    [self setupLetter:self.imgL];
    [self setupLetter:self.imgS];
    [self setupLetter:self.imgE];
    
    [self doInAnimation];
    */
}

-(void)animatorDoneNotification:(NSNotification *)event
{
    [self.animationView attachMedia:event.object];
    [event.object startAnimator];
}

-(void)animationDoneNotification:(NSNotification*)event
{
    //[event.object startAnimator];
    [self performSegueWithIdentifier:@"toMap" sender:nil];
}
/*
-(void)setupLetter:(UIImageView*)view
{
    [self resetLetter:view];
    
    view.translatesAutoresizingMaskIntoConstraints = YES;
    //    view.center.x = view.
}

-(void)resetLetter:(UIImageView*)view
{
    view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    view.alpha = 0.0f;
//    view.center.x = view.
}

-(void)unresetLetter:(UIImageView*)view
{
    view.transform = CGAffineTransformMakeScale(1, 1);
    view.alpha = 1.0f;

}

#define START_OFFSET 0.1333
#define PAUSE_OFFSET 0.5

-(void)doInAnimation
{
    NSLog(@"Start of in");
    [self animateIn:self.imgP start:START_OFFSET * 0 onDone:nil];
    [self animateIn:self.imgU start:START_OFFSET * 1 onDone:nil];
    [self animateIn:self.imgL start:START_OFFSET * 2 onDone:nil];
    [self animateIn:self.imgS start:START_OFFSET * 3 onDone:nil];
    [self animateIn:self.imgE start:START_OFFSET * 4 onDone:^(BOOL finished) {
        [self doOutAnimation];
    }];

}

-(void)doOutAnimation
{
    NSLog(@"Start of out");
    [self animateOut:self.imgP start:PAUSE_OFFSET + START_OFFSET * 0 onDone:nil];
    [self animateOut:self.imgU start:PAUSE_OFFSET + START_OFFSET * 1 onDone:nil];
    [self animateOut:self.imgL start:PAUSE_OFFSET + START_OFFSET * 2 onDone:nil];
    [self animateOut:self.imgS start:PAUSE_OFFSET + START_OFFSET * 3 onDone:nil];
    [self animateOut:self.imgE start:PAUSE_OFFSET + START_OFFSET * 4 onDone:^(BOOL finished) {
        [self doInAnimation];
    }];

}

-(void)animateIn:(UIImageView*)view start:(CGFloat)start onDone:(void (^)(BOOL finished))onDone
{
    [UIView animateWithDuration:0.9333
                          delay:start
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self unresetLetter:view];
                         //[self.view layoutIfNeeded];
                     }
                     completion:onDone];

}

-(void)animateOut:(UIImageView*)view start:(CGFloat)start onDone:(void (^)(BOOL finished))onDone
{
    [UIView animateWithDuration:0.9333
                          delay:start
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self resetLetter:view];
                         //[self.view layoutIfNeeded];
                         
                     } completion:onDone];
}
 
*/
@end
