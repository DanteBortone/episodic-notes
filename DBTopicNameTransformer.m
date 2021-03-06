/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTopicNameTransformer.h"
//---------------------------------------------

#import "DBSubTopic.h"
#import "DBMainTopic.h"

//---------------------------------------------


@implementation DBTopicNameTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

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
  
  if ([value isKindOfClass:[DBMainTopic class]]) {

    DBMainTopic * mainTopic = value;
    
    return [NSString stringWithFormat:@"%@", mainTopic.displayName];
    
  } else {
    
    DBSubTopic * subTopic = value;
    
    return [NSString stringWithFormat:@"%@ : %@", subTopic.mainTopic.displayName, subTopic.displayName];


  }
  
}

@end
