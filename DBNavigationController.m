/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBNavigationController.h"
//---------------------------------------------

#import "NSButton_Extensions.h"

//---------------------------------------------


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
  [recentTab setState:0];
  
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
