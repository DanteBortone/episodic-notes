//
//  DBClipboardObject.m
//  Episodic Notes
//
//  Created by Dante Bortone on 3/6/14.
//
//

#import "DBObjectClipboard.h"
#import "DBManagedTreeObject.h"
#import "DBDetail.h"

@implementation DBObjectClipboard

// Relationships ----------
@dynamic items;

// -------------------------------------------------------------------------------

// flattenedContent

// -------------------------------------------------------------------------------

- (NSArray *) flattenedContent
{
  
  NSMutableArray * returnItems = [ NSMutableArray array ];
  
  for ( DBManagedTreeObject * object in self.items ) {
  
    [returnItems addObjectsFromArray:[object flattenedWithSubGroups]];
  
  }
  
  return [ NSArray arrayWithArray: returnItems ];
  
}

// -------------------------------------------------------------------------------

// orderedContent

// -------------------------------------------------------------------------------

//returns array of clipboard items which have been ordered by sortIndex

- (NSArray *) orderedContent
{
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortIndex" ascending:YES];
  
  return [self.items.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
}

// -------------------------------------------------------------------------------

// containsDetailObjects

// -------------------------------------------------------------------------------

// returns NULL if there are no items on clipboard

- (BOOL) containsDetailObjects
{
  
  if (self.items.count > 0) {
    
    DBManagedTreeObject * sampleObject = [self.items anyObject];
    
    if ([sampleObject isKindOfClass:[DBDetail class]]) {
      
      return YES;
      
    } else {
      
      return NO;
    }
    
  } else {
    
    return NULL;
  }
  
  
}


@end
