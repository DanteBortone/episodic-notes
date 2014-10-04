//
//  NSMutableArray_Extensions.h
//  NoteTaker
//
//  Created by Dante on 9/25/13.
//
//

#import <Cocoa/Cocoa.h>

@interface NSMutableArray (DBExtensions)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)moveObject:(id)object toIndex:(NSUInteger)toIndex;

@end
