//
//  FindUserTableViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "FindUserTableViewController.h"
#import "User.h"
#import "KlickBeacon/BeaconManager.h"
#import "UnknownBeacon.h"

@interface FindUserTableViewController () <BeaconManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIToolbar *blurBox;

@property NSArray * users;
//@property NSMutableArray * filteredResults;
@property NSURLSession * urlSession;
@property BeaconManager * beaconManager;
@property UIRefreshControl * refreshControl;
@end

@implementation FindUserTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [[UIImage alloc]init];
    
    self.blurBox.barStyle = UIBarStyleBlack;
    self.blurBox.translucent = YES;
    //self.blurBox.barTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    self.beaconManager = [[BeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [self refreshList];
    
    self.users = @[];
    
    //[self.tableView reloadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self  action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    // Calculate the size of the tableView if it were to be displayed
    
    
}

-(void)refreshInvoked:(id)sender forState:(UIControlState)state {
    [self refreshList];
}

-(void)refreshList {
    NSURL * url = [NSURL URLWithString:BASEURL @"client/most"];
    NSURLRequest * req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //NSLog(@"Starting refresh...");
    //NSLog(@"URL: %@", [url absoluteString]);
    NSURLSessionDataTask * task = [self.urlSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Refresh complete");
        
        if(error) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            return;
        }
        
        NSArray * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if(error) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            return;
        }
        
        self.users = [[User usersFromJSON:json] sortedArrayUsingSelector:@selector(name)];
        //self.filteredResults = [NSMutableArray arrayWithCapacity:[self.users count]];
        
        fetchingBeaconId = nil;
        
        for(int i = 0; i < self.users.count; i++) {
            User * user = [self.users objectAtIndex:i];
            if(user.latestPingBeaconId) {
                fetchingBeaconId = user.latestPingBeaconId;
                [self.beaconManager fetchBeaconWithId:fetchingBeaconId];
                break;
            }
        }
        
        if(fetchingBeaconId == nil) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:self.tableView waitUntilDone:NO];
        
        //[self.tableView reloadData];
    }];
    
    [task resume];
}

-(NSComparisonResult)sortUsers:(User*)a and:(User*)b
{
    return [a.name compare:b.name];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //self.tableView.contentOffset = CGPointMake(0.0, self.searchBar.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //if(tableView == self.searchDisplayController.searchResultsTableView) {
    //    if([self.filteredResults count] == 0) {
    //        return 1;
    //    }
    //    return [self.filteredResults count];
    //} else {
        if([self.users count] == 0)
            return 1;
        return [self.users count];
    //}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(tableView == self.searchDisplayController.searchResultsTableView) {
    //    return [self tableView:tableView prepareCellForSearchResultAtIndex:indexPath];
    //} else {
        return [self tableView:tableView prepareCellForUserAtIndex:indexPath];
    //}
}

-(UITableViewCell *)tableView:(UITableView *)tableView prepareCellForUserAtIndex:(NSIndexPath *)index {
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if([self.users count] == 0) {
        cell.textLabel.text = @"No one is online";
        cell.detailTextLabel.text = @"";
    } else {
        User * user = [self.users objectAtIndex:index.row];
        
        cell.textLabel.text = user.name;
        cell.detailTextLabel.text = @"";
        if(user.beacon) {
            cell.detailTextLabel.text = user.beacon.title;
        }
        //cell.detailTextLabel.text = @"location!";
        //cell.detailTextLabel.text = user.location;
    }
    
    return cell;

}

/*
-(UITableViewCell *)tableView:(UITableView *)tableView prepareCellForSearchResultAtIndex:(NSIndexPath *)index {
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if([self.filteredResults count] == 0) {
        cell.textLabel.text = @"No results";
        cell.detailTextLabel.text = @"";
    } else {
        User * user = [self.filteredResults objectAtIndex:index.row];
        
        cell.textLabel.text = user.name;
        if(user.beacon) {
            cell.detailTextLabel.text = user.beacon.title;
        }
        //cell.detailTextLabel.text = user.location;
    }
    
    return cell;
    
}

-(void)filterContentForSearches:(NSString *)searchText scope:(NSString*)scope {
    
    //[self.filteredResults removeAllObjects];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@ OR SELF.beacon.title contains[c] %@", searchText, searchText];
    
    self.filteredResults = [NSMutableArray arrayWithArray:[self.users filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearches:searchString scope:nil];
    
    return NO;
    
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    tableView.alpha = 0.0f;
    tableView.userInteractionEnabled = NO;
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    //[self.tableView setContentOffset:CGPointMake(0.0, self.searchBar.frame.size.height) animated:YES];
}
 */

NSString * fetchingBeaconId;

-(void)didReceiveBeacon:(Beacon *)beacon {
    NSLog(@"did receieve beacon");
    NSString * nextBeaconId;
    BOOL any = NO;
    for(int i = 0; i < self.users.count; i++) {
        User* user = [self.users objectAtIndex:i];
        
        if([user.latestPingBeaconId isEqualToString:beacon.beaconId]) {
            NSLog(@"Updating user # %d with beacon", i);
            user.beacon = beacon;

            any = YES;
            //UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            //cell.detailTextLabel.text = beacon.title;
        } else if(user.beacon == nil && user.latestPingBeaconId) {
            nextBeaconId = user.latestPingBeaconId;
        }
    }
    
    
    
    if(any) {
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:self.tableView waitUntilDone:NO];
    }
        
    
    if(nextBeaconId) {
        fetchingBeaconId = nextBeaconId;
        [self.beaconManager fetchBeaconWithId:fetchingBeaconId];
    } else {
        fetchingBeaconId = nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
             
-(void)populateTableUpdates {
    [self.tableView reloadData];
}

-(void)fetchingBeaconFailedWithError:(NSError *)error {
    NSLog(@"Did fail to receive beacon");
    NSString * nextBeaconId;
    
    NSMutableArray * reload = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.users.count; i++) {
        User* user = [self.users objectAtIndex:i];
        
        if([user.latestPingBeaconId isEqualToString:fetchingBeaconId]) {
            user.beacon = [[UnknownBeacon alloc] init];
            [reload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
        } else if(user.beacon == nil && user.latestPingBeaconId) {
            nextBeaconId = user.latestPingBeaconId;
        }
    }
    
    
    [self.tableView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationLeft];
    
    //if(any) {
    //    [self.tableView reloadData];
    //}
    
    if(nextBeaconId) {
        fetchingBeaconId = nextBeaconId;
        [self.beaconManager fetchBeaconWithId:fetchingBeaconId];
    } else {
        fetchingBeaconId = nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
