/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "NSMutableAttributedString_Extensions.h"
//---------------------------------------------


@implementation NSMutableAttributedString (DBExtensions)


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)changeFontSize:(CGFloat)size;
{
  NSFontManager * fontManager = [NSFontManager sharedFontManager];

  [self enumerateAttribute:NSFontAttributeName
                          inRange:NSMakeRange(0, [self length])
                          options:0
                       usingBlock:^(id value,
                                    NSRange range,
                                    BOOL * stop)
   {
     NSFont * font = value;
     font = [fontManager convertFont:font
                              toSize:size];
     if (font != nil) {
       [self removeAttribute:NSFontAttributeName
                              range:range];
       [self addAttribute:NSFontAttributeName
                           value:font
                           range:range];
     }
   }];

}


@end
