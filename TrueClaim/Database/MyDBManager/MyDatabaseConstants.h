//
//  MyDatabaseConstants.h
//  DatabaseManager

#ifndef DatabaseManager_MyDatabaseConstants_h
#define DatabaseManager_MyDatabaseConstants_h

#import "RecordTable.h"
#import "Settings.h"
#import "MassegeDetail.h"
#import "Claim.h"
#import "FAQDetail.h"

#define kComment        @"comment"
#define kEmail          @"email"
#define kName           @"name"
#define kPhoneNumber    @"phoneNumber"

#define kPassword       @"password"

//================= "Claim Attributes" ==================================
#define TBL_CLAIM @"Claim"
#define kClaimsNumber @"claimsNumber"
#define kClaimsDate @"claimsDate"

//================= "MassegeDetail Attributes" ===========================
#define TBL_MASSEGE_DETAIL @"MassegeDetail"
#define kMsgDate @"msgDate"
#define kMsgImage @"msgImage"
#define kMsgText  @"msgText"
#define kMsgAttachment @"msgAttachment"

//================= "FAQ Attributes" ==================================
#define TBL_FAQ_DETAIL @"FAQDetail"
#define kQuestion @"question"
#define kAnswer @"answer"
#endif
