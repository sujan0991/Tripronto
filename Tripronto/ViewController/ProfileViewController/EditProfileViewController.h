//
//  EditProfileViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 5/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{

  

}


@property (weak, nonatomic) IBOutlet UITableView *editProfileTableView;

@property  int selectedButton;
@end
