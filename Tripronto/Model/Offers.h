//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offers : NSObject

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *offerTitle;
@property (nonatomic, strong) NSString *expertId;
@property (nonatomic, strong) NSString *expertImage;

@property (nonatomic, strong) NSString *featuredImage;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *offerDetails;
@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *noOfPassengers;
@property (nonatomic, strong) NSString *isFeatured;
@property (nonatomic, strong) NSString *flightClasses;
@property (nonatomic, strong) NSString *noOfDays;

@end
