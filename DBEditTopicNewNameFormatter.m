/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBEditTopicNewNameFormatter.h"
//---------------------------------------------

#import "DBDetailController.h"
#import "DBEditTopicController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSCharacterSet_Extensions.h"

//---------------------------------------------


@implementation DBEditTopicNewNameFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib
{
  
  prohibitedCharacters = [[NSCharacterSet topicNameCharacterSet] invertedSet];
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailController = appDelegate.detailController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)takeActionOnNewLineCharacter{
  
  NSLog(@"newline character detected");
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) takeActionWithPartialString:(NSString*)partialString
{
  
   // initialize the add topic panel based on the partial string
   //want to tell if
        //  it's the same name
        //  it already exists as a topic
        //  it is empty.
  //  how about validateNewName method for editnewnamecontroller?
  
  [ editTopicController validateNewName: partialString ];  //returned boolean unused
  
}
@end
