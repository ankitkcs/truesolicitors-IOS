//
//  DocumnetType.h
//  TrueClaim
//
//  Created by krish on 10/27/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DocumentsType : NSManagedObject

@property (nonatomic, retain) NSString * action_prompt;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * response_template;
@property (nonatomic, retain) NSString * recorded_at;

@end
