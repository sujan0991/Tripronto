//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SummaryDestination : NSObject

@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) NSString *airlinePreferenceString;
@property (nonatomic, strong) NSString *datePreferenceString;
@property (nonatomic, strong) NSString *accommodationPreferenceString;
@property (nonatomic, strong) NSString *activityPreferenceString;


-(NSMutableDictionary *) toNSDictionary;

@end
