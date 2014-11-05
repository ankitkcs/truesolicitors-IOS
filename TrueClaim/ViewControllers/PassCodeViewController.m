//
//  TempPassCodeVC.m
//  TrueClaim
//
//  Created by Krish on 22/07/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "PassCodeViewController.h"
#import "UIView+RKBorder.h"
#import "LinkClaimViewController.h"
#import "MyFolderViewController.h"

@interface PassCodeViewController ()

@end

@implementation PassCodeViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    //getSavedPassword
//    NSString *checkAppRun = [ApplicationData offlineObjectForKey:FIRST_RUN];
//    if([checkAppRun isEqualToString:@"running_first_time"] || checkAppRun == nil)
//    {
//        [self showCustomAlertWithTitle:@"Welcome to My Folder"
//                            alertImage:[UIImage imageNamed:@"ios_folder_popup_icon.png"]
//                              alertMsg:@"This is where you can store, view and respond to the documnets we send you."
//                                andTag:331];
//        
//        return;
//    }
//    else
//    {
//        [self showViewAfterWelcomerScreen];
//        [self.hiddenText becomeFirstResponder];
//    }

}

-(void)viewDidAppear:(BOOL)animated
{
    //getSavedPassword
    NSString *checkAppRun = [ApplicationData offlineObjectForKey:FIRST_RUN];
    if([checkAppRun isEqualToString:@"running_first_time"] || checkAppRun == nil)
    {
        [self showCustomAlertWithTitle:@"Welcome to My Folder"
                            alertImage:[UIImage imageNamed:@"ios_folder_popup_icon.png"]
                              alertMsg:@"This is where you can store, view and respond to the documnets we send you."
                                andTag:331];
        
        return;
    }
    else
    {
        [self showViewAfterWelcomerScreen];
        [self.hiddenText becomeFirstResponder];
    }

}

-(void) showViewAfterWelcomerScreen
{
    self.passInputBackView.backgroundColor = [UIColor clearColor];
    
       if(!IS_IPHONE_5)
        {
            self.passInputBackView.frame = CGRectMake(0, 0 , self.passInputBackView.frame.size.width, self.passInputBackView.frame.size.height - 10);
            self.rememberBackView.frame = CGRectMake(0, CGRectGetMaxY(self.passInputBackView.frame) , self.rememberBackView.frame.size.width, self.rememberBackView.frame.size.height);
            self.btnForgotPass.frame = self.rememberBackView.frame;
        }
    
    isNewPass = YES;
    //isConfirmPass = YES;
    [self resetInitialPassView];
    
    self.rememberBackView.BordersFlag = DrawBordersTop | DrawBordersBottom;
    self.rememberBackView.BordersColor = [UIColor lightGrayColor];
    self.rememberBackView.BordersWidth = 1;
    
    // check saved password
    NSString *savedPass = [ApplicationData offlineObjectForKey:SAVED_PASSCODE];
    
    if(savedPass == nil)
    {
        [self setUpViewForSettingPassword];
    }
    else
    {
        [self setUpViewForRegularPassword];
    }
}


-(void) setUpViewForSettingPassword
{
    self.navigationItem.title = @"CREATE PASSCODE";
    self.passMessage.text = @"please create a 4 digit passcode to aaccess Your Folder";
    self.btnSave.title = @"Save";
    self.rememberBackView.hidden = NO;
    self.btnForgotPass.hidden = YES;
}


-(void) setUpViewForRegularPassword
{
    self.navigationItem.title = @"ENTER PASSCODE";
    self.passMessage.text = @"please enter your personal 4 digit passcode";
    self.btnSave.title = @"Submit";
    self.rememberBackView.hidden = YES;
    self.btnForgotPass.hidden = NO;
}

-(IBAction)btnForgotPassClick:(id)sender
{
    [self performSegueWithIdentifier:@"PASSCODE_TO_LINK" sender:self];
}


