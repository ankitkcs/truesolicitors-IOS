//
//  HomeViewController.m
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "HomeRegularViewController.h"
#import "btnCellView.h"
#import "claimCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "LinkClaimViewController.h"
#import "MessageViewController.h"
#import "IntroViewController.h"

#import "FAQViewController.h"
#import "ShareViewController.h"
#import "AboutUsViewController.h"
#import "NZLabel.h"
#import "MyDatabaseManager.h"
#import "UIVIew+RKBorder.h"

@interface HomeRegularViewController ()

@property(nonatomic,strong) NSArray *allClaims;

@end

@implementation HomeRegularViewController

-(void) viewDidAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    self.lblLink.text = @"To get the most from this app \n please link your claim below.";
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [ApplicationData sharedInstance].navigateFromView = @"HomeView";
    
    self.title = @"Home";
    self.navigationController.navigationBarHidden = YES;
    
    self.allClaims = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil byAcending:YES fromTable:TBL_LINK_CLAIM];
    
    NSLog(@"ALL CLAIMS : %@",self.allClaims);
    
    // customize footer buttons back view
    
    self.btnFooterView.backgroundColor = [UIColor clearColor];
    
    self.btnLinkBackView.backgroundColor = [UIColor clearColor];
    self.btnLinkBackView.layer.borderColor = THEME_RED_COLOR.CGColor;
    self.btnLinkBackView.layer.borderWidth = 1;
    
    self.btnReportBackView.backgroundColor = [UIColor clearColor];
    self.btnReportBackView.layer.borderColor = THEME_RED_COLOR.CGColor;
    self.btnReportBackView.layer.borderWidth = 1;
    
    self.btnBackView.BordersFlag = DrawBordersTop;
    self.btnBackView.BordersColor = Rgb2UIColor(200, 200, 200);
    self.btnBackView.BordersWidth = 1;
    
    
    if([self.allClaims count] == 0)
    {
        [self setUpViewForFirstTimeUser];
    }
    else
    {
        [self setupViewForRegularUser];
    }
}

# pragma mark -
# pragma mark View Set up Accordint to user

-(void) setUpViewForFirstTimeUser
{
    self.logoImageView.hidden = NO;
    self.logoBackView.hidden = NO;
    
    self.logoBackView.backgroundColor = [UIColor clearColor];

    self.lblLink.text = @"To get the most from this app \n please link your claim below";
    
    NSString *attribText = @"link your claim";
    [self.lblLink setFont:[UIFont boldSystemFontOfSize:18] string:attribText];
    [self.lblLink setFontColor:THEME_RED_COLOR string:attribText];
    
//    NSString *attribText2 = @"below";
//    [self.lblLink setFont:[UIFont systemFontOfSize:18] string:attribText2];
//    [self.lblLink setFontColor:[UIColor greenColor] string:attribText2];
    
    if(!IS_IPHONE_5)
    {
        self.logoBackView.frame = CGRectMake(0, 130, self.logoBackView.frame.size.width, self.logoBackView.frame.size.height);
    }
    else
    {
        self.logoBackView.frame = CGRectMake(0, 130, self.logoBackView.frame.size.width, self.logoBackView.frame.size.height);
        self.tblClaimsView.frame = CGRectMake(20, 130 + self.logoBackView.frame.size.height + 20, self.tblClaimsView.frame.size.width, 240);
    }
}

-(void) setupViewForRegularUser
{
    
    self.logoImageView.hidden = NO;
    self.logoBackView.hidden = YES;
    
    if(!IS_IPHONE_5)
    {
        
        CGFloat tblHeight = (80 * [self.allClaims count]) + 175;
        
        if(tblHeight > 240)
        {
            tblHeight = 240;
        }
        
        self.tblClaimsView.frame = CGRectMake(20, 120 , self.tblClaimsView.frame.size.width, tblHeight);
    }
    else
    {
        CGFloat tblHeight = (80 * [self.allClaims count]) + 175;
        
        if(tblHeight > 385)
        {
            tblHeight = 385;
        }
        
        self.tblClaimsView.frame = CGRectMake(20, 120 , self.tblClaimsView.frame.size.width, tblHeight);
    }
    
    [self.tblClaimsView reloadData];
}

# pragma mark -
# pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allClaims count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblClaimsView)
    {
        static NSString *CellIdentifier = @"claimCell";
        claimCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        LinkToClaim *claim = [self.allClaims objectAtIndex:indexPath.row];
        
        cell.backgroundView = [self createViewForNormalClaimCellView];
        cell.selectedBackgroundView = [self createViewForSelectedClaimCellView];
        cell.lblClaimNumber.text = [NSString stringWithFormat:@"YOUR CLAIM %@",claim.claim_number];
        return cell;
    }

    return nil;
}


