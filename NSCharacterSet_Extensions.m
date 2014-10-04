//
//  NSCharacterSet_Extensions.m
//  NoteTaker
//
//  Created by Dante on 3/1/13.
//
//


//---------------------------------------------
#import "NSCharacterSet_Extensions.h"
//---------------------------------------------


@implementation NSCharacterSet (DBExtensions)



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (NSCharacterSet *) wikiCharacterSet{
  
 return [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//just adds a space to wikiCharacterSet

+ (NSCharacterSet *) topicNameCharacterSet{
  
  NSMutableCharacterSet * returnSet;
  
  returnSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
  
  [returnSet formUnionWithCharacterSet:[self wikiCharacterSet]];
  
  return returnSet;

}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

+ (NSCharacterSet *) endEditingCharacterSet{
  
  NSMutableCharacterSet * returnSet;
  
  returnSet = [NSCharacterSet characterSetWithCharactersInString:@"\t"];
  
  [returnSet formUnionWithCharacterSet:[self newlineCharacterSet]];
  
  return returnSet;
  
}

@end
