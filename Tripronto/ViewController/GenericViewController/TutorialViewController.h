//
//  TutorialViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPageControl.h"

#import "SignInView.h"
#import "SignUpView.h"



#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "ZHPopupView.h"
#import "KSToastView.h"


#import "TabBarViewController.h"

#import  <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "Tripronto-Swift.h"


@interface TutorialViewController : UIViewController<UIScrollViewDelegate,SignInViewDelegate,SignUpViewDelegate,FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;

@property (strong,nonatomic) NSMutableArray* imageNameArray;

@property (weak, nonatomic) IBOutlet TAPageControl *customStoryboardPageControl;

@property NSInteger pageSelected;


@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (weak, nonatomic) IBOutlet CDFlipView *flipLoader;


@end
