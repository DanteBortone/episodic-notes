/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBGetPathTextOutputClipboardForTitle.h"
//---------------------------------------------

#import "DBDetailController.h"
#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


@implementation DBGetPathTextOutputClipboardForTitle


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(id)performDefaultImplementation {
  
  //NSLog(@"running DBGetPathTextOutputClipboardForTitle");
  
  NoteTaker_AppDelegate *appDelegate;
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  //Get values from applescript
  NSDictionary *args = [self evaluatedArguments];
  
  NSString *filePath = @"";
  NSString *copiedText = @"";
  NSString *outputValue = @"";
  BOOL hasImageOnClipBoard = NO;
  NSString *detailTitle = @"";

  //NSLog(@"args: %@",[args description]);
  
  if(args.count) {
    
    filePath = [args valueForKey:@""];    // get the direct argument
    if([args valueForKey:@"CopiedText"]) copiedText = [args valueForKey:@"CopiedText"];
    if([args valueForKey:@"OutputValue"]) outputValue = [args valueForKey:@"OutputValue"];
    if([args valueForKey:@"Clipboard"]) hasImageOnClipBoard = [[args objectForKey:@"Clipboard"] boolValue];//__NSCFBoolean private NSNumber class
    if([args valueForKey:@"Title"]) detailTitle = [args valueForKey:@"Title"];
    
    

    
    //NSLog(@"raw filePath: %@", filePath);
    //NSLog(@"copiedText: %@", copiedText);
    //NSLog(@"outputValue: %@", outputValue);
    //NSLog(@"clipboard: %@", clipboard ? @"YES" : @"NO");
    //NSLog(@"title: %@", detailTitle);

  }

  



  //pass on info to detail controller
  [appDelegate.detailController newDetailWithPath: filePath
                                             note: copiedText
                                      outputValue: outputValue
                                 imageOnClipboard: hasImageOnClipBoard
                                         entitled: detailTitle ];
  
  return nil;
  
}

@end
