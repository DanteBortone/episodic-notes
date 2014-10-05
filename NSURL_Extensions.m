/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "NSURL_Extensions.h"
//---------------------------------------------


@implementation NSURL (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (BOOL) isAlias{
  NSError *error = nil;
  id isAlias;
  
  [self getResourceValue:&isAlias forKey:NSURLIsAliasFileKey error:&error];
  if (error != nil){
    NSLog(@"getResourceValue error is: %@",error);
    error = nil;
  }
  
  // 0 for alias 1 for file
  if ([isAlias intValue] == 1) {
    
    //NSLog(@"Selection is an alias. Insufficient entitlements to resolve alias target.");
    
    return YES;
    
  } else {
    
    return NO;
  }

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

//returns targetURL from alias at aliasURL
//this works on items in sandbox but not outside of there
//doesn't need to be recursive for alias created from alias
- (NSURL *) getAliasTargetURL{
  
  NSData * bookmark;
  NSError * error;
  error = nil;
  NSURL * targetURL;
  
  //NSLog(@"original URL: %@", [self path]);
  //needs to do something if link is dead
  bookmark = [NSURL bookmarkDataWithContentsOfURL:self error:&error];
  if (error != nil) {
    //NSLog(@"getAliasTargetURL bookmarkDataWithContentsOfURL error: %@", error);
    return self;
  }
  // i've seen this error for microsoft silverlight and mocrosoft office x in application folder: getAliasTargetURL bookmarkDataWithContentsOfURL error: Error Domain=NSPOSIXErrorDomain Code=21 "The operation couldn’t be completed. Is a directory"
  
  
  targetURL = [NSURL URLByResolvingBookmarkData:bookmark options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NO error:&error];
  if (error != nil) {
    //NSLog(@"getAliasTargetURL URLByResolvingBookmarkData error: %@", error);
    return self;
  }
  
  //NSLog(@"target URL: %@", [targetURL lastPathComponent]);

  return targetURL;
  //returns null if file has been deleted
}


@end
