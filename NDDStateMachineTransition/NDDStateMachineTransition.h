//
//  NDDStateMachineTransition.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDDStateMachine;
@class NDDStateMachineState;
@class NDDStateMachineEvent;
@protocol NDDStateMachineDataSource;

/**
 This class represents the transition between two states in a state machine.
 
 In practice, it's a more-or-less ephemeral object whose only purpose is to factor out a
 lot of ugly code from NDDStateMachine.
 */

@interface NDDStateMachineTransition : NSObject

/**
 Creates and returns an initialized instance of the class with the necessary values to
 compute and perform a transition.
 
 @param _stateMachine The involved state machine.
 @param _client The client managing the state machine.
 @param _current The current state of the state machine.
 @param _next The next state to enter.
 @param _event The event occurring.
 @param _block A completion handler.
 @return An initialized instance of the class.
 */

+ (instancetype)transitionForStateMachine:(NDDStateMachine *)_stateMachine client:(NSObject<NDDStateMachineDataSource> *)_client current:(NDDStateMachineState *)_current next:(NDDStateMachineState *)_next event:(NDDStateMachineEvent *)_event completionHandler:(NDDErrorHandlerType)_block;

/**
 Executes the transition.
 */

- (void)execute;

@end
