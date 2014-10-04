//
//  DBMakeBookmarkScript.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 10/17/12.
//
//


//---------------------------------------------
#import "DBGetPathAndTextScript.h"
//---------------------------------------------
#import "DBAliasController.h"
#import "NoteTaker_AppDelegate.h"


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
