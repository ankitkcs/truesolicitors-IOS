//
//  IngrediantDetails.h
//  Qwiches
//
//  Created by krish on 2/3/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IngrediantDetails : NSManagedObject

@property (nonatomic, retain) NSString * ingrediantName;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSNumber * ingrediantId;

@end
