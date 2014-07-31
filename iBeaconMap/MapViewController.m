//
//  FirstViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"
#import "UIView+convertViewToImage.h"
#import "UIImage+ImageEffects.h"

#import "KlickBeacon/BeaconManager.h"
#import "Marker.h"

@interface MapViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate> {
    Marker * transitionMarker;
    Beacon * transitionBeacon;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property BOOL isIpad;
@property (strong, nonatomic) BeaconManager * beaconManager;
@property (strong, nonatomic) NSUUID * klickUUID;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.isIpad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    
    /*if(!self.isIpad && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)){
        [self.navigationController setNavigationBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
    }*/
    
    self.klickUUID = [[NSUUID alloc] initWithUUIDString:@"2f73d96d-f86e-4f95-b88d-694cefe5837f"];
    
    self.webView.delegate = self;
    
    [self loadMap];
    
    self.beaconManager = [[BeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    
//    NSLog(@"%ld", (long)self.webView.frame.origin.y);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(self.isIpad) return;
    
    /*if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        //[self.view layoutSubviews];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    } else {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }*/
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    
    static NSString *urlPrefix = @"myapp://";
    
    if ([url hasPrefix:urlPrefix]) {
        NSString *paramsString = [url substringFromIndex:[urlPrefix length]];
        NSArray * qArray = [paramsString componentsSeparatedByString:@"?"];
        
        NSString * action;
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        
        action = [qArray objectAtIndex:0];
        
        if([qArray count] > 1) {
        
            NSArray *paramsArray = [[qArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            size_t paramsAmount = [paramsArray count];
            
            for (int i = 0; i < paramsAmount; i++) {
                NSArray *keyValuePair = [[paramsArray objectAtIndex:i] componentsSeparatedByString:@"="];
                NSString *key = [keyValuePair objectAtIndex:0];
                NSString *value = nil;
                if ([keyValuePair count] > 1) {
                    value = [keyValuePair objectAtIndex:1];
                }
                
                if (key && [key length] > 0) {
                    if (value && [value length] > 0) {
                        [params setObject:value forKey:key];
                    }
                }
            }
        }
        
        [self handleWebViewAction:action withParams:[[NSDictionary alloc] initWithDictionary:params]];
        
        return NO;
    }
    else {
        return YES;
    }
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoader];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    mapLoaded = YES;
    [self hideLoader];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoader];
    [self showError:error];
}

-(void)handleWebViewAction:(NSString *) action withParams:(NSDictionary*)params {
    /*
    if([action isEqualToString:@"click"]) {
        [self showLoader];
        
        NSInteger major, minor;
        
        major = [[params valueForKey:@"major"] intValue];
        minor = [[params valueForKey:@"minor"] intValue];
        
        [self.beaconManager fetchBeaconsWithUUID:self.klickUUID major:major minor:minor];
    } else */if([action isEqualToString:@"marker_click"]) {
        [self showLoader];
        
        NSString * markerId = [params valueForKey:@"id"];
        
        [self loadMarker:markerId];
    } else {
        
        NSLog(@"Received unknown webview command: %@", action);
        NSLog(@"With parameters: %@", params);
    }
    
}

-(void)loadMarker:(NSString*)marker
{
    [Marker loadMarker:marker whenComplete:^(NSError *error, Marker * marker) {
       
        if(error) {
            [self performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(showError:) withObject:error waitUntilDone:YES];
            return;
        }
    
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self hideLoader];
            
            transitionMarker = marker;
            [self performSegueWithIdentifier:@"detailView" sender:nil];
        });
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"detailView"]) {
        DetailViewController * dtvc = [segue destinationViewController];
        
        
        dtvc.marker = transitionMarker;
        
        transitionBeacon = nil;
        
        
    }
    
}
-(void)showLoader {
    self.loadingView.hidden = NO;
    self.webView.userInteractionEnabled = NO;
}

-(void)hideLoader{
    self.loadingView.hidden = YES;
    self.webView.userInteractionEnabled = YES;
}

-(void)showError:(NSError*)error {

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was an error loading the selected item: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

-(void)didReceiveBeacon:(Beacon *)beacon {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self hideLoader];
    
        transitionBeacon = beacon;
        [self performSegueWithIdentifier:@"detailView" sender:nil];
    });
}

-(void)fetchingBeaconFailedWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showError:) withObject:error waitUntilDone:YES];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake) {
        [self.webView reload];
    }
}

BOOL mapLoaded = NO;

-(void)loadMap {
    if(mapLoaded) {
        NSLog(@"Map already loaded");
        return;
    }
    
    NSLog(@"Loading map");
    NSURL * url = [NSURL URLWithString:BASEURL @"?ios"];
    
    NSURLRequest * req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [self.webView loadRequest:req];
}

@end
