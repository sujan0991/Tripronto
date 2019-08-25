//
//  EditProfileTableViewCell.m
//  Tripronto
//
//  Created by Sujan on 10/2/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "EditProfileTableViewCell.h"

@implementation EditProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
//    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//    [datePicker setDate:[NSDate date]];
//    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
//    [self.editInfoTextField setInputView:datePicker];
//    
//    
//    
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//    [self.editInfoTextField resignFirstResponder];
//    
//    return YES;
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    [self.editInfoTextField resignFirstResponder];
//
//    
//}

@end
