//
//  LoaderViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 11/19/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

#import "Constants.h"

@interface LoaderViewController : UIViewController


@property (strong,nonatomic) IBOutlet UIImageView *animationImageView;

@property (strong,nonatomic) NSMutableArray *images;

@property (strong,nonatomic) NSMutableArray* imageUrls;


@end
