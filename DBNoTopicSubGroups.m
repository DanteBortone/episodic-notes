/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBNoTopicSubGroups.h"
//---------------------------------------------

#import "DBSubTopic.h"
#import "DBMainTopic.h"

//---------------------------------------------


@implementation DBNoTopicSubGroups


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
  
  return [NSNumber class];
  
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
    
  if ([value isKindOfClass:[DBSubTopic class]]) {
  
    return [NSNumber numberWithBool:NO];
  
  } else {
    
    DBMainTopic * mainTopic = value;
    
    if (mainTopic.subTopics.count > 0) {
      
      return [NSNumber numberWithBool:NO];
    
    } else {
    
      return [NSNumber numberWithBool:YES];
    
    }
    
  }
  
}


@end
