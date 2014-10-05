/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBShadowlessTextFieldCell.h"
//---------------------------------------------


@implementation DBShadowlessTextFieldCell

//static NSShadow *kShadow = nil;
/*
+ (void)initialize
{
  kShadow = [[NSShadow alloc] init];
  [kShadow setShadowColor:[NSColor redColor]];
  [kShadow setShadowBlurRadius:1.0f];
  [kShadow setShadowOffset:NSMakeSize(0.f, -2.f)];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  [super drawInteriorWithFrame:cellFrame inView:controlView];

  [kShadow set];
  NSLog(@"doing something");
}
*/


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

- (void)setBackgroundStyle:(NSBackgroundStyle)style
{
  //[self set];
  //[super setBackgroundStyle:NSBackgroundStyleDark];
  
  //NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:  self.attributedStringValue.string];
  
  //[self setAttributedStringValue:attrString];

}



//-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{}

//-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{}

//-(void) drawWithExpansionFrame:(NSRect)cellFrame inView:(NSView *)view{}


@end
