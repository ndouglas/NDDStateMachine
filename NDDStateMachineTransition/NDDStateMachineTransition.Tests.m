//
//  NDDStateMachineTransition.Tests.m
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NDDStateMachineTransition.Private.h"

#undef NDD_OPTION_BASE_DEBUG_TRACE_LOCAL
#define NDD_OPTION_BASE_DEBUG_TRACE_LOCAL										FALSE

@interface NDDStateMachineTransitionTests : SenTestCase
@end

@implementation NDDStateMachineTransitionTests
#undef __CLASS__
#define __CLASS__ "NDDStateMachineTransitionTests"

- (void)setUp {
	NDD_TRACE_ENTRY
	[super setUp];
	NDD_TRACE_EXIT
}

- (void)tearDown {
	NDD_TRACE_ENTRY
	[super tearDown];
	NDD_TRACE_EXIT
}

- (void)test {
	NDD_TRACE_ENTRY
	/*
		Run a test here.
	*/
	NDD_TRACE_EXIT
}

#undef __CLASS__
@end
