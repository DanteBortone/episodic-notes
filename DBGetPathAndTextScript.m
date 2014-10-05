/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBGetPathAndTextScript.h"
//---------------------------------------------

#import "DBAliasController.h"
#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


@implementation DBGetPathAndTextScript


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(id)performDefaultImplementation {
  
  NoteTaker_AppDelegate *appDelegate;
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //Get values from applescript
  NSDictionary *args = [self evaluatedArguments];
  NSString *filePath = @"";
  NSString *selectedText = NULL;

  if(args.count) {
    filePath = [args valueForKey:@""];    // get the direct argument
    if([args valueForKey:@"CopiedText"]) selectedText = [args valueForKey:@"CopiedText"];
  } else {
    // raise error
    [self setScriptErrorNumber:-50];
    [self setScriptErrorString:@"Parameter Error: A filePath parameter is expected."];
  }
  
  //pass on path and text to make link and detail

  //[appDelegate.aliasController makeLinkAndDetail:filePath withNote:selectedText];
  
  
  
  //NSLog(@"DBGetPathAndTextScript filePath: %@", filePath);
  return nil;

}

@end
