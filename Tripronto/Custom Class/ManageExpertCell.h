//
//  IteneraryCommentCell.h
//  Tripronto
//
//  Created by Tanvir Palash on 4/20/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageExpertCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *expertName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *expertPic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkButtonFixedWidth;

@end
