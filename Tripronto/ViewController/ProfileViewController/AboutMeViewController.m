//
//  AboutMeViewController.m
//  Tripronto
//
//  Created by Sujan on 10/3/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.aboutMeTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonAction:(id)sender {
    
    
    

    [[NSNotificationCenter defaultCenter]postNotificationName:@"AboutMe" object:self.aboutMeTextView.text];

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.aboutMeTextView resignFirstResponder];

}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//
//}


@end
