//
//  DBOutlineViewDelegate.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 5/8/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//


//---------------------------------------------
#import "DBOutlineView.h"
//---------------------------------------------
#import "DBDetail.h"
#import "DBDetailController.h"
#import "DBHyperlinkEditor.h"
#import "DBOutlineViewController.h"
#import "DBControllerOfOutlineViews.h"
#import "DBDetailOutlineViewDelegate.h"
#import "NoteTaker_AppDelegate.h"
#import "NSTreeController_Extensions.h"
#import "DBDetailOutlineViewController.h"
#import "DBDetailViewController.h"
#import "DBTableRowView.h"
#import "DBMainWindow.h"
#import "DBDetailOutlineView.h"
#import "DBTopicFolderView.h"
#import "NSCharacterSet_Extensions.h"

@implementation DBOutlineView

@synthesize myDelegate;
@synthesize controller;
@synthesize animatesToStartingPositionsOnCancelOrFail;

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) awakeFromNib
{
  appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  myDelegate = (DBOutlineViewDelegate * )[self delegate];
  
  controllerOfOutlineViews = appDelegate.controllerOfOutlineViews;
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(textDidEndEditing:)
             name:NSTextDidEndEditingNotification
           object:self];

  //[self setAllowsMultipleSelection: YES];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) reloadDataAndReselect
{
  
  //need to reload the displayname columns
  [self reloadData];

  // restore the selection after reload if possible
  [ self performSelector:@selector(reselect) withObject:NULL afterDelay:(float) 0.001 ];//can't access row view for a bit
  
}



// -------------------------------------------------------------------------------

// keyDown:

// -------------------------------------------------------------------------------

