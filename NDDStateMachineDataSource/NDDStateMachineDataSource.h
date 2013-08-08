//
//  NDDStateMachineDataSource.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

@class NDDStateMachine;

/**
 A protocol defining how state machine clients store data.
 */

@protocol NDDStateMachineDataSource <NSObject>

/**
 The current state of the delegate.
 
 @param _stateMachine The state machine making the request.
 @return The name of the current state.
 */

- (NSString *)currentStateForStateMachine:(NDDStateMachine *)_stateMachine;

/**
 Sets the current state of the delegate.
 
 @param _state The state to set.
 @param _stateMachine The state machine making the request.
 */

- (void)setCurrentState:(NSString *)_state forStateMachine:(NDDStateMachine *)_stateMachine;

@end
