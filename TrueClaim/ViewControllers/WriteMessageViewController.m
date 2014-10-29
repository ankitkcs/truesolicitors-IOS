//
//  WriteMessageViewController.m
//  TrueClaim
//
//  Created by krish on 7/25/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "WriteMessageViewController.h"

@interface WriteMessageViewController ()

@end

@implementation WriteMessageViewController

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
	// Do any additional setup after loading the view.
    
    self.selClaim = [ApplicationData sharedInstance].selectedClaim;
    self.lblClaimHead.text = self.selClaim.claim_number;
    
    [self.msgTextView becomeFirstResponder];
}

-(IBAction)btnCancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnSendClick:(id)sender
{
    NSDictionary *msgDict = @{@"body": self.msgTextView.text};
    
    // request for get messages
    self.webApi = [[WebApiRequest alloc] init];
    [ApplicationData sharedInstance].tc_auth_token = self.selClaim.auth_token;
    [self.webApi PostDataWithParameter: msgDict.mutableCopy forDelegate:self andTag:116 forRequstType:reqGET_MESSAGE serviceType:WS_POST];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    @try{
        
        if ([ErrorMsg length]>0)
        {
            //[ProgressHudHelper dissmissAdvanceHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == 116)
            {
                NSLog(@"Response Data : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    NSLog(@"Now you can save the data to local database");
                    
                    //NSArray *msgArray = [responseData valueForKey:@"messages"];
                    
                    //NSLog(@"TOTAL MESSAGES : %d",msgArray.count);
                    //NSLog(@"FIRST MESSAGE DETAIL : %@",[msgArray objectAtIndex:0]);
                    
                    //                    NSArray *attachDocArray = [[msgArray objectAtIndex:0] valueForKey:@"attached_document_guids"];
                    //                    NSLog(@"DOC IDS : %@",[attachDocArray objectAtIndex:0]);
                    //                    NSString *attacmentID = [attachDocArray objectAtIndex:0];
                    
                    /*
                    NSString *todayDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
                    
                    for(int i=0; i < msgArray.count ; i++)
                    {
                        NSArray *attachDocArray = [[msgArray objectAtIndex:0] valueForKey:kAttachesDocGuids];
                        NSString *attacmentID = [attachDocArray objectAtIndex:0];
                        
                        //NSString *attached_document_guids = attacmentID;
                        NSString *from = [[msgArray objectAtIndex:i] valueForKey:kFrom];
                        NSString *guid = [[msgArray objectAtIndex:i] valueForKey:kGuid];
                        NSString *body = [[msgArray objectAtIndex:i] valueForKey:kBody];
                        NSString *posted_at = [[msgArray objectAtIndex:i] valueForKey:kPostedAt];
                        NSString *is_delivered = [NSString stringWithFormat:@"%@",[[msgArray objectAtIndex:i] valueForKey:kIsDeliverd]];
                        NSString *is_to_firm = [NSString stringWithFormat:@"%@",[[msgArray objectAtIndex:i] valueForKey:kIsToFirm]];
                        
                        NSString *is_new_message = [NSString stringWithFormat:@"%@",@"1"];
                        NSString *created_at = todayDate;
                        NSString *claim_number = self.selClaim.claim_number;
                        
                        
                        NSMutableDictionary *saveMessage = [NSMutableDictionary dictionary];
                        [saveMessage setValue:attacmentID forKey:kAttachesDocGuids];
                        [saveMessage setValue:from forKey:kFrom];
                        [saveMessage setValue:guid forKey:kGuid];
                        [saveMessage setValue:body forKey:kBody];
                        [saveMessage setValue:posted_at forKey:kPostedAt];
                        [saveMessage setValue:is_delivered forKey:kIsDeliverd];
                        [saveMessage setValue:is_to_firm forKey:kIsToFirm];
                        
                        [saveMessage setValue:is_new_message forKey:kIsNewMessage];
                        [saveMessage setValue:created_at forKey:kCreateAt];
                        [saveMessage setValue:claim_number forKeyPath:kMsgClaimNumber];
                        
                        NSLog(@"Dict To Save : %@",saveMessage);
                        
                        MassegeDetail *newMessage = [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_MASSEGE_DETAIL withDataDict:saveMessage];
                        
                        if(newMessage)
                        {
                            NSLog(@"MESSAGE SAVED");
                        }
                        
                        
                    }
                    
                    self.filteredMessages = [NSMutableArray arrayWithCapacity:[self.allMessages count]];
                    [self.tableView reloadData];
                    [self reloadMyTable]; */
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
