/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBHighlightView.h"
//---------------------------------------------


@implementation DBHighlightView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // Initialization code here.
      self.activeView = false;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{

  [super drawRect:dirtyRect];

  if (self.activeView) {
    //NSLog(@"drawing blue");

    // not really using it as a gradient at this time
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithDeviceRed:(float)233/255 green:(float)243/255 blue:(float)255/255 alpha:1.0], 0.0,
                            [NSColor colorWithDeviceRed:(float)233/255 green:(float)243/255 blue:(float)255/255 alpha:1.0], 1.0, nil];
    
    NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    
    [gradient drawInBezierPath:selectionPath angle:90];
  
  } else {
    //NSLog(@"drawing grey");
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor lightGrayColor], 0.0,
                            [NSColor lightGrayColor], 1.0, nil];
    
    NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    
    [gradient drawInBezierPath:selectionPath angle:90];
    
  }

  
  
}

@end
