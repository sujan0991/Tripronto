//
//  SignInView.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"

@protocol SignInViewDelegate;

@interface SignInView : UIView<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *customLoginButton;


@property (weak) id<SignInViewDelegate> delegate;

@end

@protocol SignInViewDelegate <NSObject>
@optional

-(void)signinview:(SignInView *)view closeTapped:(UIButton*)sender;
-(void)signinview:(SignInView *)view signUpCalled:(UIButton*)sender;
- (void)login:(UIButton *)sender;

@end
