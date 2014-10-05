/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBGradientView.h"
//---------------------------------------------


@implementation DBGradientView

@synthesize startingColor;
@synthesize endingColor;
@synthesize angle;

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code here.
    [self setStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    [self setEndingColor:nil];
    [self setAngle:270];
  }
  return self;
}

- (void)drawRect:(NSRect)rect {
  if (endingColor == nil || [startingColor isEqual:endingColor]) {
    // Fill view with a standard background color
    [startingColor set];
    NSRectFill(rect);
  }
  else {
    // Fill view with a top-down gradient
    // from startingColor to endingColor
    NSGradient* aGradient = [[NSGradient alloc]
                             initWithStartingColor:startingColor
                             endingColor:endingColor];
    [aGradient drawInRect:[self bounds] angle:angle];
  }
}

@end
