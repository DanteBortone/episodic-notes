//
//  NSNumber.h
//  NoteTaker
//
//  Created by Dante on 4/8/13.
//
//


#import <Cocoa/Cocoa.h>


@interface NSNumber (DBExtensions)

- (NSNumber *) increment;
- (NSNumber *) decrement;
- (NSNumber *) incrementBy:(NSInteger)value;
- (NSNumber *) decrementBy:(NSInteger)value;


@end
