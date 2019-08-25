//
//  OfferByCityCollectionViewCell.m
//  Tripronto
//
//  Created by Sujan on 11/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "OfferByCityCollectionViewCell.h"

@implementation OfferByCityCollectionViewCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutIfNeeded];
    
        self.expertProPicture.layer.cornerRadius = self.expertProPicture.frame.size.width / 2;
        self.expertProPicture.clipsToBounds = YES;
        self.expertProPicture.layer.borderWidth = 1.0;
        self.expertProPicture.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
//        UIView *shadowView = [[UIView alloc] init];
//        shadowView.backgroundColor = [UIColor clearColor];
//        shadowView.frame = self.guideProPicture.bounds;
//        shadowView.layer.masksToBounds = NO;
//        shadowView.layer.shadowOffset = CGSizeMake(0, 0);
//        shadowView.layer.shadowRadius = 3;
//        shadowView.layer.shadowOpacity = 0.3;
//    
//        [self.contentView addSubview:shadowView];
}

@end
