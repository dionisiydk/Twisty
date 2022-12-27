"
I'm the root of the hierarchy of built layout commands.

My subclasses should implement required methods to order each others on text.
Public API and Key Messages

- executeBy: aTwyLayoutBuildet 
- shouldBeExecutedBefore: anotherCommand
"
Class {
	#name : #TwyLayoutBuiltCommand,
	#superclass : #Object,
	#category : #'Twisty-Layout'
}

{ #category : #execution }
TwyLayoutBuiltCommand >> correctState [
	self subclassResponsibility 
]

{ #category : #execution }
TwyLayoutBuiltCommand >> executeBy: aLayoutBuilder [
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> hasBuiltPlaceAfterLayoutSpan: aTwyLayoutSpan [ 
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> hasBuiltPlaceBeforeTextChange: aTextChange [

	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> hasBuiltPlaceChangedBy: aTextChange [
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isActiveAtLine: aLayoutLine [
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isActiveAtSpan: aLayoutLine [
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isEmbody: anotherCommand [
	^self isSimilarTo: anotherCommand
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isRedundant [
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isSimilarTo: aLayoutBuiltCommand [ 
	
	self == aLayoutBuiltCommand ifTrue: [ ^true ].
	
	self class == aLayoutBuiltCommand class ifFalse: [ ^false  ].
	
	^self isSimilarToSameClassCommand: aLayoutBuiltCommand
]

{ #category : #testing }
TwyLayoutBuiltCommand >> isSimilarToSameClassCommand: aLayoutBuiltCommand [ 
	
	self subclassResponsibility 
]

{ #category : #testing }
TwyLayoutBuiltCommand >> shouldBeExecutedBefore: anotherBuiltCommand [
	self subclassResponsibility 
]
