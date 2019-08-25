//
//  MessageBoardViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 4/20/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageCommentTableViewCell.h"
#import "IteneraryCommentCell.h"
#import "ManageExpertCell.h"

#import "UIImageView+WebCache.h"

#import "HexColors.h"
#import "AFNetworking.h"

#import "KSToastView.h"
#import "Tripronto-Swift.h"

#import "DDHTimerControl.h"


#import "Pusher.h"

#import "SummaryViewController.h"

#import "NSString+URLEncoding.h"

@interface MessageBoardViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,PTPusherDelegate>

@property (strong,nonatomic) NSMutableDictionary *tripDetails;

@property BOOL isFromInboxVC;
@property int tripId;
@property (strong,nonatomic) NSString *tripName;
@property (strong,nonatomic)  NSString *tripCreatedTime;

@property int selectedTabIndex;
@property BOOL isPastTrip;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UICollectionView *expertSelectorFilter;

@property (weak, nonatomic) IBOutlet UIView *allUpdatesView;

@property (weak, nonatomic) IBOutlet UIView *iteneraryView;
@property (weak, nonatomic) IBOutlet UIView *manageView;
@property (weak, nonatomic) IBOutlet UIView *timerView;


@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UICollectionView *expertSelectorForIteneray;
@property (weak, nonatomic) IBOutlet UITableView *iteneraryFeedTableView;

@property (weak, nonatomic) IBOutlet UITableView *ExpertListTableView;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *withDrawButton;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NextGrowingTextView *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstant;

@property (nonatomic, strong) IBOutlet DDHTimerControl *hourControl;
@property (nonatomic, strong) IBOutlet DDHTimerControl *minControl;
@property (nonatomic, strong) IBOutlet DDHTimerControl *secControl;

@property (weak, nonatomic) IBOutlet UIButton *summaryViewButton;




@end