-(void) resetInitialPassView
{
    _chk = false;
    charCounter = 0;
    self.btnSave.enabled = NO;
    
    [self createEmptyRoundLabel:_l1];
    [self createEmptyRoundLabel:_l2];
    [self createEmptyRoundLabel:_l3];
    [self createEmptyRoundLabel:_l4];
    
    self.hiddenText.text = @"";
    self.hiddenText.delegate=self;
    [self.hiddenText becomeFirstResponder];
    [self.hiddenText setEnablesReturnKeyAutomatically:YES];
}

- (IBAction)btnCancel:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)btnSave:(id)sender
{
    UIBarButtonItem *barButton = (UIBarButtonItem*)sender;
    if([barButton.title isEqualToString:@"Submit"])
    {
        [self submittPasswordAndGotoMyFolderView];
    }
    else  if([barButton.title isEqualToString:@"Save"])
    {
        [self savePasswordForSetting];
    }
}

-(void) savePasswordForSetting
{
    // first passcode
    if(self.hiddenText.text.length == 4 && isNewPass == YES)
    {
        enterPasscode = self.hiddenText.text;
        isNewPass = NO;
        
        //[self resetInitialPassView];
        //self.passMessage.text = @"Please confirm your password again";
        NSLog(@"PASSWORD : %@",enterPasscode);
        
        [ApplicationData setOfflineObject:enterPasscode forKey:SAVED_PASSCODE];
        
        [self showCustomAlertWithTitle:@"Passcode Saved!"
                            alertImage:[UIImage imageNamed:@"ios_tick_popup_icon.png"]
                              alertMsg:@"Please make sure you remember your 4 digit passcode."
                                andTag:333];
    }
    else
    {
        [[ApplicationData sharedInstance]showAlert:@"Please input four digit password" andTag:0];
        isNewPass = YES;
        [self resetInitialPassView];
    }
}



/*
-(void) savePasswordForSettingWithConfirmation
{
    // first passcode
    if(self.hiddenText.text.length == 4 && isNewPass == YES)
    {
        enterPasscode = self.hiddenText.text;
        isNewPass = NO;
        [self resetInitialPassView];
        self.passMessage.text = @"Please confirm your password again";
        //NSLog(@"PASSWORD : %@",enterPasscode);
         self.btnSave.title = @"ReSave";
    }
    
    // confirm passcode
    if(isNewPass == NO && self.hiddenText.text.length == 4)
    {
        confirmPasscode = self.hiddenText.text;
        isConfirmPass = NO;
        //NSLog(@"CONFIRM PASSWORD : %@",confirmPasscode);
    }
    
    if(isNewPass == NO && isConfirmPass == NO) // both are inputed
    {
        if([enterPasscode isEqualToString:confirmPasscode]) // if pascode and confirm match
        {
            [ApplicationData setOfflineObject:confirmPasscode forKey:SAVED_PASSCODE];
            
            [self showCustomAlertWithTitle:@"Passcode Saved!"
                                alertImage:[UIImage imageNamed:@"ios_tick_popup_icon.png"]
                                  alertMsg:@"Please make sure you remember your 4 digit passcode."
                                    andTag:333];
            
            //[self showPassCodeSaveSucessAlertView];
        }
        else
        {
            [[ApplicationData sharedInstance]showAlert:@"Password is not matching" andTag:0];
            isNewPass = YES;
            isConfirmPass = YES;
            [self resetInitialPassView];
            return;
        }
    }
    else
    {
        
    }
}
*/

-(void) submittPasswordAndGotoMyFolderView
{
     NSString *savedPass = [ApplicationData offlineObjectForKey:SAVED_PASSCODE];
    
     if([self.hiddenText.text isEqualToString:savedPass])
     {
         [ApplicationData sharedInstance].isReloadMyFolderData = YES;
         [self performSegueWithIdentifier:@"PASSCODE_TO_MYFOLDER" sender:self];
     }
    else
    {
        [ApplicationData sharedInstance].isReloadMyFolderData = NO;
        [[ApplicationData sharedInstance]showAlert:@"Wrong password" andTag:0];
        [self resetInitialPassView];
    }
}