-(UIView*)createViewForNormalClaimCellView
{
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = [UIColor clearColor];
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = THEME_RED_COLOR.CGColor;
    sublayer.frame = CGRectMake(0, 5, 279, 70);
    [cellView.layer addSublayer:sublayer];
    
    return cellView;
}

-(UIView*)createViewForSelectedClaimCellView
{
    UIView *selectedView = [[UIView alloc]init];
    selectedView.backgroundColor = [UIColor clearColor];
    
    CALayer *selSublayer = [CALayer layer];
    selSublayer.backgroundColor = [UIColor whiteColor].CGColor;
    selSublayer.borderWidth = 1.5;
    selSublayer.borderColor = THEME_RED_COLOR.CGColor;
    selSublayer.frame = CGRectMake(0, 5, 279, 71);
    [selectedView.layer addSublayer:selSublayer];
    return selectedView;
}

-(UIView*)createViewForNormalButton
{
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = [UIColor clearColor];
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor clearColor].CGColor;
    sublayer.borderWidth = 1.5;
    sublayer.borderColor = THEME_RED_COLOR.CGColor;
    sublayer.frame = CGRectMake(0, 5, 279, 70);
    [cellView.layer addSublayer:sublayer];
    
    return cellView;
}

-(UIView*)createViewForSelectedButton
{
    UIView *selectedView = [[UIView alloc]init];
    selectedView.backgroundColor = [UIColor clearColor];
    
    CALayer *selSublayer = [CALayer layer];
    selSublayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4].CGColor;
    selSublayer.frame = CGRectMake(0, 5, 279, 70);
    [selectedView.layer addSublayer:selSublayer];
    return selectedView;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ApplicationData sharedInstance].navigateFromView = @"TabView";
    
    self.selCellIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"HOME_TO_TABVIEW" sender:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)btnLinkClicked:(id)sender
{
   // open Link Claim view
    NSLog(@"btn Link Click HOME_TO_LINK");
    [self performSegueWithIdentifier:@"HOME_TO_LINK" sender:self];
}

-(IBAction)btnReportClicked:(id)sender
{
    // open mail view
    NSLog(@"btn Report Click");
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    
    // only on iOS < 3
    //if ([MFMailComposeViewController canSendMail] == NO)
    //  [self launchMailApp]; // you need to
    
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:@"office@true.co.uk",nil]];
    
    [mailComposeViewController setSubject:@"Enquiry from the TRUE website"];
    
    // [mailComposeViewController setMessageBody:@"I invite you to join me on clark's callboard.It's a website and mobile app where i post my availability online as well as track the availability of my colleagues.It's easy,free to join, and designed especially for our industry.You can click the link to open the registration page http://demo.inextsolutions.com/clark/register.html or check out furthur information and view a full demonstration at: http://clarkscallboard.com/clarkscallboard.com/Parked_Page.html" isHTML:YES];
    
    
    mailComposeViewController.delegate = self;
    mailComposeViewController.title = @"Report Claim";
    mailComposeViewController.navigationBar.tintColor = THEME_RED_COLOR;
    
    [self.navigationController presentViewController:mailComposeViewController animated:YES completion:nil];

}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)shareBntClick:(id)sender
{
    UIImage *logoImg = [UIImage imageNamed:@"ios_true_logo.png"];
    
    NSString *linkStr = @"link to appstore for download true claim";
    
    NSString *initalTextString = [NSString stringWithFormat:@"%@",linkStr];
    
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:@[logoImg,initalTextString] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnAboutClick:(id)sender
{
     [self performSegueWithIdentifier:@"HOME_TO_ABOUT" sender:self];
}

-(IBAction)btnFAQClicked:(id)sender
{
     [self performSegueWithIdentifier:@"HOME_TO_FAQ" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"RECIEVE SEGUE IDENTIFIER ON PREPARE : %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"HOME_TO_ABOUT"])
    {
        AboutUsViewController *controller = [segue destinationViewController];
        controller.displayHtmlfile = @"ABOUT";
    }
    else if([segue.identifier isEqualToString:@"HOME_TO_TABVIEW"])
    {
        LinkToClaim *claim = [self.allClaims objectAtIndex: self.selCellIndex];
        NSLog(@"SELECTED CLAIM AUTH TOKEN ON HOME: %@",claim.auth_token);
        [ApplicationData sharedInstance].selectedClaim = claim;

    }

}


@end
