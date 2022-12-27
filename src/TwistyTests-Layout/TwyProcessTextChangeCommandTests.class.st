Class {
	#name : #TwyProcessTextChangeCommandTests,
	#superclass : #TwyLayoutBuiltCommandTestCase,
	#instVars : [
		'textChange'
	],
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyProcessTextChangeCommandTests >> commandClass [
	^TwyProcessTextChangeCommand 
]

{ #category : #running }
TwyProcessTextChangeCommandTests >> setUp [ 	
	super setUp.
	
	textChange := Mock new.
	
	command textChange: textChange.
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testExecution [
	
	[ 
		[ self executeCommand ]
			should strictly satisfy: 
		[ builder restoreSpanCorruptedBy: textChange ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testHasBuiltPlaceBeforeTextChange [

	(textChange stub isBeforeChange: #anotherChange) willReturn: #result.

	(command hasBuiltPlaceBeforeTextChange: #anotherChange) should be: #result
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testHasBuiltPlaceUnderTextChange [

	[:anotherTextChange |
		 [ (command hasBuiltPlaceChangedBy: anotherTextChange) should be: #result]
			should strictly satisfy: 
		[(anotherTextChange isEmbody: textChange) willReturn: #result]
	 ] runWithMocks 
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testIsActiveAtLine [
	
	[ :layoutLine |
		[ (command isActiveAtLine: layoutLine) should be: #result]
			should strictly satisfy: 
		[ (textChange isAffectLayoutLine: layoutLine) willReturn: #result ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testIsActiveAtSpan [
	
	[ :layoutSpan |
		[ (command isActiveAtSpan: layoutSpan) should be: #result]
			should strictly satisfy: 
		[ (textChange isAffectLayoutSpan: layoutSpan) willReturn: #result ]
	
	 ] runWithMocks 
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testIsRedundant [

	textChange stub isRedundant willReturn: #result.

	command isRedundant should be: #result
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testIsSimilarToSameClassCommand [

	| similarCommand |
	similarCommand := self commandClass new.
	similarCommand textChange: textChange.
		
	(command isSimilarTo: similarCommand) should be: true.
	
	similarCommand textChange: #anotherChange.
	
	(command isSimilarTo: similarCommand) should be: false.
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testShouldBeExecutedBeforeAnotherCommandWhichHasBuiltPlaceAfterMe [

	[:anotherCommand |
		 [ (command shouldBeExecutedBefore: anotherCommand) should be: false]
			should strictly satisfy: 
		[(anotherCommand hasBuiltPlaceBeforeTextChange: textChange) willReturn: true]
	 ] runWithMocks 
]

{ #category : #tests }
TwyProcessTextChangeCommandTests >> testShouldNotBeExecutedBeforeAnotherCommandWhichHasBuiltPlaceBeforeMe [

	[:anotherCommand |
		 [ (command shouldBeExecutedBefore: anotherCommand) should be: false]
			should strictly satisfy: 
		[(anotherCommand hasBuiltPlaceBeforeTextChange: textChange) willReturn: true]
	 ] runWithMocks 
]
