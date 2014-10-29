//
//  LetterReadViewController.m
//  TrueClaim
//
//  Created by krish on 7/28/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "LetterReadViewController.h"
#import "JLActionSheet.h"
#import "ConfirmViewController.h"
#import "MessageDetailViewController.h"
#import "MyDatabaseManager.h"

@interface LetterReadViewController () <JLActionSheetDelegate>

{
    UIBarButtonItem *shareBarBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *nextBtn;
}

@property (nonatomic, strong) JLActionSheet* actionSheet;

@end

@implementation LetterReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backBtn  = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(btnBackTapped:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    shareBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareTapped:)];
    nextBtn  = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(btnNextTapped:)];
    self.navigationItem.rightBarButtonItems = @[shareBarBtn,nextBtn];
    
    //self.tabBarItem.title = @"Message";
}

-(void) viewWillAppear:(BOOL)animated
{
    //self.tabBarController.tabBar.hidden = YES;
    //self.navigationController.navigationBarHidden = YES;
    
    self.selDocDetail = [ApplicationData sharedInstance].selectedDocDetail;
    self.selClaim = [ApplicationData sharedInstance].selectedClaim;
    
    self.navigationItem.title = self.selClaim.claim_number;
    
    NSLog(@"Selected DOC CODE TYPE : %@",self.selDocDetail.type_code);
    NSLog(@"Read App Date : %@",self.selDocDetail.app_date_read_at);
    
    // check document is readed or not
    if(self.selDocDetail.app_date_read_at.length == 0 || self.selDocDetail.app_date_read_at == nil)
    {
        //show next button if not readed and popup for confirm
        self.navigationItem.rightBarButtonItems = @[shareBarBtn,nextBtn];
    }
    else // app is readed and check action is performed or not
    {
        if(self.selDocDetail.app_date_actioned_at.length == 0 || self.selDocDetail.app_date_actioned_at == nil)
        {
            // show next button if readed and not action performed
            //self.navigationItem.rightBarButtonItems = @[nextBtn,shareBarBtn];
            
            NSArray *docTypeArr = [[MyDatabaseManager sharedManager]  allRecordsSortByAttribute:kDocTypeDocCode where:kDocTypeDocCode contains:self.selDocDetail.type_code byAcending:YES fromTable:TBL_DOCUMENT_TYPE];
            
            NSLog(@"doc Detail Find : %@ And Total Count : %lu",docTypeArr,(unsigned long)docTypeArr.count);
            DocumentsType *selDocTypeDetail = [docTypeArr objectAtIndex:0];
            
            if(selDocTypeDetail.action_prompt.length == 0 || selDocTypeDetail.action_prompt == nil)
            {
                // if action prompt contains no text dont show next button
                self.navigationItem.rightBarButtonItems = @[shareBarBtn];
            }
            else
            {
                // if action prompt contains text show next button and show prompt data on agree view
                self.navigationItem.rightBarButtonItems = @[nextBtn,shareBarBtn];
            }
        }
        else
        {
            self.navigationItem.rightBarButtonItems = @[shareBarBtn];
        }
    }
    
    [self sendRequestForGetSelectedDocPDF];
    
}

