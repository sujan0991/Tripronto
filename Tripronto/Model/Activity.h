//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *featuredImage;

@property (nonatomic, strong) NSString *isFav;
@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *isPopular;
@property (nonatomic, strong) NSString *isFeatured;

@property (nonatomic, strong) NSString *activityDescription;
@property (nonatomic, strong) NSString *categoryName;


@end
