//
//  FindUserTableViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "FindUserTableViewController.h"
#import "User.h"

@interface FindUserTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray * users;
@property NSMutableArray * filteredResults;
@end

@implementation FindUserTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    
    
    self.users = [NSArray arrayWithObjects:
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
             [User userWithName:@"Mary" andLocation:@"QA"],
             [User userWithName:@"Joe" andLocation:@"Labs"],
                  
             nil];
    
    self.filteredResults = [NSMutableArray arrayWithCapacity:[self.users count]];
    
    
    
    [self.tableView reloadData];
    
    // Calculate the size of the tableView if it were to be displayed
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView layoutIfNeeded];
    
    self.tableView.contentInset = UIEdgeInsetsMake(/*self.topLayoutGuide.length*/ 0, 0, self.bottomLayoutGuide.length, 0);
    //self.tableView.contentOffset = CGPointMake(0.0, self.topLayoutGuide.length /*+ self.searchBar.bounds.size.height*/);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
    
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
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredResults count];
    } else {
        return [self.users count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    User * user;
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
        user = [self.filteredResults objectAtIndex:indexPath.row];
    } else {
        user = [self.users objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.location;
    
    return cell;
}

-(void)filterContentForSearches:(NSString *)searchText scope:(NSString*)scope {
    
    //[self.filteredResults removeAllObjects];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.filteredResults = [NSMutableArray arrayWithArray:[self.users filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearches:searchString scope:nil];
    
    return YES;
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

//    [self.tableView setContentOffset:CGPointMake(0.0, -100 /* self.topLayoutGuide.length * 2*/) animated:NO];
    
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
    //                      atScrollPosition:UITableViewScrollPositionTop
    //                              animated:YES];
    
    //[self.tableView scrollRectToVisible:CGRectMake(0,0,1,1)
    //                           animated:YES];
    
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
