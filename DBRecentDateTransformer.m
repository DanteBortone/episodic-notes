/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBRecentDateTransformer.h"
//---------------------------------------------

#import "NSDate_Extensions.h"

//---------------------------------------------


@implementation DBRecentDateTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (Class)transformedValueClass
{
  
  return [NSString class];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return NO;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{
  NSDate *thisDate = value;
  
  NSDateFormatter *dateFormat;
  dateFormat = [[NSDateFormatter alloc] init];
  
  NSString * returnString;
  
  if ([thisDate isToday]) {
    
    [dateFormat setDateFormat:@"h:mm a"];
    
    returnString = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:thisDate]];

  //} else if ([thisDate isSameYearAsDate:[NSDate date]]){
    
    //[dateFormat setDateFormat:@"M/d"];
  
  } else {
    
    [dateFormat setDateFormat:@"M/d/yy"];
    
    returnString = [dateFormat stringFromDate:thisDate];
    
  }

  return returnString;

}

@end
