//
//  NDDStateMachineTransition.Private.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineTransition.h"

@interface NDDStateMachineTransition () {
  NDDStateMachine *stateMachine;
  NSObject<NDDStateMachineDataSource> *client;
  NDDStateMachineState *current;
  NDDStateMachineState *next;
  NDDStateMachineEvent *event;
  NDDErrorHandlerType errorHandler;
}
@property (strong, nonatomic, readwrite) NDDStateMachine *stateMachine;
@property (strong, nonatomic, readwrite) NSObject<NDDStateMachineDataSource> *client;
@property (strong, nonatomic, readwrite) NDDStateMachineState *current;
@property (strong, nonatomic, readwrite) NDDStateMachineState *next;
@property (strong, nonatomic, readwrite) NDDStateMachineEvent *event;
@property (copy, nonatomic, readwrite) NDDErrorHandlerType errorHandler;
@property (strong, nonatomic, readonly) NSArray *blocks;
- (instancetype)initWithStateMachine:(NDDStateMachine *)_stateMachine client:(NSObject<NDDStateMachineDataSource> *)_client current:(NDDStateMachineState *)_current next:(NDDStateMachineState *)_next event:(NDDStateMachineEvent *)_event completionHandler:(NDDErrorHandlerType)_block;
@end
