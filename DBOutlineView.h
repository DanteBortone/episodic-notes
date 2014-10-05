/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class DBOutlineViewDelegate;
@class DBControllerOfOutlineViews;
@class DBTopicObject;
@class NoteTaker_AppDelegate;
@class DBOutlineViewController;

//---------------------------------------------


@interface DBOutlineView : NSOutlineView {

  NoteTaker_AppDelegate *appDelegate; //for subclasses to access activeTree
  DBControllerOfOutlineViews * controllerOfOutlineViews;
  
}

@property (strong) DBOutlineViewController * controller;  //the controllers will assign this at awakeFromNIB
@property (retain) DBOutlineViewDelegate * myDelegate;
//@property (strong) IBOutlet NSTextField * header;
//@property (strong) DBTopicObject * viewTopic;
@property BOOL animatesToStartingPositionsOnCancelOrFail;

- (NSTableColumn *) columnWithIndex:(NSInteger)index;
- (BOOL)becomeFirstResponder;
- (void)reloadDataAndReselect;
- (id)tableCellViewFromEvent:(NSEvent *) theEvent;
- (void)copy:(id)sender;
- (void)cut:(id)sender;
- (void)paste:(id)sender;

@end