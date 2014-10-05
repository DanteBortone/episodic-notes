/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "NSButton_Extensions.h"
//---------------------------------------------


@implementation NSButton (DBExtensions)



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (NSColor *)textColor
{
  NSAttributedString *attrTitle = [self attributedTitle];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
  NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
  NSColor *textColor = [NSColor controlTextColor];
  if (attrs) {
    textColor = [attrs objectForKey:NSForegroundColorAttributeName];
  }
  return textColor;
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setTextColor:(NSColor *)textColor
{
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];

  //NSLog(@"attributedTitle: %@", [self attributedTitle]);
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSForegroundColorAttributeName
                    value:textColor
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)makeTextBold
{ 
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSFontAttributeName
                    value:[NSFont boldSystemFontOfSize:[[self font] pointSize]]
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
  
}


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)unmakeTextBold
{
  //NSLog(@"unmake text bold");
  NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                          initWithAttributedString:[self attributedTitle]];
  int len = (int)[attrTitle length];
  NSRange range = NSMakeRange(0, len);
  [attrTitle addAttribute:NSFontAttributeName
                    value:[NSFont systemFontOfSize:[[self font] pointSize]]
                    range:range];
  [attrTitle fixAttributesInRange:range];
  [self setAttributedTitle:attrTitle];
}

@end
