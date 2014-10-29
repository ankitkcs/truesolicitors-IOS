//
//  PasscodePopController.h
//  TrueClaim
//
//  Created by krish on 10/10/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagePopDelegate <NSObject>
-(void) PopUpDoneWithMessageText: (NSString*)msgText;
-(void) PopUpCancelWithMessageText: (NSString*)msgText;
@end

@interface MsgTruePopController : UIView <UITextFieldDelegate>

{

}

@property (weak,nonatomic) UITextView *msgTextView;

@property (retain,nonatomic) NSString *MessageText;
@property (nonatomic, assign) BOOL hideCloseButton;

@property(nonatomic,weak) id <MessagePopDelegate> delegate;

-(void)Open;
-(void)close;


@end
