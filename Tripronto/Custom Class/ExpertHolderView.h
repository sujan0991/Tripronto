//
//  ExpertHolderView.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/3/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertHolderView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *expertName;
@property (weak, nonatomic) IBOutlet UIImageView *expertPic;

@property (weak, nonatomic) IBOutlet UILabel *relevancyValue;
@property (weak, nonatomic) IBOutlet UILabel *feedbackValue;

@property (weak, nonatomic) IBOutlet UILabel *oneLinerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *industryLogo;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;


@property (weak, nonatomic) IBOutlet UIButton *selectExpertButton;


@end
