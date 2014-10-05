/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBViewFileButtonMenuDelegate.h"
//---------------------------------------------

#import "DBDetailViewController.h"
#import "DBViewObject.h"
#import "DBTopicObject.h"
#import "DBFileTopic.h"
#import "DBAliasController.h"
#import "NoteTaker_AppDelegate.h"
#import "NSArray_Extensions.h"
#import "DBTextFormats.h"

//---------------------------------------------


@implementation DBViewFileButtonMenuDelegate

//@synthesize myButton;
@synthesize columnsMenu;
@synthesize detailViewController;
@synthesize menuDelegate;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(DBFileTopic *) fileTopic{
  
  //NSLog(@"Using DBTopicFileButtonMenuDelegate version of fileTopic method.");
  
  return (DBFileTopic *)detailViewController.managedViewObject.viewTopic;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  self = [super init];
  if (self) {
    
    NSLog(@"init");

    appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    aliasController = appDelegate.aliasController;
    
    columnsMenu = [[NSMenu alloc] initWithTitle:@"Bob"];
    [columnsMenu setAutoenablesItems:NO];
    
    
    menuDelegate = self;
    columnsMenu.delegate = menuDelegate;
  
  }
  
  return self;
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  NSLog(@"awakeFromNib");
  [super awakeFromNib];
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  aliasController = appDelegate.aliasController;
  
  columnsMenu = [[NSMenu alloc] initWithTitle:@""];
  [columnsMenu setAutoenablesItems:NO];
  
  columnsMenu.delegate = self;
  
  //[self.myButton setMenu:columnsMenu];
  
}


#pragma mark - NSMenuDelegate conformance

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)menuWillOpen:(NSMenu *)menu {
  
  //NSDictionary *attributes = @{
    //                           NSFontAttributeName: [NSFont fontWithName:@"Lucida Grande" size:14.0],
      //                         };
  
  NSAttributedString *attributedTitle;
  
  [columnsMenu removeAllItems];
  
  if([detailViewController.managedViewObject.viewTopic isKindOfClass:[DBFileTopic class]]){
    
    DBFileTopic * fileTopic = [self fileTopic];
    
    [aliasController updateAliasObjectPath:fileTopic];
    
    NSMutableString * path = [NSMutableString stringWithString:fileTopic.recentPath];
    [path replaceOccurrencesOfString:@" " withString:@"%20" options: NULL range:NSMakeRange(0, [path length])];
    
    NSURL *fileURL = [NSURL URLWithString:path];
    
    fullPathComponents = [ NSMutableArray arrayWithArray: [ fileURL pathComponents ] ];
    
    NSInteger arrayCount = [fullPathComponents count];
    
    [fullPathComponents replaceObjectAtIndex:0 withObject:@"//"];//we know root is at the root
    
    NSRange deleteRange;
    
    do {
      
      [fullPathComponents setObject:[ NSMutableString stringWithString:path ] atIndexedSubscript:arrayCount-1];
      
      if ([path hasSuffix:@"/"]) {
        deleteRange.length = [[path lastPathComponent] length] + 1;//plus one to include slash
      } else {
        deleteRange.length = [[path lastPathComponent] length];
      }
      
      deleteRange.location = path.length - deleteRange.length;
      
      [path deleteCharactersInRange:deleteRange];
      //NSLog(@"editedPath: %@", path);
      
      arrayCount -= 1;
      
    } while (arrayCount > 1);
    
    //NSLog(@"fullPathcomponents: %@", [fullPathComponents listStrings]);
    
  }
  
  NSMenuItem *pathMenuItem;
  NSMutableString *displayPath;
  NSImage *image;
  NSSize size;
  size.width = 15;
  size.height = 15;
  
  
  
  for (NSMutableString *path in fullPathComponents) {
    
    displayPath = [NSMutableString stringWithString:[path lastPathComponent]];//can't get last component wihtout %20
    [displayPath replaceOccurrencesOfString:@"%20" withString:@" " options:NULL range:NSMakeRange(0,[displayPath length])];
    
    pathMenuItem= [[NSMenuItem alloc] initWithTitle:displayPath
                                             action:@selector(openURL:)
                                      keyEquivalent:@""];
    
    image = [[NSWorkspace sharedWorkspace] iconForFile:[path stringByReplacingOccurrencesOfString:@"%20" withString:@" "]];
    [image setSize:size];
    
    [pathMenuItem setImage:image];
    
    pathMenuItem.target = self;
    [pathMenuItem setState:NSOffState];
    [columnsMenu addItem:pathMenuItem];
    
  }
  
  for (NSMenuItem *menuItem in menu.itemArray) {
    
    attributedTitle = [[NSAttributedString alloc] initWithString:[menuItem title] attributes:appDelegate.textFormatter.menuTextAttributes];
    [menuItem setAttributedTitle:attributedTitle];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openURL:(id)sender { //  sender NSMenuItem
  
  NSArray * itemArray = columnsMenu.itemArray;
  
  NSInteger senderIndex;
  NSMutableString *path;
  
  for ( senderIndex = 0; senderIndex < itemArray.count; senderIndex += 1){
    
    if ([itemArray objectAtIndex:senderIndex] == sender){
      
      break;
      
    }
    
  }
  
  //for breaking down path into components you can't have spaces for opening files you can't have %20's
  path = [NSMutableString stringWithString:[fullPathComponents objectAtIndex:senderIndex]];
  [path replaceOccurrencesOfString:@"%20" withString:@" " options:NULL range:NSMakeRange(0,[path length])];
  [[NSWorkspace sharedWorkspace] openFile:path];
  
  
  //need @"%20" for:  gettingURL to get pathComponent,lastComponent
  //need @" " for: menu title, image, openfile
  
}


@end
