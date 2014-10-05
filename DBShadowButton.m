/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBShadowButton.h"
//---------------------------------------------


@implementation DBShadowButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  
  //NSColor * shadowColor = [NSColor colorWithDeviceRed:(float)206/255 green:(float)222/255 blue:(float)230/255 alpha:1.0];
  NSColor * shadowColor = [NSColor colorWithDeviceRed:(float)0/255 green:(float)128/255 blue:(float)255/255 alpha:1.0];

  NSShadow *shadow = [[NSShadow alloc] init];
  [shadow setShadowColor:shadowColor];
  [shadow setShadowOffset:NSMakeSize(0, 0)];
  [shadow setShadowBlurRadius:3];
  [shadow set];
  
  NSLog(@"draw");

  [super drawRect:dirtyRect];

}

@end
