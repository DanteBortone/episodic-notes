//
//  DBShadowControledTextFieldCell.m
//  NoteTaker
//
//  Created by Dante on 1/27/13.
//
//


//---------------------------------------------
#import "DBShadowControledTextFieldCell.h"
//---------------------------------------------


//static NSShadow *kShadow = nil;


@implementation DBShadowControledTextFieldCell

//REALLY struggled to get this to work.  it only sets the shadow for the disclosure button and not the text

+ (void)initialize
{
 // kShadow = [[NSShadow alloc] init];
 // [kShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.f alpha:0.08f]];
 // [kShadow setShadowBlurRadius:0.f];
 // [kShadow setShadowOffset:NSMakeSize(0.f, -2.f)];
}

/*
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  [kShadow set];
  [super drawInteriorWithFrame:cellFrame inView:controlView];
}
*/

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
 NSShadow *shadow = [[NSShadow alloc] init];
 [shadow setShadowOffset:NSMakeSize(0.f, -2.f)];
 [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.f alpha:0.08f]];
 [shadow setShadowBlurRadius:0.f];
  
  NSMutableParagraphStyle *paragStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragStyle setAlignment:[self alignment]];
  
  NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                              [self font],NSFontAttributeName,
                              shadow,NSShadowAttributeName,
                              [self textColor],NSForegroundColorAttributeName,
                              paragStyle,NSParagraphStyleAttributeName,nil];
  
  NSAttributedString *string = [[NSAttributedString alloc] initWithString:[self stringValue] attributes:attributes];
  [self setAttributedStringValue:string];
  [[self attributedStringValue] drawInRect:cellFrame];
}


@end
