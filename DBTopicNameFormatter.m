/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTopicNameFormatter.h"
//---------------------------------------------

#import "DBAddTopicController.h"
#import "DBDetailController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSCharacterSet_Extensions.h"

//---------------------------------------------


@implementation DBTopicNameFormatter


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  prohibitedCharacters = [[NSCharacterSet topicNameCharacterSet] invertedSet];
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  detailController = appDelegate.detailController;
  
  //[super awakeFromNib]; //overwrites prohibited characters
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

  [addTopicController validateMainTopicName: partialString];

}



@end
