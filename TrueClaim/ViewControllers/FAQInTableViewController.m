//
//  FAQInTableViewController.m
//  TrueClaim
//
//  Created by krish on 8/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "FAQInTableViewController.h"
#import "MyDatabaseManager.h"
#import "FaqData.h"
#import "FaqDetailsViewController.h"

@interface FAQInTableViewController ()
{
    UILabel *lbl;
}
@property (nonatomic,retain) NSMutableArray *allFaq;

@property (nonatomic,retain) NSString *selecQues;
@property (nonatomic,retain) NSString *selecAns;



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
    self.allFaq = [FaqData faqDataForDemo].mutableCopy;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
    
    NSDictionary *faqDict = [self.allFaq objectAtIndex:indexPath.row];
    NSString *faQuestion = [faqDict valueForKey:kQuestion];
    CGFloat lblHeigtht = [self dyanmicHeightForlabelText:faQuestion];
    
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, lblHeigtht)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor blackColor];
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.text = faQuestion;
        lbl.font = [UIFont systemFontOfSize:15.0];
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

    NSDictionary *faqDict = [self.allFaq objectAtIndex:indexPath.row];
    NSString *faQuestion = [faqDict valueForKey:kQuestion];
    cellHeight = 10 + [self dyanmicHeightForlabelText:faQuestion] + 10;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *faqDict = [self.allFaq objectAtIndex:indexPath.row];
    NSString *faQuestion = [faqDict valueForKey:kQuestion];
    
    self.selecQues = faQuestion;
    self.selecAns =  [faqDict valueForKey:kAnswer];
    NSLog(@"QCLICK :  %@",faQuestion);
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
     //controller.selFaqDetail = self.selectedFaq;
     controller.FaqQuestion = self.selecQues;
     controller.FaqAnswer = self.selecAns;
     
    // NSDictionary *faqDict = [self.allFaq objectAtIndex:indexPath.row];
     //NSString *faQuestion = [faqDict valueForKey:kQuestion];
     
     //self.selecQues = faQuestion;
     //self.selecAns =  [faqDict valueForKey:kAnswer];
     
     //NSLog(@"QSEG : %@",self.selectedFaq.question);
     //controller.headerLabel.text = self.selectedFaq.question;
 }
}


@end
