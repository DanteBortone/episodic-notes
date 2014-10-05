/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBComboBoxDelegate.h"
//---------------------------------------------

#import "DBAddTopicController.h"

//---------------------------------------------


@implementation DBComboBoxDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {

  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  comboBox = addTopicController.topicListComboBox;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//these handle enabling/disabling the "add existing topic button"

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
  
  //NSLog(@"comboBoxSelectionDidChange");
   
  if ([comboBox objectValueOfSelectedItem]) {
  
    [addTopicController initExistingTopicItems];
  
  }

}




@end
