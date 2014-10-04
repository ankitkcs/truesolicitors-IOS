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
    self.navigationController.navigationBarHidden = NO;
   self.navigationItem.title = @"ABOUT US";
   self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
