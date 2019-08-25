//
//  HeaderTableViewCell.h
//  Medication
//
//  Created by Masudur Rahman on 2/19/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableDictionary* destinationData;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationViewHeightConstant;

@property (weak, nonatomic) IBOutlet UIView *nameView;


-(void)adjustHeightOfTableview;

@end
