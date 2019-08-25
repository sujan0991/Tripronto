//
//  ReadNWrite.m
//  test
//
//  Created by Amit on 4/27/11.
//  Copyright 2011 RiseUpLabs. All rights reserved.
//

#import "ReadNWrite.h"


@implementation ReadNWrite


+(void)writeToDucumentDirectory:(NSString*)arrayName :(NSMutableArray*)array{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:arrayName]; 
	[array writeToFile:dataFilePath atomically:YES];
    
}

+(NSMutableArray*)readFromDoucmentDirectory:(NSString*)fileName{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSMutableArray *peoplesList = [[NSMutableArray alloc] initWithContentsOfFile:dataFilePath];
    dataFilePath = nil;
	return peoplesList;
    
}

//- (void)dealloc {
//    [super dealloc];
//}


@end
