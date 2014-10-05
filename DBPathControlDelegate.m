/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBPathControlDelegate.h"
//---------------------------------------------


@implementation DBPathControlDelegate 

/*
- (void)pathControl:(NSPathControl *)pathControl willPopUpMenu:(NSMenu *)menu {
  // We don't want to show the useless "parent folders" menu items, as they are very confusing.
  while ([[menu itemArray] count] >= 4) {
    [menu removeItemAtIndex:3];
  }
}
*/

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)pathControl:(NSPathControl *)pathControl willDisplayOpenPanel:(NSOpenPanel *)openPanel
{
  
  [openPanel setDelegate:self];
  [openPanel setCanChooseDirectories:YES];
  [openPanel setCanCreateDirectories:YES];
  [openPanel setCanChooseFiles:YES];
  [openPanel setPrompt:@"Choose"];
  
}



@end
