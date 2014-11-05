//
//  AboutUsViewController.m
//  TrueClaim
//
//  Created by krish on 7/29/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    
    NSLog(@"SHOW>>>>>HTML %@",self.displayHtmlfile);
    
   self.navigationController.navigationBarHidden = NO;
   self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
   if([self.displayHtmlfile isEqualToString:@"ABOUT"])
   {
       self.navigationItem.title = @"ABOUT US";
       [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aboutTrue" ofType:@"html"]isDirectory:NO]]];
   }
   else if([self.displayHtmlfile isEqualToString:@"WHY"])
   {
       self.navigationItem.title = @"WHY TRUE";
       [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"whyTrue" ofType:@"html"]isDirectory:NO]]];
   }
   else if([self.displayHtmlfile isEqualToString:@"INJURY"])
   {
       self.navigationItem.title = @"INJURY TYPES";
       [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"injuryTypes" ofType:@"html"]isDirectory:NO]]];
   }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
