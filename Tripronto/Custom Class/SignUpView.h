//
//  SignUpView.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"

@protocol SignUpViewDelegate;

@interface SignUpView : UIView<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *firstNameView;
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak) id<SignUpViewDelegate> delegate;


@end

@protocol SignUpViewDelegate <NSObject>
@optional

-(void)SignUpView:(SignUpView *)view closeTapped:(UIButton*)sender;
- (void)SignUpView:(SignUpView *)view signInCalled:(UIButton *)sender;
- (void)signUp:(UIButton *)sender;

@end