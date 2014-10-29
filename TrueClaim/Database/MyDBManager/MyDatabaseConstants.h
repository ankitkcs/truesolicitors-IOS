//
//  MyDatabaseConstants.h
//  DatabaseManager

#ifndef DatabaseManager_MyDatabaseConstants_h
#define DatabaseManager_MyDatabaseConstants_h

#import "RecordTable.h"
#import "Settings.h"
#import "MassegeDetail.h"
#import "LinkToClaim.h"
#import "FAQDetail.h"
#import "DocumentDetail.h"
#import "DocumentsType.h"

#define kComment        @"comment"
#define kEmail          @"email"
#define kName           @"name"
#define kPhoneNumber    @"phoneNumber"

#define kPassword       @"password"

//================= "LINK TO Claim Attributes" ==================================
#define TBL_LINK_CLAIM @"LinkToClaim"

#define kAccountID @"account_id"
#define kClaimNumber @"claim_number"
#define kAccountName @"account_name"
#define kCustomerName @"customer_name"
#define kAccidentDate @"accident_date"
#define kLinkedAt @"linked_at"
#define kAuthToken @"auth_token"
#define kCreateAt @"created_at"

//================= "MassegeDetail Attributes" ===========================
#define TBL_MASSEGE_DETAIL @"MassegeDetail"

#define kMsgAttachesDocGuids @"attached_document_guids"
#define kMsgFrom @"from"
#define kMsgGuid @"guid"
#define kMsgBody @"body"
#define kMsgPostedAt @"posted_at"
#define kMsgIsDeliverd @"is_delivered"
#define kMsgIsToFirm @"is_to_firm"

#define kMsgIsNewMessage @"is_new_message"
#define kMsgCreatedAt @"created_at"
#define kMsgClaimNumber @"claim_number"

//======================= DocumentDetail Attributes"======================
#define TBL_DOCUMENT_DETAIL @"DocumentDetail"

#define kDocGuid @"guid"
#define kDocName @"name"
#define kDocAppDateReadAt @"app_date_read_at"
#define kDocAppDateActionAt @"app_date_actioned_at"
#define kDocTypeCode @"type_code"
#define kDocCreatedAt @"created_at"

#define kDocRecordedAt @"recorded_at"
#define kDocClaimNumber @"claim_number"

//======================= DocumentType Attributes"======================
#define TBL_DOCUMENT_TYPE @"DocumentsType"

#define kDocTypeActionPrompt @"action_prompt"
#define kDocTypeDocCode @"code"
#define kDocTypeName @"name"
#define kDocRespTemplate @"response_template"

#define kDocTypeRecordedAt @"recorded_at"

//================= "FAQ Attributes" ==================================
#define TBL_FAQ_DETAIL @"FAQDetail"
#define kQuestion @"question"
#define kAnswer @"answer"
#endif
