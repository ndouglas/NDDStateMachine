//
//  NDDStateMachineTransitionFactory.Private.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

#import "NDDStateMachineTransitionFactory.h"

@interface NDDStateMachineTransitionFactory () {
  NDDStateMachine __weak *stateMachine;
}
@property (weak, nonatomic, readwrite) NDDStateMachine *stateMachine;
- (instancetype)initWithStateMachine:(NDDStateMachine *)_stateMachine;
@end
