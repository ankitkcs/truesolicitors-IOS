//
//  LinkClaimViewController.m
//  TrueClaim
//
//  Created by krish on 7/21/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "LinkClaimViewController.h"
#import "HomeRegularViewController.h"
#import "UIView+RKBorder.h"

@interface LinkClaimViewController ()

@end

@implementation LinkClaimViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    self.title = @"LINK YOUR CLAIM";
    self.webApi = [[WebApiRequest alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
    
    self.txtClaimNo.BordersFlag = DrawBordersBottom;
    self.txtClaimNo.BordersColor = [UIColor lightGrayColor];
    self.txtClaimNo.BordersWidth = 1;
    
    self.txtBirthDate.BordersFlag = DrawBordersBottom;
    self.txtBirthDate.BordersColor = [UIColor lightGrayColor];
    self.txtBirthDate.BordersWidth = 1;
    
   self.inputBackView.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *linkBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Link"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(linkBtnTapped)];
    self.navigationItem.rightBarButtonItem = linkBarButton;
    
    if(self.isLinkAdded)
    {
        self.isLinkAdded = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(!IS_IPHONE_5)
    {
        self.lblHead.frame = CGRectMake(20, 60, self.lblHead.frame.size.width,self.lblHead.frame.size.height);
        
        self.inputBackView.frame = CGRectMake(0, self.lblHead.frame.origin.y + self.lblHead.frame.size.height, self.inputBackView.frame.size.width, self.inputBackView.frame.size.height);
    }
    
    self.txtBirthDate.delegate = self;
    
    self.txtClaimNo.text = @"01928384F";
    self.txtBirthDate.text = @"1975-12-22";
    [self.txtClaimNo becomeFirstResponder];
}

-(void)linkBtnTapped
{
    NSLog(@"DEVICE ID : %@",[ApplicationData sharedInstance].deviceUUID);
    
    if(![ApplicationData checkValidStringLengh:self.txtClaimNo.text])
    {
        [[ApplicationData sharedInstance] showAlert:ENTER_CLAIM_NUMBER andTag:101];
        return;
    }
    else if(![ApplicationData checkValidStringLengh:self.txtBirthDate.text])
    {
         [[ApplicationData sharedInstance] showAlert:ENTER_BIRTH_DATE andTag:102];
         return;
    }
    else
    {
        
        //NSLog(@"%hhd",[ApplicationData ConnectedToInternet]);
        
        if([ApplicationData ConnectedToInternet])
        {
         [ProgressHudHelper showLoadingHudWithText:@""];
         NSMutableDictionary *claimDict = @{
                                    kCLAIM_NUMBER:self.txtClaimNo.text,
                                    kBITH_DATE:self.txtBirthDate.text,
                                    kDEVICE_ID:[ApplicationData offlineObjectForKey:DEVICE_UUID]
                                    }.mutableCopy;
        
        // token for link claim a
        [ApplicationData sharedInstance].tc_auth_token = LINK_TOKEN;
        [self.webApi PostDataWithParameter:claimDict forDelegate:self
                                    andTag:tLink
                             forRequstType:reqLINK_CLAIM
                               serviceType:WS_POST];
        }
        else
        {
            [[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:0];
        }
    }
}

-(void) showTransparentAlertView
{
    self.transparentView = [[RKMTransView alloc] init];
    self.transparentView.delegate = self;
    self.transparentView.backgroundColor = [UIColor clearColor];
    self.transparentView.allowBlurView = YES;
    
    self.transparentView.alertTitle = @"Welcome, Mr Sommerville";
    self.transparentView.alertImage = [UIImage imageNamed:LINK_IMAGE];
    self.transparentView.alertMessage = [NSString stringWithFormat:CLAIM_LINKED_SUCCESS,self.txtClaimNo.text];
    [self.transparentView open];
}

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
    self.isLinkAdded = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showDatePickerForiPhone
{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:@""
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    //[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    UIToolbar *pickerTopToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    pickerTopToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerTopToolbar setTranslucent:YES];
    pickerTopToolbar.tintColor = [UIColor lightGrayColor];
    [pickerTopToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(DatePickerCancelForIphone)];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DatePickerDoneForIphone)];
    [doneBtn setTintColor:[UIColor whiteColor]];
    
    [barItems addObject:cancelBtn];
    [barItems addObject:flex];
    [barItems addObject:doneBtn];
    [pickerTopToolbar  setItems:barItems animated:YES];
    
    CGRect pickerFrame = CGRectMake(0,40,320,250);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePicker];
    
    [actionSheet addSubview:pickerTopToolbar];
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0,320,395)];
}

