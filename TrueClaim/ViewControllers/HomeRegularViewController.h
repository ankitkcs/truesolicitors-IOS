//
//  HomeViewController.h
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
#import "LinkToClaim.h"

//@protocol homeViewDelegate <NSObject>
//-(void) SelectedClaim:(LinkToClaim*)claim;
//@end

@interface HomeRegularViewController : UIViewController

@property(nonatomic,weak) IBOutlet UILabel *lblWelocome;
@property(nonatomic,weak) IBOutlet NZLabel *lblLink;

@property(nonatomic,weak) IBOutlet UIView *logoBackView;
@property(nonatomic,weak) IBOutlet UIImageView *logoImageView;

@property(nonatomic,weak) IBOutlet UIView *btnLinkBackView;
@property(nonatomic,weak) IBOutlet UIView *btnReportBackView;
@property(nonatomic,weak) IBOutlet UIView *btnFooterView;

//@property(nonatomic,weak) IBOutlet UITableView *tblButtonsView;
@property(nonatomic,weak) IBOutlet UITableView *tblClaimsView;

@property(nonatomic,weak) IBOutlet UIButton *btnAboutUS;
@property(nonatomic,weak) IBOutlet UIButton *btnShareApp;
@property(nonatomic,weak) IBOutlet UIButton *btnFAQ;
@property(nonatomic,weak) IBOutlet UIView *btnBackView;

//@property(nonatomic,weak) id <homeViewDelegate> delegate;


//@property(nonatomic,strong) UINavigationController *navController;
//
- (IBAction)btnLinkClicked:(id)sender;
- (IBAction)btnReportClicked:(id)sender;
//- (IBAction)btnFAQClicked:(id)sender;

@end
