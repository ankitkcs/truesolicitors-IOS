//
//  MyFolderViewController.m
//  TrueClaim
//
//  Created by krish on 7/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "MyFolderViewController.h"
#import "PassCodeViewController.h"
#import "folderDocCellView.h"
#import "LetterReadViewController.h"
#import "RKMTransView.h"
//#import "RKPopUpAlertView.h"

@interface MyFolderViewController ()

@end

@implementation MyFolderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios_background.png"]];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    // add custom back Button
    UIButton *btnBack = [ApplicationData customBackNavButtonWithTite:@"Home"
                                                                icon:[UIImage imageNamed:@"ios_back_arrow_icon.png"]
                                                             bgColor:[UIColor clearColor]
                                                          titleColor:THEME_RED_COLOR
                                                           titleFont:[UIFont boldSystemFontOfSize:17] buttonSize:CGRectMake(0, 0, 80, 44)];
    
    [btnBack addTarget:self action:@selector(goBackToHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barBackButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"MY FOLDER";
    self.tabBarItem.title = @"My Folder";
    
    NSString *openViewFor = @"REGULAR_USER";
    
    if([openViewFor isEqualToString:@"FIRST_TIME_USER"])
    {
        self.tblMessage.hidden = YES;
    }
    else
    {
        self.tblMessage.hidden = NO;
    }

    if([ApplicationData sharedInstance].isPasscodeSaved == NO)
    {
        [self showTransparentPopUpAlertView];
    }
    else
    {
        //[self showPassCodeScreenForRegularUser];
    }
}

-(void) showTransparentPopUpAlertView
{
    self.transparentView = [[RKMTransView alloc] init];
    self.transparentView.delegate = self;
    self.transparentView.backgroundColor = [UIColor clearColor];
    self.transparentView.allowBlurView  = YES;
    self.transparentView.hideCloseButton = YES;
    
    self.transparentView.alertTitle =  @"Welcome to My Folder";
    self.transparentView.alertImage =  [UIImage imageNamed:@"ios_folder_popup_icon.png"];
    self.transparentView.alertMessage = @"This is where you can store, view and respond to the documnets we send you.";
    [self.transparentView open];
}

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
        if ([ApplicationData sharedInstance].isDisply_PassCodeScreen == YES)
        {
             [ApplicationData sharedInstance].isDisply_PassCodeScreen = NO;
             [self showPassCodeScreenForFirstTimeUser];
        }
}

// set password on first time using app
-(void) showPassCodeScreenForFirstTimeUser
{
    PassCodeViewController *passCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TempPassCodeVC"];
    [self presentViewController:passCodeVC animated:YES completion:nil];
}

-(void) goBackToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -
# pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"folderCell";
        folderDocCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.lblDate.text = @"Tus, 20/10/2014";
        cell.lblDocName.text = @"myDocumnet.pdf";
        return cell;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    LetterReadViewController *readLetterView = [self.storyboard instantiateViewControllerWithIdentifier:@"LetterReadViewController"];
//    //[self presentViewController:readLetterView animated:YES completion:nil];
//    
//    [self.navigationController pushViewController:readLetterView animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
