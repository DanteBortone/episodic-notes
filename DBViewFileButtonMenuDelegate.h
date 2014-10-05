/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
*/


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBDetailViewController;
@class NoteTaker_AppDelegate;
@class DBAliasController;
//---------------------------------------------

//not inheriting from filebuttonmenu because this one needs to load from init and don't want to mess up the orginal while I'm working around
//changes:
  //  columnsMenu, detailviewController and myButton are visible properties
  //  new init

@interface DBViewFileButtonMenuDelegate : NSViewController<NSMenuDelegate> {
  
  NoteTaker_AppDelegate * appDelegate;
  DBAliasController * aliasController;
  
  //IBOutlet DBDetailViewController *detailViewController;
  
  NSMutableArray *fullPathComponents;  
  
}

//SLOPPY.  make this prety if it works.
@property (strong) DBViewFileButtonMenuDelegate *menuDelegate; //this is needed to keep it from being dropped
@property (strong) DBDetailViewController *detailViewController;
@property (strong) NSMenu *columnsMenu;
//@property (strong) NSButton *myButton;

- (void)openURL:(id)sender;


@end