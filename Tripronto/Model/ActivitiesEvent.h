//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitiesEvent : NSObject

@property  int eventId;
@property (nonatomic, strong) NSString *eventTitle;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (strong,nonatomic) NSDate *startTime;
@property (strong,nonatomic) NSDate *endTime;
@property (nonatomic, strong) NSString *durationUnit;
@property  int durationAmount;

@property (nonatomic, strong) NSString *activityTitle;
@property (nonatomic, strong) NSString *featuredImage;
@property (nonatomic, strong) NSString *activityDescription;

@property BOOL isFeatured;
@property BOOL isHome;


@end
