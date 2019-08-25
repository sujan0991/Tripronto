//
//  OfferByCityCollectionViewCell.h
//  Tripronto
//
//  Created by Sujan on 11/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferByCityCollectionViewCell : UICollectionViewCell




@property (weak, nonatomic) IBOutlet UIImageView *cityFeaturedImage;
@property (weak, nonatomic) IBOutlet UIImageView *expertProPicture;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;

@end
