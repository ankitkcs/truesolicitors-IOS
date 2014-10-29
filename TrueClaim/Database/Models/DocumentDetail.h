//
//  DocumentDetail.h
//  TrueClaim
//
//  Created by krish on 10/8/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DocumentDetail : NSManagedObject

@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * app_date_read_at;
@property (nonatomic, retain) NSString * app_date_actioned_at;
@property (nonatomic, retain) NSString * type_code;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * recorded_at;
@property (nonatomic, retain) NSString * claim_number;

@end
