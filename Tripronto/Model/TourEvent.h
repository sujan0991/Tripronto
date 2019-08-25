//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TourEvent : NSObject

@property  int eventId;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (nonatomic, strong) NSString *tourOperatorName;
@property (nonatomic, strong) NSString *tourTitle;
@property (nonatomic, strong) NSString* tourDescription;
@property (nonatomic, strong) NSString *tourConfirmationNumber;


@end
