//
//  NDDStateMachineTransitionFactory.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDDStateMachine;
@protocol NDDStateMachineDataSource;

/**
 This class is a simple factory that produces NDDStateMachineTransition objects for its
 parent NDDStateMachine object.
 */

@interface NDDStateMachineTransitionFactory : NSObject

/**
 Initializes the transition factory and associates it with the specified state machine.
 
 @param _stateMachine The controlling state machine.
 @return An initialized instance of the class.
 */

+ (instancetype)factoryForStateMachine:(NDDStateMachine *)_stateMachine;

/**
 Attempts a transition for the specified event on the factory's owner's client.
 
 @param _client The factory's owner's client.
 @param _event The event.
 @param _block A completion handler.
 */

- (void)performTransitionForClient:(NSObject<NDDStateMachineDataSource> *)_client event:(NSString *)_event completionHandler:(NDDErrorHandlerType)_block;

@end
