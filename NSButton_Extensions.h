//
//  NSButton.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 8/12/12.
//  Copyright 2012 UNC-Chapel Hill. All rights reserved.
//
//textcolor and settextcolor from: www.developers-life.com


#import <Cocoa/Cocoa.h>


@interface NSButton (DBExtensions)

- (NSColor *)textColor;
- (void)setTextColor:(NSColor *)textColor;
- (void)makeTextBold;
- (void)unmakeTextBold;

@end