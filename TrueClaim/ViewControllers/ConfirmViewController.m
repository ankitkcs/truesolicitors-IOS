//
//  ConfirmViewController.m
//  TrueClaim
//
//  Created by krish on 7/28/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "ConfirmViewController.h"
#import "QRadioButton.h"
#import "MyFolderViewController.h"
#import "MyDataBaseManager.h"
#import "MsgTruePopController.h"
#import "QCheckBox.h"


@interface ConfirmViewController () <MessagePopDelegate,QRadioButtonDelegate,QCheckBoxDelegate>

{
    QCheckBox *checkMsg;
}

@end

@implementation ConfirmViewController

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
    [self createCustomRadioButton];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelTapped:)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnConfirm  = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(btnConfirmTapped:)];
    self.navigationItem.rightBarButtonItem = btnConfirm;
    
    self.navigationItem.title = @"AUTORITY";
    self.authType = @"None";
    
    self.selDocDetail = [ApplicationData sharedInstance].selectedDocDetail;
    
    NSArray *docTypeArr = [[MyDatabaseManager sharedManager]  allRecordsSortByAttribute:kDocTypeDocCode where:kDocTypeDocCode contains:self.selDocDetail.type_code byAcending:YES fromTable:TBL_DOCUMENT_TYPE];
    
    NSLog(@"doc Detail Find : %@ And Total Count : %lu",docTypeArr,(unsigned long)docTypeArr.count);
    
    DocumentsType *selDoc = [docTypeArr objectAtIndex:0];
    
    NSLog(@"DOC ACTION PROMPT : %@",selDoc.action_prompt);
    
    self.lblPrompt.text = selDoc.action_prompt;
    
}

- (void)createCustomRadioButton
{
    
    CGFloat posY = self.lblPrompt.frame.origin.y + self.lblPrompt.frame.size.height + 20;
    
    QRadioButton *rdoBtnAgree = [[QRadioButton alloc] initWithDelegate:self
                                                               groupId:@"groupAuthority"];
    rdoBtnAgree.frame = CGRectMake(50, posY,200, 40);
    rdoBtnAgree.tag = 1000;
    [rdoBtnAgree setTitle:@"I Agree" forState:UIControlStateNormal];
    [rdoBtnAgree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rdoBtnAgree setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rdoBtnAgree setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rdoBtnAgree.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rdoBtnAgree setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [rdoBtnAgree setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:rdoBtnAgree];
    

    QRadioButton *rdoBtnDisAgree = [[QRadioButton alloc] initWithDelegate:self
                                                                  groupId:@"groupAuthority"];
    rdoBtnDisAgree.frame = CGRectMake(50,posY+50, 200, 40);
    rdoBtnDisAgree.tag = 2000;
    [rdoBtnDisAgree setTitle:@"I Do Not Agree" forState:UIControlStateNormal];
    [rdoBtnDisAgree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rdoBtnDisAgree setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rdoBtnDisAgree setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rdoBtnDisAgree.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rdoBtnDisAgree setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [rdoBtnDisAgree setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:rdoBtnDisAgree];
    
    
    checkMsg = [[QCheckBox alloc] initWithDelegate:self];
    checkMsg.frame = CGRectMake(50,posY+100, 280, 40);
    [checkMsg setTitle:@"Include a message to TRUE?" forState:UIControlStateNormal];
    [checkMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkMsg setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [checkMsg setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [checkMsg.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [checkMsg setImage:[UIImage imageNamed:@"ios_selection_circle_icon.png"] forState:UIControlStateNormal];
    [checkMsg setImage:[UIImage imageNamed:@"ios_selection_tick_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:checkMsg];
    [checkMsg setChecked:NO];
}

#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
    
    if(radio.tag == 1000) // agree
     {
         self.authType = @"1"; // for agree
     }
    else if(radio.tag == 2000)
    {
         self.authType = @"0"; // for disagree
    }
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    
    if(checked)
    {
        self.isMessage = YES;
    }
    else
    {
        self.isMessage = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConfirmTapped:(id)sender
{
    if([self.authType isEqualToString:@"None"])
    {
        [[ApplicationData sharedInstance] showAlert:@"Plese perform action for Agree or Disagree."
                                             andTag:0];
    }
    else
    {
        // if message selected show message prompt
        if(self.isMessage)
        {
            MsgTruePopController *msgAlert = [[MsgTruePopController alloc] init];
            msgAlert.delegate = self;
            [msgAlert Open];
        }
        else
        {
            // send request without message
            [self sendRequestForConfrimAction];
        }
    }
}


-(void) PopUpCancelWithMessageText:(NSString *)msgText
{
    NSLog(@"Entered Passcode In MyFolder %@",msgText);
    self.optionMsgText = @"";
    
    // uncheck msg checkbox
    [checkMsg setChecked:NO];
    self.isMessage = NO;
}

-(void) PopUpDoneWithMessageText:(NSString *)msgText
{
    NSLog(@"Entered Passcode In MyFolder %@",msgText);
    self.optionMsgText = msgText;
    
    [self sendRequestForConfrimAction];
}

-(void) sendRequestForConfrimAction
{
    self.selDocDetail = [ApplicationData sharedInstance].selectedDocDetail;
    NSString *readDate = self.selDocDetail.app_date_read_at;
    NSString *actionDate = [ApplicationData getStringFromDate:[NSDate date] inFormat:DATETIME_FORMAT_DB];
    NSString *reqForConfirm = [NSString stringWithFormat:@"documents/%@",self.selDocDetail.guid];
    
    if([ApplicationData ConnectedToInternet])
    {
        [ProgressHudHelper showLoadingHudWithText:@""];
        NSDictionary *reqDict = @{@"app_date_read_at": readDate,
                                  @"app_date_actioned_at":actionDate,
                                  @"app_type_of_action":self.authType,
                                  @"optional_message":self.optionMsgText
                                  };
        
        self.webApi = [[WebApiRequest alloc]init];
        [self.webApi PostDataWithParameter:reqDict.mutableCopy forDelegate:self andTag:tAction forRequstType:reqForConfirm serviceType:WS_PUT];
    }
    else
    {
        [[ApplicationData sharedInstance] showAlert:INTERNET_CONNECTION_ERROR andTag:0];
    }

}

#pragma mark -
#pragma mark webapi delegate
-(void)setData:(NSMutableArray *)responseData :(NSString *)ErrorMsg withDelegate:(id)Delegate andTag:(int)Tag
{
    @try{
        
        if ([ErrorMsg length]>0)
        {
            [ProgressHudHelper dissmissAdvanceHud];
            [[ApplicationData sharedInstance] showAlert:ErrorMsg andTag:0];
        }
        else
        {
            if (Tag == tAction)
            {
                NSLog(@"Response Data : %@",responseData);
                
                if([[responseData valueForKey:@"response_message"] isEqualToString:@"success"])
                {
                    [ProgressHudHelper hideLoadingHud];
                    NSLog(@"Update the data to database according to response");
                }
                else
                {
                    [ProgressHudHelper hideLoadingHud];
                    [[ApplicationData sharedInstance] showAlert:[responseData valueForKey:@"response_message"] andTag:0];
                }
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)btnCancelTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
