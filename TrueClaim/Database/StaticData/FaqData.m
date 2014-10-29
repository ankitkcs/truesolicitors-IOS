//
//  DemoData.m
//  TrueClaim
//
//  Created by krish on 9/2/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import "FaqData.h"
#import "MyDatabaseManager.h"

@implementation FaqData

+(NSArray*) faqDataForDemo
{
     NSMutableArray *faqDataArray = [NSMutableArray array];
    
    NSDictionary *FAQ01 = @{
                               kQuestion: @"Can I make a claim?",
                               kAnswer: @"If you’ve been injured in an accident that wasn’t your fault, then it is likely you will able to claim compensation. If you are not sure whether you can make a claim, simply give us a call and we will tell you whether you have a winnable claim."
                               };
    
    NSDictionary *FAQ02 = @{
                            kQuestion: @"How long do I have to make a claim?",
                            kAnswer: @"Normally you have 3 years from the date of your accident to start court proceedings. This rule does not apply to children as the 3 years does not start until their 18th birthday."
                            };
    
    NSDictionary *FAQ03 = @{
                            kQuestion: @"What can I claim for?",
                            kAnswer: @"In addition to personal injury compensation, you can also claim for any losses caused by the accident. This might include damage to your vehicle, the cost of hiring an alternative vehicle, lost earnings, medical treatment costs, travel expenses, damage to clothing or personal belongings and even the cost of any care provided to you by your family and friends."
                            };

    NSDictionary *FAQ04 = @{
                            kQuestion: @"How much compensation will I receive?",
                            kAnswer: @"The amount of compensation you are awarded will depend on the seriousness of your injuries and the extent of your other losses and out-of-pocket expenses. It is therefore impossible for any solicitor to predict the amount you will receive at the start of your claim."
                            };
    
    NSDictionary *FAQ05 = @{
                            kQuestion: @"How much will it cost me to make a claim?",
                            kAnswer: @"We will deal with your claim on a ‘no win, no fee’ basis, which means you pay nothing if your claim is not successful. This arrangement takes the risk out of making a personal injury claim and gives you peace of mind. The official name for this type of arrangement is a Conditional Fee Agreement or CFA."
                            };
    
    NSDictionary *FAQ06 = @{
                            kQuestion: @"What do I have to pay if I lose?",
                            kAnswer: @"You do not have pay us anything if you lose except in exceptional circumstances. For example, if you fail to cooperate, make a dishonest claim, or reject our advice."
                            };
    
    
    NSDictionary *FAQ07 = @{
                            kQuestion: @"What do I have to pay if I’m successful?",
                            kAnswer: @"Before April 2013, the losing party, in addition to paying compensation, was also legally required to pay the claimant’s full legal costs. Unfortunately the government believed this system was unfair to insurance companies and so it introduced a system where the claimant pays the success fee and the legal expenses insurance premium from the compensation they are awarded."
                            };
    
    NSDictionary *FAQ08 = @{
                            kQuestion: @"How long will my claim take to settle?",
                            kAnswer: @"This depends on many factors, such as the complexity of your claim, whether your claim is disputed, the seriousness of your injuries, and the attitude of the defendant’s insurance company. If your case is straightforward then your claim could conclude within a few months."
                            };
    
    NSDictionary *FAQ09 = @{
                            kQuestion: @"What is  the  process of claiming/what happens next?",
                            kAnswer: @"We take your instructions on all of the details of the accident. Once we have all the details we need , we notify the other party’s insurers that we will be making a claim. They will advise if it is there intention to admit or deny liability.  At the same time we will gather evidence in support of your claim. We will arrange for you to have a medical examination to determine your injuries. We will also write to witnesses and obtain documents relating to the case. If the other party admits liability, we gather sufficient evidence to value your case and then obtain the best settlement we can for you. If the other party denies liability, then we will advise you on your prospects for success."
                            };
    
    NSDictionary *FAQ10 = @{
                            kQuestion: @"Do I have to attend your office?",
                            kAnswer: @"No. You are welcome to visit us at our offices in Newcastle, Leeds, Ipswich and Birmingham, but we are able to deal with your claim just as easily over the telephone, by email and by post."
                            };
    
    NSDictionary *FAQ11 = @{
                            kQuestion: @"Will I have to attend for a medical examination?",
                            kAnswer: @"A claim for personal injury compensation must be supported by a medical report prepared by a medical expert."
                            };
    
    NSDictionary *FAQ12 = @{
                            kQuestion: @"How far will I have to travel to see a medical expert?",
                            kAnswer: @"The medical agencies we use to arrange medical examinations have an extensive nationwide panel of medical experts and so in most cases the medical examination will take place close to where you live."
                            };

    
    NSDictionary *FAQ13 = @{
                            kQuestion: @"What happens after the medical examination?",
                            kAnswer: @"The medical expert will send us his report, this may take a few weeks. We will then send you the medical report for you to check and approve. If the medical report is fine we will value your case or if the expert has suggested treatment, make those arrangements. If the medical report is not accurate or you have other concerns about the report, you need to tell us."
                            };
    
    NSDictionary *FAQ14 = @{
                            kQuestion: @"Will I have to pay for treatment arranged by True?",
                            kAnswer: @"The cost of treatment will form part of your claim and will be claimed from the losing side in addition to your personal injury compensation."
                            };
    
    NSDictionary *FAQ15 = @{
                            kQuestion: @"What happens after I accept an offer?",
                            kAnswer: @"Once we communicate your acceptance to the other party, your case is settled and we will not be able to reopen it. It is therefore important that you check that we have included all of your losses, and that you are happy with the valuation of your injury."
                            };
    
    NSDictionary *FAQ16 = @{
                            kQuestion: @"Can I still bring a claim if the accident was partly my fault?",
                            kAnswer: @"Yes. You can recover compensation for the part of the accident that was not your fault. For example, if you were found to be 25% to blame, then you would recover compensation to cover 75% of your losses."
                            };
    
    NSDictionary *FAQ17 = @{
                            kQuestion: @".Will I still get compensation if the other party is not insured?",
                            kAnswer: @"Yes. An organisation called the MIB (Motor Insurers Bureau) pays compensation to road accident victims where the other driver is not insured."
                            };
    
    NSDictionary *FAQ18 = @{
                            kQuestion: @"Will I get compensation if I am the victim of a hit and run accident?",
                            kAnswer: @"Provided you can show that the accident happened and was the fault of the hit and run driver, then the MIB (Motor Insurers Bureau) will pay you compensation."
                            };
    
    
    NSDictionary *FAQ19 = @{
                            kQuestion: @"Will I lose my job if I make a claim against my employer?",
                            kAnswer: @"It would be against the law for your employer to terminate your employment because you were injured at work.  In any event your employer will be insured against the risk of one of its employees becoming injured and so any compensation you are awarded will be paid by an insurance company and not your employer"
                            };
    
    NSDictionary *FAQ20 = @{
                            kQuestion: @"Can a child make a claim?",
                            kAnswer: @"Yes a child can claim. However their cases are dealt with differently. They will need a litigation friend (usually a parent) and their compensation is held in an account until they are 18."
                            };
    
    NSDictionary *FAQ21 = @{
                            kQuestion: @".What if I receive an offer directly from the other side?",
                            kAnswer: @"An early offer made without a medical report or independent legal advice should be treated with cautions."
                            };
    
    NSDictionary *FAQ22 = @{
                            kQuestion: @"Will I have to go to court?",
                            kAnswer: @"The vast majority of personal injury claims settle before a final hearing at court. However, if there is an argument about the facts of your accident or the value of your claim that cannot be resolved, then you may need to attend a court hearing. If this happens, your  True Advisor will be right by your side."
                            };
    
    NSDictionary *FAQ23 = @{
                            kQuestion: @"What type of personal injury claims can we help you with?",
                            kAnswer: @"TRUE Solicitors are specialists in all types of personal injury work. This includes:-\n\n Road Traffic Accidents\n Accidents at Work\n Fatal Accidents Medical Negligence\n Industrial Disease."
                            };
    
    NSDictionary *FAQ24 = @{
                            kQuestion: @"Why TRUE Solicitors?",
                            kAnswer: @"Because we are experienced in handling all types of personal injury claims.\nBecause we will provide you with a professional, objective review of your accident claim.\nBecause we will guide you through every stage of the compensation process.\nBecause TRUE Solicitors win 9 out of 10 cases."
                            };

    
    [faqDataArray insertObject:FAQ01 atIndex:0];
    [faqDataArray insertObject:FAQ02 atIndex:1];
    [faqDataArray insertObject:FAQ03 atIndex:2];
    [faqDataArray insertObject:FAQ04 atIndex:3];
    [faqDataArray insertObject:FAQ05 atIndex:4];
    [faqDataArray insertObject:FAQ06 atIndex:5];
    [faqDataArray insertObject:FAQ07 atIndex:6];
    [faqDataArray insertObject:FAQ08 atIndex:7];
    [faqDataArray insertObject:FAQ09 atIndex:8];
    [faqDataArray insertObject:FAQ10 atIndex:9];
    [faqDataArray insertObject:FAQ11 atIndex:10];
    [faqDataArray insertObject:FAQ12 atIndex:11];
    [faqDataArray insertObject:FAQ13 atIndex:12];
    [faqDataArray insertObject:FAQ14 atIndex:13];
    [faqDataArray insertObject:FAQ15 atIndex:14];
    [faqDataArray insertObject:FAQ16 atIndex:15];
    [faqDataArray insertObject:FAQ17 atIndex:16];
    [faqDataArray insertObject:FAQ18 atIndex:17];
    [faqDataArray insertObject:FAQ19 atIndex:18];
    [faqDataArray insertObject:FAQ20 atIndex:19];
    [faqDataArray insertObject:FAQ21 atIndex:20];
    [faqDataArray insertObject:FAQ22 atIndex:21];
    [faqDataArray insertObject:FAQ23 atIndex:22];
    [faqDataArray insertObject:FAQ24 atIndex:23];

    return faqDataArray;
}

@end
