//
//  DBHighlightView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 6/8/14.
//
//

#import "DBHighlightView.h"

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
