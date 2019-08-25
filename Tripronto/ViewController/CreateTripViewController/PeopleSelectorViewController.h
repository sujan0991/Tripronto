//
//  PeopleSelectorViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/7/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"
#import "PeopleStepper.h"
//#import "Tripronto-Swift.h"
#import "AKPickerView.h"
#import "KSToastView.h"

#import "ANStepperview.h"

@interface PeopleSelectorViewController : UIViewController<APParallaxViewDelegate,AKPickerViewDataSource, AKPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>


@property (nonatomic, strong) NSString *tripTypeId;


@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *step2View;
@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UIView *stepNumberView;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;


//@property (weak, nonatomic) IBOutlet PeopleStepper *adultStepper;
//@property (weak, nonatomic) IBOutlet GMStepper* adultStepper;
//@property (weak, nonatomic) IBOutlet GMStepper* childStepper;

@property (weak, nonatomic) IBOutlet ANStepperView *adultStepper;
@property (weak, nonatomic) IBOutlet ANStepperView  *childStepper;


@property (weak, nonatomic) IBOutlet UICollectionView *childAgeCollection;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
