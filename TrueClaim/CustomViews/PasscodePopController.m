//
//  PasscodePopController.m
//  TrueClaim
//
//  Created by krish on 10/10/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "PasscodePopController.h"

#define APP_HEIGHT 568.0f
#define APP_WIDTH 320.0f

@interface PasscodePopController ()
@property (nonatomic, assign) NSInteger statusBarStyle;
@end

@implementation PasscodePopController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = [[UIScreen mainScreen] bounds];
        self.opaque = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.hideCloseButton = YES;
        self.passcodeText = @"";
    }
    return self;
}

-(void) Open
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    // Get current statusBarStyle
    self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    // Close button
    if (!self.hideCloseButton)
    {
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.frame = CGRectMake(self.frame.size.width - 60, 26, 60, 30);
        [close setImage:[UIImage imageNamed:@"btn-close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];
    }
    
    // add your custom alert here
    [self passcodeView];
    
    // Animation
    CATransition *viewIn = [CATransition animation];
    [viewIn setDuration:0.4];
    [viewIn setType:kCATransitionReveal];
    [viewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self layer] addAnimation:viewIn forKey:kCATransitionReveal];
    
    [[[window subviews] objectAtIndex:0] addSubview:self];
}

#pragma mark - Close Transparent View

- (void)close
{
    // Animation
    CATransition *viewOut = [CATransition animation];
    [viewOut setDuration:0.3];
    [viewOut setType:kCATransitionFade];
    [viewOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.superview layer] addAnimation:viewOut forKey:kCATransitionFade];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [self removeFromSuperview];
}


-(void) passcodeView
{
    UINib *nib = [UINib nibWithNibName:@"PasscodePopView" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    UIView *popView = [nibArray objectAtIndex: 0];
    
    popView.backgroundColor = [UIColor clearColor];
    popView.frame = CGRectMake(0, 0, popView.frame.size.width, popView.frame.size.height);
    
    UIButton *closeButton = (UIButton*)[popView viewWithTag:11];
    [closeButton addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitButton = (UIButton*)[popView viewWithTag:12];
    [submitButton addTarget:self action:@selector(btnSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.hiddenText = (UITextField*)[popView viewWithTag:13];
    
    self.l1 = (UILabel*)[popView viewWithTag:14];
    self.l2 = (UILabel*)[popView viewWithTag:15];
    self.l3 = (UILabel*)[popView viewWithTag:16];
    self.l4 = (UILabel*)[popView viewWithTag:17];
    
    [self addSubview:popView];
    
    [self resetInitialPassView];
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

-(void) btnCloseClick
{
    [self close];
}

-(void) btnSubmitClick
{
    if([self.hiddenText.text isEqualToString:self.passcodeText])
    {
        [self close];
        [self.delegate PopUpCloseWithPassText:self.hiddenText.text];
    }
    else
    {
        [[ApplicationData sharedInstance] showAlert:@"Wrong password" andTag:0];
        [self resetInitialPassView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
