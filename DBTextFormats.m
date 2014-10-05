/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTextFormats.h"
//---------------------------------------------


@implementation DBTextFormats

// -------------------------------------------------------------------------------

// init

// -------------------------------------------------------------------------------

// initialized by appDelegate as textFormatter
- (id)init
{
  self = [super init];
  if (self) {
    
  }
  
  return self;
}


// -------------------------------------------------------------------------------

// menuTextAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *)menuTextAttributes
{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSFont systemFontOfSize:14.0], NSFontAttributeName,
          nil];
  
}

// -------------------------------------------------------------------------------

// plainTextAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *)   plainTextAttributes{
  
  NSMutableParagraphStyle * myStyle = [[NSMutableParagraphStyle alloc] init];
  [myStyle setLineSpacing:-1.0];
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
            [NSFont systemFontOfSize:11.0], NSFontAttributeName,
            myStyle, NSParagraphStyleAttributeName,
            nil];
  
}

// -------------------------------------------------------------------------------

// localHyperlinkAttributes

// -------------------------------------------------------------------------------

- (NSDictionary *) localHyperlinkAttributes{
  
  NSColor *  localHyperlinkColor = [NSColor colorWithCalibratedRed:(float)210/255 green:(float)69/255 blue:(float)0/255 alpha:1.0];
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          localHyperlinkColor,NSForegroundColorAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          nil];
  
}

// -------------------------------------------------------------------------------

// globalHyperlinkAttributes

// -------------------------------------------------------------------------------

-(NSDictionary *)   globalHyperlinkAttributes{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSColor blueColor],NSForegroundColorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          nil];
  
}


// -------------------------------------------------------------------------------

// modelHyperlinkAttributes

// -------------------------------------------------------------------------------

-(NSDictionary *)   modelHyperlinkAttributes{
  
  return [[NSDictionary alloc]initWithObjectsAndKeys:
          self.textShadow, NSShadowAttributeName,
          [NSCursor pointingHandCursor], NSCursorAttributeName,
          [NSColor blueColor],NSForegroundColorAttributeName,
          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
          @"model", @"wikiWordURL",
          nil];

}

// -------------------------------------------------------------------------------

// textShadow

// -------------------------------------------------------------------------------


-(NSShadow *) textShadow{
  
  NSShadow *shadow = [[NSShadow alloc] init];
  [shadow setShadowColor:[NSColor whiteColor]];
  [shadow setShadowBlurRadius:3];
  [shadow setShadowOffset:NSMakeSize(2, -1)];
  
  return shadow;
  
}


@end
