//
//  CustomAccessoryView.m
//  MyCustomKeyBoardiPhone
//
//  Created by KCS on 9/25/12.
//  Copyright (c) 2012 KCS. All rights reserved.
//

#import "CustomAccessoryView.h"

@interface CustomAccessoryView ()

@end

@implementation CustomAccessoryView
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrevious;
@synthesize txtTarget;
@synthesize delegate;


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
    // Do any additional setup after loading the view from its nib.
}

- (UIControl <UITextInput> *) txtTarget{
    return _txtTarget;
}

- (void) setTxtTarget:(UIControl<UITextInput> *)txtTarget
{
    _txtTarget = txtTarget;
}

-(IBAction)btnNextCliked:(id)sender{
    [delegate moveToNextField];
}

-(IBAction)btnPreviousCliked:(id)sender{
    [delegate moveToPreviousField];
}

-(IBAction)btnDoneCliked:(id)sender{
    [delegate Done];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
