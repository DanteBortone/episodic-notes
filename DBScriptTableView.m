//
//  DBScriptTableView.m
//  NoteTaker
//
//  Created by Dante on 10/9/13.
//
//


//---------------------------------------------
#import "DBScriptTableView.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"

@implementation DBScriptTableView

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)awakeFromNib
{
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  appleScriptController = appDelegate.appleScriptController;
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(BOOL) becomeFirstResponder {
  
  [appleScriptController selectionDidChangeForTable:self];
  
  return [super becomeFirstResponder];
  
}

@end
