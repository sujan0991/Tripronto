//
//  ExpertListViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/29/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"

#import "JT3DScrollView.h"
#import "ExpertHolderView.h"

#import "TAPageControl.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "KSToastView.h"

#import "SummaryViewController.h"
#import "ExpertDetailsViewController.h"

@interface ExpertListViewController : UIViewController<APParallaxViewDelegate,UIScrollViewDelegate,TAPageControlDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *expertView;

@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *inspireButton;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet JT3DScrollView *expertScrollView;

@property (weak, nonatomic) IBOutlet TAPageControl *customStoryboardPageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertViewRatio;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertListHeight;

@end
