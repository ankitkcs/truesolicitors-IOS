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
#import "MyDatabaseManager.h"
#import "DocumentDetail.h"
#import "PasscodePopController.h"

//#import "RKPopUpAlertView.h"

@interface MyFolderViewController () <passDelegate,PassCodePopDelegate>

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
    
    NSLog(@"FOLDER VIEW APPEAR");
    
    self.navigationItem.title = @"MY FOLDER";
    self.tabBarItem.title = @"My Folder";
    
    //getSavedPassword
    NSString *savPass = [ApplicationData offlineObjectForKey:SAVED_PASSCODE];
    if([savPass isEqualToString:@""] || savPass == nil)
    {
        [self showTransparentPopUpAlertViewForWelcomeToFolder];
    }
    else
    {
        [self showTransparentPopUpAlertWithPassCodeScreen];
    }
    self.selClaim = [ApplicationData sharedInstance].selectedClaim;
}


-(void) sendRequestForGetAllDocuments
{
    [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_DOCUMENT_DETAIL];
    
    if([ApplicationData ConnectedToInternet])
    {
        [ProgressHudHelper showLoadingHudWithText:@""];
    
    NSLog(@"SELECTED AUTH TOKEN-NUMBER ON MESSAGE : %@",self.selClaim.auth_token);
    // request for get messages
    self.webApi = [[WebApiRequest alloc] init];
    [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
    [self.webApi PostDataWithParameter:nil forDelegate:self andTag:tGetDoc forRequstType:reqGET_DOCUMENTS serviceType:WS_GET];
    }
    else
    {
        [[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }
}

-(void) sendRequestForGetAllDocumentsType
{
    [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_DOCUMENT_TYPE];
    
    if([ApplicationData ConnectedToInternet])
    {
        [ProgressHudHelper showLoadingHudWithText:@""];
        
        NSLog(@"SELECTED AUTH TOKEN-NUMBER ON MESSAGE : %@",self.selClaim.auth_token);
        // request for get messages
        self.webApi = [[WebApiRequest alloc] init];
        [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
        [self.webApi PostDataWithParameter:nil forDelegate:self andTag:tGetDocType forRequstType:reqGET_DOCUMNETS_TYPE serviceType:WS_GET];
    }
    else
    {
        [[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }
}



-(void) showTransparentPopUpAlertViewForWelcomeToFolder
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

-(void) showTransparentPopUpAlertWithPassCodeScreen
{
    PasscodePopController *passAlert = [[PasscodePopController alloc] init];
    passAlert.delegate = self;
    passAlert.passcodeText = [ApplicationData offlineObjectForKey:SAVED_PASSCODE];
    [passAlert Open];
}

-(void) PopUpCloseWithPassText:(NSString *)passcode
{
    NSLog(@"Entered Passcode In MyFolder %@",passcode);
    [self sendRequestForGetAllDocuments];
}

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
    [self showPassCodeScreen];
}

-(void) showPassCodeScreen
{
    PassCodeViewController *passCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TempPassCodeVC"];
    passCodeVC.delegate = self;
    [self presentViewController:passCodeVC animated:NO completion:nil];
}

-(void) viewShowingAfterCorrectPassword
{
    [self sendRequestForGetAllDocuments];
}

-(void) goBackToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)refreshTableData
{
    self.allDocuments  = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:kDocCreatedAt byAcending:NO fromTable:TBL_DOCUMENT_DETAIL] mutableCopy];
    
    if(self.allDocuments.count == 0)
    {
        self.tblDocumnets.hidden = YES;
    }
    else
    {
         self.tblDocumnets.hidden = NO;
        [self.tblDocumnets reloadData];
    }
}

# pragma mark -
# pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allDocuments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"folderCell";
        folderDocCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DocumentDetail *docDetails = [self.allDocuments objectAtIndex:indexPath.row];
    
    if (docDetails.app_date_read_at.length > 0)
    {
        cell.docImgRead.image = [UIImage imageNamed:@"ios_tick_doc_icon.png"];
    }
    else
    {
        cell.docImgRead.image = [UIImage imageNamed:@"radio_unchecked.png"];
    }
    
    if (docDetails.app_date_actioned_at.length > 0)
    {
        cell.docImgAction.image = [UIImage imageNamed:@"ios_tick_doc_icon.png"];
    }
    else
    {
        cell.docImgAction.image = [UIImage imageNamed:@"radio_unchecked.png"];
    }
    
    cell.lblDate.text = docDetails.created_at;
    cell.lblDocName.text = docDetails.name;
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
    DocumentDetail *docDetails = [self.allDocuments objectAtIndex:indexPath.row];
    
    [ApplicationData sharedInstance].selectedDocDetail = docDetails;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    @try{
        
        if ([ErrorMsg length]>0)
        {
            [ProgressHudHelper hideLoadingHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == tGetDoc)
            {
                NSLog(@"Response Data : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    NSArray *docsArray = [responseData valueForKey:@"documents"];
                    
                    // get all doc from databse
                    NSArray *allDocOfDB = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:kDocCreatedAt byAcending:NO fromTable:TBL_DOCUMENT_DETAIL] mutableCopy];
                    
                    NSLog(@"COUNT EXIXST DOC IN DB : %lu",(unsigned long)allDocOfDB.count);
                    
                    if(allDocOfDB.count == 0)
                    {
                        for(int j=0; j < docsArray.count; j++)
                        {
                            NSDictionary *docDict = [docsArray objectAtIndex:j];
                            //insert
                            [self insertDocumnet:docDict];
                            NSLog(@"**********Inserte First Time");
                        }
                    }
                    else
                    {
                        [self checkExistDataForUpdateAndInsertWithDBdata:allDocOfDB
                                                               andWSdata:docsArray];
                    }

                    [self refreshTableData];
                    [ProgressHudHelper hideLoadingHud];
                    
                    // call documnet type id
                    [self sendRequestForGetAllDocumentsType];
                    
                }
                else
                {
                    [ProgressHudHelper hideLoadingHud];
                    [[ApplicationData sharedInstance] showAlert:[responseData valueForKey:@"response_message"] andTag:0];
                }
            }
            else if (Tag == tGetDocType)
            {
                [ProgressHudHelper hideLoadingHud];
                NSLog(@"Response Data DOC TYPE : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    NSArray *docsArray = [responseData valueForKey:@"document_types"];
                    
                    NSLog(@"Total Documnets Type : %ld",docsArray.count);
                    
                    for(int j=0; j < docsArray.count; j++)
                    {
                        NSDictionary *docDict = [docsArray objectAtIndex:j];
                        //insert
                        [self insertDocumnetType:docDict];
                    }

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

-(void) checkExistDataForUpdateAndInsertWithDBdata:(NSArray*)allDocOfDB andWSdata:(NSArray*)docsArray
{
    for(int i = 0; i < allDocOfDB.count; i++)
    {
        DocumentDetail *docDetailFromDB = [allDocOfDB objectAtIndex:i];
        
        for(int j=0; j < docsArray.count; j++)
        {
            NSString *guidFromDB = docDetailFromDB.guid;
            NSDictionary *docDictWS = [docsArray objectAtIndex:j];
            NSString *guidFromWS = [docDictWS valueForKey:kDocGuid];
            
            if([guidFromDB isEqualToString:guidFromWS])
            {
                //update
                [self updateDocumnet:docDictWS forDoc:docDetailFromDB];
                NSLog(@"********Updated");
            }
            else
            {
                //insert
                [self insertDocumnet:docDictWS];
                NSLog(@"**********Inserte");
            }
        }
    }
}


-(void) insertDocumnet:(NSDictionary*) docsDict
{
     NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
    
    NSString *guid = [docsDict valueForKey:kDocGuid];
    NSString *name = [docsDict valueForKey:kDocName];
    NSString *app_date_read_at = [docsDict valueForKey:kDocAppDateReadAt];
    NSString *app_date_actioned_at = [docsDict valueForKey:kDocAppDateActionAt];
    NSString *type_code = [docsDict valueForKey:kDocTypeCode];
    NSString *created_at = [docsDict valueForKey:kDocCreatedAt];
    NSString *recorded = todayDate;
    NSString *claim_number = self.selClaim.claim_number;
    
    NSMutableDictionary *saveDocumnet = [NSMutableDictionary dictionary];
    
    [saveDocumnet setValue:guid forKey:kDocGuid];
    [saveDocumnet setValue:name forKey:kDocName];
    [saveDocumnet setValue:app_date_read_at forKey:kDocAppDateReadAt];
    [saveDocumnet setValue:app_date_actioned_at forKey:kDocAppDateActionAt];
    [saveDocumnet setValue:type_code forKey:kDocTypeCode];
    [saveDocumnet setValue:created_at forKey:kDocCreatedAt];
    [saveDocumnet setValue:recorded forKey:kDocRecordedAt];
    [saveDocumnet setValue:claim_number forKey:kDocClaimNumber];
    
    NSLog(@"Dict To Insert : %@",saveDocumnet);
    
    DocumentDetail *newDoc = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_DOCUMENT_DETAIL withDataDict:saveDocumnet];
    
    if(newDoc)
    {
        NSLog(@"Documnet Inserted");
    }
}

-(void) updateDocumnet:(NSDictionary*) docsDict forDoc:(DocumentDetail*)docForUpdate
{
    
    //for read later update here according to read action on letter read page;
    
    NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
    NSString *guid = [docsDict valueForKey:kDocGuid];
    NSString *name = [docsDict valueForKey:kDocName];
    NSString *app_date_read_at = [docsDict valueForKey:kDocAppDateReadAt];
    NSString *app_date_actioned_at = [docsDict valueForKey:kDocAppDateActionAt];
    NSString *type_code = [docsDict valueForKey:kDocTypeCode];
    NSString *created_at = [docsDict valueForKey:kDocCreatedAt];
    NSString *recorded = todayDate;
    NSString *claim_number = self.selClaim.claim_number;
    
    NSDictionary *updateDict = @{kDocGuid : guid,
                                 kDocName : name,
                                 kDocAppDateReadAt : app_date_read_at,
                                 kDocAppDateActionAt : app_date_actioned_at,
                                 kDocTypeCode : type_code,
                                 kDocCreatedAt : created_at,
                                 kDocRecordedAt : recorded,
                                 kDocClaimNumber : claim_number
                                 };
    
    NSLog(@"Dict To Update : %@",updateDict);
    
    DocumentDetail *updateDoc = [[MyDatabaseManager sharedManager]
                              updateRecordInTable:TBL_DOCUMENT_DETAIL
                              ofRecord:docForUpdate
                              recordDetail:updateDict];
    
    if(updateDoc)
    {
        NSLog(@"Documnet Updated");
    }
}

-(void) insertDocumnetType:(NSDictionary*) docsDict
{
    
    NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
    
    NSString *action_prompt = [docsDict valueForKey:kDocTypeActionPrompt];
    NSString *name = [docsDict valueForKey:kDocTypeName];
    NSString *type_code = [docsDict valueForKey:kDocTypeDocCode];
    NSString *response_template = [docsDict valueForKey: kDocRespTemplate];
    NSString *recorded = todayDate;
    
    NSMutableDictionary *saveDocumnet = [NSMutableDictionary dictionary];
    
    [saveDocumnet setValue:action_prompt forKey:kDocTypeActionPrompt];
    [saveDocumnet setValue:name forKey:kDocTypeName];
    [saveDocumnet setValue:type_code forKey:kDocTypeDocCode];
    [saveDocumnet setValue:response_template forKey:kDocRespTemplate];
    
    [saveDocumnet setValue:recorded forKey:kDocRecordedAt];
    
    NSLog(@"Dict To Insert DOC TYPE : %@",saveDocumnet);
    
    DocumentDetail *newDoc = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_DOCUMENT_TYPE withDataDict:saveDocumnet];
    
    if(newDoc)
    {
        NSLog(@"Documnet Inserted");
    }

}



/*
-(void) insertDocumnetsToLocalDataBaseFromData:(NSMutableArray *)responseData
{

        NSArray *docsArray = [responseData valueForKey:@"documents"];
    
        NSLog(@"TOTAL MESSAGES : %d",docsArray.count);
    
        NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
        
        for(int i=0; i < docsArray.count ; i++)
        {
            NSString *guid = [[docsArray objectAtIndex:i] valueForKey:kDocGuid];
            NSString *name = [[docsArray objectAtIndex:i] valueForKey:kDocName];
            NSString *app_date_read_at = [[docsArray objectAtIndex:i] valueForKey:kDocAppDateReadAt];
            NSString *app_date_actioned_at = [[docsArray objectAtIndex:i] valueForKey:kDocAppDateActionAt];
            NSString *type_code = [[docsArray objectAtIndex:i] valueForKey:kDocTypeCode];
            NSString *created_at = [[docsArray objectAtIndex:i] valueForKey:kDocCreatedAt];
            NSString *recorded = todayDate;
            NSString *claim_number = self.selClaim.claim_number;
            
            NSDictionary *saveDict = @{kDocGuid : guid,
                                         kDocName : name,
                                         kDocAppDateReadAt : app_date_read_at,
                                         kDocAppDateActionAt : app_date_actioned_at,
                                         kDocTypeCode : type_code,
                                         kDocCreatedAt : created_at,
                                         kDocRecordedAt : recorded,
                                         kDocClaimNumber : claim_number
                                         };

            NSLog(@"Dict To Save : %@",saveDict);
            
            DocumentDetail *newDoc = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_DOCUMENT_DETAIL withDataDict:saveDict];
            
            if(newDoc)
            {
                NSLog(@"Documnet SAVED");
            }
        }
        
        [self refreshTableData];
        [ProgressHudHelper hideLoadingHud];
}
*/

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
