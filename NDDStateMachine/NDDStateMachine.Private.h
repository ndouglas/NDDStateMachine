//
//  NDDStateMachine.Private.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachine.h"

@class NDDStateMachineState;
@class NDDStateMachineTransitionFactory;

@interface NDDStateMachine () {
	NSMutableDictionary *eventDictionary;
	NSMutableDictionary *stateDictionary;
	NDDStateMachineState *initialState;
  NDDStateMachineTransitionFactory *transitionFactory;
	NDDErrorHandlerType errorHandler;
}
@property (strong, nonatomic, readwrite) NSMutableDictionary *eventDictionary;
@property (strong, nonatomic, readwrite) NSMutableDictionary *stateDictionary;
@property (strong, nonatomic, readwrite) NDDStateMachineState *initialState;
@property (strong, nonatomic, readwrite) NDDStateMachineTransitionFactory *transitionFactory;
- (instancetype)initWithDefinition:(NDDStateMachineDefinitionType)_definition;
@end
