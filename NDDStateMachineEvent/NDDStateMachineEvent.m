//
//  NDDStateMachineEvent.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineEvent.Private.h"

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

@implementation NDDStateMachineEvent
#undef __CLASS__
#define __CLASS__ "NDDStateMachineEvent"
@synthesize name;
@synthesize beforeHandler;
@synthesize afterHandler;
@synthesize beforeBlocks;
@synthesize afterBlocks;

+ (instancetype)eventWithName:(NSString *)_name {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_name)
	NDD_ASSERT(_name)
	NDDStateMachineEvent *result = [[self alloc] initWithName:_name];
	NDD_TRACE_OBJECT(result)
	NDD_TRACE_EXIT
	return result;
}

- (instancetype)initWithName:(NSString *)_name {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_name)
	NDD_ASSERT(_name)
	self = [super init];
	if (self) {
		self.name = _name;
		self.beforeBlocks = [NSMutableSet set];
		self.afterBlocks = [NSMutableSet set];
		NDD_WEAKSELF
		self.beforeHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.beforeBlocks) {
				block();
			}
			NDD_TRACE_EXIT
		} copy];
		self.afterHandler = [^{
			NDD_TRACE_ENTRY
			NDD_STRONGSELF
			for (void(^block)(void) in self.afterBlocks) {
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

- (void)addBeforeBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.beforeBlocks addObject:_block];
	}
	NDD_TRACE_EXIT
}

- (void)addAfterBlock:(NDDBasicBlockType)_block {
	NDD_TRACE_ENTRY
	NDD_TRACE_OBJECT(_block)
	NDD_ASSERT(_block)
	@synchronized (self) {
		[self.afterBlocks addObject:_block];
	}
	NDD_TRACE_EXIT
}

#undef __CLASS__
@end
