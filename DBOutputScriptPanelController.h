//
//  DBOutputScriptPanelController.h
//  NoteTaker
//
//  Created by Dante on 10/20/13.
//
//

#import <Cocoa/Cocoa.h>

#import "DBPanelController.h"

@interface DBOutputScriptPanelController : DBPanelController{
  
  IBOutlet NSPopUpButton * popUpButton;
  IBOutlet NSArrayController * remainingItems;
  
}

-(IBAction)changeRemainingItems:(id)sender;

@end
