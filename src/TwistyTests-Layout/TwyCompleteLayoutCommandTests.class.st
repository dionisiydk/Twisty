Class {
	#name : #TwyCompleteLayoutCommandTests,
	#superclass : #TwyLayoutBuiltCommandTestCase,
	#category : #'TwistyTests-Layout'
}

{ #category : #running }
TwyCompleteLayoutCommandTests >> commandClass [
	^TwyCompleteLayoutCommand 
]

{ #category : #tests }
TwyCompleteLayoutCommandTests >> testExecutionWhenBuilderAtLayoutEnd [

	[ 
		[ self executeCommand]
			should strictly satisfy: 
		[ builder isAtLayoutEnd willReturn: true ]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCompleteLayoutCommandTests >> testExecutionWhenBuilderIsNotAtLayoutEnd [

	[ 
		[self executeCommand]
			should strictly satisfy: 
		[ builder isAtLayoutEnd willReturn: false.
		builder addLayoutCommand: command]
	 ] runWithMocks 
]

{ #category : #tests }
TwyCompleteLayoutCommandTests >> testIsNotActiveAtAnyLayoutLine [

	(command isActiveAtLine: nil) should be: false
]

{ #category : #tests }
TwyCompleteLayoutCommandTests >> testIsNotActiveAtAnyLayoutSpan [

	(command isActiveAtSpan: nil) should be: false
]
