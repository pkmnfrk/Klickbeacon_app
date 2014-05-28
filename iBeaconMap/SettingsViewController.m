//
//  SettingsViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "SettingsViewController.h"
#import "OptionTableViewCell.h"
#import "EditCellViewController.h"

@interface SettingsViewController ()

@property NSString * name;

@end

@implementation SettingsViewController

NSString * _name;

-(void)setName:(NSString *)name {
    _name = name;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(NSString *)name {
    return _name;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.name = @"Joe";
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    if(indexPath.section == 0) { //name
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Name";
        cell.detailTextLabel.text = self.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    } else if (indexPath.section == 1) {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
        cell.labelView.text = @"Notifications";
        [cell.switchView setOn:YES];
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Unknown row";
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0) {
        [self performSegueWithIdentifier:@"editCell" sender:indexPath];
        
    }
}


-(NSIndexPath *)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView shouldHighlightRowAtIndexPath:indexPath] ? indexPath : nil;
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return YES;
    
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return YES;
    }
    
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if(section == 1) {
        return @"Will monitor for beacons when the app is in the background. Requires Background App Refresh to be enabled";
    }
    
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"editCell"]) {
        
        NSIndexPath * indexPath = sender;
        EditCellViewController * ecvc = [segue destinationViewController];
        
        if(indexPath.section == 0) {
            ecvc.title = @"Name";
            ecvc.label = @"Name";
            ecvc.editValue = self.name;
            ecvc.instructions = @"This will be shown as your name when other people are using this app";
            ecvc.onComplete = ^(NSString * value) {
                self.name = value;
            };
        }
        
    }
}


@end
