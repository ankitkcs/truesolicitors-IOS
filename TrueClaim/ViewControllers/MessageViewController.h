//
//  ClaimHistoryViewController.h
//  TrueClaim
//
//  Created by krish on 7/21/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface MessageViewController : UITableViewController
<
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate,
UISearchDisplayDelegate
>
//@property (nonatomic,strong) NSMutableArray *myLocalDataArray;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong) IBOutlet UIButton *btnHome;
@property(nonatomic,assign) BOOL isFiltering;
@property(nonatomic,strong) NSMutableArray *allMessages;
@property(nonatomic,strong) NSMutableArray *filteredMessages;

@property (strong,nonatomic) UIView *myRefreshView;

-(IBAction)btnHomeClick:(id)sender;
-(IBAction)newMessageClicked:(id)sender;

@end
