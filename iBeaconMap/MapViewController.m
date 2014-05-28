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

@interface MapViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property BOOL isIpad;
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
    
    self.webView.delegate = self;
    
    NSURL * url = [NSURL URLWithString:@"http://ibeacon.klick.com/?ios"];
    
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:req];
    
    
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

-(void)handleWebViewAction:(NSString *) action withParams:(NSDictionary*)params {
    
    if([action isEqualToString:@"click"]) {
        [self performSegueWithIdentifier:@"detailView" sender:self];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"detailView"]) {
        DetailViewController * dtvc = [segue destinationViewController];
        
        
        UIImage * image = [self.view convertViewToImage];
        
        //blur it here
        image = [image applyBlurWithRadius:20
                                 tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                     saturationDeltaFactor:1.3
                                 maskImage:nil];
        
        dtvc.backgroundViewImage = image;
        
        
        
        
    }
    
}

@end
