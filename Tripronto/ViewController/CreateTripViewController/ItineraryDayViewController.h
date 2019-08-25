//
//  ItineraryViewController.h
//  ItineraryDemo
//
//  Created by Tanvir Palash on 7/24/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tripronto-Swift.h"


@interface ItineraryDayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *dayEvents;

@property (weak, nonatomic) IBOutlet UILabel *navTitleText;
@property (weak, nonatomic)  UITableView *itineraryTableView;


@end
