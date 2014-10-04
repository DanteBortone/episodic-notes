//
//  DBRootObjectsTransformer.m
//  NoteTaker
//
//  Created by Dante on 6/28/13.
//
//


//---------------------------------------------
#import "DBRootObjectsTransformer.h"
//---------------------------------------------
#import "DBDetail.h"
#import "DBTopicObject.h"


@implementation DBRootObjectsTransformer

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)awakeFromNib

{
  //appDelegate = (NoteTaker_AppDelegate *)[[NSApplication sharedApplication] delegate];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (Class)transformedValueClass
{
  return [NSMutableSet class];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return YES;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{
  
  NSMutableSet * returnSet = [NSMutableSet set];
  
  for (DBDetail * item in (NSSet *) value){
    
    if (item.parent == nil) {
      
      [returnSet addObject:item];

    }
    
  }
      
  return returnSet;//[NSSet setWithSet:returnSet];
    
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//don't know if this is needed 

- (id)reverseTransformedValue:(id)value
{
  
  DBDetail * item = [(NSSet *)value anyObject];

  return [NSMutableSet setWithSet:item.topic.details];
  
}


@end
