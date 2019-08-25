//
//  ReadNWrite.h
//  test
//
//  Created by Amit on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadNWrite : NSObject {

}
+(void)writeToDucumentDirectory:(NSString*)arrayName :(NSMutableArray*)array;
+(NSMutableArray*)readFromDoucmentDirectory:(NSString*)fileName;

@end
