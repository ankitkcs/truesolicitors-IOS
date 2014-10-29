//
//  MassegeDetail.h
//  TrueClaim
//
//  Created by krish on 10/7/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MassegeDetail : NSManagedObject

@property (nonatomic, retain) NSString * attached_document_guids;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * posted_at;
@property (nonatomic, retain) NSString * is_delivered;
@property (nonatomic, retain) NSString * is_to_firm;

@property (nonatomic, retain) NSString * is_new_message;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * claim_number;

@end
