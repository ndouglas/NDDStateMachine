//
//  NDDStateMachineState.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineState.Private.h"

typedef enum {
	NDDStateMachineStateError_None,
	NDDStateMachineStateError_AcceptorRefusedToAllowTransition,
} NDDStateMachineStateErrorType;

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

@implementation NDDStateMachineState
#undef __CLASS__
#define __CLASS__ "NDDStateMachineState"
@synthesize name;
@synthesize destinationsByEvent;
@synthesize acceptorsByEvent;
@synthesize beforeEnterHandler;
@synthesize afterEnterHandler;
@synthesize beforeExitHandler;
@synthesize afterExitHandler;
@synthesize beforeEnterBlocks;
@synthesize afterEnterBlocks;
@synthesize beforeExitBlocks;
@synthesize afterExitBlocks;

+ (instancetype)stateWithName:(NSString *)_name {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_name)
	NDD_ASSERT(_name)
	NDDStateMachineState *result = [[self alloc] initWithName:_name];
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;
}

- (instancetype)initWithName:(NSString *)_name {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_name)
	NDD_ASSERT(_name)
	self = [self init];
	if (self) {
		self.name = _name;
		self.destinationsByEvent = [NSMutableDictionary new];
		self.acceptorsByEvent = [NSMutableDictionary new];
		self.beforeEnterBlocks = [NSMutableSet new];
		self.afterEnterBlocks = [NSMutableSet new];
		self.beforeExitBlocks = [NSMutableSet new];
		self.afterExitBlocks = [NSMutableSet new];
		NDD_WEAKSELF
		self.beforeEnterHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.beforeEnterBlocks) {
				block();
			}
			NDD_TRACE_EXIT
		} copy];
		self.afterEnterHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.afterEnterBlocks) {
				block();
			}
			NDD_TRACE_EXIT
		} copy];
		self.beforeExitHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.beforeExitBlocks) {
				block();
			}
			NDD_TRACE_EXIT
		} copy];
		self.afterExitHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.afterExitBlocks) {
				block();
			}
			NDD_TRACE_EXIT
		} copy];
		NDD_TRACE_INIT
	}
	NDD_TRACE_OBJECT(self)
	NDD_TRACE_EXIT
	return self;
}

- (void)addDestination:(NSString *)_destination forEvent:(NSString *)_event onCondition:(NDDStateMachineAcceptorType)_condition {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_destination)
	NDD_TRACE_OBJECT(_event)
	NDD_TRACE_OBJECT(_condition)
	NDD_ASSERT(_destination)
	NDD_ASSERT(_destination.length)
	NDD_ASSERT(_event)
	NDD_ASSERT(_event.length)
	NDD_ASSERT(!self->destinationsByEvent[_event] || [self->destinationsByEvent[_event] isEqualToString:_destination])
	@synchronized (self) {
		self->destinationsByEvent[_event] = _destination;
		if (_condition) {
			if (!self->acceptorsByEvent[_event]) {
				self->acceptorsByEvent[_event] = [NSMutableSet set];
			}
			[self->acceptorsByEvent[_event] addObject:[_condition copy]];
		}
	}
	NDD_TRACE_EXIT
}

- (BOOL)shouldAllowTransitionViaEvent:(NSString *)_event error:(NSError **)_error {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_event)
	BOOL result = YES;
	NSSet *conditionSet = self->acceptorsByEvent[_event];
	dispatch_group_t group = dispatch_group_create();
	NSError *error;
	for (NDDStateMachineAcceptorType acceptor in conditionSet) {
		dispatch_group_enter(group);
		if (!acceptor(&error)) {
			result = NO;
			if (_error) {
				NSString *errorString = [NSString stringWithFormat:NSLocalizedString(@"State '%@' refused to allow a transition via the event '%@': %@.", nil), self.name, _event, error];
				*_error = [NSError errorWithDomain:NSStringFromClass(self.class)
					code:NDDStateMachineStateError_AcceptorRefusedToAllowTransition
					userInfo:@{ NSLocalizedDescriptionKey:errorString }];
			}
			break;
		}
	}
	NDD_TRACE_BOOLEAN(result)
	NDD_TRACE_ERROR(_error)
	NDD_TRACE_EXIT
	return result;
}

- (void)addBeforeEnterBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.beforeEnterBlocks addObject:_block];
	}
	NDD_TRACE_EXIT
}

- (void)addAfterEnterBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.afterEnterBlocks addObject:_block];
	};
	NDD_TRACE_EXIT
}

- (void)addBeforeExitBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.beforeExitBlocks addObject:_block];
	}
	NDD_TRACE_EXIT
}

- (void)addAfterExitBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.afterExitBlocks addObject:_block];
	}
	NDD_TRACE_EXIT
}

- (BOOL)isFinal {
	NDD_TRACE_ENTRY
	NSMutableSet *destinations = [NSMutableSet setWithArray:self.destinationsByEvent.allValues];
	[destinations minusSet:[NSSet setWithObject:self.name]];
	BOOL result = destinations.count == 0;
	NDD_TRACE_BOOLEAN(result)
	NDD_TRACE_EXIT
	return result;
}

#undef __CLASS__
@end
