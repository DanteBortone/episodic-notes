/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBPreferencesController.h"
//---------------------------------------------

#import "NoteTaker_AppDelegate.h"

//---------------------------------------------


@implementation DBPreferencesController

@synthesize detailTableLayout, relatedTableLayout;



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  //NSLog(@"DBPreferencesController awakeFromNib");

  [ super awakeFromNib ];
  
  if (appDelegate.firstTimeRunningApplication) {
    [ self setupDefaultTableLayouts ];    
  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) setupDefaultTableLayouts{
  
  //NSLog(@"DBPreferencesController setupDefaultTableLayouts");
  
  NSArray * columns = [detailTableLayout tableColumns];
  
  NSString * identifier;
  
  for (NSTableColumn * column in columns){
    identifier = column.identifier;
    
    if ([identifier isEqualToString:@"Created"] || [identifier isEqualToString:@"Modified"] || [identifier isEqualToString:@"Associated"]) {
      
      [column setHidden:YES];
      
    } else {
      
      [column setHidden:NO];

    }
    
  }
  
  columns = [relatedTableLayout tableColumns];
  
  for (NSTableColumn * column in columns){
      
    [column setHidden:NO];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)toggleWindow:(id)sender{
  
  if ([myWindow isVisible]){
    
    [myWindow orderOut:myWindow];
    
  } else {
    
    [myWindow makeKeyAndOrderFront:myWindow];
    
  }
  
  
}


-(IBAction)resetHelpTips:(id)sender
{
  
  NSNumber * resetValue = [NSNumber numberWithBool:NO];
  
  [[ NSUserDefaults standardUserDefaults] setValue:resetValue forKey:@"hideAllTipButtons" ];
  [[ NSUserDefaults standardUserDefaults] setValue:resetValue forKey:@"hideMainTopicWikiWordTip" ];
  [[ NSUserDefaults standardUserDefaults] setValue:resetValue forKey:@"hideTemplatesTip" ];
  [[ NSUserDefaults standardUserDefaults] setValue:resetValue forKey:@"hideInsertOptonsTip" ];

}

@end
