//
//  NSCharacterSet_Extensions.h
//  NoteTaker
//
//  Created by Dante on 3/1/13.
//
//


#import <Cocoa/Cocoa.h>


@interface NSCharacterSet (DBExtensions)

+ (NSCharacterSet *) wikiCharacterSet;
+ (NSCharacterSet *) topicNameCharacterSet;
+ (NSCharacterSet *) endEditingCharacterSet;

@end
