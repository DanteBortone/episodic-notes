//
//  DBTopicNameTransformer.m
//  NoteTaker
//
//  Created by Dante on 11/29/13.
//
//


//---------------------------------------------
#import "DBTopicNameTransformer.h"
//---------------------------------------------
#import "DBSubTopic.h"
#import "DBMainTopic.h"


@implementation DBTopicNameTransformer

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
  
  return [NSString class];
  
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
  
  if ([value isKindOfClass:[DBMainTopic class]]) {

    DBMainTopic * mainTopic = value;
    
    return [NSString stringWithFormat:@"%@", mainTopic.displayName];
    
  } else {
    
    DBSubTopic * subTopic = value;
    
    return [NSString stringWithFormat:@"%@ : %@", subTopic.mainTopic.displayName, subTopic.displayName];


  }
  
}

@end
