//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Destination : NSObject

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *featuredImage;

@property (nonatomic, strong) NSString *cityDescription;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSArray *media;


@end
