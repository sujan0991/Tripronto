//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateData : NSObject

@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic) int year;
@property (nonatomic) int month;
@property (nonatomic) int day;



-(NSMutableDictionary *) toNSDictionary;

@end
