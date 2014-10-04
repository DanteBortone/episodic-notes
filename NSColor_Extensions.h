//
//  NSColor_Extensions.h
//  NoteTaker
//
//  Created by Dante on 6/30/13.
//
//


#import <Cocoa/Cocoa.h>


@interface NSColor (DBExtensions)

//make option for link color
//move to NSColor extensions
+ (NSColor *)colorForKey:(NSString *)key;
- (void)setColor:(NSColor *)color forKey:(NSString *)key;

// from BWToolKit
//  Use this method to draw 1 px wide lines independent of scale factor. Handy for resolution independent drawing. Still needs some work - there are issues with drawing at the edges of views.
- (void)bwDrawPixelThickLineAtPosition:(int)posInPixels withInset:(int)insetInPixels inRect:(NSRect)aRect inView:(NSView *)view horizontal:(BOOL)isHorizontal flip:(BOOL)shouldFlip;


@end
