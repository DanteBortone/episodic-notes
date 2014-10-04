//
//  DBTableRowView.m
//  NoteTaker
//
//  Created by Angela Bortone on 8/16/13.
//
//


//---------------------------------------------
#import "DBTableRowView.h"
//---------------------------------------------
#import "DBTableCellTextView.h"
#import "DBOutlineView.h"
#import "DBOutlineViewController.h"


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
