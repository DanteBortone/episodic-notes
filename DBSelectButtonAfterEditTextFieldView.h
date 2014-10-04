//
//  DBSelectButtonAfterEditTextFieldView.h
//  Episodic Notes
//
//  Created by Dante Bortone on 4/7/14.
//
//

#import <Cocoa/Cocoa.h>
#import "DBEnterEnabledButton.h"

@interface DBSelectButtonAfterEditTextFieldView : NSTextField{

  IBOutlet DBEnterEnabledButton * buttonToSelect;

}

@end
