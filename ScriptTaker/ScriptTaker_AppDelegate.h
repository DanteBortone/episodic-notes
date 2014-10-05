/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */

#import <Cocoa/Cocoa.h>

//  this appDelegate runs a helper app that handles the service response
  //  without making the main app active
  //  doesn't need xpcservice set-up because it's purpose is to run the applescript

//should put up a visual display when it's on
//should show visual display of when the service is called

@interface ScriptTaker_AppDelegate : NSObject <NSApplicationDelegate>{

  NSStatusItem *statusItem;
  
}


-(void) activateScriptAnimation;

@end
