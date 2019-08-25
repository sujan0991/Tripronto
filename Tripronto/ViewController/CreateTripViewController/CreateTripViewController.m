//
//  CreateTripViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/6/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "CreateTripViewController.h"
#import "Trip.h"

@interface CreateTripViewController ()

@end

@implementation CreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view layoutIfNeeded];
    
    self.stepView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    [self setCornerRadius];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.containerView.parallaxView.delegate = self;
    
    
    

    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.step1View.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
       // NSLog(@"contentRect %lf",contentRect.size.height);
    }
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:@"Plan a new trip"];
    
    [[self.containerView.parallaxView backButton] addTarget:self
                                                     action:@selector(backButtonAction)
                                           forControlEvents:UIControlEventTouchUpInside];
    
    
    //NSLog(@"containerView %@",self.containerView);

    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    

    
}

-(void)backButtonAction
{
    //NSLog(@"backClicked");
    [self.navigationController popViewControllerAnimated:YES];

}

//-(void) viewDidLayoutSubviews
//{
//
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in self.containerView.subviews) {
//        
//        contentRect = CGRectUnion(contentRect, view.frame);
//        NSLog(@"contentRect %lf",contentRect.size.height);
//    }
//    
//    self.containerView.contentSize=contentRect.size;
//
//}

-(void) setCornerRadius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.stepNumberView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.stepNumberView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.stepNumberView.layer.mask = maskLayer;
}



- (IBAction)buttonPress:(UIButton *)sender
{
    sender.selected=!sender.selected;
}


#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
//    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
   // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"destination"]) {
//        PeopleSelectorViewController* userViewController = [segue destinationViewController];
//        userViewController.tripTypeId = @"1";
        
        [Trip sharedManager].trip_type_id=1;
    }
    else if ([[segue identifier] isEqualToString:@"activity"]) {
        [Trip sharedManager].trip_type_id=2;
    }
    else if ([[segue identifier] isEqualToString:@"knowNothing"]) {
        [Trip sharedManager].trip_type_id=3;
    }
    
//    NSMutableArray *xtra = [[NSMutableArray alloc] init];
//    NSMutableArray *appointmentList = [[NSMutableArray alloc] init];
//    appointmentList= [ReadNWrite readFromDoucmentDirectory:@"Appointment.plist"];
//    
//    NSLog(@"appointmentList %lu",(unsigned long)appointmentList.count);
//    
//    NSMutableDictionary *appointmentData= [[NSMutableDictionary alloc] init];
//    [appointmentData setValue:[NSString stringWithFormat:@"%lu",appointmentList.count] forKey:@"id"];
//    [appointmentData setValue:self.descriptionTextViewforApp.text forKey:@"description"];
//    [appointmentData setValue:self.appointmentPicker.date forKey:@"appointmentDate"];
//    NSLog(@"appointmentData %@",appointmentData);
//    
//    if(appointmentList.count==0)
//    {
//        [xtra addObject:appointmentData];
//        
//        NSLog(@"xtra %@",xtra);
//        [ReadNWrite writeToDucumentDirectory:@"Appointment.plist" :xtra];
//        
//    }else
//    {
//        [appointmentList addObject:appointmentData];
//        
//        NSLog(@"appointmentList %@",appointmentList);
//        [ReadNWrite writeToDucumentDirectory:@"Appointment.plist" :appointmentList];
//    }

}


@end
