//
//  EditCellViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "EditCellViewController.h"

@interface EditCellViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelField;
@property BOOL isReturningNormally;

@end

@implementation EditCellViewController

NSString * _t;
NSString * _label;
NSString * _value;
NSString * _instr;

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
    
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStylePlain
                                        target:self action:@selector(onCancel)
     ];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                     style:UIBarButtonItemStyleDone
                                    target:self action:@selector(onDone)
     ];
    
    self.navigationItem.title = _t;
    self.labelField.text = _label;
    self.textField.text = _value;
    
    self.textField.delegate = self;
    self.isReturningNormally = NO;
    [self.textField becomeFirstResponder];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return _instr;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onDone];
    return NO;
}

-(void)onCancel {
    self.isReturningNormally = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onDone {
    self.isReturningNormally = YES;
    _value = self.textField.text;
    if(self.onComplete) {
        self.onComplete(self.editValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle:(NSString *)title {
    _t = title;
    if(self.navigationItem)
        self.navigationItem.title = title;
}

-(NSString * )title {
    return _t;
}

-(void)setLabel:(NSString *)label {
    _label = label;
    if(self.labelField)
        self.labelField.text = label;
}

-(NSString *)label {
    return _label;
}

-(void)setEditValue:(NSString *)value {
    _value = value;
    if(self.textField)
        self.textField.text = value;
}

-(NSString *)editValue{
    return _value;
}

-(void)setInstructions:(NSString*)instructions {
    _instr = instructions;
    
    if(self.tableView)
       [self.tableView reloadData];
}

-(NSString*)instructions {
    return _instr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(!self.isReturningNormally) {
        [self onDone];
    }
}

@end
