//
//  DBFixedCodeTextviewDelegate.m
//  NoteTaker
//
//  Created by Dante on 10/15/13.
//
//
//---------------------------------------------
#import "DBFixedCodeTextviewDelegate.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"

@implementation DBFixedCodeTextviewDelegate



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib {
  
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  applescriptController= appDelegate.appleScriptController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) textDidChange:(NSNotification *)notification
{
  
  [applescriptController updateFixedCodeTestScript];
  
}


@end
