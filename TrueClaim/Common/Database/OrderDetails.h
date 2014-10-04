//
//  OrderDetails.h
//  Qwiches
//
//  Created by krish on 1/21/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * productQuantity;

@end
