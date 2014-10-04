//
//  DBShadowButtonView.m
//  Episodic Notes
//
//  Created by Dante Bortone on 6/8/14.
//
//

#import "DBShadowButton.h"

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
