//
//  Claim.h
//  TrueClaim
//
//  Created by krish on 10/6/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LinkToClaim : NSManagedObject

@property (nonatomic, retain) NSString * account_id;
@property (nonatomic, retain) NSString * claim_number;
@property (nonatomic, retain) NSString * account_name;
@property (nonatomic, retain) NSString * customer_name;
@property (nonatomic, retain) NSString * accident_date;
@property (nonatomic, retain) NSString * linked_at;
@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSString * created_at;

@end
