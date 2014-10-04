//
//  HomeViewController.h
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"

@interface HomeRegularViewController : UIViewController
{
  
}

@property(nonatomic,weak) IBOutlet UILabel *lblWelocome;
@property(nonatomic,weak) IBOutlet NZLabel *lblLink;

@property(nonatomic,weak) IBOutlet UIView *logoBackView;
@property(nonatomic,weak) IBOutlet UIImageView *logoImageView;

@property(nonatomic,weak) IBOutlet UITableView *tblButtonsView;
@property(nonatomic,weak) IBOutlet UITableView *tblClaimsView;

@property(nonatomic,weak) IBOutlet UIButton *btnAboutUS;
@property(nonatomic,weak) IBOutlet UIButton *btnShareApp;
@property(nonatomic,weak) IBOutlet UIButton *btnFAQ;
@property(nonatomic,weak) IBOutlet UIView *btnBackView;


//@property(nonatomic,strong) UINavigationController *navController;
//
//- (IBAction)btnAboutUsClicked:(id)sender;
//- (IBAction)btnShareClicked:(id)sender;
//- (IBAction)btnFAQClicked:(id)sender;

@end
