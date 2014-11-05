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
    [ApplicationData sharedInstance].isDisply_PassCodeScreen = YES;
    [ApplicationData sharedInstance].isReloadMyFolderData = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"More";
    self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
    self.moreArr = @[@"About TRUE", @"Why TRUE", @"Type of Injuries", @"Contact"];
    
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


# pragma mark -
# pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.moreArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"moreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if(indexPath.row == 3)
        {
            cell.textLabel.textColor = THEME_RED_COLOR;
        }
    
        cell.textLabel.text = self.moreArr[indexPath.row];
        cell.accessoryView = [[ UIImageView alloc ]
                              initWithImage:[UIImage imageNamed:@"ios_right_arrow_icon.png"]];

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"More Option index : %i", indexPath.row);
    
    if(indexPath.row == 0)
    {
        self.showDetailsFor = @"ABOUT";
        [self performSegueWithIdentifier:@"MORE_TO_DETAIL" sender:self];
    }
    else if(indexPath.row == 1)
    {
        self.showDetailsFor = @"WHY";
        [self performSegueWithIdentifier:@"MORE_TO_DETAIL" sender:self];
    }
    else if(indexPath.row == 2)
    {
        self.showDetailsFor = @"INJURY";
        [self performSegueWithIdentifier:@"MORE_TO_DETAIL" sender:self];
    }
    else
    {
         self.showDetailsFor = @"CONTACT";
        [self performSegueWithIdentifier:@"MORE_TO_CONTACT" sender:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"RECIEVE SEGUE IDENTIFIER ON FAQ : %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"MORE_TO_DETAIL"])
    {
        AboutUsViewController *controller = [segue destinationViewController];
        controller.displayHtmlfile = self.showDetailsFor;
    }
}



@end
