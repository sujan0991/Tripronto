//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expert : NSObject

@property (nonatomic) int expertId;
@property (nonatomic) int userId;
@property (nonatomic) int itineraryNumber;

@property (nonatomic, strong) NSString *expertName;
@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *relevancy;
@property (nonatomic, strong) NSString *feedback;

@property (nonatomic, strong) NSString *oneLiner;
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, strong) NSString *affiliationLogo;

@property (nonatomic, strong) NSString *agencyName;
@property (nonatomic, strong) NSString *biography;

@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *cities;


- (NSMutableDictionary *)toNSDictionary;

@end