- (void)keyDown:(NSEvent *)theEvent{
  //NSLog(@"keydown");
  NSUInteger flags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
  BOOL tookAction = NO;
  unsigned short keyCode = [theEvent keyCode];
  
  if( flags == NSCommandKeyMask ){
    
    /*
     switch ( keyCode ) {
    	
      case 7: // "x"
        
        //NSLog(@"cut");

        [ appDelegate.detailController cutObjectClipboardContentsUsingController:controller ];
        tookAction = YES;
        break;
    	
      case 8: // "c"
        
        //NSLog(@"copy");

        [ appDelegate.detailController copySelectedObjectsUsingController:controller ];
        tookAction = YES;
        break;
      
      case 9: // "v"
        
        //NSLog(@"paste");
        
        [ appDelegate.detailController pasteObjectClipboardContentsUsingController:controller ];
        tookAction = YES;
        break;
    
      
      
    }
    */
  } else if ( flags == 0 || flags == NSShiftKeyMask ){
    
    //NSLog(@"no flags");
    
    // else if no modifiers were down and no items are selected
    // then make an item (bullet or topic)
    // and see if super key down types the key pressed into the field
    
    // should I start editing if a bullet is selected?
    
    //if ( controller.tree.selectedObjects.count == 0 ) {
      
      if (keyCode == 36){
        
        //NSLog(@"enter pressed");

        [ self createDefaultItemWithString:NULL];
        
        tookAction = YES;

      } else {
        
        NSString * keyString = [theEvent charactersIgnoringModifiers];
        
        unichar keyChar = [keyString characterAtIndex:0];
        
        if ([[NSCharacterSet topicNameCharacterSet] characterIsMember:keyChar]) {
          
          //NSLog(@"topicCharacter pressed");
          
          [ self createDefaultItemWithString:keyString];
          
          tookAction = YES;

        }
        
      }

    //}
    
  }
  
  /* 
   else {
    // if short cut is setup through the main menu this is done twice
    //    need to setup through main menu but have command detect if a topic or detail view is active
    
    if ( keyCode == 51 ){ // Delete key pressed. Should this be for no modifiers only?
    
      if ([self isKindOfClass:[DBDetailOutlineView class]]) {
        
        [ appDelegate.detailController removeFromDetailView: self];
      
      } else if ([self isKindOfClass:[DBTopicFolderView class]]) {
      
        [ appDelegate.detailController removeFromFolderView: self];

      }
        
    }
     
    
  }
  */
  
  if (! tookAction){
    [super keyDown:theEvent]; // get system alert sound if a cmd shft c,v,x gets passed here
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) createDefaultItemWithString:(NSString *)typedKey
{
  
  // stub for detail and topic views to implement
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)copy:(id)sender
{
  
  [ appDelegate.detailController copySelectedObjectsUsingController:controller ];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)cut:(id)sender
{
  
  [ appDelegate.detailController cutObjectClipboardContentsUsingController:controller ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)paste:(id)sender
{
  
  [ appDelegate.detailController pasteObjectClipboardContentsUsingController:controller ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) reselect
{
  //have access to rows now.  can I select them?
  
  NSArray * selectedItems = [self.controller.tree selectedNodes];
  NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];

  NSInteger rowNum;
  
  for (NSTreeNode * node in selectedItems) {
    //NSLog(@"node name: %@", [[node representedObject] valueForKey:@"displayName"]);
    
    rowNum = [self rowForItem:node];
    //NSLog(@"rowNum: %li", rowNum);
    
    if (rowNum > -1) {
      
      [ indexSet addIndex:[self rowForItem:node]];
  
      //rowView = [self rowViewAtRow:rowNum makeIfNecessary:NO];//RETURNING NULL
      
    }
    
  }

  [ self selectRowIndexes:indexSet byExtendingSelection:NO ];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (NSTableColumn *) columnWithIndex:(NSInteger)index{
  
  NSArray * columns = [NSArray arrayWithArray: [self tableColumns]];
                       
  return [columns objectAtIndex:index];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void) drawContextMenuHighlightForRow:(int)row{
  
  // just overwriting this to get rid of right click outline

}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// topic headers are edited through topic editor so this only concerns FolderOrganizers and details
// need to add option to trim whitespace
// ideally would replace with old displayName if the new entry is blank
- (void)textDidEndEditing:(NSNotification *)aNotification
{
  DBManagedTreeObject * selectedObject;
  NSString * editedName;
  //NSAttributedString * displayNameWithWiki;
  DBDetailViewController * mainDetailViewController;
  
  if ([controller.tree selectedObjects].count > 0){
    
    selectedObject = [[controller.tree selectedObjects] objectAtIndex:0];

    editedName = [selectedObject.displayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    mainDetailViewController = controller.mainDetailViewController;
    
    if([editedName isEqualToString:@""]){
      
      [self abortEditing];
      
    } else if(mainDetailViewController){ //if it's not a topic folder
      
      [controllerOfOutlineViews updateRelatedContent];
      
    }
    
    [super textDidEndEditing:aNotification];
  
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------


- (void)dragImage:(NSImage *)anImage
               at:(NSPoint)imageLoc
           offset:(NSSize)mouseOffset
            event:(NSEvent *)theEvent
       pasteboard:(NSPasteboard *)pboard 
           source:(id)sourceObject 
        slideBack:(BOOL)slideBack {
  
  //mouseOffset is always ignored (per documentation)
  
  NSString *theImageName;
  NSPoint mousePosition;
  CGFloat bumpX;
  CGFloat bumpY;
  //NSString * dragSelection = [appDelegate.detailController.dragType objectValueOfSelectedItem];
  NSNumber * dragSelectionindex = [[NSUserDefaults standardUserDefaults] objectForKey:@"dragTypeIndex"];
  
  /*
  if ([dragSelectionindex isEqualToString:@"Move"]) {
    
    theImageName = @"DragMove.png";

  } else if ([dragSelection isEqualToString:@"Copy"]){
    
    theImageName = @"DragCopy.png";
    
  } else if ([dragSelection isEqualToString:@"Link"]){

    theImageName = @"DragLink.png";

  }
*/
  if ([dragSelectionindex isEqualToNumber:[NSNumber numberWithInt:0]]){
    
    theImageName = @"DragMove.png";
    
  } else if ([dragSelectionindex isEqualToNumber:[NSNumber numberWithInt:1]]){
   
    theImageName = @"DragCopy.png";

  }
  
  bumpX = -4;
  bumpY = 42;
  
  mousePosition = [theEvent locationInWindow];
  imageLoc = [self convertPoint:mousePosition fromView:nil];
  
  imageLoc.x += bumpX;
  
  imageLoc.y += bumpY;
  
  anImage = [NSImage imageNamed: theImageName];  
  
  [super dragImage:anImage 
                at:imageLoc 
            offset:mouseOffset 
             event:theEvent 
        pasteboard:pboard 
            source:sourceObject 
         slideBack:slideBack]; 
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//assumes a row is selected
-(id)tableCellViewFromEvent:(NSEvent *) theEvent{
  
  NSPoint tablePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
  NSInteger rowNum = [self rowAtPoint:tablePoint];
  NSInteger colNum = [self columnAtPoint:tablePoint];
  
  return [self viewAtColumn:colNum row:rowNum makeIfNecessary:NO];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL)becomeFirstResponder {

  //want it to reselect it's selected object; this selects twice if a new selection is made and it's also becoming first responder

  //[controller.tree selectNone];

  [appDelegate.mainWindow makeFirstResponder:self];
   
  //[controllerOfOutlineViews highlightActiveOutline];

  return YES;
}

@end
