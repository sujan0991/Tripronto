//
//  PeopleStepper.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/8/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleStepper : UIView
{
    int counterValue;
    CGPoint labelOriginalCenter;
    CGFloat labelSlideLength;
    NSTimeInterval labelSlideDuration;
}

@property (strong,nonatomic) UIButton* leftButton;
@property (strong,nonatomic) UIButton* rightButton;
@property (strong,nonatomic) UILabel* counterLabel;


@end
