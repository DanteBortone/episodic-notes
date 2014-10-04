//
//  DBUnderlineLabelFormatter.h
//  NoteTaker
//
//  Created by Dante on 10/5/13.
//
//

#import <Foundation/Foundation.h>

@class NoteTaker_AppDelegate;

@interface DBUnderlineLabelFormatter : NSFormatter{
  
  NSDictionary * attributes;
  NoteTaker_AppDelegate *appDelegate; //for subclasses to access activeTree

}

@end
