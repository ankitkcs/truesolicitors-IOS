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
#import "MassegeDetail.h"
#import  "RKMTransView.h"

@interface MessageViewController () <RKMTransViewDelegate>
{
    NSMutableArray *msgTextrecords;
    NSString *sortingAttribute;
}
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (nonatomic, retain) RKMTransView *transparentView;

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
}


-(void) viewWillAppear:(BOOL)animated
{
    //********************* CLEAR DATA *******************************************
    //[[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_MASSEGE_DETAIL];
    //****************************************************************************
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *noteBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessageClicked)];
    self.navigationItem.rightBarButtonItem = noteBarBtn;
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    // add custom back Button
    UIButton *btnBack = [ApplicationData customBackNavButtonWithTite:@"Home"
                        icon:[UIImage imageNamed:@"ios_back_arrow_icon.png"]
                        bgColor:[UIColor clearColor]
                        titleColor:THEME_RED_COLOR
                        titleFont:[UIFont boldSystemFontOfSize:17]
                        buttonSize:CGRectMake(-0.5f, 0, 80, 44)];
    
    [btnBack addTarget:self action:@selector(btnHomeClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barBackButton;
    
    self.selClaim = [ApplicationData sharedInstance].selectedClaim;
    self.navigationItem.title = self.selClaim.claim_number;
    self.tabBarItem.title = @"Message";
    self.tabBarController.tabBar.tintColor = THEME_RED_COLOR;
    
    self.allMessages  = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:kMsgPostedAt  byAcending:NO fromTable:TBL_MASSEGE_DETAIL] mutableCopy];
    
    if(self.allMessages.count == 0)
    {
        [self sendRequestForGetMessages];
    }
    else
    {
        //[[ApplicationData sharedInstance] showAlert:@"No Data Found" andTag:0];
        [self refreshTableData];
    }
}

-(void) sendRequestForGetMessages //get first message
{
    NSLog(@"SELECTED AUTH TOKEN-NUMBER ON MESSAGE : %@",self.selClaim.auth_token);
    
     if([ApplicationData ConnectedToInternet])
     {
         [ProgressHudHelper showLoadingHudWithText:@""];
         // request for get messages
         self.webApi = [[WebApiRequest alloc] init];
         [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
         [self.webApi PostDataWithParameter:nil forDelegate:self andTag:tGetMessage forRequstType:reqGET_MESSAGE serviceType:WS_GET];
     }
    else
    {
        // show old messages from database
        [self refreshTableData];
        [[ApplicationData sharedInstance]showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }
}

-(void) sendRequestForGetNewMessages // on pull to refresh
{
    MassegeDetail *msgDetail = [self.allMessages objectAtIndex:0];
    NSString *reqForNewMsg = [NSString stringWithFormat:@"messages/%@",msgDetail.guid];
    NSLog(@"SELECTED AUTH TOKEN-NUMBER ON MESSAGE : %@",self.selClaim.auth_token);
    
    if([ApplicationData ConnectedToInternet])
    {
    // request for get messages
    self.webApi = [[WebApiRequest alloc] init];
    [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
    [self.webApi PostDataWithParameter:nil forDelegate:self andTag:tGetNewMessage forRequstType:reqForNewMsg serviceType:WS_GET];
    }
    else
    {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.transparentView close];
        [[ApplicationData sharedInstance]showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }
}

-(void) makeAllMessagaesOldBeforeGettingNewMessage
{
    for(int i =0; i< self.allMessages.count; i++)
    {
         MassegeDetail *msgDetail = [self.allMessages objectAtIndex:i];
        
         NSDictionary *updateDict = @{ kMsgIsNewMessage:@"0"};
        
         [[MyDatabaseManager sharedManager] updateRecordInTable:TBL_MASSEGE_DETAIL
                                                       ofRecord:msgDetail
                                                 recordDetail:updateDict];
    }
    
    [self sendRequestForGetNewMessages];
}

-(void)refreshTableData
{
    self.filteredMessages = [NSMutableArray arrayWithCapacity:[self.allMessages count]];
    [self.tableView reloadData];
    
    self.allMessages  = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:kMsgPostedAt  byAcending:NO fromTable:TBL_MASSEGE_DETAIL] mutableCopy];
    [self.tableView reloadData];
}

-(void)newMessageClicked
{
    WriteMessageViewController *newMsgView = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteMessageViewController"];
    [self presentViewController:newMsgView animated:YES completion:nil];
}

//-(IBAction)btnHomeClick:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)btnHomeClick
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
    
    if([msgDetails.from isEqualToString:@"TRUE Solicitors"])
    {
        cell.logoImageView.image = [UIImage imageNamed:@"ios_true_logoCell.png"];
    }
    else
    {
        cell.logoImageView.image = [UIImage imageNamed:@"ios_user_icon.png"];
    }
    
        cell.lblDate.text = msgDetails.posted_at;
    
        CGRect lblMessageFrame = cell.lblMesaage.frame;
        lblMessageFrame.size.height = [self dyanmicHeightForlabelText:msgDetails.body]+5;
        cell.lblMesaage.frame = lblMessageFrame;
        cell.lblMesaage.numberOfLines = 0;
        cell.lblMesaage.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblMesaage.text = msgDetails.body;
    
        if([msgDetails.is_new_message isEqualToString:@"1"])
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
    
    cellHeight = 60 + [self dyanmicHeightForlabelText:msgDetails.body] + 10;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    //NSLog(@"DYNAMIC HEIGHT BY TEXT : %0.f",size.height);
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
    
    //NSLog(@"SEARCH TEXT : %@",searchText);
    //NSLog(@"SCOPE TEXT : %@",scope);
    
    self.filteredMessages = [[[MyDatabaseManager sharedManager]
                              allRecordsSortByAttribute:kMsgPostedAt
                              where:scope
                              contains:searchText
                              byAcending:YES
                              fromTable:TBL_MASSEGE_DETAIL]mutableCopy];
    
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
    [self filterContentForSearchText:searchText scope:kMsgBody];
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

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
}

