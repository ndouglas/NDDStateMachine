//
//  NDDStateMachineEvent.Private.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineEvent.h"

@interface NDDStateMachineEvent () {
	NSString *name;
	NDDBasicBlockType beforeHandler;
	NDDBasicBlockType afterHandler;
	NSMutableSet *beforeBlocks;
	NSMutableSet *afterBlocks;
}
@property (copy, nonatomic, readwrite) NDDBasicBlockType beforeHandler;
@property (copy, nonatomic, readwrite) NDDBasicBlockType afterHandler;
@property (strong, nonatomic, readwrite) NSMutableSet *beforeBlocks;
@property (strong, nonatomic, readwrite) NSMutableSet *afterBlocks;
@property (copy, nonatomic, readwrite) NSString *name;
- (instancetype)initWithName:(NSString *)_name;
@end
