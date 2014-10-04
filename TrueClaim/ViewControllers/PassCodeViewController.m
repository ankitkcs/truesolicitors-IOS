//
//  TempPassCodeVC.m
//  TrueClaim
//
//  Created by Krish on 22/07/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "PassCodeViewController.h"
#import "UIView+RKBorder.h"

@interface PassCodeViewController ()

@end

@implementation PassCodeViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.passInputBackView.backgroundColor = [UIColor clearColor];
    
    isNewPass = YES;
    isConfirmPass = YES;
    [self resetInitialPassView];
    
    if(!IS_IPHONE_5)
    {
        self.passInputBackView.frame = CGRectMake(0, self.fakeNavBarView.frame.size.height + 20 , self.passInputBackView.frame.size.width, self.passInputBackView.frame.size.height - 10);
        self.rememberBackView.frame = CGRectMake(0,self.passInputBackView.frame.origin.y + self.passInputBackView.frame.size.height, self.rememberBackView.frame.size.width, self.rememberBackView.frame.size.height);
    }
    
    UIColor *borderColor = [UIColor lightGrayColor];
    
    self.fakeNavBarView.BordersFlag = DrawBordersBottom;
    self.fakeNavBarView.BordersColor = borderColor;
    self.fakeNavBarView.BordersWidth = 1;
    
    
    self.rememberBackView.BordersFlag = DrawBordersTop | DrawBordersBottom;
    self.rememberBackView.BordersColor = borderColor;
    self.rememberBackView.BordersWidth = 1;
    
    
//    if([ApplicationData sharedInstance].isPasscodeSaved == YES)
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

-(void) resetInitialPassView
{
    _chk = false;
    charCounter = 0;
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSave:(id)sender
{
    // first passcode
    if(self.hiddenText.text.length == 4 && isNewPass == YES)
    {
       enterPasscode = self.hiddenText.text;
       isNewPass = NO;
       [self resetInitialPassView];
       self.passMessage.text = @"Please confirm your password again";
        //NSLog(@"PASSWORD : %@",enterPasscode);
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
        if([enterPasscode isEqualToString:confirmPasscode])
        {
            //[self.hiddenText resignFirstResponder];
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self showPassCodeSaveSucessAlertView];
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


-(void) showPassCodeSaveSucessAlertView
{
    [self.hiddenText resignFirstResponder];
    
    self.transparentView = [[RKMTransView alloc] init];
    self.transparentView.delegate = self;
    self.transparentView.backgroundColor = [UIColor colorWithRed:(139.0 / 255.0) green:(23.0 / 255.0) blue:(41.0 / 255.0) alpha:0.9];
    
    self.transparentView.alertTitle = @"Passcode Saved!";
    self.transparentView.alertImage = [UIImage imageNamed:@"ios_tick_popup_icon.png"];
    self.transparentView.alertMessage = @"Please make sure you remember your 4 digit passcode.";
    [self.transparentView open];

}

#pragma -mark
#pragma -marl RKPOP Delegate

- (void)RKMTransViewDidClosed
{
    NSLog(@"Did close");
    [ApplicationData sharedInstance].isPasscodeSaved = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //    if ([ApplicationData sharedInstance].isDisply_PassCodeScreen == YES)
    //    {
    //        [ApplicationData sharedInstance].isDisply_PassCodeScreen = NO;
    //        [self showPassCodeScreen];
    //    }
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

@end
