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

@interface HomeRegularViewController ()

@property(nonatomic,strong) NSArray *allClaims;

@end

@implementation HomeRegularViewController

-(void) viewDidAppear:(BOOL)animated
{
//    
//     LinkClaimViewController *linkClaimView = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkClaimViewController"];
//    self.navController = [[UINavigationController alloc] initWithRootViewController:linkClaimView];
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
    
//    if([ApplicationData sharedInstance].isFirstTime == YES)
//    {
//        IntroViewController *introView = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
//        introView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:introView animated:NO completion:nil];
//    }
    
    self.title = @"Home";
    self.navigationController.navigationBarHidden = YES;
    
    self.allClaims = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_CLAIM];
    
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
    self.tblClaimsView.hidden = YES;
    self.logoImageView.hidden = YES;
    self.tblButtonsView.hidden = NO;
    self.logoBackView.hidden = NO;
    
    self.logoBackView.backgroundColor = [UIColor clearColor];
    self.tblButtonsView.backgroundColor = [UIColor clearColor];
    
    self.lblLink.text = @"To get the most from this app \n please link your claim below";
    
    NSString *attribText = @"link your claim";
    [self.lblLink setFont:[UIFont boldSystemFontOfSize:18] string:attribText];
    [self.lblLink setFontColor:THEME_RED_COLOR string:attribText];
    
//    NSString *attribText2 = @"below";
//    [self.lblLink setFont:[UIFont systemFontOfSize:18] string:attribText2];
//    [self.lblLink setFontColor:[UIColor greenColor] string:attribText2];
    
    if(!IS_IPHONE_5)
    {
        self.logoBackView.frame = CGRectMake(0, 30, self.logoBackView.frame.size.width, self.logoBackView.frame.size.height);
        self.tblButtonsView.frame = CGRectMake(20, (self.logoBackView.frame.origin.y + self.logoBackView.frame.size.height) + 10, self.tblButtonsView.frame.size.width,155);
        self.btnBackView.frame = CGRectMake(0, (self.tblButtonsView.frame.origin.y + self.tblButtonsView.frame.size.height) + 20, self.btnBackView.frame.size.width,self.btnBackView.frame.size.height);
    }
    else
    {
        self.logoBackView.frame = CGRectMake(0, 80, self.logoBackView.frame.size.width, self.logoBackView.frame.size.height);
    }
}

-(void) setupViewForRegularUser
{
    self.tblClaimsView.hidden = NO;
    self.tblButtonsView.hidden = NO;
    self.logoBackView.hidden = YES;
    self.logoImageView.hidden = NO;
    
    if(!IS_IPHONE_5)
    {
        self.tblClaimsView.frame = CGRectMake(20, 115, self.tblClaimsView.frame.size.width, 160);
        self.tblButtonsView.frame = CGRectMake(20, 115 + self.tblClaimsView.frame.size.height + 5,self.tblButtonsView.frame.size.width , 160);
        self.btnBackView.frame = CGRectMake(0, self.tblButtonsView.frame.origin.y + self.tblButtonsView.frame.size.height, 320, 44);
    }
    else
    {
        self.tblClaimsView.frame = CGRectMake(20, 115, self.tblClaimsView.frame.size.width, 240);
        self.tblButtonsView.frame = CGRectMake(20, 115 + self.tblClaimsView.frame.size.height + 5,self.tblButtonsView.frame.size.width , 160);
        self.btnBackView.frame = CGRectMake(0, self.tblButtonsView.frame.origin.y + self.tblButtonsView.frame.size.height, 320, 44);
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
    if(tableView == self.tblClaimsView)
    {
        return [self.allClaims count];
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tblClaimsView)
    {
        static NSString *CellIdentifier = @"claimCell";
        claimCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Claim *claim = [self.allClaims objectAtIndex:indexPath.row];
        
        cell.backgroundView = [self createViewForNormalClaimCellView];
        cell.selectedBackgroundView = [self createViewForSelectedClaimCellView];
        cell.lblClaimNumber.text = [NSString stringWithFormat:@"YOUR CLAIM %@",claim.claimsNumber];
        return cell;
    }

    if(tableView == self.tblButtonsView)
    {
        static NSString *CellIdentifier = @"btnCell";
        btnCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        cell.backgroundView = [self createViewForNormalButton];
        cell.selectedBackgroundView = [self createViewForSelectedButton];
    
        if(indexPath.row == 0)
        {
            cell.imgType.image = [UIImage imageNamed:@"ios_link_claim_icon.png"];
            cell.imgType.highlightedImage = [UIImage imageNamed:@"ios_link_claim_icon.png"];
            cell.lblTitle.text = @"LINK TO MY CLAIM";
        }
        else if(indexPath.row == 1)
        {
            cell.imgType.image = [UIImage imageNamed:@"ios_report_claim_icon.png"];
            cell.imgType.highlightedImage = [UIImage imageNamed:@"ios_report_claim_icon.png"];
            cell.lblTitle.text = @"REPORT A NEW CLAIM";
        }
        
        cell.backgroundView.backgroundColor = [UIColor clearColor];
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
//        RKTabBaseViewController *tabsVC = [[RKTabBaseViewController alloc]init];
//        
//        //[self.navigationController pushViewController:tabsVC animated:YES];
//        [self presentViewController:tabsVC animated:YES completion:nil];
    }
    
    if(tableView == self.tblButtonsView)
    {
//        LinkClaimViewController *linkClaimView = [self.storyboard instantiateViewControllerWithIdentifier:@"LinkClaimViewController"];
//        
//        [self.navigationController pushViewController:linkClaimView animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
