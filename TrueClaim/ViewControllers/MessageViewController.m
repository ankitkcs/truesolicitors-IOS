//
//  ClaimHistoryViewController.m
//  TrueClaim
//
//  Created by krish on 7/21/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "MessageViewController.h"
#import "messageCellView.h"
#import "WriteMessageViewController.h"
#import "MessageDetailViewController.h"
#import "MyDatabaseManager.h"
//#import "MassegeDetail.h"
#import "DemoData.h"

@interface MessageViewController ()
{
    NSMutableArray *msgTextrecords;
    NSString *sortingAttribute;
}
@property (nonatomic, readwrite, assign) NSUInteger reloads;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //customize searchbar
    [self customizeSearchbar];
    
    // setup pull-to-refresh
    [self setUpPullToRefreshView];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    sortingAttribute = kMsgText;
    NSArray *records  = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_MASSEGE_DETAIL];
    
    if(records.count == 0)
    {
        [self addStaticDataToCoreData];
    }
    else
    {
        [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_MASSEGE_DETAIL];
        [self addStaticDataToCoreData];
    }
    
    self.filteredMessages = [NSMutableArray arrayWithCapacity:[self.allMessages count]];
    [self.tableView reloadData];
    
}

-(void) addStaticDataToCoreData
{
    NSArray *dataArray = [DemoData messageDataForDemo];
    
    for (NSDictionary *msgDict in dataArray)
    {
        [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_MASSEGE_DETAIL withDataDict:msgDict];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    
    //    id nav = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    if ([nav isKindOfClass:[UINavigationController class]])
    //    {
    //        UINavigationController *navc = (UINavigationController *) nav;
    //        if(navc.navigationBarHidden)
    //        {
    //            NSLog(@"NOOOO NAV BAR");
    //        } else {
    //            NSLog(@"WE HAVE NAV BAR");
    //        }
    //    }
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *noteBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessageClicked:)];
    self.navigationItem.rightBarButtonItem = noteBarBtn;
    
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
    
    self.navigationItem.title = @"CLAIM 346002";
    self.tabBarItem.title = @"Message";
    
    UITabBarItem *tbi = (UITabBarItem *)self.tabBarController.selectedViewController.tabBarItem;
    tbi.badgeValue = @"1";
    
    [ApplicationData sharedInstance].isDisply_PassCodeScreen = YES;
    [self reloadMyTable];
}

-(void)reloadMyTable
{
    self.allMessages  = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_MASSEGE_DETAIL] mutableCopy];
    [self.tableView reloadData];
}

-(IBAction)newMessageClicked:(id)sender
{
    WriteMessageViewController *newMsgView = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMessageViewController"];
    [self presentViewController:newMsgView animated:YES completion:nil];
}

