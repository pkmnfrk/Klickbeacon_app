//
//  DetailViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

BOOL stop = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = NO;
    
    
    
    /*
    
    if(self.beacon.uiImage) {
        self.imageView.image = self.beacon.uiImage;
        
    }
    if(self.beacon.bodyText) {
        self.textView.text = self.beacon.bodyText;
    }*/
    
    
    self.webView.delegate = self;
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"marker" ofType:@"html"] isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
    if(self.marker.title) {
        self.navigationItem.title = self.marker.title;
    }

}


-(void)viewWillAppear:(BOOL)animated {
    //NSLog(@"self.navigationController.navigationBar: %@", self.navigationController.navigationBar);
}

-(void)viewWillLayoutSubviews{
    //NSLog(@"viewWillLayoutSubviews TopLayoutGuide: %f", self.topLayoutGuide.length);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //NSLog(@"didRotateFromInterfaceOrientation TopLayoutGuide: %f", self.topLayoutGuide.length);
    
}

-(void)viewWillDisappear:(BOOL)animated {
    stop = YES;
}


-(void) viewDidAppear:(BOOL)animated {
    [self.view layoutIfNeeded];
    [self.navigationController.view layoutIfNeeded];
    //NSLog(@"viewDidAppear TopLayoutGuide: %f", self.topLayoutGuide.length);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSError * error;
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:[self.marker toDictionary]];
    
    
    NSString * image = [data valueForKey:@"image"];
    
    if(image != nil) {
        NSURL * baseUrl = [[NSURL alloc] initWithString:BASEURL];
    
        NSURL * imageUrl = [[NSURL alloc] initWithString:image relativeToURL:baseUrl];
        [data setValue:[imageUrl absoluteString] forKey:@"image"];
    }
    
    NSData * jsonObj = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString * json = [[NSString alloc] initWithData:jsonObj encoding:NSUTF8StringEncoding];
    
    NSString * script = [NSString stringWithFormat:@"loadContent(\"%@\", %@)", BASEURL, json];
    NSLog(@"%@", script);
    [webView stringByEvaluatingJavaScriptFromString:script];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
