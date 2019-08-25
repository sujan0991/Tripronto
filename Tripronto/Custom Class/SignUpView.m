//
//  SignUpView.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "SignUpView.h"

@implementation SignUpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SignUpView" owner:self options:nil];
        self.contentView.frame = self.frame;
        [self addSubview: self.contentView];
        [self setup];
    }
    
    
    return self;
}

-(void)setup
{
    self.emailView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    self.passwordView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    self.firstNameView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    self.lastNameView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    
    self.emailView.layer.masksToBounds = NO;
    self.emailView.layer.shadowOffset = CGSizeMake(0, 0);
    self.emailView.layer.shadowRadius = 5;
    self.emailView.layer.shadowOpacity = 0.1;
    self.emailView.layer.zPosition=100;
    self.emailView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    self.passwordView.layer.masksToBounds = NO;
    self.passwordView.layer.shadowOffset = CGSizeMake(0, 0);
    self.passwordView.layer.shadowRadius = 5;
    self.passwordView.layer.shadowOpacity = 0.1;
    self.passwordView.layer.zPosition=100;
    self.passwordView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    self.firstNameView.layer.masksToBounds = NO;
    self.firstNameView.layer.shadowOffset = CGSizeMake(0, 0);
    self.firstNameView.layer.shadowRadius = 5;
    self.firstNameView.layer.shadowOpacity = 0.1;
    self.firstNameView.layer.zPosition=100;
    self.firstNameView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    self.lastNameView.layer.masksToBounds = NO;
    self.lastNameView.layer.shadowOffset = CGSizeMake(0, 0);
    self.lastNameView.layer.shadowRadius = 5;
    self.lastNameView.layer.shadowOpacity = 0.1;
    self.lastNameView.layer.zPosition=100;
    self.lastNameView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    
    self.firstNameField.delegate=self;
    self.lastNameField.delegate=self;
    self.emailField.delegate=self;
    self.passwordField.delegate=self;
    
    
}
- (IBAction)closePopup:(UIButton *)sender {
    
    NSLog(@"closing");
    if ([self.delegate respondsToSelector:@selector(SignUpView:closeTapped:)]) {
        [self.delegate SignUpView:self closeTapped:sender];
    }
    
}

- (IBAction)signUpAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(signUp:)]) {
        [self.delegate signUp:sender];
    }
    
}
- (IBAction)signInCalled:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(SignUpView:signInCalled:)]) {
        [self.delegate SignUpView:self signInCalled:sender];
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 1:
            
            self.passwordView.layer.shadowOpacity = 0.1;
            self.emailView.layer.shadowOpacity = 0.1;
            self.firstNameView.layer.shadowOpacity = 0.4;
            self.lastNameView.layer.shadowOpacity = 0.1;
            
            break;
        case 2:
            self.passwordView.layer.shadowOpacity = 0.1;
            self.emailView.layer.shadowOpacity = 0.1;
            self.firstNameView.layer.shadowOpacity = 0.1;
            self.lastNameView.layer.shadowOpacity = 0.4;

            break;
            
        case 3:
            self.passwordView.layer.shadowOpacity = 0.1;
            self.emailView.layer.shadowOpacity = 0.4;
            self.firstNameView.layer.shadowOpacity = 0.1;
            self.lastNameView.layer.shadowOpacity = 0.1;

            break;
        case 4:
            self.passwordView.layer.shadowOpacity = 0.4;
            self.emailView.layer.shadowOpacity = 0.1;
            self.firstNameView.layer.shadowOpacity = 0.1;
            self.lastNameView.layer.shadowOpacity = 0.1;

            break;
            
        default:
            break;
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}


@end
