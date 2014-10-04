//
//  DBCellFileButtonMenuDelegate.m
//  NoteTaker
//
//  Created by Angela Bortone on 8/13/13.
//
//
//---------------------------------------------
#import "DBTableMenuDelegate.h"
//---------------------------------------------
#import "DBFileTopic.h"
#import "NoteTaker_AppDelegate.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailViewController.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetail.h"
#import "DBFileTopic.h"
#import "DBViewObject.h"
#import "DBAliasController.h"
#import "NSDate_Extensions.h"
#import "DBCalendarController.h"
#import "DBEditDatesController.h"
#import "DBTextFormats.h"
#import "DBOutlineView.h"
#import "DBDetailOutlineViewDelegate.h"
#import "DBOutlineViewDataSource.h"
#import "DBApplescriptController.h"
#import "DBDetailController.h"

@implementation DBTableMenuDelegate

@synthesize tableView;



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib {
  
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  aliasController = appDelegate.aliasController;
  calendarController = appDelegate.calendarController;
  
  columnsMenu = [[NSMenu alloc] initWithTitle:@""];
  [columnsMenu setAutoenablesItems:NO];
  
  columnsMenu.delegate = self;
  
  [self.tableView setMenu:columnsMenu];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) dateMenuItems:(DBDetail *)selectedDetail {
  
  
  
  NSMutableArray *menuItems = [NSMutableArray array];
  
  if (selectedDetail) {
    //NSLog(@"adding date menu items");
    NSString * title;
    
    title = [NSString stringWithFormat:@"Associated: %@", [selectedDetail.dateAssociated topicString]];
    NSMenuItem *associatedDateItem = [[NSMenuItem alloc] initWithTitle:title
                                                                action:@selector(linkToAssociatedDate:)
                                                         keyEquivalent:@""];
    [menuItems addObject:associatedDateItem];

    
    title = [NSString stringWithFormat:@"Created: %@", [selectedDetail.dateCreated topicString]];
    NSMenuItem *createdDateItem = [[NSMenuItem alloc] initWithTitle:title
                                                             action:@selector(linkToCreatedDate:)
                                                      keyEquivalent:@""];
    [associatedDateItem setRepresentedObject:selectedDetail.dateCreated];
    [menuItems addObject:createdDateItem];
    
    
    title = [NSString stringWithFormat:@"Modified: %@", [selectedDetail.dateModified topicString]];
    NSMenuItem *modifiedDateItem = [[NSMenuItem alloc] initWithTitle:title
                                                                action:@selector(linkToModifiedDate:)
                                                         keyEquivalent:@""];
    [associatedDateItem setRepresentedObject:selectedDetail.dateModified];
    [menuItems addObject:modifiedDateItem];
    
    
    NSMenuItem *editDatesItem = [[NSMenuItem alloc] initWithTitle:@"Edit dates..."
                                                           action:@selector(editDates:)
                                                    keyEquivalent:@""];
    [menuItems addObject:editDatesItem];
    
    
    for (NSMenuItem *menuItem in menuItems) {
      
      [menuItem setRepresentedObject:selectedDetail];
      menuItem.target = self;
      [menuItem setState:NSOffState];
    
    }
  }
  return [ NSArray arrayWithArray: menuItems];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) editDates:(id) sender{
  
  //NSLog(@"Edit dates...");
  editDatesController.editingDetail = [sender representedObject];
  [editDatesController openPanel];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) linkToAssociatedDate:(id) sender{
  
  DBDetail * selectedDetail = [sender representedObject];
  
  [calendarController assignDateTopicFromDate:selectedDetail.dateAssociated throughLink:YES];
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) linkToCreatedDate:(id) sender{
  
  DBDetail * selectedDetail = [sender representedObject];
  
  [calendarController assignDateTopicFromDate:selectedDetail.dateCreated throughLink:YES];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) linkToModifiedDate:(id) sender{
  
  DBDetail * selectedDetail = [sender representedObject];

  [calendarController assignDateTopicFromDate:selectedDetail.dateModified throughLink:YES];

  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) noteMenuItems:(DBDetail *)selectedDetail {

  NSMutableArray *menuItems = [NSMutableArray array];
  
  if (selectedDetail) {
    
    NSMenuItem *pathMenuItem;

    NSString *note = selectedDetail.note;
    
    //if the string isn't blank
    if( (note == NULL) || [note isEqualToString:@""]) {
      
      // no note
     // NSLog(@"no note");
      
    } else {
      
      //NSLog(@"note is: %@", note);

      pathMenuItem = [[NSMenuItem alloc] initWithTitle:@"Note to clipboard"
                                                action:@selector(copyNoteToClipBoard:)
                                         keyEquivalent:@""];
      
      [pathMenuItem setRepresentedObject:note];
      pathMenuItem.target = self;
      [pathMenuItem setState:NSOffState];
      
      [menuItems addObject:pathMenuItem];

    }
  }
  return [ NSArray arrayWithArray: menuItems];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) checkMenuItems:(DBDetail *)selectedDetail {
  
  NSMutableArray *menuItems = [NSMutableArray array];
  
  if (selectedDetail) {

    NSMenuItem *menuItem;

  // check or uncheck detail
    if ([selectedDetail.isChecked boolValue]) {
      menuItem = [[NSMenuItem alloc] initWithTitle:@"Mark as unchecked"
                                                action:@selector(unmarkCheck:)
                                         keyEquivalent:@""];
    } else {
      
      menuItem = [[NSMenuItem alloc] initWithTitle:@"Mark as checked"
                                                action:@selector(markCheck:)
                                         keyEquivalent:@""];
      
    }
    
    menuItem.representedObject = selectedDetail;
    menuItem.target = self;
    [menuItem setState:NSOffState];
    [menuItems addObject:menuItem];

    //show/hide checkbox
    if ([selectedDetail.showSubGroupChecks boolValue]) {
      menuItem = [[NSMenuItem alloc] initWithTitle:@"Hide checkbox"
                                            action:@selector(hideCheck:)
                                     keyEquivalent:@""];
    } else {
      
      menuItem = [[NSMenuItem alloc] initWithTitle:@"Show checkbox"
                                            action:@selector(showCheck:)
                                     keyEquivalent:@""];
      
    }
    
    menuItem.representedObject = selectedDetail;
    menuItem.target = self;
    [menuItem setState:NSOffState];
    [menuItems addObject:menuItem];
    
  }
  return [ NSArray arrayWithArray: menuItems];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) detailMenuItems:(DBDetail *)selectedDetail {
  
  NSMutableArray *menuItems = [NSMutableArray array];
  NSMenuItem *menuItem;
  
  menuItem = [[NSMenuItem alloc] initWithTitle:@"Add bullet"
                                          action:@selector(addDetail:)
                                   keyEquivalent:@""];
  
  menuItem.representedObject = selectedDetail;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItems addObject:menuItem];
  
  menuItem = [[NSMenuItem alloc] initWithTitle:@"Remove bullet"
                                        action:@selector(removeDetail:)
                                 keyEquivalent:@""];
  
  menuItem.representedObject = selectedDetail;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItems addObject:menuItem];
  
  menuItem = [[NSMenuItem alloc] initWithTitle:@"Add subbullet"
                                        action:@selector(addSubGroup:)
                                 keyEquivalent:@""];
  
  menuItem.representedObject = selectedDetail;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItems addObject:menuItem];

  menuItem = [[NSMenuItem alloc] initWithTitle:@"Add divider"
                                        action:@selector(addDivider:)
                                 keyEquivalent:@""];
  
  menuItem.representedObject = selectedDetail;
  menuItem.target = self;
  [menuItem setState:NSOffState];
  [menuItems addObject:menuItem];
  
  return [ NSArray arrayWithArray: menuItems];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)addDetail: (id)sender{
  
  //NSLog(@"addDetail");
  [appDelegate.detailController insert:sender];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)removeDetail: (id)sender{
  
  //NSLog(@"addDetail");
  [appDelegate.detailController removeFromDetailView:sender];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)addSubGroup: (id)sender{
  
  //NSLog(@"addSubGroup");
  [appDelegate.detailController subGroup:sender];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)addDivider: (id)sender{
  
  //NSLog(@"addDivider");
  [appDelegate.detailController divider:sender];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)hideCheck: (id)sender{
  
  //NSLog(@"hideCheck");
  
  [[sender representedObject] setValue:[NSNumber numberWithBool:NO] forKey:@"showSubGroupChecks"];
  
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)showCheck: (id)sender{
  
  //NSLog(@"hideCheck");
  
  [[sender representedObject] setValue:[NSNumber numberWithBool:YES] forKey:@"showSubGroupChecks"];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)markCheck: (id)sender{
  
  //NSLog(@"markCheck");

  [[sender representedObject] setValue:[NSNumber numberWithBool:YES] forKey:@"isChecked"];
  
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)unmarkCheck: (id)sender{
  
  //NSLog(@"unmarkCheck");
  
  [[sender representedObject] setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)copyNoteToClipBoard:(id)sender {
  
//  NSLog(@"copyNoteToClipBoard");//<---not being called

  NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];

  NSArray *copiedObject = [NSArray arrayWithObject:[(NSMenuItem *)sender representedObject]];

  [pasteboard clearContents];
  [pasteboard writeObjects:copiedObject];

  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSArray *) fileMenuItems:(DBDetail *)selectedDetail {
  //NSLog(@"DBTableMenuDelegate: fileMenuItems:");
  NSMutableArray *menuItems = [NSMutableArray array];
  
  if (selectedDetail) {

    NSMenuItem *pathMenuItem;
    
    fullPathComponents = NULL;
    
    DBFileTopic * fileTopic = selectedDetail.sourceFile;
    
    if(fileTopic){
      
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
    
    NSMutableString *displayPath;
    NSImage *image;
    NSSize size;
    size.width = 15;
    size.height = 15;
    NSInteger pathPosition = 0;
    
    
    for (int index = 0; index < fullPathComponents.count; index+=1) {
      
      NSMutableString * path = [fullPathComponents objectAtIndex:index];
      displayPath = [NSMutableString stringWithString:[path lastPathComponent]];//can't get last component without %20
      [displayPath replaceOccurrencesOfString:@"%20" withString:@" " options:NULL range:NSMakeRange(0,[displayPath length])];
      
      // the last path component needs to have a different sleector so it can use the outputScript
      if (index == fullPathComponents.count-1) {
        
        pathMenuItem= [[NSMenuItem alloc] initWithTitle:displayPath
                                                 action:@selector(useOutputScriptToOpen:)
                                          keyEquivalent:@""];
        
        [pathMenuItem setRepresentedObject:selectedDetail];
      
      } else {
      
        pathMenuItem= [[NSMenuItem alloc] initWithTitle:displayPath
                                               action:@selector(openURL:)
                                        keyEquivalent:@""];
      }
      
      image = [[NSWorkspace sharedWorkspace] iconForFile:[path stringByReplacingOccurrencesOfString:@"%20" withString:@" "]];
      [image setSize:size];
      
      [pathMenuItem setImage:image];
      
      pathMenuItem.target = self;
      [pathMenuItem setState:NSOffState];
      
      [pathMenuItem setTag:pathPosition];
      pathPosition = pathPosition +1;
      
      
      [menuItems addObject:pathMenuItem];
      
    }
  }
  
  return [ NSArray arrayWithArray: menuItems];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)menuWillOpen:(NSMenu *)menu {

  //NSLog(@"menuWillOpen");
  [columnsMenu removeAllItems];

  // when table view first loads I can't get it to select programatically.  if a row is selected then clicking the buttons doesn't work unless we go through a programatic selection
  if ( [ tableView selectedRow] > -1 ) {
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[tableView clickedRow]];
    
    [tableView selectRowIndexes:indexSet byExtendingSelection:NO];  //doesn't work on first load
  
  } else {
    
    NSEvent *click = [NSEvent mouseEventWithType:NSLeftMouseDown location:[NSEvent mouseLocation] modifierFlags:NULL timestamp:1 windowNumber:NULL context:NULL eventNumber:NULL clickCount:1 pressure:(float)1.0];
    
    [tableView mouseDown:click];
    
    //select the row first and then load data off selectedDetail
    
    NSTreeNode * clickedNode = [tableView itemAtRow:[tableView clickedRow]];
    
    [tableView.controller.tree setSelectionIndexPath:[clickedNode indexPath]];
    
  }
  
  DBDetail *selectedDetail;
  if (tableView.controller.tree.selectedObjects.count > 0) {
    selectedDetail = [tableView.controller.tree.selectedObjects objectAtIndex:0];
  } else {
    selectedDetail = NULL;
  }
  
  NSArray *detailMenuItems = [self detailMenuItems:selectedDetail];
  NSArray *dateMenuItems = [self dateMenuItems:selectedDetail];
  NSArray *fileMenuItems = [self fileMenuItems:selectedDetail];
  NSArray *noteMenuItems = [self noteMenuItems:selectedDetail];
  NSArray *checkMenuItems = [self checkMenuItems:selectedDetail];
  
  NSArray *menuCategories = [NSArray arrayWithObjects:detailMenuItems, dateMenuItems, fileMenuItems, noteMenuItems, checkMenuItems, nil];
  
  NSArray * menuItems;
  Boolean previousMenuHadItems = NO;
  NSAttributedString *attributedTitle;

  for ( int index = 0; index < menuCategories.count; index++ ){
    
    menuItems = [menuCategories objectAtIndex:index];
    
    if (menuItems.count > 0) {
      
    // put divider here if previousMenuHadItems
      if (previousMenuHadItems) {
        
        [columnsMenu addItem:[NSMenuItem separatorItem]];
        
      }
      
      for (NSMenuItem * menuItem in menuItems) {
        
        attributedTitle = [[NSAttributedString alloc] initWithString:[menuItem title] attributes:appDelegate.textFormatter.menuTextAttributes];
        [menuItem setAttributedTitle:attributedTitle];
        [columnsMenu addItem:menuItem];
        
      }

      previousMenuHadItems = YES;

    }
  
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) useOutputScriptToOpen:(id)sender {
  
  [appDelegate.appleScriptController runOutputScriptForDetail:[sender representedObject]];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) openURL:(id)sender { //  sender NSMenuItem
  
  
  NSMutableString *path;
  
  //for breaking down path into components you can't have spaces; for opening files you can't have %20's
  path = [NSMutableString stringWithString:[fullPathComponents objectAtIndex:[sender tag]]];
  [path replaceOccurrencesOfString:@"%20" withString:@" " options:NULL range:NSMakeRange(0,[path length])];
  [[NSWorkspace sharedWorkspace] openFile:path];
  
  
  //need @"%20" for:  gettingURL to get pathComponent,lastComponent
  //need @" " for: menu title, image, openfile
  
}

@end
