//
//  DBComboBoxCell.m
//  NoteTaker
//
//  Created by Dante on 3/5/13.
//
//


//---------------------------------------------
#import "DBComboBoxCell.h"
//---------------------------------------------


@implementation DBComboBoxCell

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSString *)completedString:(NSString *)string
{
  NSString *result = nil;
  
  if (string == nil)
    return result;
  
  for (NSString *item in self.objectValues) {
    NSString *truncatedString = [item substringToIndex:MIN(item.length, string.length)];
    if ([truncatedString caseInsensitiveCompare:string] == NSOrderedSame) {
      result = item;
      break;
    }
  }
  
  return result;
}

@end
