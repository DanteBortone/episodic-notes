//
//  DBService.h
//  NoteTaker
//
//  Created by Dante on 10/18/13.
//
//

#import <Foundation/Foundation.h>

@class ScriptTaker_AppDelegate;

@interface DBService : NSObject{
    
    ScriptTaker_AppDelegate * appDelegate;

}


- (void)makeNote:(NSPasteboard *)pboard
             userData:(NSString *)userData error:(NSString **)error;

@end
