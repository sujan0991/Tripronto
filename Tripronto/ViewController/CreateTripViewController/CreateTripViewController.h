//
//  CreateTripViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/6/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"



@interface CreateTripViewController : UIViewController<APParallaxViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *step1View;

@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UIView *stepNumberView;

@property (weak, nonatomic) IBOutlet UIButton *doButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *inspireButton;


@end
