//
//  DBEnableAddLocalTransformer.m
//  NoteTaker
//
//  Created by Dante on 11/22/13.
//
//


//---------------------------------------------
#import "DBEnableAddLocalTransformer.h"
//---------------------------------------------
#import "DBFolderOrganizer.h"
#import "DBTopicObject.h"


@implementation DBEnableAddLocalTransformer



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
  
  return [NSNumber class];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (BOOL)allowsReverseTransformation
{
  return NO;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (id)transformedValue:(id)value
{
  
  NSArray * objects = value;
  
  if (objects.count > 0) {
    
    
    id selectedObject = [(NSArray*)value objectAtIndex:0];
    
    //NSLog(@"selectedObject is a: %@", [selectedObject className]);
    
    if ([selectedObject isKindOfClass:[DBFolderOrganizer class]]) {
      
      return [NSNumber numberWithBool:NO];
      
    } else {
      
      DBTopicObject * topic = [selectedObject valueForKey:@"topic"];
      
      
      if (topic.isGlobal) {
        
        return [NSNumber numberWithBool:YES];
        
      } else {
        
        return [NSNumber numberWithBool:YES];
        
      }
      
    }
    
  } else { // no selection
    
    return [NSNumber numberWithBool:NO];
    
  }
  
}

@end
