//
//  DBRemoveOutputScriptController.m
//  NoteTaker
//
//  Created by Dante on 10/20/13.
//
//

//---------------------------------------------
#import "DBPanelController.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"

@implementation DBPanelController


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];

  [myWindow setDelegate:self];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) closePanel{
  
  [myWindow orderOut:myWindow];
  [self resetPanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) resetPanel{

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openPanel
{
  
  [myWindow makeKeyAndOrderFront:myWindow];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)openWindow:(id)sender
{
  
  [self openPanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)closeWindow:(id)sender
{
  
  [self closePanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleWindow:(id)sender{
  
  if ([myWindow isVisible]){
    
    [self closePanel];
    
  } else {
    
    [self openPanel];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)windowDidResignKey:(NSNotification *)notification
{
  
  //NSLog(@"windowDidResignKey");
  [self closePanel];
  
}

@end