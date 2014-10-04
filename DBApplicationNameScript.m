//
//  DBApplicationName.m
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//


//---------------------------------------------
#import "DBApplicationNameScript.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"


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
