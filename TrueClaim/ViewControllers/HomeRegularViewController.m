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
    
    if([self.allClaims count] == 0)
    {
        [self setUpViewForFirstTimeUser];
    }
    else
    {
        [self setupViewForRegularUser];
    }
    
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
        
        //self.tblButtonsView.frame = CGRectMake(20, (self.logoBackView.frame.origin.y + self.logoBackView.frame.size.height) + 10, self.tblButtonsView.frame.size.width,155);
        //self.btnBackView.frame = CGRectMake(0, (self.tblButtonsView.frame.origin.y + self.tblButtonsView.frame.size.height) + 20, self.btnBackView.frame.size.width,self.btnBackView.frame.size.height);
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
        
        if(tblHeight > 300)
        {
            tblHeight = 300;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.tblClaimsView)
    {
            LinkToClaim *claim = [self.allClaims objectAtIndex:indexPath.row];
            NSLog(@"SELECTED CLAIM AUTH TOKEN ON HOME: %@",claim.auth_token);
            [ApplicationData sharedInstance].selectedClaim = claim;
            [self performSegueWithIdentifier:@"TabControllerSegueIdentifier" sender:self];
    }
}

-(IBAction)btnLinkClicked:(id)sender
{
   // open Link Claim view
}

-(IBAction)btnReportClicked:(id)sender
{
    // open mail view
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"RECIEVE SEGUE IDENTIFIER ON PREPARE : %@",segue.identifier);
}


@end
