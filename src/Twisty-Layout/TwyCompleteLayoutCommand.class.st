"
I'm special ""terminal"" command which should be always executed at the end of layout restoration logic.
I complete position correction of rest layout elements after last real command.
"
Class {
	#name : #TwyCompleteLayoutCommand,
	#superclass : #TwyLayoutBuiltCommand,
	#category : #'Twisty-Layout'
}

{ #category : #execution }
TwyCompleteLayoutCommand >> executeBy: aLayoutBuilder [
	aLayoutBuilder isAtLayoutEnd ifTrue: [ ^self ].
	
	aLayoutBuilder addLayoutCommand: self
]

{ #category : #testing }
TwyCompleteLayoutCommand >> isActiveAtLine: aLayoutLine [
	^false
]

{ #category : #testing }
TwyCompleteLayoutCommand >> isActiveAtSpan: aLayoutSpan [
	^false
]

{ #category : #testing }
TwyCompleteLayoutCommand >> isRedundant [ 	
	^false
]