-(void)DatePickerDoneForIphone
{
    NSString *dateStr = [ApplicationData getStringFromDate:datePicker.date
                                                  inFormat:@"yyyy-MM-dd"];
    [self.txtBirthDate setText:dateStr];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) DatePickerCancelForIphone
{
     [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dateChange:(id)sender
{
    NSString *dateStr = [ApplicationData getStringFromDate:datePicker.date
                                                  inFormat:@"yyyy-MM-dd"];
    [self.txtBirthDate setText:dateStr];
}

#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    //NSLog(@"Response Data : %@",responseData);
    
   // [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_LINK_CLAIM];
    
    @try{
        
        if ([ErrorMsg length]>0)
        {
            [ProgressHudHelper hideLoadingHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == tLink)
            {
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    [self insertRecordInLocalDataBaseFromData:responseData];
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

-(void) insertRecordInLocalDataBaseFromData:(NSMutableArray *)responseData
{
    {
        //NSLog(@"Response Data : %@",responseData);
        
            //NSLog(@"Now you can save the data to local database");
            
            //NSLog(@"CLAIM : %@",[[responseData valueForKey:@"linked_claim"] valueForKey:@"auth_token"]);
            
            NSDictionary *claimDict = [responseData valueForKey:@"linked_claim"];
            
            //NSLog(@"Dict To Save : %@",claimDict);
            
            NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
            NSString *accountID = [NSString stringWithFormat:@"%d",
                                   [[claimDict valueForKey:kAccountID] intValue]
                                   ];
            NSString *claimNumber = [claimDict valueForKey:kClaimNumber];
            NSString *accountName =  [claimDict valueForKey:kAccountName];
            NSString *customerName = [claimDict valueForKey:kCustomerName];
            NSString *accidentDate =  [claimDict valueForKey:kAccidentDate];
            NSString *linkedAt = [claimDict valueForKey:kAccidentDate];
            NSString *authToken = [claimDict valueForKey:kAuthToken];
            NSString *saveOnDate = todayDate;
            
            NSMutableDictionary *saveClaim = [NSMutableDictionary dictionary];
            [saveClaim setValue:accountID forKey:kAccountID];
            [saveClaim setValue:claimNumber forKey:kClaimNumber];
            [saveClaim setValue:accountName forKey:kAccountName];
            [saveClaim setValue:customerName forKey:kCustomerName];
            [saveClaim setValue:accidentDate forKey:kAccidentDate];
            [saveClaim setValue:linkedAt forKey:kLinkedAt];
            [saveClaim setValue:authToken forKey:kAuthToken];
            [saveClaim setValue:saveOnDate forKey:kCreateAt];
            
            NSLog(@"Dict To Save : %@",saveClaim);
            
            LinkToClaim *newClaim = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_LINK_CLAIM withDataDict:saveClaim];
            
            if(newClaim)
            {
                NSLog(@"ADDED TO LOCAL SUCCESSFULLY");
                
                [ProgressHudHelper hideLoadingHud];
                
                [self.txtClaimNo resignFirstResponder];
                [self.txtBirthDate resignFirstResponder];
                [self performSelector:@selector(showTransparentAlertView) withObject:self afterDelay:0.2];
            }
    }
}

#pragma mark -
#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtBirthDate)
    {
       // [self.txtClaimNo resignFirstResponder];
        [self.txtBirthDate resignFirstResponder];
        
        //[self performSelector:@selector(showDatePickerForiPhone) withObject:nil afterDelay:0.3];
        
        [self showDatePickerForiPhone];
    }
}

 /*

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if(textField == self.txtBirthDate)
    {
        NSString *filter = @"## - ## - ##";
    
        if(!filter) // No filter provided, allow anything
        {
            return YES;
        }
    
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(range.length == 1 && // Only do for single deletes
       string.length < range.length &&
       [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
    {
        // Something was deleted.  Delete past the previous number
        NSInteger location = changedString.length-1;
        if(location > 0)
        {
            for(; location > 0; location--)
            {
                if(isdigit([changedString characterAtIndex:location]))
                {
                    break;
                }
            }
            changedString = [changedString substringToIndex:location];
        }
    }
        textField.text = [self filteredPhoneStringFromString:changedString WithFilter:filter];
        return NO;
    }
    return YES;
}

-(NSMutableString*)filteredPhoneStringFromString:(NSString*) string WithFilter:(NSString*)filter
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        
        if(onFilter == 0 || onFilter == 1 || onFilter == 2)
        {
            int dateVal = [string intValue];
            
            NSLog(@"FILTER STRING VAL After 012 :: %d",dateVal);
            
            if(dateVal > 31)
            {
                break;
            }
        }
        
        if(onFilter == 6 || onFilter == 7 || onFilter == 8)
        {
            int monthVal = [[string substringFromIndex:5] intValue];
            
            NSLog(@"FILTER STRING After 678 :: %d",monthVal);
            
            if(monthVal > 12)
            {
                break;
            }
        }

        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    
    return [[NSString stringWithUTF8String:outputString] mutableCopy];
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
