//
//  NDDStateMachineTransition.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineTransition.Private.h"
#import "NDDStateMachine.h"
#import "NDDStateMachineEvent.h"
#import "NDDStateMachineState.h"
#import "NDDStateMachineDataSource.h"

typedef enum {
  NDDStateMachineTransitionError_None,
  NDDStateMachineTransitionError_EventAcceptorRefusedToAllowTheTransition,
} NDDStateMachineTransitionErrorType;

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

@implementation NDDStateMachineTransition
#undef __CLASS__
#define __CLASS__ "NDDStateMachineTransition"
@synthesize stateMachine;
@synthesize client;
@synthesize current;
@synthesize next;
@synthesize event;
@synthesize blocks;
@synthesize errorHandler;

+ (instancetype)transitionForStateMachine:(NDDStateMachine *)_stateMachine client:(NSObject<NDDStateMachineDataSource> *)_client current:(NDDStateMachineState *)_current next:(NDDStateMachineState *)_next event:(NDDStateMachineEvent *)_event completionHandler:(NDDErrorHandlerType)_block {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_stateMachine)
  NDD_TRACE_OBJECT(_client)
  NDD_TRACE_OBJECT(_current)
  NDD_TRACE_OBJECT(_next)
  NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_block)
  NDDStateMachineTransition *result = [[self alloc] initWithStateMachine:_stateMachine client:_client current:_current next:_next event:_event completionHandler:(NDDErrorHandlerType)_block];
  NDD_TRACE_OBJECT(result)
  NDD_TRACE_EXIT
  return result;
}

- (instancetype)initWithStateMachine:(NDDStateMachine *)_stateMachine client:(NSObject<NDDStateMachineDataSource> *)_client current:(NDDStateMachineState *)_current next:(NDDStateMachineState *)_next event:(NDDStateMachineEvent *)_event completionHandler:(NDDErrorHandlerType)_block {
  NDD_TRACE_ENTRY
  NDD_TRACE_OBJECT(_stateMachine)
  NDD_TRACE_OBJECT(_client)
  NDD_TRACE_OBJECT(_current)
  NDD_TRACE_OBJECT(_next)
  NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_block)
  NDD_ASSERT(_stateMachine)
  NDD_ASSERT(_client)
  NDD_ASSERT(_current)
  NDD_ASSERT(_next)
  NDD_ASSERT(_event)
  NDD_ASSERT([_stateMachine isKindOfClass:[NDDStateMachine class]])
  NDD_ASSERT([_current isKindOfClass:[NDDStateMachineState class]])
  NDD_ASSERT([_next isKindOfClass:[NDDStateMachineState class]])
  NDD_ASSERT([_event isKindOfClass:[NDDStateMachineEvent class]])
  self = [super init];
  if (self) {
    self.stateMachine = _stateMachine;
    self.client = _client;
    self.current = _current;
    self.next = _next;
    self.event = _event;
		_block = [_block copy];
    self.errorHandler = ^(BOOL _success_, NSError *_error_) {
      NDD_TRACE_ENTRY
      NDD_TRACE_BOOLEAN(_success_)
      NDD_TRACE_OBJECT(_error_)
			if (_block) {
				_block(_success_, _error_);
			} else if (!_success_) {
				NDD_TRACE_OBJECT(_error_)
			}
      NDD_TRACE_EXIT
    };
    NDD_TRACE_INIT
  }
  NDD_TRACE_OBJECT(self)
  NDD_TRACE_EXIT
  return self;
}

- (void)execute {
  NDD_TRACE_ENTRY
  @synchronized (self.stateMachine) {
		NSError *error;
		if ([self.current shouldAllowTransitionViaEvent:self.event.name error:&error]) {
			self.event.beforeHandler();
			self.current.beforeExitHandler();
			self.next.beforeEnterHandler();
			self.current.afterExitHandler();
			[self.client setCurrentState:self.next.name forStateMachine:self.stateMachine];
			self.next.afterEnterHandler();
			self.event.afterHandler();
			self.errorHandler(YES, nil);
		} else {
			error = [NSError errorWithDomain:NSStringFromClass(self.class)
				code:NDDStateMachineTransitionError_EventAcceptorRefusedToAllowTheTransition
				userInfo:@{
					NSUnderlyingErrorKey : error,
					NSLocalizedDescriptionKey : NSLocalizedString(@"The acceptor refused to allow the transition.",nil),
			}];
			self.errorHandler(NO, error);
		}
  }
  NDD_TRACE_EXIT
}

#undef __CLASS__
@end
