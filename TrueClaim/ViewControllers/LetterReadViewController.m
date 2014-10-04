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

@interface LetterReadViewController () <JLActionSheetDelegate>
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
    
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareTapped:)];
    self.navigationItem.leftBarButtonItem = shareBarBtn;
    
    UIBarButtonItem *nextBtn  = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(btnNextTapped:)];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    self.navigationItem.title = @"LATEST LETTER";
   // self.tabBarItem.title = @"Message";
}

-(void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    //self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"Call Back Index : %d",buttonIndex);
    NSLog(@"Clicked button title: %@", [actionSheet titleAtIndex:buttonIndex]);
    
    if(buttonIndex == 0) // cancel
    {
       
    }
    else if(buttonIndex == 1) // Read Again Later
    {
        
    }
    else if(buttonIndex == 2) // Confirm Read
    {
        ConfirmViewController *confirmView = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmViewController"];
        [self.navigationController pushViewController:confirmView animated:YES];
    }
}

- (void) actionSheet:(JLActionSheet*)actionSheet didDismissButtonAtIndex:(NSInteger)buttonIndex
{
    
}
@end