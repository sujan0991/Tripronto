//
//  SettingsViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 5/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end