-(void) setUpPullToRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        weakSelf.transparentView = [[RKMTransView alloc] init];
        weakSelf.transparentView.delegate = weakSelf;
        weakSelf.transparentView.backgroundColor = [UIColor clearColor];
        weakSelf.transparentView.allowBlurView  = YES;
        weakSelf.transparentView.hideCloseButton = YES;
        weakSelf.transparentView.hideAlertView = YES;
        
        //design refresh view
        weakSelf.myRefreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, weakSelf.view.bounds.size.height-55)];
        weakSelf.myRefreshView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, weakSelf.myRefreshView.frame.size.height/2 - 25, 320, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = THEME_RED_COLOR;
        label.numberOfLines = 2;
        [label setText:@"Updating your app \n please wait..."];
        label.font = [UIFont boldSystemFontOfSize:16];
        [weakSelf.myRefreshView addSubview: label];
        
        [weakSelf.transparentView addSubview:weakSelf.myRefreshView];
        [weakSelf.transparentView open];
        
        // call new message service here
        [weakSelf makeAllMessagaesOldBeforeGettingNewMessage];
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

//- (void)insertRowAtTop
//{
//    if(!self.isFiltering)
//    {
//        int64_t delayInSeconds = 5.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//        {
//            /*
//            [self.tableView beginUpdates];
//            
//            //[self.allMessages addObject:[self myNewDictioanry]];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: ([self.allMessages count] - 1) inSection:0];
//            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView endUpdates];
//            */
//            
//            [self.tableView.pullToRefreshView stopAnimating];
//            [self.transparentView close];
//            
//            //[self.tableView scrollRectToVisible:CGRectMake(0, 100, 1, 1) animated:YES];
//            //[commentTableView scrollRectToVisible:CGRectMake(0, commentTableView.contentSize.height-1, 1, 1) animated:YES];
//            
//        });
//    }
//    else
//    {
//        return;
//    }
//}

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


