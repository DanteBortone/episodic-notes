//
//  DBPreferences.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/14/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


#import "DBObjectController.h"


@interface DBPreferencesController : DBObjectController {

  //NoteTaker_AppDelegate * appDelegate;

  IBOutlet NSTextField *folderBaseField;
  IBOutlet NSTextField *topicDetailBaseField;
  
  
  IBOutlet NSWindow * myWindow;

}

@property (strong) IBOutlet NSTableView * detailTableLayout;
@property (strong) IBOutlet NSTableView * relatedTableLayout;


- (IBAction) toggleWindow:(id)sender;
- (IBAction) resetHelpTips:(id)sender;

@end


