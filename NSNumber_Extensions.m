//
//  NSNumber.m
//  NoteTaker
//
//  Created by Dante on 4/8/13.
//
//


//---------------------------------------------
#import "NSNumber_Extensions.h"
//---------------------------------------------


@implementation NSNumber (DBExtensions)



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSNumber *) increment
{

  return [NSNumber numberWithInteger: ([self integerValue] + 1)];

}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSNumber *) decrement
{
  
  return [NSNumber numberWithInteger: ([self integerValue] - 1)];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSNumber *) incrementBy:(NSInteger)value
{
  
  //NSLog(@"NSNumber extensions:");
  //NSLog(@"self: %@", self);
  //NSLog(@"add: %li", value);
  //NSLog(@"after addition: %@", [NSNumber numberWithInteger: ([self integerValue] + value)]);
  //self = [NSNumber numberWithInteger: ([self integerValue] + value)];
  return [NSNumber numberWithInteger: ([self integerValue] + value)];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSNumber *) decrementBy:(NSInteger)value
{
  
  return [NSNumber numberWithInteger: ([self integerValue] - value)];
  
}


@end
