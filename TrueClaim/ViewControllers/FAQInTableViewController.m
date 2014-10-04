//
//  FAQInTableViewController.m
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "FAQInTableViewController.h"
#import "MyDatabaseManager.h"
#import "DemoData.h"
#import "FaqDetailsViewController.h"

@interface FAQInTableViewController ()
@property (nonatomic,retain) NSMutableArray *allFaq;
@property (nonatomic,retain) FAQDetail *selectedFaq;
@end

@implementation FAQInTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     NSArray *records  = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_FAQ_DETAIL];
    
    if(records.count == 0)
    {
        [self addStaticDataToCoreData];
    }
    else
    {
        [[MyDatabaseManager sharedManager] deleteAllRecordOfTable:TBL_FAQ_DETAIL];
        [self addStaticDataToCoreData];
    }
    
    [self reloadMyTable];
}

-(void) addStaticDataToCoreData
{
    NSArray *dataArray = [DemoData faqDataForDemo];
    
    for (NSDictionary *msgDict in dataArray)
    {
        [[MyDatabaseManager sharedManager] insertRecordInTable:TBL_FAQ_DETAIL withDataDict:msgDict];
    }
}

-(void)reloadMyTable
{
    self.allFaq  = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil fromTable:TBL_FAQ_DETAIL] mutableCopy];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    FAQDetail *faqDetail = [self.allFaq objectAtIndex:indexPath.row];
    CGFloat lblHeigtht = [self dyanmicHeightForlabelText:faqDetail.question];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, lblHeigtht)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor blackColor];
    lbl.numberOfLines = 0;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.text = faqDetail.question;
    lbl.font = [UIFont systemFontOfSize:15.0];
    
    //cell.backgroundColor = [UIColor orangeColor];
    [cell.contentView addSubview:lbl];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self allFaq].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    FAQDetail *faqDetail = [self.allFaq objectAtIndex:indexPath.row];
    cellHeight = 10 + [self dyanmicHeightForlabelText:faqDetail.question] + 10;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     FAQDetail *faqDetail = [self.allFaq objectAtIndex:indexPath.row];
     self.selectedFaq = faqDetail;
    //NSLog(@"QCLICK :  %@",self.selectedFaq.question);
    
//    FaqDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqDetailsViewController"];
//    controller.selFaqDetail = self.selectedFaq;
    
   // [self.navigationController pushViewController:controller animated:YES];
    [self performSegueWithIdentifier:@"FaqDetailSegueIdentifier" sender:self];
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat) dyanmicHeightForlabelText:(NSString*)str
{
    CGSize size;
    
    if (OSVersionIsAtLeastiOS7())
    {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0], NSFontAttributeName, nil];
        
        CGRect frame = [str boundingRectWithSize:CGSizeMake(280, 1000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
        
        size = frame.size;
    }
    else
    {
        size = [str sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return size.height;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"RECIEVE SEGUE IDENTIFIER ON FAQ : %@",segue.identifier);
    
 if ([segue.identifier isEqualToString:@"FaqDetailSegueIdentifier"])
 {
     FaqDetailsViewController *controller = [segue destinationViewController];
     controller.selFaqDetail = self.selectedFaq;
     //NSLog(@"QSEG : %@",self.selectedFaq.question);
     //controller.headerLabel.text = self.selectedFaq.question;
 }
}


@end
