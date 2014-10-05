/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBHeaderOrganizer.h"
//---------------------------------------------

#import "DBTopicObject.h"
#import "DBSubTopic.h"

//---------------------------------------------


@implementation DBHeaderOrganizer

// Attributes -------------
@dynamic topic;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setSortIndex:(NSNumber *)sortIndex
{
  
  [self willChangeValueForKey:@"sortIndex"];
  [self setPrimitiveValue:sortIndex forKey:@"sortIndex"];
  [self didChangeValueForKey:@"sortIndex"];
  
  if (! self.topic.isGlobal){
    
    DBSubTopic * topic = (DBSubTopic*)self.topic;
    
    topic.sortIndex = sortIndex;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// this is called by local topics to update the headers
// need a seperate function so it doesn't make a loop

- (void) primativeSetSortIndex:(NSNumber *)sortIndex
{
  
  [self willChangeValueForKey:@"sortIndex"];
  [self setPrimitiveValue:sortIndex forKey:@"sortIndex"];
  [self didChangeValueForKey:@"sortIndex"];

}

@end
