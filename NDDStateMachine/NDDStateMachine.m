//
//  NDDStateMachine.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachine.Private.h"
#import "NDDStateMachineEvent.h"
#import "NDDStateMachineState.h"
#import "NDDStateMachineTransitionFactory.h"

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

NDDStateMachineDefinitionType NDDStateMachineDefinition_Default = ^(NDDStateMachine *_stateMachine_, NDDErrorHandlerType _errorHandler_) {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_stateMachine_)
	NDD_TRACE_OBJECT(_errorHandler_)
	_errorHandler_(_stateMachine_ != nil, nil);
	NDD_TRACE_EXIT
};

NDDStateMachineAcceptorType NDDStateMachineAcceptor_Default = ^BOOL(NSError **_error_) {
	NDD_TRACE_ENTRY
	NDD_TRACE_POINTER(_error_)
	BOOL result = YES;	// Just say "OK" by default.
	NDD_TRACE_BOOLEAN(result)
	NDD_TRACE_EXIT
	return result;
};

NDDErrorHandlerType NDDStateMachineErrorHandler_Default = ^(BOOL _success_, NSError *_error_) {
	NDD_TRACE_ENTRY
	NDD_TRACE_BOOLEAN(_success_)
	NDD_TRACE_OBJECT(_error_)
	if (!_success_ && _error_) {
		// We don't do anything with an error by default.
	}
	NDD_TRACE_EXIT
};

@implementation NDDStateMachine
#undef __CLASS__
#define __CLASS__ "NDDStateMachine"
@synthesize eventDictionary;
@synthesize stateDictionary;
@synthesize initialState;
@synthesize transitionFactory;
@synthesize errorHandler;

+ (instancetype)stateMachineWithDefinition:(NDDStateMachineDefinitionType)_definition {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_definition)
	NDD_ASSERT(_definition)
	NDDStateMachine *result = [[self alloc] initWithDefinition:_definition];
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;
}

- (instancetype)initWithDefinition:(NDDStateMachineDefinitionType)_definition {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_definition)
	NDD_ASSERT(_definition)
	self = [super init];
	if (self) {
		if (!_definition) {
			_definition = NDDStateMachineDefinition_Default;
		}
		self.eventDictionary = [NSMutableDictionary new];
		self.stateDictionary = [NSMutableDictionary new];
		self.initialState = nil;
    self.transitionFactory = [NDDStateMachineTransitionFactory factoryForStateMachine:self];
		self.errorHandler = NDDStateMachineErrorHandler_Default;
		[self readStateMachineDefinition:_definition];
		NDD_TRACE_INIT
	}
	NDD_TRACE_OBJECT(self)
	NDD_TRACE_EXIT
	return self;
}

- (void)readStateMachineDefinition:(NDDStateMachineDefinitionType)_definition {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_definition)
	NDD_ASSERT(_definition)
	__block BOOL errorHandlerWasCalledInDefinition = NO;
	_definition(self, ^(BOOL _success_, NSError *_error_) {
		NDD_TRACE_ENTRY
		NDD_TRACE_BOOLEAN(_success_)
		NDD_TRACE_OBJECT(_error_)
		if (!_success_) {
			NDD_LOG(NSLocalizedString(@"Failed to construct state machine: %@", nil), _error_)
		}
		errorHandlerWasCalledInDefinition = YES;
		NDD_TRACE_EXIT
	});
	NDD_ASSERT(errorHandlerWasCalledInDefinition)
	NDD_TRACE_EXIT
}

- (void)addState:(NSString *)_state {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_state)
	NDD_ASSERT(_state)
	NDD_ASSERT(_state.length > 0)
	@synchronized (self) {
		if (!self.stateDictionary[_state]) {
			self.stateDictionary[_state] = [NDDStateMachineState stateWithName:_state];
		}
	}
	NDD_TRACE_EXIT
}

- (void)addEvent:(NSString *)_event {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_event)
	NDD_ASSERT(_event)
	NDD_ASSERT(_event.length > 0)
	@synchronized (self) {
		if (!self.eventDictionary[_event]) {
			self.eventDictionary[_event] = [NDDStateMachineEvent eventWithName:_event];
		}
	}
	NDD_TRACE_EXIT
}

- (void)client:(NSObject<NDDStateMachineDataSource> *)_client didInputEvent:(NSString *)_event completionHandler:(NDDErrorHandlerType)_block {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_client)
  NDD_TRACE_OBJECT(_event)
	NDD_ASSERT(_client)
	NDD_ASSERT(_event)
	NDD_ASSERT(_event.length > 0)
	NDD_ASSERT([self.alphabet containsObject:_event])
	@synchronized (self) {
		[self.transitionFactory performTransitionForClient:_client event:_event completionHandler:_block ?: self.errorHandler];
  }
  NDD_TRACE_EXIT
}

- (void)onEvent:(NSString *)_event exitState:(NSString *)_startState enterState:(NSString *)_endState ifCondition:(NDDStateMachineAcceptorType)_condition {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_startState)
	NDD_TRACE_OBJECT(_endState)
	NDD_TRACE_OBJECT(_condition)
	NDD_ASSERT(_event)
	NDD_ASSERT(_event.length)
	NDD_ASSERT(_startState)
	NDD_ASSERT(_startState.length)
	NDD_ASSERT(_endState)
	NDD_ASSERT(_endState.length)
	NDD_ASSERT(self.eventDictionary[_event])
	NDD_ASSERT(self.stateDictionary[_startState])
	NDD_ASSERT(self.stateDictionary[_endState])
	@synchronized (self) {
		[self.stateDictionary[_startState] addDestination:_endState forEvent:_event onCondition:_condition];
	}
	NDD_TRACE_EXIT
}

- (void)beforeEvent:(NSString *)_event performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.eventDictionary[_event])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineEvent *)self.eventDictionary[_event] addBeforeBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (void)afterEvent:(NSString *)_event performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.eventDictionary[_event])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineEvent *)self.eventDictionary[_event] addAfterBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (void)beforeEnteringState:(NSString *)_state performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_state)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.stateDictionary[_state])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineState *)self.stateDictionary[_state] addBeforeEnterBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (void)afterEnteringState:(NSString *)_state performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_state)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.stateDictionary[_state])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineState *)self.stateDictionary[_state] addAfterEnterBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (void)beforeExitingState:(NSString *)_state performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_state)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.stateDictionary[_state])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineState *)self.stateDictionary[_state] addBeforeExitBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (void)afterExitingState:(NSString *)_state performBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_state)
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(self.stateDictionary[_state])
	NDD_ASSERT(_block)
	@synchronized (self) {
		[(NDDStateMachineState *)self.stateDictionary[_state] addAfterExitBlock:_block];
	}
	NDD_TRACE_EXIT
}

- (NSSet *)alphabet {
	NDD_TRACE_ENTRY
	NSSet *result = [NSSet setWithArray:self.eventDictionary.allKeys];
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;
}

- (NSSet *)states {
	NDD_TRACE_ENTRY
	NSSet *result = [NSSet setWithArray:self.stateDictionary.allKeys];
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;	
}

- (NSString *)initial {
	NDD_TRACE_ENTRY
	NSString *result = self.initialState.name;
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;
}

- (void)setInitial:(NSString *)_initial {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_initial)
	NDD_ASSERT(self.stateDictionary[_initial])
	self.initialState = self.stateDictionary[_initial];
	NDD_TRACE_EXIT
}

#undef __CLASS__
@end
