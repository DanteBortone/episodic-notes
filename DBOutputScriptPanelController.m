//
//  DBOutputScriptPanelController.m
//  NoteTaker
//
//  Created by Dante on 10/20/13.
//
//

//---------------------------------------------
#import "DBOutputScriptPanelController.h"
//---------------------------------------------
#import "DBOutputScript.h"
#import "DBDetail.h"
#import "NoteTaker_AppDelegate.h"
#import "DBApplescriptController.h"

@implementation DBOutputScriptPanelController



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(IBAction)changeRemainingItems:(id)sender{
  
  //NSLog(@"change remaing items");
  
  NSArray * array = [remainingItems arrangedObjects];

  DBOutputScript * selectedScript = [[popUpButton selectedItem] representedObject];
  
  for (DBDetail * item in array) {
    
    [item setOutputScript:selectedScript];
  
  }
  
  [super closeWindow:sender];

  [appDelegate.appleScriptController removeOutputScript:sender];
  
}


@end
