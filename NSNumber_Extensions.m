/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


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
