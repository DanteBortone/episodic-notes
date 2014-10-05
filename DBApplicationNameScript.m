/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBApplicationNameScript.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"

//---------------------------------------------


@implementation DBApplicationNameScript


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(id)performDefaultImplementation {
  
  NoteTaker_AppDelegate *appDelegate;
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  //Get values from applescript
  NSDictionary *args = [self evaluatedArguments];
  NSString *applicationName = @"";
  
  if(args.count) {
    applicationName = [args valueForKey:@""];    // get the direct argument
    
    [appDelegate.appleScriptController runInputScriptForApplicationNamed:(NSString*) applicationName];
    //NSLog(@"performDefaultImplementation: %@", applicationName);

  } else {
    // raise error
    [self setScriptErrorNumber:-50];
    [self setScriptErrorString:@"Parameter Error: An application name is expected."];
  }
  
  return nil;
  
}

@end
