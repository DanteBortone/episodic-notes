//
//  DBGradientView.h
//  Episodic Notes
//
//  Created by Dante Bortone on 4/4/14.
//
//

#import <Cocoa/Cocoa.h>

@interface DBGradientView : NSView



// Define the variables as properties
@property(nonatomic, retain) NSColor *startingColor;
@property(nonatomic, retain) NSColor *endingColor;
@property(assign) int angle;

@end
