//
//  OfferByCityViewController.h
//  Tripronto
//
//  Created by Sujan on 11/14/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface OfferByCityViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


//

@property (weak, nonatomic) IBOutlet UICollectionView *offerByCityCollectionView;

@property (strong,nonatomic) NSString * cityId;
@property (weak, nonatomic) IBOutlet UILabel *nevTitle;
@property (strong,nonatomic) NSString * cityName;

@end
