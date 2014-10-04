//
//  NSArray_Extensions.m
//  SortedTree
//
//  Created by Jonathan Dann on 14/05/2008.
//
// Copyright (c) 2008 Jonathan Dann
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "Sorted Tree" by Jonathan Dann" will do.


//---------------------------------------------
#import "NSArray_Extensions.h"
//---------------------------------------------


@implementation NSArray (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)firstObject
{
	if ([self count] == 0)
		return nil;
  
	return [self objectAtIndex:0];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)listStrings {
  
  NSMutableString *returnString = nil;
  [returnString setString: @"" ];
  
  if (self.count > 0) {
    returnString = [NSMutableString stringWithString:[self objectAtIndex:0]];
    for (int i = 1; i < [self count]; i++){
      [returnString appendString:[NSString stringWithFormat:@"\r%@", [self objectAtIndex:i]]];
    }
  }
  
  return returnString;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//  provides every index of object in array below a given index
//  does not check index at maxIndex
- (NSArray *) indexesOfObject:(id)object below:(NSInteger) maxIndex{
  
  NSMutableArray * array = [NSMutableArray array];

  if (self.count<1) {
    return NULL;
  }
  
  if (maxIndex > self.count) maxIndex = self.count;
  
  for (int i=0; i < maxIndex; i+=1) {

    if ([ self objectAtIndex:i ] == object ) {

      [ array addObject:[NSNumber numberWithInt:i] ];
    }
  }
  
  
  // report values
  /*
  NSNumber * number;
  for (int j=0; j< array.count; j+=1) {
    number = [array objectAtIndex:j];
    NSLog(@"%li", [number integerValue]);
  }
  */
  return [NSArray arrayWithArray:array];

}



@end
