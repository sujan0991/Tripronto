//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airports : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *shortCode;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic) int cityId;
@property (nonatomic) int airportId;

@property (strong,nonatomic) NSDate *arrivalDate;
@property (strong,nonatomic) NSDate *departureDate;
@end
