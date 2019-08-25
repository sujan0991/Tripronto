//
//  SignInView.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "SignInView.h"

@implementation SignInView

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
        [[NSBundle mainBundle] loadNibNamed:@"SignInView" owner:self options:nil];
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
    
    self.emailField.delegate=self;
    self.passwordField.delegate=self;
    
}
- (IBAction)closePopup:(UIButton *)sender {
    

    if ([self.delegate respondsToSelector:@selector(signinview:closeTapped:)]) {
        [self.delegate signinview:self closeTapped:sender];
    }

}
- (IBAction)signUpCalled:(UIButton*)sender {
  
    if ([self.delegate respondsToSelector:@selector(signinview:signUpCalled:)]) {
        [self.delegate signinview:self signUpCalled:sender];
    }
    

    
}
- (IBAction)loginAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(login:)]) {
        [self.delegate login:sender];
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 1:
            self.passwordView.layer.shadowOpacity = 0.1;
            self.emailView.layer.shadowOpacity = 0.4;
            break;
        case 2:
            self.emailView.layer.shadowOpacity = 0.1;
            self.passwordView.layer.shadowOpacity = 0.4;
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
