//
//  DBDetail.h
//  NoteTaker
//
//  Created by Dante Bortone with Copyright on 12/23/12.
//  Copyright 2012 Dante Bortone. All rights reserved.
//


//#import <Cocoa/Cocoa.h>
#import "DBManagedTreeObject.h"


@class DBTopicObject;
@class DBTopicObject;
@class DBFileTopic;
@class DBOutputScript;


@interface DBDetail : DBManagedTreeObject

// Attributes -------------
@property (strong) NSDate * dateAssociated;
@property (strong) NSDate * dateCreated;
@property (strong) NSDate * dateModified;
@property (strong) NSNumber * isChecked;// 0 off, 1 on, -1 mixed
@property (strong) NSString * note;
@property (strong) NSString * outputValue;
@property (strong) NSData * image;
@property (strong) NSNumber *showSubGroupChecks;

// Relationships ----------
@property (strong) DBFileTopic * sourceFile;
@property (strong) DBTopicObject * topic;
@property (strong) DBOutputScript * outputScript;

//-(NSInteger) siblingCount;

-(void) updateCheckMark;

//- (Boolean)hasNote;

@end
