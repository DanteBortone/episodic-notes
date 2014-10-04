//
//  DBPathControl.m
//  NoteTaker
//
//  Created by Dante on 10/15/13.
//
//


//---------------------------------------------
#import "DBPathControl.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"
#import "DBOutputScript.h"


@implementation DBPathControl

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  applescriptController= appDelegate.appleScriptController;
  
}


/*
-(void)mouseDown:(NSEvent *)theEvent{
  
  NSLog(@"Before Choose is selected...");
  
  [super mouseDown:theEvent];
  
  NSLog(@"After Choose is selected...");

  [applescriptController updateFixedCodeTestScript];
  
}
*/

@end
