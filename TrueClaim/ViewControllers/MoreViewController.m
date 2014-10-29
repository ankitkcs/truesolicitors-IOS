//
//  MoreViewController.m
//  TrueClaim
//
//  Created by krish on 7/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutUsViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"More";
    self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
//    UIBarButtonItem *noteBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessageClicked:)];
//    self.navigationItem.rightBarButtonItem = noteBarBtn;
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    // add custom back Button
    UIButton *btnBack = [ApplicationData customBackNavButtonWithTite:@"Home"
                                                                icon:[UIImage imageNamed:@"ios_back_arrow_icon.png"]
                                                             bgColor:[UIColor clearColor]
                                                          titleColor:THEME_RED_COLOR
                                                           titleFont:[UIFont boldSystemFontOfSize:17] buttonSize:CGRectMake(-0.5f, 0, 80, 44)];
    
    [btnBack addTarget:self action:@selector(goBackToHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barBackButton;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(IBAction)newMessageClicked:(id)sender
{
    //    WriteMessageViewController *newMsgView = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMessageViewController"];
    //
    //    [self presentViewController:newMsgView animated:YES completion:nil];
}

-(IBAction)btnHomeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) goBackToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) aboutTrueClick:(id)sender
{
    AboutUsViewController *aboutView = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    [self.navigationController pushViewController:aboutView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
