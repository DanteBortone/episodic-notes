//
//  DBPathControlDelegate.m
//  NoteTaker
//
//  Created by Dante on 10/15/13.
//
//
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
