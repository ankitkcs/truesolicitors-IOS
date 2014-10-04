//
//  CustomAccessoryViewDelegate.h
//  ReachMe
//
//  Created by KCS on 12/12/12.
//  Copyright (c) 2012 Kcspl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomAccessoryViewDelegate <NSObject>

-(void) moveToNextField;
-(void) moveToPreviousField;
-(void) Done;

@end
