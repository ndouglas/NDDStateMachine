//
//  NDDStateMachine.h
//  NDDStateMachine
//
//  Created by Nathan Douglas on 08/08/2013.
//  Copyright (c) 2013 Nathan Douglas. All rights reserved.
//

@protocol NDDStateMachineDataSource;

/**
 This class is an abstraction of a Finite State Machine.
 
 A state machine is a quintuple (a,b,c,d,e), where:
 
 - a is an input alphabet.  Here, we're using a generalized notion of inputs that can be
 invoked in any number of ways -- through notifications, direct execution, etc.  All that
 is important is that the -input: method below is triggered.
 - b is a finite, non-empty set of states.  The state machine can only exist in one state
 at a time and can only proceed from one state to another if there is an edge (in this
 case, an acceptor block) connecting them.
 - c is an initial state (element of b).  If this is not set, the machine will be unable
 to function.
 - d is a state transition function.
 - e is a set of final states, a possibly empty subset of b.
 
 Note that although the interface of the state machine deals only with strings, these are
 (under the hood) just simplified interfaces to feature-rich objects.
 
 A number of callbacks are invoked during the performance of each state transition, in the
 following order:
 
 1.  The event's acceptor block.  "Does it make sense to do this?"
 2.  The event's before-transition handler block.  "I'm going to do this... right?"
 3.  The source's before-exit handler block.  "Is it possible to leave this state?"
 4.  The destination's before-entry handler block.  "Is it possible to enter that state?"
 5.  The source's after-exit handler block.  "What happens as I leave this state?"
 6.  The destination's after-entry handler block.  "What happens as I enter this state?"
 7.  The event's after-transition handler block.  "I did that... is everything still okay?"
 
 Note that blocks are not encodable/unencodable, so the error handler must be reset whenever
 (if ever) it is unencoded.
 */

@interface NDDStateMachine : NSObject

/**
 A set of strings representing the allowable inputs for this system.  The events.
 */

@property (strong, nonatomic, readonly) NSSet *alphabet;

/**
 A set of strings representing the allowable states for this system.
 */

@property (strong, nonatomic, readonly) NSSet *states;

/**
 A string representing the initial state of this system.  A member of -states.
 */

@property (copy, nonatomic, readwrite) NSString *initial;

/**
 A standard error handler used when no other is specified.
 */

@property (copy, nonatomic, readwrite) NDDErrorHandlerType errorHandler;

/**
 Returns an instance of the class initialized with the specified definition.
 
 @param _definition A state machine definition.
 @return An initialized instance of the class.
 */

+ (instancetype)stateMachineWithDefinition:(NDDStateMachineDefinitionType)_definition;

/**
 Adds a state with a specific name.
 
 @param _state The name of the state.
 */

- (void)addState:(NSString *)_state;

/**
 Adds an event with a specific name.
 
 @param _event The name of the event.
 */

- (void)addEvent:(NSString *)_event;

/**
 Performs the actions set to occur as a result of the specified event.
 
 @param _client The client using this state machine.
 @param _event The event.
 @param _block A completion handler.
 */

- (void)client:(NSObject<NDDStateMachineDataSource> *)_client didInputEvent:(NSString *)_event completionHandler:(NDDErrorHandlerType)_block;

/**
 Connects one state to another with a new transition and associates this with an event.
 
 @param _event The event that will fire this transition. This must be non-nil, have a
 non-zero length, and be a valid event.
 @param _startState If we are here, the transition will begin.  This must be non-nil,
 have a non-zero length, and be a valid state.
 @param _endState Where we end up, if everything goes according to plan.  This must be
 non-nil, have a non-zero length, and be a valid state.
 @param _condition An acceptor that will be evaluated when the event fires and indicate
 whether the transition should proceed or not.  This can be nil, in which case the
 transition will be allowed.
 @discussion This method call can be repeated with different conditions to allow for
 multiple conditions on an event.  Failing any condition will result in the transition
 failing.
 */

- (void)onEvent:(NSString *)_event exitState:(NSString *)_startState enterState:(NSString *)_endState ifCondition:(NDDStateMachineAcceptorType)_condition;

/**
 Registers a specified block to be executed before the specified event is handled.
 
 @param _event The event.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)beforeEvent:(NSString *)_event performBlock:(NDDBasicBlockType)_block;

/**
 Registers a specified block to be executed after the specified event is handled.
 
 @param _event The event.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)afterEvent:(NSString *)_event performBlock:(NDDBasicBlockType)_block;

/**
 Registers a specified block to be executed before entering the specified state.
 
 @param _state The state.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)beforeEnteringState:(NSString *)_state performBlock:(NDDBasicBlockType)_block;

/**
 Registers a specified block to be executed after entering the specified state.
 
 @param _state The state.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)afterEnteringState:(NSString *)_state performBlock:(NDDBasicBlockType)_block;

/**
 Registers a specified block to be executed before exiting the specified state.
 
 @param _state The state.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)beforeExitingState:(NSString *)_state performBlock:(NDDBasicBlockType)_block;

/**
 Registers a specified block to be executed after exiting the specified state.
 
 @param _state The state.
 @param _block The block.
 @discussion Can be repeated.  Must not interfere with the transition in any way.
 */

- (void)afterExitingState:(NSString *)_state performBlock:(NDDBasicBlockType)_block;

@end
