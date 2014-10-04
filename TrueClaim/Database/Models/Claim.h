//
//  Claim.h
//  TrueClaim
//
//  Created by krish on 8/27/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Claim : NSManagedObject

@property (nonatomic, retain) NSString * claimsNumber;
@property (nonatomic, retain) NSString * claimsDate;

@end