-(IBAction)btnHomeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) goBackToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltering)
    {
        return [self.filteredMessages count];
    }
    else
    {
        return [self.allMessages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    messageCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    
    MassegeDetail *msgDetails;
    
    if (self.isFiltering)
    {
        msgDetails = [self.filteredMessages objectAtIndex:indexPath.row];
    }
    else
    {
        msgDetails = [self.allMessages objectAtIndex:indexPath.row];
    }
    
        cell.logoImageView.image = [UIImage imageNamed:msgDetails.msgImage];
        cell.lblDate.text = msgDetails.msgDate;
    
        CGRect lblMessageFrame = cell.lblMesaage.frame;
        lblMessageFrame.size.height = [self dyanmicHeightForlabelText:msgDetails.msgText]+5;
        cell.lblMesaage.frame = lblMessageFrame;
    
        cell.lblMesaage.numberOfLines = 0;
        cell.lblMesaage.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblMesaage.text = msgDetails.msgText;
    
        if(indexPath.row == 0)
        {
            cell.lblStatus.hidden = NO;
        }
        else
        {
            cell.lblStatus.hidden = YES;
        }
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    MassegeDetail *msgDetails;
    
    if (self.isFiltering)
    {
        msgDetails = [self.filteredMessages objectAtIndex:indexPath.row];
    }
    else
    {
        msgDetails = [self.allMessages objectAtIndex:indexPath.row];
    }
    
    cellHeight = 60 + [self dyanmicHeightForlabelText:msgDetails.msgText] + 10;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    MessageDetailViewController *msgDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageDetailViewController"];
//    [self.navigationController pushViewController:msgDetailView animated:YES];
}

-(CGFloat) dyanmicHeightForlabelText:(NSString*)commentText
{
    CGSize size;
    NSString *str = commentText;
    
    if (IS_IOS7_OR_PLUS)
    {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName, nil];
        
        CGRect frame = [str boundingRectWithSize:CGSizeMake(300, 1000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
        
        size = frame.size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    NSLog(@"DYNAMIC HEIGHT BY TEXT : %0.f",size.height);
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma -mark
#pragma -mark Searchbar Delegates

-(void) customizeSearchbar
{
    [self.searchBar setImage:[UIImage imageNamed: @"ios_search_icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"ios_cross_search_icon.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"ios_cross_search_icon.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    //self.searchBar.delegate = self;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    self.filteredMessages = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil
                                                                                    where:scope
                                                                                 contains:searchText]mutableCopy];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0)
    {
        self.isFiltering = NO;
    }
    else
    {
         self.isFiltering = YES;
    }
    
    [self filterContentForSearchText:searchText scope:kMsgText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma -mark
#pragma -mark Scrollview Delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma -mark
#pragma -mark Pull to Refresh Action & View

-(void) setUpPullToRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        weakSelf.myRefreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, weakSelf.view.bounds.size.height - (50 + 100))];
        weakSelf.myRefreshView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, weakSelf.myRefreshView.frame.size.height/2 - 25, 320, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = THEME_RED_COLOR;
        label.numberOfLines = 2;
        [label setText:@"Updating your app \n please wait..."];
        label.font = [UIFont boldSystemFontOfSize:16];
        
        [weakSelf.myRefreshView addSubview: label];
        
        [weakSelf.tableView addSubview:weakSelf.myRefreshView];
        [weakSelf insertRowAtTop];
    }];
    
    [[self.tableView pullToRefreshView] setCustomView:[self customPullView] forState:SVPullToRefreshStateLoading];
    
    // setup infinite scrolling
    //    [self.tableView addInfiniteScrollingWithActionHandler:^{
    //        //[weakSelf insertRowAtBottom];
    //    }];

}

- (UIView *) customPullView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    av.color = THEME_RED_COLOR;
    av.center = CGPointMake(self.view.frame.size.width / 2,15);
    [av startAnimating];
    [v addSubview:av];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 320, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = THEME_RED_COLOR;
    [label setText:@"CHECKING FOR UPDATES"];
    label.font = [UIFont boldSystemFontOfSize:14];
    [v addSubview:label];
    return v;
}

- (void)insertRowAtTop
{
    if(!self.isFiltering)
    {
        int64_t delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.tableView beginUpdates];
            
            [self.allMessages addObject:[self myNewDictioanry]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: ([self.allMessages count] - 1) inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            [self.tableView.pullToRefreshView stopAnimating];
            //[self.tableView scrollRectToVisible:CGRectMake(0, 100, 1, 1) animated:YES];
            //[commentTableView scrollRectToVisible:CGRectMake(0, commentTableView.contentSize.height-1, 1, 1) animated:YES];
            [self.myRefreshView removeFromSuperview];
        });
    }
    else
    {
        return;
    }
}

//- (void)insertRowAtBottom
//{
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.tableView beginUpdates];
//        //[self.dataSource addObject:[weakSelf.dataSource.lastObject dateByAddingTimeInterval:-90]];
//        //[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
//
//        [self.tableView.infiniteScrollingView stopAnimating];
//    });
//}


#pragma -mark
#pragma -mark LOCAL DATA DICTIONARY

-(NSDictionary*) myNewDictioanry  // for demo adding only
{
    NSDictionary *dict = @{
                           kMsgDate: @"Tues,Feb 28, 11.23 AM",
                           kMsgImage: @"ios_true_logoCell.png",
                            kMsgText: @"Good news! The other party has accepted your offer. In accordeance with the court rules they should now send your settlement cheque within 4 working days.",
                           kMsgAttachment: @"N"
                           };
    return dict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
