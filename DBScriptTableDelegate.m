/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBScriptTableDelegate.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"

//---------------------------------------------


@implementation DBScriptTableDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {//this code isn't activated if it's not in the nib!!!!!!!!
  
  myTable.delegate = self; 
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  appleScriptController = appDelegate.appleScriptController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    
  [appleScriptController selectionDidChangeForTable:myTable];

}


@end
