//
//  DBDetail.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/23/12.
//
//


//---------------------------------------------
#import "DBDetail.h"
//---------------------------------------------
#import "DBTopicObject.h"
#import "DBViewObject.h"
#import "DBDetailViewController.h"
#import "DBUndoManager.h"
#import "NoteTaker_AppDelegate.h"

@implementation DBDetail

// Attributes -------------
@dynamic dateAssociated;
@dynamic dateCreated;
@dynamic dateModified;
@dynamic isChecked;
@dynamic note;
@dynamic outputValue;
@dynamic image;
@dynamic showSubGroupChecks;

// Relationships ----------
@dynamic sourceFile;
@dynamic topic;
@dynamic outputScript;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) awakeFromInsert //after it's inserted
{
  
  [super awakeFromInsert];
  
  //[self setValue:[NSDate date] forKey:@"dateAssociated"];
  //[self setValue:[NSDate date] forKey:@"dateCreated"];
  //[self setValue:[NSDate date] forKey:@"dateModified"];
  
  self.dateAssociated = [NSDate date];
  self.dateCreated = [NSDate date];
  self.dateModified = [NSDate date];


}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setOutputScript:(DBOutputScript *)outputScript
{
  
  NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager * undoManager = appDelegate.undoManager;
  
  [undoManager makeUndoable];
  
  
  [self willChangeValueForKey:@"outputScript"];
  [self setPrimitiveValue:outputScript forKey:@"outputScript"];
  [self didChangeValueForKey:@"outputScript"];
  
  
  if ( [self.initializingObject boolValue] != YES ) {
    
    [self setDateModified:[NSDate date]];

  }
  
  [undoManager stopMakingUndoable];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified
// undo done in DBEditDatesController

- (void) setDateAssociated:(NSDate *)dateAssociated {
  
  [self willChangeValueForKey:@"dateAssociated"];
  [self setPrimitiveValue:dateAssociated forKey:@"dateAssociated"];
  [self didChangeValueForKey:@"dateAssociated"];
  
  if ( [self.initializingObject boolValue] != YES ) {
    
    [self reloadMyRowsIfShowingColumnWithIdentifier:@"Associated"];
    [self setDateModified:[NSDate date]];
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) reloadMyRowsIfShowingColumnWithIdentifier:(NSString *) identifier{

  NSSet * views =  self.topic.views;
  
  for (DBViewObject *view in views ){
    
    [ view.detailViewController shouldReloadRowWithItem:self ifShowingColumnWithIdentifier: identifier];

  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//undo actions done in DBTextViewCell
// date modified set on end editing of DBTextCell
- (void) setDisplayName:(NSString *)displayName {
  
  //NSLog(@"set dispaly name");
  
  [self willChangeValueForKey:@"displayName"];
  [self setPrimitiveValue:[displayName stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"displayName"];
  [self didChangeValueForKey:@"displayName"];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified set on end editing of DBNoteTextView

- (void) setNote:(NSString *)note {

  [ self willChangeValueForKey: @"note" ];
  [ self setPrimitiveValue: note forKey:@"note" ];
  [ self didChangeValueForKey: @"note" ];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setIsChecked:(NSNumber *)isChecked {

  NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager * undoManager = appDelegate.undoManager;
  
  [undoManager makeUndoable];
  
  //only change these values if they are being modified

    [self primitiveIsChecked:isChecked];
    
  
      NSSet * subGroups = self.subGroups;
      
      for (DBDetail * subGroup in subGroups) {
        
        [ subGroup parentWasChecked:isChecked ];
        
      }
      
      if (self.parent != NULL) {
        
        [(DBDetail *)self.parent updateCheckMark];
        
      }
      
  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setShowSubGroupChecks:(NSNumber *)showSubGroupChecks
{
  
  [self willChangeValueForKey:@"showSubGroupChecks"];
  [self setPrimitiveValue:showSubGroupChecks forKey:@"showSubGroupChecks"];
  [self didChangeValueForKey:@"showSubGroupChecks"];
  
  // check all the subgroups for this all well
  if ([showSubGroupChecks boolValue]) {
    
    NSSet * subGroups = self.subGroups;
    
    for (DBDetail * subGroup in subGroups) {
      
      [ subGroup setShowSubGroupChecks: showSubGroupChecks ];
      
    }
  }
  
  if ( [self.initializingObject boolValue] != YES ) {

    [self setDateModified:[NSDate date]];
  
    [self reloadMyRowsIfShowingColumnWithIdentifier:@"Check"];
  
  }

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setOutputValue:(NSString *)outputValue {
  

  
  
  [self willChangeValueForKey:@"outputValue"];
  [self setPrimitiveValue:outputValue forKey:@"outputValue"];
  [self didChangeValueForKey:@"outputValue"];
  
  
  //Need ot set this through subclassing the text view
  //[self setDateModified:[NSDate date]];
  
  
}

// -------------------------------------------------------------------------------

// setTopic:

// -------------------------------------------------------------------------------

// set topic of subgrousp if this items topic is changed

- (void) setTopic:(DBTopicObject *)topic {
  
  [self willChangeValueForKey:@"topic"];
  [self setPrimitiveValue:topic forKey:@"topic"];
  [self didChangeValueForKey:@"topic"];
  
  for (DBDetail * subgroup in self.subGroups) {
    
    subgroup.topic = topic;
    
  }
  
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setSourceFile:(DBFileTopic *)sourceFile
{
  
  NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager * undoManager = appDelegate.undoManager;
  
  // this undo has a slight bug in that the file topic will still exist, but I don't want to mess with undoing topics.  it's a mess when a deleted topic will show up in the foward and back history navigation. or when a topic is being viewed and the file topic it's viewing is undone. I'd have to do these undo actions manually and I'm not up for that right now.
  
  [undoManager makeUndoable];
  
  [self willChangeValueForKey:@"sourceFile"];
  [self setPrimitiveValue:sourceFile forKey:@"sourceFile"];
  [self didChangeValueForKey:@"sourceFile"];
  
  if ( [self.initializingObject boolValue] != YES ) {

    [self setDateModified:[NSDate date]];
  
  }
  
  [undoManager stopMakingUndoable];

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update date modefied
// want to inherit the checkbox display from parent

- (void) setParent:(DBDetail *)parent
{
  //NSLog(@"set parent");
  DBDetail * previousParent = (DBDetail *)self.parent;
  
  [ super setParent: parent ];
  
  if ([parent.showSubGroupChecks boolValue]) {
    
    [ self setShowSubGroupChecks: parent.showSubGroupChecks ];
    
  }
  
  //handles 
  [previousParent updateCheckMark];
  [parent updateCheckMark];
  
  //if ( [self.initializingObject boolValue] != YES ) {

    //[self setDateModified:[NSDate date]];
    
  //}

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// date undo's are set up at DBEditDatesController

- (void) setDateModified:(NSDate *)dateModified
{
  
  
  [self willChangeValueForKey:@"dateModified"];
  [self setPrimitiveValue:dateModified forKey:@"dateModified"];
  [self didChangeValueForKey:@"dateModified"];
  
  [self.topic setDateModified:[NSDate date]];
  
  //reload rows with this item
  if ( [self.initializingObject boolValue] != YES ) {
    //NSLog(@"not initializing obejct anymore");

    //NSLog(@"modified & not initializing object: save now? ");
    
    [self reloadMyRowsIfShowingColumnWithIdentifier:@"Modified"];
  
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// date undo's are set up at DBEditDatesController

- (void) setDateCreated:(NSDate *)dateCreated
{

  [self willChangeValueForKey:@"dateCreated"];
  [self setPrimitiveValue:dateCreated forKey:@"dateCreated"];
  [self didChangeValueForKey:@"dateCreated"];
  
  //reload rows with this item
  if ( [self.initializingObject boolValue] != YES ) {
    
    [self reloadMyRowsIfShowingColumnWithIdentifier:@"Created"];
    [self setDateModified:[NSDate date]];
  
  }
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) setImage:(NSData *)image
{
  
  NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
  DBUndoManager * undoManager = appDelegate.undoManager;
  
  [undoManager makeUndoable];
  
  [self willChangeValueForKey:@"image"];
  [self setPrimitiveValue:image forKey:@"image"];
  [self didChangeValueForKey:@"image"];

  [self setDateModified:[NSDate date]];
  
  [undoManager stopMakingUndoable];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) parentWasChecked:(NSNumber *) isChecked
{
  
  //only do this if it's actually changing the value
  if ([isChecked integerValue] != [self.isChecked integerValue]) {
    
    [self primitiveIsChecked:isChecked];
    
    NSSet * subGroups = self.subGroups;
    
    for (DBDetail * subGroup in subGroups) {
      
      [ subGroup parentWasChecked:isChecked ];
      
    }
    
  }
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) updateCheckMark
{
  
  NSSet * subGroups = self.subGroups;
  
  BOOL mixedSubgroups = NO;
  
  if (subGroups.count > 0) {
    
    NSInteger subGroupCheck = [[ [ subGroups anyObject] valueForKey:@"isChecked" ] integerValue];
    
    for (DBDetail * subGroup in subGroups) {
      
      if ([subGroup isNotALeaf]) {  // i.e. not a divider
        
        if (subGroupCheck != [subGroup.isChecked integerValue] ) {
          
          mixedSubgroups = YES;
          
        } else if (subGroupCheck == -1) {
          
          mixedSubgroups = YES;
          
        }
        
      }
      
    }
    
    if (mixedSubgroups) {
      
      [ self primitiveIsChecked:[NSNumber numberWithInt:-1 ] ];
      
    } else {
      
      [ self primitiveIsChecked: [ NSNumber numberWithBool:subGroupCheck ] ];
      
    }
    
    if (self.parent != NULL) {
      
      [(DBDetail *)self.parent updateCheckMark];
      
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void) primitiveIsChecked:(NSNumber *)isChecked
{
  
  [self willChangeValueForKey:@"isChecked"];
  [self setPrimitiveValue:isChecked forKey:@"isChecked"];
  [self didChangeValueForKey:@"isChecked"];
  
  [self setDateModified:[NSDate date]];
  
  if ( [isChecked intValue] == 1 ) {
    
    [self setDateAssociated:[NSDate date]];
    
  }
  
}

- (void) doneInitializing {
  
  [super doneInitializing];
  
  // need to make sure subgroups know they are done initializing as well
  
  for (DBDetail * subgroup in self.subGroups) {
    
    [subgroup doneInitializing];
    
  }
  
}




@end
