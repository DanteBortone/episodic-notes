//
//  DBRecentDateTransformer.m
//  Episodic Notes
//
//  Created by Dante Bortone on 2/8/14.
//
//


//---------------------------------------------
#import "DBRecentDateTransformer.h"
//---------------------------------------------
#import "NSDate_Extensions.h"


@implementation DBRecentDateTransformer

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
  NSDate *thisDate = value;
  
  NSDateFormatter *dateFormat;
  dateFormat = [[NSDateFormatter alloc] init];
  
  NSString * returnString;
  
  if ([thisDate isToday]) {
    
    [dateFormat setDateFormat:@"h:mm a"];
    
    returnString = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:thisDate]];

  //} else if ([thisDate isSameYearAsDate:[NSDate date]]){
    
    //[dateFormat setDateFormat:@"M/d"];
  
  } else {
    
    [dateFormat setDateFormat:@"M/d/yy"];
    
    returnString = [dateFormat stringFromDate:thisDate];
    
  }

  return returnString;

}

@end
