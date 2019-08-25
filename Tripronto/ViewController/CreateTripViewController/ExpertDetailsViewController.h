//
//  ExpertDetailsViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 6/22/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "AFNetworking.h"

#import "ResponsiveLabel.h"
#import "Expert.h"

@interface ExpertDetailsViewController : UIViewController<APParallaxViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong) Expert *selectedExpert;
@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UITableView *expertTableView;

@property (weak, nonatomic) IBOutlet UILabel *aboutExpartLabel;

@property (weak, nonatomic) IBOutlet ResponsiveLabel *expartDetailLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertTableViewHeightConstraint;

@end
