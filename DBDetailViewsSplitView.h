/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import <Cocoa/Cocoa.h>
//---------------------------------------------

@class NoteTaker_AppDelegate;
@class DBControllerOfOutlineViews;

//---------------------------------------------


@interface DBDetailViewsSplitView : NSSplitView <NSSplitViewDelegate>{

  NoteTaker_AppDelegate *appDelegate; //to change size of main window to accomdate more views
  DBControllerOfOutlineViews * controllerOfOutlineViews;
} 

@property BOOL makingRoomForDetailViews; //to make sure navigation view doesn't gank the space made for the detail views
@property BOOL gotBigger;


-(BOOL) shouldAdjustMySize;
-(CGFloat) myMinimumViewSize;

@end
