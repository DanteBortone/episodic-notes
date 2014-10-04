//
//  DBDetailOutlineViewDelegate.h
//  NoteTaker
//
//  Created by Dante on 4/15/13.
//
//


#import "DBOutlineViewDelegate.h"


@interface DBDetailOutlineViewDelegate : DBOutlineViewDelegate {
  
  NSTextView * textView; //for measuring the height of the rows
  
}

@end
