//
//  AppDelegate.h
//  ScriptTaker
//
//  Created by Dante on 10/20/13.
//
//

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
