//
//  DBNavigationController.m
//  NoteTaker
//
//  Created by Dante on 7/20/13.
//
//

//---------------------------------------------
#import "DBNavigationController.h"
//---------------------------------------------
#import "NSButton_Extensions.h"

@implementation DBNavigationController

@synthesize folderTab, filesTab, recentTab, navTabView;
@synthesize fileTableHeader;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  [ super awakeFromNib ];
  [ self initializeActiveTab ];
  
  [fileTableHeader setStartingColor:
   [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]];
  [fileTableHeader setEndingColor:
   [NSColor colorWithCalibratedWhite:0.7 alpha:1.0]];
  [fileTableHeader setAngle:270];
  

  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)selectTab:(NSButton *)sender {
  NSString * title;
  
  title = [sender alternateTitle];
  
  [navTabView selectTabViewItemWithIdentifier: title];

  
  [folderTab setState:0];
  [filesTab setState:0];
  
  [sender setState:1];

  //[folderTab unmakeTextBold];
  //[filesTab unmakeTextBold];
  //[recentTab unmakeTextBold];
  
  [sender makeTextBold];
  [[NSUserDefaults standardUserDefaults] setObject: title
                                            forKey:@"activeTab"];
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) initializeActiveTab{
  NSString * activeTab;
  
  activeTab = [[NSUserDefaults standardUserDefaults] stringForKey:@"activeTab"];
    
  if ([activeTab isEqualToString:@"Folder"]) [self selectTab:folderTab];
  else if ([activeTab isEqualToString:@"Files"]) [self selectTab:filesTab];
  else if ([activeTab isEqualToString:@"Recent"]) [self selectTab:recentTab];
  
  else NSLog(@"appDelegate initializeActiveTab: unknown activeTab");
  
}


@end