-(void) showCustomAlertWithTitle:(NSString*)tile alertImage:(UIImage*)image alertMsg:(NSString*)msgText andTag:(int)tagval
{
    [self.hiddenText resignFirstResponder];
    
    self.transparentView = [[RKMTransView alloc] init];
    self.transparentView.delegate = self;
    self.transparentView.backgroundColor = [UIColor clearColor];
    self.transparentView.allowBlurView  = YES;
    self.transparentView.hideCloseButton = YES;
    self.transparentView.tag = tagval;
    self.transparentView.alertTitle = tile;
    self.transparentView.alertImage = image;
    self.transparentView.alertMessage = msgText;
    [self.transparentView open];
}

#pragma -mark
#pragma -marl RKPOP Delegate

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
    if(self.transparentView.tag == 331)
    {
        //close welcom alert
         NSString *SecondTimeRun = @"running_second_time";
        [ApplicationData setOfflineObject:SecondTimeRun forKey:FIRST_RUN];
        [self showViewAfterWelcomerScreen];
    }
    else if(self.transparentView.tag == 333)
    {
        //manually push
        MyFolderViewController *myFolder = [self.storyboard
                                            instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
        [ApplicationData sharedInstance].isReloadMyFolderData = YES;
        [self.navigationController pushViewController:myFolder animated:YES];
    }
}

-(void)createEmptyRoundLabel:(UILabel*)myLabel
{
    myLabel.backgroundColor = [UIColor whiteColor];
    myLabel.text = @"";
    myLabel.layer.cornerRadius = 10;
    myLabel.layer.borderColor = Rgb2UIColor(139, 23, 41).CGColor;
    myLabel.layer.borderWidth = 1.0f;
}

-(void)fillRoundLabel:(UILabel*)myLabel
{
    myLabel.backgroundColor = Rgb2UIColor(139, 23, 41);
}

-(void)emptyRoundLabel:(UILabel*)myLabel
{
    myLabel.backgroundColor = [UIColor whiteColor];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@""])
    {
        switch (charCounter)
        {
            case 1:
                [self emptyRoundLabel:_l1];
                charCounter--;
                passcode = self.hiddenText.text;
                break;
                
            case 2:
                [self emptyRoundLabel:_l2];
                charCounter--;
                passcode = self.hiddenText.text;
                break;
                
            case 3:
                [self emptyRoundLabel:_l3];
                charCounter--;
                passcode = self.hiddenText.text;
                break;
                
            case 4:
                [self emptyRoundLabel:_l4];
                charCounter--;
                passcode = self.hiddenText.text;
                break;
                
            default:
                charCounter=0;
                passcode = self.hiddenText.text;
                break;
        }
        
        if (charCounter<5)
        {
            _chk=false;
            self.btnSave.enabled = NO;
        }
        
    }
    else
    { 
        if (_chk==false)
        {
            charCounter++;
        }

        if (charCounter==1)
        {
            [self fillRoundLabel:_l1];
            passcode = self.hiddenText.text;
        }
        else if (charCounter==2)
        {
            [self fillRoundLabel:_l2];
             passcode = self.hiddenText.text;
        }
        else if (charCounter==3)
        {
            [self fillRoundLabel:_l3];
             passcode = self.hiddenText.text;
        }
        else if (charCounter==4 && _chk==false)
        {
            [self fillRoundLabel:_l4];
             passcode = self.hiddenText.text;
            
            charCounter=4;
            _chk=true;
            self.btnSave.enabled = YES;
            
        }
        else if(charCounter>4 || _chk==true)
        {
            charCounter=4;
            _chk=true;
            
            if(charCounter == 4)
            {
                return NO;
            }
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"RECIEVE SEGUE IDENTIFIER ON PREPARE : %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"PASSCODE_TO_LINK"])
    {
        LinkClaimViewController *controller = [segue destinationViewController];
        controller.showViewFor = @"RESETCODE";
    }
    else if([segue.identifier isEqualToString:@"PASSCODE_TO_MYFOLDER"])
    {
        
    }
}

@end
