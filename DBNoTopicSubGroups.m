//
//  DBTopicHasSubGroups.m
//  NoteTaker
//
//  Created by Dante on 11/28/13.
//
//


//---------------------------------------------
#import "DBNoTopicSubGroups.h"
//---------------------------------------------
#import "DBSubTopic.h"
#import "DBMainTopic.h"


@implementation DBNoTopicSubGroups


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
    
  if ([value isKindOfClass:[DBSubTopic class]]) {
  
    return [NSNumber numberWithBool:NO];
  
  } else {
    
    DBMainTopic * mainTopic = value;
    
    if (mainTopic.subTopics.count > 0) {
      
      return [NSNumber numberWithBool:NO];
    
    } else {
    
      return [NSNumber numberWithBool:YES];
    
    }
    
  }
  
}


@end
