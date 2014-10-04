//
//  ConfirmViewController.m
//  TrueClaim
//
//  Created by krish on 7/28/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "ConfirmViewController.h"
#import "QRadioButton.h"
#import "MyFolderViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    [self createCustomRadioButton];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelTapped:)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnConfirm  = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(btnConfirmTapped:)];
    self.navigationItem.rightBarButtonItem = btnConfirm;
    
    self.navigationItem.title = @"AUTORITY";

}

- (void)createCustomRadioButton
{
    QRadioButton *rdoBtnTable = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupCarTable"];
    rdoBtnTable.frame = CGRectMake(50, 280,200, 44);
    [rdoBtnTable setTitle:@"I Agree" forState:UIControlStateNormal];
    [rdoBtnTable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rdoBtnTable setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rdoBtnTable setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rdoBtnTable.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rdoBtnTable setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [rdoBtnTable setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:rdoBtnTable];
    

    QRadioButton *rdoBtnCar = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupCarTable"];
    rdoBtnCar.frame = CGRectMake(50,330, 200, 44);
    [rdoBtnCar setTitle:@"I Do Not Agree" forState:UIControlStateNormal];
    [rdoBtnCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rdoBtnCar setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rdoBtnCar setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rdoBtnCar.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rdoBtnCar setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [rdoBtnCar setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:rdoBtnCar];
    
    QRadioButton *rdoBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupCarTable"];
    rdoBtn.frame = CGRectMake(50,380, 280, 44);
    [rdoBtn setTitle:@"Include a message to TRUE?" forState:UIControlStateNormal];
    [rdoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rdoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rdoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rdoBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rdoBtn setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [rdoBtn setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:rdoBtn];
}

#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
    
//    if([radio.titleLabel.text isEqualToString:@"Car"])
//    {
//        self.bokingFor = @"Car";
//    }
//    else
//    {
//        self.bokingFor = @"Table";
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConfirmTapped:(id)sender
{
    //MyFolderViewController *myFolderView = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnCancelTapped:(id)sender
{
    //MyFolderViewController *myFolderView = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
