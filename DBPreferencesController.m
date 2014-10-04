//
//  DBPreferences.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/14/12.
//
//


//---------------------------------------------
#import "DBPreferencesController.h"
//---------------------------------------------
#import "NoteTaker_AppDelegate.h"

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
