//
//  DBDetailOutlineViewDelegate.m
//  NoteTaker
//
//  Created by Dante on 4/15/13.
//
//
//---------------------------------------------
#import "DBDetailOutlineViewDelegate.h"
//---------------------------------------------
#import "DBOutlineViewController.h"
#import "NoteTaker_AppDelegate.h"
#import "DBDetailOutlineViewController.h"
#import "DBHyperlinkEditor.h"
#import "DBOutlineView.h"
#import "DBTopicObject.h"
#import "DBDetailViewController.h"
#import "DBTableCellTextView.h"
#import "DBDetail.h"
#import "DBTextViewCell.h"
#import "DBOutlineView.h"
#import "DBTableRowView.h"
#import "DBControllerOfOutlineViews.h"
#import "DBTextFormats.h"
#import "NSTreeController_Extensions.h"
#import "DBAliasController.h"
#import "DBFileTopic.h"
//#import "DBTableCellFileView.h"
#import "DBTableCellButtonView.h"
#import "BWSplitView.h"
#import "NSIndexPath_Extensions.h"
#import "DBApplescriptController.h"
#import "DBRelatedTextViewCell.h"
#import "DBViewFileButtonMenuDelegate.h"
#import "DBViewObject.h"

@implementation DBDetailOutlineViewDelegate


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init{
  
  if (self = [super init]) {
    
    textView = [[NSTextView alloc] init];
  }
  
  return self;
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)openFileForViewDetail:(id)sender {
    

  DBDetail * viewDetail = [(NSTableCellView *)[sender superview] objectValue];
    
  [appDelegate.appleScriptController runOutputScriptForDetail: viewDetail];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)showNote:(id)sender {

// select row
  NSInteger row = [self.controller.view rowForView:(NSTableCellView *)[sender superview]];
  NSTreeNode * node = [self.controller.view itemAtRow:row];
  [self.controller.tree setSelectionIndexPath:[node indexPath]];

  DBDetailViewController * mainDetailViewController = self.controller.mainDetailViewController;
  
// open note tab
  [ mainDetailViewController selectDetailTabWithIdentifier:@"NoteTab" ];
  
// select bullet detail tab
  [ mainDetailViewController selectTab:mainDetailViewController.detailTabBtn ];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (IBAction)showPic:(id)sender {
    
// select row
  NSInteger row = [self.controller.view rowForView:(NSTableCellView *)[sender superview]];
  NSTreeNode * node = [self.controller.view itemAtRow:row];
  [self.controller.tree setSelectionIndexPath:[node indexPath]];
  
  
  DBDetailViewController * mainDetailViewController = self.controller.mainDetailViewController;
  
  // open image tab
  [ mainDetailViewController selectDetailTabWithIdentifier:@"ImageTab" ];
  
  // select bullet detail tab
  [ mainDetailViewController selectTab:mainDetailViewController.detailTabBtn ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)outlineViewColumnDidResize:(NSNotification *)notification
{
  
  //NSLog(@"outlineViewColumnDidResize");

  
  [self.controller.view reloadDataAndReselect];
    
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
   
  DBManagedTreeObject *object = [(NSTreeNode*)item representedObject];
  
  NSString * displayName = object.displayName;
  
  if (displayName.length > 0) [textView setString:object.displayName];
  else [textView setString:@" "]; //crashes if given a zero length string
  
  [textView.textStorage setAttributes:appDelegate.textFormatter.plainTextAttributes range:NSMakeRange(0, textView.textStorage.length)];
  
  CGFloat frameWidth = [[self.controller.view outlineTableColumn] width] - [self.controller.view indentationPerLevel] * (1+[self.controller.view levelForItem:item]) - (float)self.controller.view.intercellSpacing.width + 2;//don't know why I needed to add these extra pixels but it makes things work
  
  [textView setFrame:NSMakeRect(textView.frame.origin.x, textView.frame.origin.y, frameWidth, 0)];
  
  [textView.layoutManager glyphRangeForTextContainer:textView.textContainer];
  
  NSRect rect = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
  
  if (rect.size.height > 0) return rect.size.height;
  else return 14.0f;//keeps it from crashing when collapsing width of a column
  
}




// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//to set the hyperlinks to the noteView on the initial selection of the detail
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
  
  //NSLog(@"DBDetailOutlineViewDelegate: outlineViewSelectionDidChange");

  //output for debugging
  //NSArray * selectedObjects = self.controller.tree.selectedObjects;
  
  //if (selectedObjects.count > 0) {
    
    //NSLog(@"topic of selected item: %@", [[[selectedObjects objectAtIndex:0] valueForKey:@"topic"] valueForKey:@"displayName"] );
    
  //}
  
  // --------------------------


  // this notification occurs before the textView is loaded with a new string
  [ self performSelector:@selector(addHyperlinksToNote) withObject:NULL afterDelay:(float) 0.001 ];
  
  [super outlineViewSelectionDidChange:notification];  // enter edit mode
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) addHyperlinksToNote{

  NSArray * selectedObjects;
  DBDetailViewController * mainDetailViewController;
  
  if (self.controller.viewTopic) {
    
    selectedObjects = [self.controller.tree selectedObjects];
    
    mainDetailViewController = [(DBDetailOutlineViewController*)(self.controller) mainDetailViewController];
    
    if (selectedObjects.count > 0) {
      
      [hyperlinkEditor addHyperlinksToEntireTextOf:(NSTextView *)[mainDetailViewController noteView] withRespectTo: mainDetailViewController.managedViewObject.viewTopic];
      
    }
    
  }


}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// this sets the hyperlink of the view cells on initial load
// see DBTextViewCellDelegate for changing value while typing

- (NSView*)outlineView:(DBOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{

  //  item is a NSTreeNode
  
  NSString *identifier = [tableColumn identifier]; 
  
  DBDetail * detail = [item representedObject];

  if ([identifier isEqualToString:@"Detail"]) {
    
    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"DetailCellView" owner:self];

    DBTextViewCell * textViewCell = (DBTextViewCell*)cellView.textView;
    
    textViewCell.treeNode = item;
    
    
    DBOutlineViewController * outlineViewController = [outlineView controller];

    //needs to know this so it can 
    textViewCell.outlineViewController = outlineViewController;
    
    
    if (detail) {
      [cellView.textView bind:NSAttributedStringBinding
            toObject:detail
         withKeyPath:@"displayName"
             options:(@{
                      NSValueTransformerNameBindingOption :@"DBAttributedStringTransformer",
                      NSContinuouslyUpdatesValueBindingOption : @YES })];
    }

    //NSLog(@"viewForTableColumn: %@", detail.displayName);
    
    [hyperlinkEditor addHyperlinksToEntireTextOf:cellView.textView withRespectTo:detail.topic];
    
    return cellView;
    
  } else if ([identifier isEqualToString:@"File"]){
    
    if ([detail.isLeaf boolValue]) return NULL;

    DBTableCellButtonView * fileView = [outlineView makeViewWithIdentifier:@"FileCellView" owner:self];
    
    if (detail.sourceFile) {

      [fileView.myButton bind:@"toolTip"
                     toObject:detail.sourceFile
                  withKeyPath:@"recentPath"
                      options:NULL];
      
      [fileView.myButton setAction:@selector(openFileForViewDetail:)];
      [fileView.myButton setTarget:self];
    
    }
    
    //image is set with binding in IB. so it updates immediately
    
    return fileView;
    
  } else if ([identifier isEqualToString:@"Note"]){
    
    if ([detail.isLeaf boolValue]) return NULL;


    DBTableCellButtonView * noteView = [outlineView makeViewWithIdentifier:@"NoteCellView" owner:self];
    
    [noteView.myButton bind:@"toolTip"
                   toObject:detail
                withKeyPath:@"note"
                    options:NULL];
    
    [noteView.myButton setAction:@selector(showNote:)];
    [noteView.myButton setTarget:self];
    
    return noteView;
    
  } else if ([identifier isEqualToString:@"Image"]){
    
    if ([detail.isLeaf boolValue]) return NULL;

    DBTableCellButtonView * imageView = [outlineView makeViewWithIdentifier:@"ImageCellView" owner:self];
    
    [imageView.myButton setToolTip:@"Open image panel."];
    
    [imageView.myButton setAction:@selector(showPic:)];
    [imageView.myButton setTarget:self];
    
    return imageView;
    
  } else if ([identifier isEqualToString:@"Check"]){

    if ([detail.isLeaf boolValue]) return NULL;
    
    // button is still working even though it's not visible
    
    BOOL showChecksOfAllSubGroups = [[NSUserDefaults standardUserDefaults] boolForKey:@"showChecksOfAllSubGroups"];
    
    
    DBTableCellButtonView * checkView = [outlineView makeViewWithIdentifier:@"CheckCellView" owner:self];

    if (showChecksOfAllSubGroups) {
      
      [checkView.myButton setHidden:NO];

    } else if ([[detail.parent valueForKey:@"showSubGroupChecks"] boolValue] || [[detail valueForKey:@"showSubGroupChecks"] boolValue] ){
      
      [checkView.myButton setHidden:NO];

      
    } else {
      
      [checkView.myButton setHidden:YES];

    }
    
    return checkView;

    
  } else if ([identifier isEqualToString:@"Associated"]){

    if ([detail.isLeaf boolValue]) return NULL;
    
    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"AssociatedCellView" owner:self];
    
    DBRelatedTextViewCell * dateView = (DBRelatedTextViewCell *) cellView.textView;
    NSRect frame = dateView.frame;
    
    [dateView setFrame:NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    if (detail) {
      [dateView bind:NSAttributedStringBinding
            toObject:detail
         withKeyPath:@"dateAssociated"
             options:(@{
                      NSValueTransformerNameBindingOption :@"DBDateTransformer",
                      NSContinuouslyUpdatesValueBindingOption : @YES })];
    }
    
    [hyperlinkEditor addModelLinksTo:dateView];//will tell mouseDown event in DBDetailOutlineView to figure the target of the lnk out based on the model.
    
    return cellView;
    
  } else if ([identifier isEqualToString:@"Created"]){

    if ([detail.isLeaf boolValue]) return NULL;

    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"CreatedCellView" owner:self];
    
    DBRelatedTextViewCell * dateView = (DBRelatedTextViewCell *) cellView.textView;
    NSRect frame = dateView.frame;
    
    [dateView setFrame:NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    if (detail) {
      [dateView bind:NSAttributedStringBinding
            toObject:detail
         withKeyPath:@"dateCreated"
             options:(@{
                      NSValueTransformerNameBindingOption :@"DBDateTransformer",
                      NSContinuouslyUpdatesValueBindingOption : @YES })];
    }
    
    [hyperlinkEditor addModelLinksTo:dateView];//will tell mouseDown event in DBDetailOutlineView to figure the target of the lnk out based on the model.
    
    return cellView;
    
  } else if ([identifier isEqualToString:@"Modified"]){
    
    if ([detail.isLeaf boolValue]) return NULL;

    DBTableCellTextView * cellView = [outlineView makeViewWithIdentifier:@"ModifiedCellView" owner:self];
    
    DBRelatedTextViewCell * dateView = (DBRelatedTextViewCell *) cellView.textView;
    NSRect frame = dateView.frame;
    
    [dateView setFrame:NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    if (detail) {
      [dateView bind:NSAttributedStringBinding
            toObject:detail
         withKeyPath:@"dateModified"
             options:(@{
                      NSValueTransformerNameBindingOption :@"DBDateTransformer",
                      NSContinuouslyUpdatesValueBindingOption : @YES })];
    }
    
    [hyperlinkEditor addModelLinksTo:dateView];//will tell mouseDown event in DBDetailOutlineView to figure the target of the lnk out based on the model.
    
    return cellView;
    
  } else {
    
    return NULL;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(NSTableRowView *)outlineView:(DBOutlineView *)outlineView rowViewForItem:(id)item{
  
    return [[DBTableRowView alloc] init];

}



@end
