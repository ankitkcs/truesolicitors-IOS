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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    
    self.title = @"LINK YOUR CLAIM";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = THEME_RED_COLOR;
    
    self.inputBackView.backgroundColor = [UIColor clearColor];
    
    self.txtClaimNo.BordersFlag = DrawBordersBottom;
    self.txtClaimNo.BordersColor = [UIColor lightGrayColor];
    self.txtClaimNo.BordersWidth = 1;
    
    self.txtBirthDate.BordersFlag = DrawBordersBottom;
    self.txtBirthDate.BordersColor = [UIColor lightGrayColor];
    self.txtBirthDate.BordersWidth = 1;
    
    UIBarButtonItem *linkBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Link" style:UIBarButtonItemStyleBordered target:self action:@selector(linkBtnTapped)];
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
    
    [self.txtClaimNo becomeFirstResponder];
}

-(void)linkBtnTapped
{
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
        NSDictionary *claimDict = @{
                                    kClaimsNumber:self.txtClaimNo.text,
                                    kClaimsDate:self.txtBirthDate.text
                                    };
        
        Claim *newClaim = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_CLAIM withDataDict:claimDict];
        
        if(newClaim)
        {
            [self.txtClaimNo resignFirstResponder];
            [self.txtBirthDate resignFirstResponder];
            [self performSelector:@selector(showTransparentAlertView) withObject:self afterDelay:0.2];
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
    
//    NSArray *claims = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_CLAIM];
//    
//    if(claims.count == 0)
//    {
//        HomeFirstTimeViewController *hfv = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeFirstTimeViewController"];
//        [self.navigationController popToViewController:hfv animated:YES];
//        
//        //[self performSegueWithIdentifier:@"FirstTimeUserSegueIdentifier" sender:nil];
//    }
//    else
//    {
//        HomeRegularViewController  *hrv = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeRegularViewController"];
//        [self.navigationController popToViewController:hrv animated:YES];
//
//        //[self performSegueWithIdentifier:@"RegularUserSegueIdentifier" sender:nil];
//    }
    
}

#pragma mark -
#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
