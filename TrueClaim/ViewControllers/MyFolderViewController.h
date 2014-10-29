//
//  MyFolderViewController.h
//  TrueClaim
//
//  Created by krish on 7/22/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMTransView.h"


@interface MyFolderViewController : UIViewController
<
UIAlertViewDelegate,
RKMTransViewDelegate
>
@property (strong, nonatomic) RKMTransView *transparentView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) IBOutlet UITableView *tblDocumnets;
@property(nonatomic,readwrite)BOOL viewLoaded;
@property(nonatomic,strong) NSMutableArray *allDocuments;

@property (nonatomic,strong) WebApiRequest *webApi;
@property (strong,nonatomic) LinkToClaim *selClaim;
@end
