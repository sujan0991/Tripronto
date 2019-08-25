//
//  TabBarViewController.h
//  Gloria_Jeans
//
//  Created by User on 8/24/14.
//  Copyright (c) 2014 mobioApp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "TutorialViewController.h"
#import "LoaderViewController.h"
#import "EditProfileViewController.h"

#import "AFNetworking.h"


@interface TabBarViewController : UITabBarController<UITabBarControllerDelegate,UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@end
