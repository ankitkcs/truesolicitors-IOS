//
//  MassegeDetail.h
//  TrueClaim
//
//  Created by krish on 8/27/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MassegeDetail : NSManagedObject

@property (nonatomic, retain) NSString * msgDate;
@property (nonatomic, retain) NSString * msgImage;
@property (nonatomic, retain) NSString * msgText;
@property (nonatomic, retain) NSString * msgAttachment;

@end
