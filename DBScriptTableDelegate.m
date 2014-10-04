//
//  DBInputScriptTableDelegate.m
//  NoteTaker
//
//  Created by Dante on 10/8/13.
//
//
//---------------------------------------------
#import "DBScriptTableDelegate.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"


@implementation DBScriptTableDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {//this code isn't activated if it's not in the nib!!!!!!!!
  
  myTable.delegate = self; 
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  appleScriptController = appDelegate.appleScriptController;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    
  [appleScriptController selectionDidChangeForTable:myTable];

}


@end
