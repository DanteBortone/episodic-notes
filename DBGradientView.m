//
//  DBGradientView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 4/4/14.
//
//

#import "DBGradientView.h"

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
