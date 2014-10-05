/*
 
 Episodic Notes: A personal wiki, note taking app for Mac OSX. Create notes through any application on your computer and keep them in one place.
 
 Copyright (C) 2014. Dante Bortone
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 */


//---------------------------------------------
#import "DBTableRowView.h"
//---------------------------------------------

#import "DBTableCellTextView.h"
#import "DBOutlineView.h"
#import "DBOutlineViewController.h"

//---------------------------------------------


@implementation DBTableRowView


// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

// keeps selection on drag but messes up other things

-(void)drawBackgroundInRect:(NSRect)dirtyRect
{

  //NSLog(@"drawBackgroundInRect");

  NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
  
  [self drawBackgroundFill:selectionRect];
  [self drawBackgroundOutline:selectionRect];

}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void) drawBackgroundFill:(NSRect) selectionRect{
  
  NSBezierPath * selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
  
  [selectionPath fill];
  
  [[self backgroundColor] setFill];
  
  [selectionPath fill];
  
}



// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)drawBackgroundOutline:(NSRect) selectionRect{
  
  NSBezierPath * selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:6.0 yRadius:6.0];
  
  NSColor * pathColor = [NSColor lightGrayColor];
  
  [selectionPath setLineWidth: 0.5];
  [pathColor set];
  [selectionPath stroke];
  
  
}

// -------------------------------------------------------------------------------

//

// -------------------------------------------------------------------------------

-(void)drawSelectionInRect:(NSRect)dirtyRect
{
  //NSLog(@"DBTableRowView : drawSelectionInRect");
  NSGradient *gradient;

  if (self.backgroundColor == [NSColor whiteColor]) { //if it's the acitive view
    
    gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed:(float)233/255 green:(float)243/255 blue:(float)255/255 alpha:1.0], 0.0,
                [NSColor colorWithDeviceRed:(float)206/255 green:(float)222/255 blue:(float)230/255 alpha:1.0], 1.0, nil];
    
  } else {
    
    gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed:(float)235/255 green:(float)235/255 blue:(float)235/255 alpha:1.0], 0.0,
                [NSColor colorWithDeviceRed:(float)215/255 green:(float)215/255 blue:(float)215/255 alpha:1.0], 1.0, nil];
    
  }
  
  
  NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
  
  NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
  
  [gradient drawInBezierPath:selectionPath angle:90];
  
}

@end
