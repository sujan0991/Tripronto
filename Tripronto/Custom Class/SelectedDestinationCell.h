//
//  SelectedDestinationCell.h
//  Tripronto
//
//  Created by Tanvir Palash on 5/16/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedDestinationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
