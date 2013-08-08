//
//  NDDStateMachineState.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDDStateMachineState : NSObject

/**
 The name of this state.
 */

@property (copy, nonatomic, readonly) NSString *name;

/**
 A list of destinations, sorted by the event that would cause a transition thereto.
 */

@property (strong, nonatomic, readonly) NSDictionary *destinationsByEvent;

/**
 A block executed before the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType beforeEnterHandler;

/**
 A block executed after the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType afterEnterHandler;

/**
 A block executed before the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType beforeExitHandler;

/**
 A block executed after the event is processed.
 */

@property (copy, nonatomic, readonly) NDDBasicBlockType afterExitHandler;

/**
 Is this block final?  In other words, does it have any non-self destinations?
 */

@property (assign, nonatomic, readonly, getter=isFinal) BOOL final;

/**
 Creates and returns a state with the specified name.

 @param _name The name of this state.
 @return An initialized instance of the class.
 */

+ (instancetype)stateWithName:(NSString *)_name;

/**
 Adds a block that will be executed before entry.
 
 @param _block A block.
 */

- (void)addBeforeEnterBlock:(NDDBasicBlockType)_block;

/**
 Adds a block that will be executed after entry.
 
 @param _block A block.
 */

- (void)addAfterEnterBlock:(NDDBasicBlockType)_block;

/**
 Adds a block that will be executed before exit.
 
 @param _block A block.
 */

- (void)addBeforeExitBlock:(NDDBasicBlockType)_block;

/**
 Adds a block that will be executed after exit.
 
 @param _block A block.
 */

- (void)addAfterExitBlock:(NDDBasicBlockType)_block;

/**
 Registers a condition under which the current state will be changed to the destination state.
 
 @param _destination The destination state.
 @param _event The event triggering the transition.
 @param _condition A condition under which the transition will occur.
 */

- (void)addDestination:(NSString *)_destination forEvent:(NSString *)_event onCondition:(NDDStateMachineAcceptorType)_condition;

/**
 Returns whether the specified transition should be allowed.
 
 @param _destination The destination.
 @param _event The event triggering the transaction.
 @return YES if the transition will be allowed, otherwise NO.
 */

- (BOOL)shouldAllowTransitionViaEvent:(NSString *)_event error:(NSError **)_error;

@end
