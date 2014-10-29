//
//  FAQViewController.m
//  TrueClaim
//
//  Created by krish on 7/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQInTableViewController.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    
    //FAQInTableViewController *faqTable = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQInTableViewController"];
    
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"FAQ'S";
    self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
    UIBarButtonItem *noteBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessageClicked:)];
    self.navigationItem.rightBarButtonItem = noteBarBtn;
    
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
    if([[ApplicationData sharedInstance].navigateFromView isEqualToString:@"HomeView"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
