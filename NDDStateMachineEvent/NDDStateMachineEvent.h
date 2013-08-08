//
//  NDDStateMachineEvent.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDDStateMachineEvent : NSObject

/**
 The name of this event.
 */

@property (copy, nonatomic, readonly) NSString *name;

/**
 A block executed before the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType beforeHandler;

/**
 A block executed after the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType afterHandler;

/**
 Creates and returns an event with the specified name.

 @param _name The name of this event.
 @return An initialized instance of the class.
 */

+ (instancetype)eventWithName:(NSString *)_name;

/**
 Adds a block that will be executed before the event is handled.
 
 @param _block A block.
 */

- (void)addBeforeBlock:(NDDBasicBlockType)_block;

/**
 Adds a block that will be executed after the event is handled.
 
 @param _block A block.
 */

- (void)addAfterBlock:(NDDBasicBlockType)_block;

@end