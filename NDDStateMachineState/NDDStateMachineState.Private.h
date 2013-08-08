//
//  NDDStateMachineState.Private.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineState.h"

@interface NDDStateMachineState () {
	NSString *name;
	NSMutableDictionary *destinationsByEvent;
	NSMutableDictionary *acceptorsByEvent;
	NSMutableSet *beforeEnterBlocks;
	NSMutableSet *afterEnterBlocks;
	NSMutableSet *beforeExitBlocks;
	NSMutableSet *afterExitBlocks;
	NDDBasicBlockType beforeEnterHandler;
	NDDBasicBlockType afterEnterHandler;
	NDDBasicBlockType beforeExitHandler;
	NDDBasicBlockType afterExitHandler;
}
@property (copy, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSMutableDictionary *destinationsByEvent;
@property (strong, nonatomic, readwrite) NSMutableDictionary *acceptorsByEvent;
@property (copy, nonatomic, readwrite) NDDBasicBlockType beforeEnterHandler;
@property (copy, nonatomic, readwrite) NDDBasicBlockType afterEnterHandler;
@property (copy, nonatomic, readwrite) NDDBasicBlockType beforeExitHandler;
@property (copy, nonatomic, readwrite) NDDBasicBlockType afterExitHandler;
@property (strong, nonatomic, readwrite) NSMutableSet *beforeEnterBlocks;
@property (strong, nonatomic, readwrite) NSMutableSet *afterEnterBlocks;
@property (strong, nonatomic, readwrite) NSMutableSet *beforeExitBlocks;
@property (strong, nonatomic, readwrite) NSMutableSet *afterExitBlocks;
- (instancetype)initWithName:(NSString *)_name;
@end
