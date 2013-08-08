//
//  NDDStateMachineTransitionFactory.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineTransitionFactory.Private.h"
#import "NDDStateMachine.h"
#import "NDDStateMachine.Private.h"
#import "NDDStateMachineDataSource.h"
#import "NDDStateMachineEvent.h"
#import "NDDStateMachineState.h"
#import "NDDStateMachineTransition.h"

typedef enum {
  NDDStateMachineTransitionFactoryError_None,
  NDDStateMachineTransitionFactoryError_NoSuchEvent,
	NDDStateMachineTransitionFactoryError_UnrecognizedEvent,
} NDDStateMachineTransitionFactoryErrorType;

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

@implementation NDDStateMachineTransitionFactory
#undef __CLASS__
#define __CLASS__ "NDDStateMachineTransitionFactory"
@synthesize stateMachine;

+ (instancetype)factoryForStateMachine:(NDDStateMachine *)_stateMachine {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_stateMachine)
  NDDStateMachineTransitionFactory *result = [[self alloc] initWithStateMachine:_stateMachine];
  NDD_TRACE_OBJECT(result)
  NDD_TRACE_EXIT
  return result;
}

- (instancetype)initWithStateMachine:(NDDStateMachine *)_stateMachine {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_stateMachine)
  self = [super init];
  if (self) {
    self.stateMachine = _stateMachine;
    NDD_TRACE_INIT
  }
  NDD_TRACE_OBJECT(self)
  NDD_TRACE_EXIT
  return self;
}

- (void)performTransitionForClient:(NSObject<NDDStateMachineDataSource> *)_client event:(NSString *)_event completionHandler:(NDDErrorHandlerType)_block {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_client)
  NDD_TRACE_OBJECT(_event)
	NDD_ASSERT(_block)
  @synchronized (self.stateMachine) {
    NDDStateMachineEvent *event = self.stateMachine.eventDictionary[_event];
    if (event) {
      NSString *currentName = [_client currentStateForStateMachine:self.stateMachine];
      NDDStateMachineState *current = !currentName ? self.stateMachine.initialState : self.stateMachine.stateDictionary[currentName];
      NSString *nextName = current.destinationsByEvent[_event];
      NDDStateMachineState *next = self.stateMachine.stateDictionary[nextName];
			if (next) {
				NDDStateMachineTransition *transition = [NDDStateMachineTransition transitionForStateMachine:self.stateMachine client:_client current:current next:next event:event completionHandler:_block];
				[transition execute];
			} else {
				NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
				  code:NDDStateMachineTransitionFactoryError_UnrecognizedEvent
					userInfo:@{
						NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Could not perform the transition because the state '%@' does not recognize the event '%@'.", nil), currentName, _event],
				}];
				_block(NO, error);
			}
    } else {
			NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
				code:NDDStateMachineTransitionFactoryError_NoSuchEvent
				userInfo:@{
					NSLocalizedDescriptionKey: NSLocalizedString(@"Could not perform the transition because the state machine does not recognize the event.", nil),
			}];
      _block(NO, error);
    }
  }
  NDD_TRACE_EXIT
}

#undef __CLASS__
@end
