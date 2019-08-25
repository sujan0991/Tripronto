//
//  OfferViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tripronto-Swift.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface OfferViewController : UIViewController<TGLParallaxCarouselDelegate, TGLParallaxCarouselDatasource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak,nonatomic) IBOutlet TGLParallaxCarousel* carouselView;

@property (weak, nonatomic) IBOutlet UICollectionView *destinationCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *offers;

@property (nonatomic, strong) NSMutableArray *citysArray;

@property (nonatomic, strong) NSString *cityId;

@end
