//
//  KCSViewController.m
//  TrueClaim
//
//  Created by krish on 7/19/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "IntroViewController.h"
#import "MyDatabaseManager.h"

#define ARC4RANDOM_MAX	0x100000000

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BACKGROUND_IMAGE;
    
    [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_CLAIM];
    
    self.webApiRequest = [[WebApiRequest alloc] init];
    
    int numberOfPages = 3;
    
    introImages = @[@"ios_instant_message_image.png",
                    @"ios_my_folder_image.png",
                    @"ios_updates_image.png"];
    
    introText = @[@"Send instant messageges to your \n TRUE Advisor.",
                  @"Read and sign documnets \n in minutes.",
                  @"Receive instant alerts of new status \n updates on your claim"];
    
    self.introLabel.text = [introText objectAtIndex:0];
	
	// define the scroll view content size and enable paging
	[self.scrollView setPagingEnabled: YES];
    float scrollContentWidth = self.scrollView.bounds.size.width * numberOfPages;
	[self.scrollView setContentSize: CGSizeMake(scrollContentWidth, self.scrollView.bounds.size.height)] ;
	
    
	// programmatically add the page control dots
	 self.pageControl = [[DDPageControl alloc] init] ;
    
    if(IS_IPHONE_5)
    {
        [self.pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-115.0f)];
    }
    else
    {
        [self.pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-145.0f)];
    }
    
	[self.pageControl setNumberOfPages: numberOfPages];
	[self.pageControl setCurrentPage: 0] ;
	[self.pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[self.pageControl setDefersCurrentPageDisplay: YES] ;
	[self.pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[self.pageControl setOnColor: [UIColor blackColor]] ;
	[self.pageControl setOffColor: [UIColor blackColor]] ;
	[self.pageControl setIndicatorDiameter: 10.0f];
	[self.pageControl setIndicatorSpace: 10.0f] ;
	[self.view addSubview: self.pageControl];
	
	for (int i = 0 ; i < numberOfPages ; i++)
	{
		// determine the frame of the current page
		pageFrame = CGRectMake(i * self.scrollView.bounds.size.width, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) ;
		
		// create a page as a simple Image
		pageImageView = [[UIImageView alloc] initWithFrame: pageFrame] ;
		
		// add it to the scroll view
		[self.scrollView addSubview: pageImageView] ;
		
		// determine and set its (random) background color
		color = [UIColor colorWithRed: (CGFloat)arc4random()/ARC4RANDOM_MAX green: (CGFloat)arc4random()/ARC4RANDOM_MAX blue: (CGFloat)arc4random()/ARC4RANDOM_MAX alpha: 1.0f];
        
        [pageImageView setImage:[UIImage imageNamed:[introImages objectAtIndex:i]]];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    if(!IS_IPHONE_5)
    {
        self.introBackView.frame = CGRectMake(0, 25, self.introBackView.frame.size.width, self.introBackView.frame.size.height);
        
        self.scrollView.frame = CGRectMake(0,( self.introBackView.frame.origin.y + self.introBackView.frame.size.height) , self.scrollView.frame.size.width, 139);
        
        self.introLabel.frame = CGRectMake(20,(self.scrollView.frame.origin.y + self.scrollView.frame.size.height) + 15, self.introLabel.frame.size.width, self.introLabel.frame.size.height);
        
        self.btnGetStart.frame =  CGRectMake(14,(self.introLabel.frame.origin.y + self.introLabel.frame.size.height) , self.btnGetStart.frame.size.width, self.btnGetStart.frame.size.height);
    }
}

    
#pragma mark -
#pragma mark DDPageControl triggered actions
    
- (void) pageControlClicked:(id)sender
{
        DDPageControl *thePageControl = (DDPageControl *)sender;
        
        // we need to scroll to the new index
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * thePageControl.currentPage, self.scrollView.contentOffset.y) animated: YES] ;
}
    
    
#pragma mark -
#pragma mark UIScrollView delegate methods
    
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
        CGFloat pageWidth = self.scrollView.bounds.size.width ;
        float fractionalPage = self.scrollView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
    
        self.introLabel.text = [introText objectAtIndex:nearestNumber];
    
        if (self.pageControl.currentPage != nearestNumber)
        {
            self.pageControl.currentPage = nearestNumber;
            //update the page control directly during the drag
            if (self.scrollView.dragging)
                [self.pageControl updateCurrentPageDisplay];
        }
}
    
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
   // if we are animating (triggered by clicking on the page control), we update the page control
    [self.pageControl updateCurrentPageDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartedTapped:(id)sender
{
    
//    NSArray *claims = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_CLAIM];
//    
//    if(claims.count == 0)
//    {
//        [self performSegueWithIdentifier:@"FirstTimeUserSegueIdentifier" sender:nil];
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"RegularUserSegueIdentifier" sender:nil];
//    }
    
     //[self dismissViewControllerAnimated:YES completion:nil];
    
//    NSMutableDictionary *reqDict = [[NSMutableDictionary alloc]init];
//    [reqDict removeAllObjects];
//    
//    [reqDict setValue:@"cashier" forKey:@"username"];
//    [reqDict setValue:@"cashier" forKey:@"password"];
//    
//    //[ProgressHudHelper showAdvanceHudWithText:@"Loading..."];
//    [self.webApiRequest performServerTaskWithRequest:nil orParameter:reqDict Delegate:self forRequestType:ACT_USER_LOGIN withTag:GET_USER];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"RECIEVE SEGUE IDENTIFIER ON PREPARE : %@",segue.identifier);
}


#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    NSLog(@"Response Data : %@",responseData);
    @try{
        
        if ([ErrorMsg length]>0)
        {
            //[ProgressHudHelper dissmissAdvanceHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == GET_USER)
            {
                NSString *responseStatus;
                
                if ([responseData isKindOfClass:[NSArray class]])
                {
                    NSLog(@"fail");
                    responseStatus=[[responseData objectAtIndex:0] valueForKey:@"Status"];
                }
                else
                {
                    NSLog(@"success");
                    responseStatus = [responseData valueForKey:@"Status"];
                }
                
                if([responseStatus isEqualToString:@"Success"])
                {
                    [ApplicationData sharedInstance].isFirstTime = NO;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    //[ProgressHudHelper dissmissAdvanceHud];
                    [[ApplicationData sharedInstance]showAlert:LOGIN_ERROR_CODE_0 andTag:0];
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

-(IBAction)openHomeView:(id)sender
{
    
}

@end