-(void) sendRequestForGetSelectedDocPDF
{
    //NSLog(@"SELECTED AUTH TOKEN-NUMBER ON MESSAGE : %@",self.selClaim.auth_token);
    //NSLog(@"Selected Doc GUID : %@",self.selDocDetail.guid);
    // request for get messages
    
    NSString *reqForPDFDocByGUID = [NSString stringWithFormat:@"documents/%@",self.selDocDetail.guid];
    
    if([ApplicationData ConnectedToInternet])
    {
        
    [ProgressHudHelper showLoadingHudWithText:@""];
    self.webApi = [[WebApiRequest alloc] init];
    [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
    [self.webApi PostDataWithParameter:nil forDelegate:self andTag:tGetDocPDF forRequstType:reqForPDFDocByGUID serviceType:WS_GET];
    }
    else
    {
        [[ApplicationData sharedInstance]showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShareTapped:(id)sender
{
    NSString *initalTextString = [NSString stringWithFormat:@"%@",
                                  self.msgTextView.text];
    UIImage *logoImg = [UIImage imageNamed:@"ios_true_logo.png"];

    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:@[logoImg,initalTextString] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)btnNextTapped:(id)sender
{
    // get selected documnet detail from document table
    
    if(self.selDocDetail.app_date_read_at.length == 0 || self.selDocDetail.app_date_read_at == nil)
    {
        // if doc not readed then show next button and confirm popup.
        [self showCustomActionSheet:sender];
    }
    else
    {
         // go to agree screen directly
         //[self performSegueWithIdentifier:@"LETTER_READ_TO_CONFIRM" sender:self];
        
        NSArray *docTypeArr = [[MyDatabaseManager sharedManager]  allRecordsSortByAttribute:kDocTypeDocCode where:kDocTypeDocCode contains:self.selDocDetail.type_code byAcending:YES fromTable:TBL_DOCUMENT_TYPE];
        
        NSLog(@"doc Detail Find : %@ And Total Count : %lu",docTypeArr,(unsigned long)docTypeArr.count);
        
        DocumentsType *selDoc = [docTypeArr objectAtIndex:0];
        
        if(selDoc.action_prompt.length == 0 || selDoc.action_prompt == nil)
        {
            //[self showCustomActionSheet:sender];
        }
        else
        {
            [self performSegueWithIdentifier:@"LETTER_READ_TO_CONFIRM" sender:self];
        }

    }
    
    /* android start
    
    // Check document Not Read(app_read_at blank then showing
    // confirmation
    // message)
    if (modelSelectedDocument.app_date_read_at == null || modelSelectedDocument.app_date_read_at.equalsIgnoreCase(""))
    {
        showPopupConfirmRead();
    }
    else
    {
        // If Document Read then Check action_prompt is blank or not
        modelSelectedDocumentType = Tbl_DocumentTypes
        .SelectTypeCodeModel(modelSelectedDocument.type_code);
        // Check Model Document Type in action_prompt blank or not
        if (!modelSelectedDocumentType.action_prompt
            .equalsIgnoreCase(""))
        {
            openAgreeDocumentIntent();
        }
    }  android End */

    /*
     NSArray *docTypeArr = [[MyDatabaseManager sharedManager]  allRecordsSortByAttribute:kDocTypeDocCode where:kDocTypeDocCode contains:self.selDocDetail.type_code byAcending:YES fromTable:TBL_DOCUMENT_TYPE];
     
     NSLog(@"doc Detail Find : %@ And Total Count : %lu",docTypeArr,(unsigned long)docTypeArr.count);
     
     DocumentsType *selDoc = [docTypeArr objectAtIndex:0];
     
     if(selDoc.action_prompt.length == 0 || selDoc.action_prompt == nil)
     {
         [self showCustomActionSheet:sender];
     }
     else
     {
        [self performSegueWithIdentifier:@"LETTER_READ_TO_CONFIRM" sender:self];
     }
     */
}


-(void) showCustomActionSheet:(id)sender
{
    NSMutableArray* buttonTitles = [[NSMutableArray alloc] initWithCapacity:3];
    
    buttonTitles[0] = @"Confirm Read";
    buttonTitles[1] = @"Read Again Later";
    buttonTitles[2] = @"Cancel";
    
    _actionSheet = [JLActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:nil otherButtonTitles:buttonTitles];
    [_actionSheet allowTapToDismiss:YES];
    [_actionSheet setStyle:JLSTYLE_APPSTYLE];
    [_actionSheet showFromBarItem:sender onViewController:self];

}

- (void) actionSheet:(JLActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Call Back Index : %ld",(long)buttonIndex);
    NSLog(@"Clicked button title: %@", [actionSheet titleAtIndex:buttonIndex]);
    
    if(buttonIndex == 0) // cancel
    {
       // [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(buttonIndex == 1) // Read Again Later
    {
        [self updateReadStatusForCurrentDoc:self.selDocDetail changeStatus:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(buttonIndex == 2) // Confirm Read
    {
        
        [self sendRequestForReadConfirmation];
        
        //[self updateReadStatusForCurrentDoc:self.selDocDetail changeStatus:YES];
        //[ApplicationData sharedInstance].selectedDocDetail = self.selDocDetail;
        //[self performSegueWithIdentifier:@"LETTER_READ_TO_CONFIRM" sender:self];
    }
}

- (void) actionSheet:(JLActionSheet*)actionSheet didDismissButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(void) updateReadStatusForCurrentDoc:(DocumentDetail*)doc changeStatus:(BOOL)change
{
    NSString *todayDate;
    
    if(change)
    {
        todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
    }
    else
    {
        todayDate = @"";
    }
    
    NSDictionary *updateDict = @{ kDocAppDateReadAt:todayDate};
    [[MyDatabaseManager sharedManager] updateRecordInTable:TBL_DOCUMENT_DETAIL
                                                  ofRecord:doc
                                              recordDetail:updateDict];
    
}


-(void) sendRequestForReadConfirmation
{
 
    NSString *reqForReadDocByGUID = [NSString stringWithFormat:@"documents/%@",self.selDocDetail.guid];
    
    if([ApplicationData ConnectedToInternet])
    {
        [ProgressHudHelper showLoadingHudWithText:@""];
        self.webApi = [[WebApiRequest alloc] init];
        [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
        
        NSString *readDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
        
        NSDictionary *reqDict = @{@"app_date_read_at": readDate};
        [self.webApi PostDataWithParameter:reqDict.mutableCopy forDelegate:self andTag:tActionRead forRequstType:reqForReadDocByGUID serviceType:WS_PUT];
    }
    else
    {
        [[ApplicationData sharedInstance]showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }

}


#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    @try{
        
        if ([ErrorMsg length]>0)
        {
            [ProgressHudHelper dissmissAdvanceHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == tGetDocPDF)
            {
                NSLog(@"Response Data : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    NSLog(@"Now you can save the data to local database");
                    
                    NSString *base64String = [[responseData valueForKey:@"document"] valueForKey:@"body"];
                    //NSLog(@"PDF Data = %@",base64String);
                    NSData *decodedData = [[NSData alloc] initWithBase64Encoding:base64String];
                    [self showPdfFromData:decodedData];
                }
                else
                {
                    [ProgressHudHelper hideLoadingHud];
                    [[ApplicationData sharedInstance] showAlert:[responseData valueForKey:@"response_message"] andTag:0];
                }
            }
            if(Tag == tActionRead)
            {
                NSLog(@"Response Data : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    [ProgressHudHelper hideLoadingHud];
                     NSLog(@"Readed Successfully");
                    // update documnet type table
                    [self updateReadStatusForCurrentDoc:self.selDocDetail changeStatus:YES];
                    [self performSegueWithIdentifier:@"LETTER_READ_TO_CONFIRM" sender:self];
                }
                else
                {
                    [ProgressHudHelper hideLoadingHud];
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

-(void) showPdfFromData: (NSData*) pdfData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",self.selDocDetail.name];
    NSString *pathStr = [documentsDir stringByAppendingPathComponent:fileName];
    
    [pdfData writeToFile:pathStr atomically:YES];
    
    
    // read pdf from path
    NSArray *readPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    
    NSString *filePath = [[readPaths lastObject] stringByAppendingPathComponent:fileName];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
    
    [ProgressHudHelper hideLoadingHud];
    
//    NSURL *documentsURLRead = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
//    NSArray *contents = [[NSFileManager defaultManager]contentsOfDirectoryAtURL:documentsURLRead includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
//    
//    NSLog(@"%@", [contents description]);
}

@end
