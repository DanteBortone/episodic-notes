//
//  DBTopicObject.m
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/24/12.
//
//


//---------------------------------------------
#import "DBTopicObject.h"
//---------------------------------------------
#import "DBDetail.h"
#import "DBHeaderOrganizer.h"
#import "DBWikiWord.h"

//#import "DBNamedTopic.h"

#import "DBMainTopic.h"
#import "DBSubTopic.h"
//#import "NoteTaker_AppDelegate.h"
//#import "DBControllerOfOutlineViews.h"
//#import "DBDetailViewController.h"
//#import "DBUndoManager.h"

@implementation DBTopicObject

// Attributes -------------
@dynamic dateCreated;
@dynamic dateViewed;
@dynamic dateModified;
@dynamic displayName;
//@dynamic isGlobal;

// Relationships ----------
@dynamic details;
@dynamic headers;
@dynamic views;
//@dynamic wikiWords;


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromInsert
{
  
  [self setValue:[NSDate date] forKey:@"dateModified"];
  [self setValue:[NSDate date] forKey:@"dateCreated"];
  [self setValue:[NSDate date] forKey:@"dateViewed"];
  
  [super awakeFromInsert];

}



// -------------------------------------------------------------------------------

// wikiString

// -------------------------------------------------------------------------------

// just a stub for subtopics and main topics to use

- (NSString *) wikiString
{
  
  return NULL;
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isGlobal{
  //stub here
  // local and main topic should each return their own value
  return NULL;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isLeaf {
  //NSLog(@"Is it a leaf?");
  if (! [self isGlobal]) {
  
    return YES;
  
  } else {
    
    // ALL main topics should be kvo for subTopics
    NSSet * set = [self valueForKey:@"subTopics"];
    
    if (set.count > 0) {
    
      return NO;
    
    } else {
    
      return YES;
    
    }
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified and headers
// set header of detailview. ( this needs to be done here to update the name for undo/redo. specifically redo doesn't change the name back )

- (void) setDisplayName:(NSString *)displayName
{
  //NSLog(@"DBTopicObject - setDisplayName");

  
  /* // didn't work becouse undo redo changes value without going through this method
   // will try by binding vale in setHeader.
  if ([self isKindOfClass:[DBNamedTopic class]] || [self isKindOfClass:[DBSubTopic class]]) {
    
    NoteTaker_AppDelegate * appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSLog(@"check for redo...");

    if ([appDelegate.undoManager isRedoing]) {
      
      NSLog(@"is redoing");
      
      NSArray *detailViewControllerArray = appDelegate.controllerOfOutlineViews.detailViewControllerArray;
      
      for (DBDetailViewController *detailViewController in detailViewControllerArray) {

        if (detailViewController.topic == self) [detailViewController setHeader:self];
          
      }
        
    }
    
  }
  */
  [self willChangeValueForKey:@"displayName"];
  [self setPrimitiveValue:displayName forKey:@"displayName"];
  [self didChangeValueForKey:@"displayName"];
  
  self.dateModified = [NSDate date];
  
  for (DBHeaderOrganizer * header in self.headers) {

    header.displayName = displayName;
    
  }
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setHeaders:(NSSet *)headers
{
  
  [self willChangeValueForKey:@"headers"];
  [self setPrimitiveValue:headers forKey:@"headers"];
  [self didChangeValueForKey:@"headers"];
  
  self.dateModified = [NSDate date];
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setWikiWords:(NSSet *)wikiWords
{
  
  [self willChangeValueForKey:@"wikiWords"];
  [self setPrimitiveValue:wikiWords forKey:@"wikiWords"];
  [self didChangeValueForKey:@"wikiWords"];
  
  self.dateModified = [NSDate date];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// update dateModified

- (void) setDetails:(NSSet *)details
{
  
  [self willChangeValueForKey:@"details"];
  [self setPrimitiveValue:details forKey:@"details"];
  [self didChangeValueForKey:@"details"];
  
  self.dateModified = [NSDate date];
  
}


// -------------------------------------------------------------------------------

// rootSet

// -------------------------------------------------------------------------------

// get set; remove items from set whose parent is not null
// used for adding new item at end of list
// Other options here: would it be faster to do a search predicate?  eliminating topic of non-root items (would take some work and couldn't quickly reference topic in search tables)

- (NSSet *) rootSet
{
  
  NSMutableSet * rootSet = [NSMutableSet set];
  
  for (DBDetail * detail in self.details){
    
    if (detail.parent == nil){
      
      [rootSet addObject : detail];
      
    }
    
  }
  
  return rootSet;
  
}

/*
- (NSUInteger) rootCount
{
  
  return [[self rootSet] count];
  
}
*/

// -------------------------------------------------------------------------------

// formattedName

// -------------------------------------------------------------------------------

// subtopics will overwrite and put maintopic:subtopic here

- (NSString *) formattedName
{
  
    return self.displayName;
  
}


// -------------------------------------------------------------------------------

// tabbedName

// -------------------------------------------------------------------------------

// subtopic will overwrite and tab name over

- (NSString *) tabbedName
{
  
  return self.displayName;
  
}


// -------------------------------------------------------------------------------

// isWikiTopic

// -------------------------------------------------------------------------------

// stub to be implemented by Named and Subtopics
// sets whether detail view button is hidden

-(BOOL) isWikiTopic
{
  return NO;
}



// -------------------------------------------------------------------------------

// isFileTopic

// -------------------------------------------------------------------------------

// stub to be implemented by FileTopics
// sets whether detail view button is hidden

-(BOOL) isFileTopic
{
  return NO;
}



// -------------------------------------------------------------------------------

// isDateTopic

// -------------------------------------------------------------------------------

// stub to be implemented by DateTopics
// sets whether detail view button is hidden

-(BOOL) isDateTopic
{
  return NO;
}

@end
