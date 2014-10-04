//
//  DemoData.m
//  TrueClaim
//
//  Created by krish on 9/2/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "DemoData.h"
#import "MyDatabaseManager.h"

@implementation DemoData

+(NSArray*) messageDataForDemo
{
    NSMutableArray *myDataArray = [NSMutableArray array];
    
    NSDictionary *msgDict1 = @{
                               kMsgDate: @"Today,11:23 AM",
                               kMsgImage: @"ios_true_logoCell.png",
                               kMsgText: @"You can claim compensation for any out of pocket expenses you have incurred but you mus provide me with supporting documentry evidence (receipts,invoices etc) for each loss claimed.I have sent you a letter setting out what information i need and have posted a copy for you to read Loc Docs.",
                               kMsgAttachment: @"Y"
                               };
    
    
    NSDictionary *msgDict2 = @{
                               kMsgDate: @"Yesterday,3:13 PM",
                               kMsgImage: @"ios_user_icon.png",
                               kMsgText: @"Thank you for the last later,can somebody please call me back ASAP? \n\n I would like to discuss it further.",
                               kMsgAttachment: @"N"
                               };
    
    NSDictionary *msgDict3 = @{
                               kMsgDate: @"Tues,Feb 28, 11.23 AM",
                               kMsgImage: @"ios_true_logoCell.png",
                               kMsgText: @"Good news! The other party has accepted your offer. In accordeance with the court rules they should now send your settlement cheque within 4 working days.",
                               kMsgAttachment: @"N"
                               };

    
    NSDictionary *msgDict4 = @{
                               kMsgDate: @"Fri,Feb 24, 12.03 AM",
                               kMsgImage: @"ios_user_icon.png",
                               kMsgText: @"Good news! The other party has accepted your offer. In accordeance with the court rules they should now send your settlement cheque within 4 working days.",
                               kMsgAttachment: @"N"
                               };

    
    NSDictionary *msgDict5 = @{
                               kMsgDate: @"Mon,Jan 30, 10.10 PM",
                               kMsgImage: @"Message.png",
                               kMsgText: @"MyMessage",
                               kMsgAttachment: @"N"
                               };
    
    [myDataArray insertObject:msgDict1 atIndex:0];
    [myDataArray insertObject:msgDict2 atIndex:1];
    [myDataArray insertObject:msgDict3 atIndex:2];
    [myDataArray insertObject:msgDict4 atIndex:3];
    [myDataArray insertObject:msgDict5 atIndex:4];

    return myDataArray;
}

+(NSArray*) faqDataForDemo
{
     NSMutableArray *faqDataArray = [NSMutableArray array];
    
    NSDictionary *FAQ01 = @{
                               kQuestion: @"How do I know if I have the right to claim for compensation?",
                               kAnswer: @"You may be able to claim for compensation if you’ve been injured in an accident that wasn’t your fault, so we need to define that for you really... accidents are the result of being put into, or entering a situation that wasn’t safe, with undesired results, such as personal injury, personal stress or financial loss.\
                               Be assured that TRUE Solicitors LLP only ever accept genuine claims seeking genuine justice and deserved compensation meaning that, if you’re with TRUE, you have the confidence of knowing you’re in the right and the security of having an expert by your side.\
                               The best thing to do is call us and we’ll help you to understand your rights after an accident. Or leave your contact details and our Front Line Team will call you back within a couple of hours."
                               };
    
    NSDictionary *FAQ02 = @{
                            kQuestion: @"What's the process of claiming from the moment I call you?",
                            kAnswer: @"1) Our Front Line Team will call you and gather all the information required to make a claim on your behalf.\
                            2) You’ll be introduced to your Personal Injury Case Manager, who will submit your claim to the other party.\
                            3) Your Personal Injury Case Manager will make the arrangements to formalise your case:\
                                  i)   Arrange a medical examination if required.\
                                 ii)   Explore treatment necessary to assist your recovery.\
                                iii)  Collect supportive evidence to substantiate your claim.This information, plus anything further of relevance, gives them the financial figures for compensation to be requested on your behalf.\
                            4) Your Personal Injury Case Manager will present their findings to the other party and pursue your claim through to its conclusion."
                            };
    
    NSDictionary *FAQ03 = @{
                            kQuestion: @"How long do cases normally take to settle?",
                            kAnswer: @"This is tricky to answer because there are so many factors to consider. The following things will make a case a little longer:\
                            •	If the other side doesn’t accept responsibility.\
                            •	If the other side is uninsured.\
                            •	If the case has to go to court.\
                            •	If the case is very complex.\
                            But none of these things should deter you from pursuing what’s right. Call us anytime and we’ll give you honest advice regarding what to do. Or leave your contact details and our Front Line Team will call you back. "
                            };

    NSDictionary *FAQ04 = @{
                            kQuestion: @"Can I claim on behalf of someone who is unable to claim for themselves?",
                            kAnswer: @"You certainly can. Some accidents leave the victim unable to claim and some claimants are too young to claim in their own right – these cases can be brought by family or friends without any issue at all."
                            };
    
    NSDictionary *FAQ05 = @{
                            kQuestion: @"What can you help me to claim for?",
                            kAnswer: @"Personal Injury Compensation Claims go beyond personal injury:\
                            •	Personal injury: damage to your person, together with the physical and emotional consequences of that and the impact it has on your day to day life.\
                            •	Rehabilitation: immediate and ongoing treatment regimes, eg: Physiotherapy and Counselling.\
                            •	Property damage: damage to vehicles or clothing for example.\
                            •	Financial loss: recouping money lost eg: by not being able to work due to your accident. Recouping expenses previously incurred eg: medication."
                            };
    
    NSDictionary *FAQ06 = @{
                            kQuestion: @"Will I have to go to court?",
                            kAnswer: @"Less than 10% of claims end up in court - but if yours is one of them, be assured that your Personal Injury Case Manager will be right by your side."
                            };

    [faqDataArray insertObject:FAQ01 atIndex:0];
    [faqDataArray insertObject:FAQ02 atIndex:1];
    [faqDataArray insertObject:FAQ03 atIndex:2];
    [faqDataArray insertObject:FAQ04 atIndex:3];
    [faqDataArray insertObject:FAQ05 atIndex:4];
    [faqDataArray insertObject:FAQ06 atIndex:5];

    return faqDataArray;
}

@end
