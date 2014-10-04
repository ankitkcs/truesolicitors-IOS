//
//  FaqDetailsViewController.m
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "FaqDetailsViewController.h"

@interface FaqDetailsViewController ()

@end

@implementation FaqDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"QDETAIL : %@",self.selFaqDetail.question);
}

-(void) viewWillAppear:(BOOL)animated
{
    float headerHeight = [self dyanmicHeightForlabelText:self.selFaqDetail.question];
    self.headerLabel.frame = CGRectMake(5, 5, 310, headerHeight+15);
    self.headerLabel.text = self.selFaqDetail.question;
    self.headerLabel.clipsToBounds = YES;
    self.headerLabel.backgroundColor = [UIColor clearColor];
    
    self.headerBackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.headerLabel.frame.size.height + 5);
    
    self.btnBack.frame = self.headerBackView.frame;
    self.btnBack.backgroundColor = [UIColor clearColor];
    
    self.txtFaqDetail.text = self.selFaqDetail.answer;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackToFAQList:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(CGFloat) dyanmicHeightForlabelText:(NSString*)str
{
    CGSize size;
    
    if (OSVersionIsAtLeastiOS7())
    {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0], NSFontAttributeName, nil];
        
        CGRect frame = [str boundingRectWithSize:CGSizeMake(310, 1000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
        
        size = frame.size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(310, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return size.height;
}

@end
