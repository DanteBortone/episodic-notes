/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


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
