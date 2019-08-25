//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expert.h"


@interface Messages : NSObject

@property int messageId;
@property (nonatomic, strong) NSString *messageDetails;
@property (nonatomic, strong) Expert *user;
@property (strong,nonatomic) NSDate *modifiedDate;
@property (strong,nonatomic) NSMutableArray *comments;

@end
