//
//  BEUMove.m
//  BEUEngine
//
//  Created by Chris Mele on 2/27/10.
//  Copyright 2010 Invulse. All rights reserved.
//

#import "BEUMove.h"


@implementation BEUMove

@synthesize inputSequence, 
character, 
interruptible, 
cooldownTime, 
moveSelector, 
completeSelector, 
completeTarget,
completed,
inProgress,
name;


-(id)init
{
	if( (self = [super init]) )
	{
		self.interruptible = NO;
		self.cooldownTime = .2;
		self.completed = NO;
		self.inProgress = NO;
		range = 60;
	}
	
	return self;
}

+(id)moveWithName:(NSString *)name_
		character:(BEUCharacter *)character_ 
		 sequence:(NSArray *)sequence_ 
		 selector:(SEL)selector_
{
	return [[[BEUMove alloc] initWithName:name_
								character:character_ 
								 sequence:sequence_
								selector:selector_] autorelease];
}

-(id)initWithName:(NSString *)name_
		character:(BEUCharacter *)character_ 
		 sequence:(NSArray *)sequence_
		 selector:(SEL)selector_
{
	[self init];
	name = name_;
	character = character_;
	inputSequence = sequence_;
	moveSelector = selector_;
	
	return self;
}

-(void)resetMove
{
	self.completed = NO;
	self.inProgress = NO;
}

-(void)startMove
{
	[character performSelector:self.moveSelector withObject: self];
	self.inProgress = YES;
}

-(void)cancelMove
{
	if(interruptible)
	{
		
	}
}

-(void)completeMove
{
	self.completed = YES;
	self.inProgress = NO;
	
	if(completeTarget)
	{
		if([completeTarget respondsToSelector:completeSelector])
		{
			[completeTarget performSelector:completeSelector withObject: self];
		}
	}
	
	[self resetMove];
}

-(BOOL)trySequence:(NSArray *)sequence
{
	
	if(sequence.count != inputSequence.count) return NO;
		
	for(int i=0; i<inputSequence.count; i++)
	{
		if([[sequence objectAtIndex: i] type] != [inputSequence objectAtIndex:i]) return NO;
	}
	[self startMove];
	return YES;
	
}

-(void)dealloc
{
	character = nil;
	moveSelector = nil; 
	completeSelector = nil;
	completeTarget = nil;
	
	[super dealloc];
}

@end
