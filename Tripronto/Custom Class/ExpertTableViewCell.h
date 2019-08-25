//
//  HeaderTableViewCell.h
//  Medication
//
//  Created by Masudur Rahman on 2/19/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"

#import "UIImageView+WebCache.h"

@interface ExpertTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray* expertData;

@property (strong, nonatomic) IBOutlet UITableView *expertsTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *expertHeaderView;

@end
