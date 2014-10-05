/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTopicNavComboBox.h"
//---------------------------------------------

#import "DBNamedTopic.h"
#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"

//---------------------------------------------


@implementation DBTopicNavComboBox


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  [self setDelegate:self];
  [self setTarget:self];
  [self setAction:@selector(returnEntered:)];
  //[self setDataSource:self];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void)comboBoxWillDismiss:(NSNotification *)notification{

  //NSLog(@"comboBoxWillDismiss");
  
  [self tryLoadingTopic];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)returnEntered:(id)sender{
  
  //NSLog(@"returnEntered");

  [self tryLoadingTopic];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) tryLoadingTopic{
  
  //NSLog(@"tryLoadingTopic");

  
  
  NSInteger index = [self indexOfSelectedItem];
  
  if (index > -1) {
    
    DBNamedTopic *topic = [[myArrayController arrangedObjects] objectAtIndex:index];
    //NSLog(@"foundtopic: %@", topic.displayName);
    
    [appDelegate.controllerOfOutlineViews.activeDetailOutlineViewController.mainDetailViewController assignTopic:topic];
    
  }
  
}


@end