#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    @try{
        
        if ([ErrorMsg length]>0)
        {
            //[ProgressHudHelper dissmissAdvanceHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == tGetMessage)
            {
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    [self insertDataToLocalDatabeseFromDictionary:responseData];
                    
                    NSArray *msgArray = [responseData valueForKey:@"messages"];
                    [self updateBadgesForMessageCount:msgArray.count];
                    [ProgressHudHelper hideLoadingHud];
                }
                else
                {
                    [ProgressHudHelper hideLoadingHud];
                    [[ApplicationData sharedInstance] showAlert:[responseData valueForKey:@"response_message"] andTag:0];
                }
            }
            else if (Tag == tGetNewMessage) // after getting New Messages
            {
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    [self insertDataToLocalDatabeseFromDictionary:responseData];
                    [self.tableView.pullToRefreshView stopAnimating];
                    //count new messages
                    NSArray *msgArray = [responseData valueForKey:@"messages"];
                    [self updateBadgesForMessageCount:msgArray.count];
                    [self.transparentView close];
                }
                else
                {
                    [self.tableView.pullToRefreshView stopAnimating];
                    [self.transparentView close];
                    [[ApplicationData sharedInstance] showAlert:[responseData valueForKey:@"response_message"] andTag:0];
                }
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

-(void) updateBadgesForMessageCount:(int) numOfNewMsg
{
    UITabBarItem *tbi = (UITabBarItem *)self.tabBarController.selectedViewController.tabBarItem;
    
    if(numOfNewMsg > 0)
    {
        tbi.badgeValue = [NSString stringWithFormat:@"%d",numOfNewMsg];
    }
    else
    {
        tbi.badgeValue = nil;
    }
}

-(void) insertDataToLocalDatabeseFromDictionary:(NSMutableArray *)responseData
{

            NSLog(@"Now you can save the data to local database With Response Data : %@",responseData);
            
            NSArray *msgArray = [responseData valueForKey:@"messages"];
    
            //NSLog(@"FIRST MESSAGE DETAIL : %@",[msgArray objectAtIndex:0]);
            
            // NSArray *attachDocArray = [[msgArray objectAtIndex:0] valueForKey:@"attached_document_guids"];
            // NSLog(@"DOC IDS : %@",[attachDocArray objectAtIndex:0]);
            // NSString *attacmentID = [attachDocArray objectAtIndex:0];
            
            NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
            
            for(int i=0; i < msgArray.count ; i++)
            {
                NSArray *attachDocArray = [[msgArray objectAtIndex:0] valueForKey:kMsgAttachesDocGuids];
                NSString *attachmentID;
                
                if(attachDocArray.count == 0)
                {
                    attachmentID = @"";
                }
                else
                {
                    attachmentID =  [attachDocArray objectAtIndex:0];
                }
               
                //NSString *attached_document_guids = attacmentID;
                NSString *from = [[msgArray objectAtIndex:i] valueForKey:kMsgFrom];
                NSString *guid = [[msgArray objectAtIndex:i] valueForKey:kMsgGuid];
                NSString *body = [[msgArray objectAtIndex:i] valueForKey:kMsgBody];
                NSString *posted_at = [[msgArray objectAtIndex:i] valueForKey:kMsgPostedAt];
                NSString *is_delivered = [NSString stringWithFormat:@"%@",[[msgArray objectAtIndex:i] valueForKey:kMsgIsDeliverd]];
                NSString *is_to_firm = [NSString stringWithFormat:@"%@",[[msgArray objectAtIndex:i] valueForKey:kMsgIsToFirm]];
                
                NSString *is_new_message = [NSString stringWithFormat:@"%@",@"1"];
                NSString *created_at = todayDate;
                NSString *claim_number = self.selClaim.claim_number;
                
                
                NSMutableDictionary *saveMessage = [NSMutableDictionary dictionary];
                [saveMessage setValue:attachmentID forKey:kMsgAttachesDocGuids];
                [saveMessage setValue:from forKey:kMsgFrom];
                [saveMessage setValue:guid forKey:kMsgGuid];
                [saveMessage setValue:body forKey:kMsgBody];
                [saveMessage setValue:posted_at forKey:kMsgPostedAt];
                [saveMessage setValue:is_delivered forKey:kMsgIsDeliverd];
                [saveMessage setValue:is_to_firm forKey:kMsgIsToFirm];
                
                [saveMessage setValue:is_new_message forKey:kMsgIsNewMessage];
                [saveMessage setValue:created_at forKey:kCreateAt];
                [saveMessage setValue:claim_number forKeyPath:kMsgClaimNumber];
                
                NSLog(@"Dict To Save : %@",saveMessage);
                
                MassegeDetail *newMessage = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_MASSEGE_DETAIL withDataDict:saveMessage];
                
                if(newMessage)
                {
                    NSLog(@"MESSAGE SAVED");
                }
            }
            
            [self refreshTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
