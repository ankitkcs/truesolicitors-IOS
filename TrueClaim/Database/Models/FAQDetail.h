//
//  FAQDetail.h
//  TrueClaim
//
//  Created by krish on 9/2/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FAQDetail : NSManagedObject

@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;

@end
