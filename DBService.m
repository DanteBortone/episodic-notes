//
//  DBService.m
//  NoteTaker
//
//  Created by Dante on 10/18/13.
//
//

#import "DBService.h"

#import "ScriptTaker_AppDelegate.h"


@implementation DBService


- (id)init{
  
  if (self = [super init]) {
    
    appDelegate = (ScriptTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    
  }
  
  return self;
  
}




- (void)makeNote:(NSPasteboard *)pboard
             userData:(NSString *)userData error:(NSString **)error {
  
  //NSLog(@"build 5 complete");
  
  [appDelegate activateScriptAnimation];
  
  NSString *scriptString =
  
  @"tell application \"System Events\"\n"
      "set _appName to short name of first process whose frontmost is true\n"
  "end tell\n"

  
  //"tell application \"Finder\"\n"
  //"display dialog \"hello\"\n"
  //"end tell\n"
  
  
  "tell application \"Episodic Notes\" to getApplicationName _appName";

  //"tell application \"NoteTaker\"\n"
    //    "getApplicationName _appName\n"
  //"end tell";

  
  
  NSAppleScript * appleScript = [[NSAppleScript alloc] initWithSource:scriptString];

  NSDictionary *errorDict;
  
  
  if ([appleScript compileAndReturnError:&errorDict]){
    
    [appleScript executeAndReturnError:&errorDict];
    
  }

  
  
}


@end
