//
//  IteneraryCommentCell.h
//  Tripronto
//
//  Created by Tanvir Palash on 4/20/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTripCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (weak, nonatomic) IBOutlet UILabel *tripTitle;

@property (weak, nonatomic) IBOutlet UILabel *tripCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *submittedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
