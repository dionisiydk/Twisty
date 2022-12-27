"
I happens when text elements group was removed
 
Internal Representation and Key Implementation Points.

    Instance Variables
	elementAfterRemovedGroup:		<TwyElement>
	elementBeforeRemovedGroup:		<TwyElement>
	firstRemovedElement:		<TwyElement>
"
Class {
	#name : #TwyElementsGroupRemoved,
	#superclass : #TwyTextStateChanged,
	#instVars : [
		'firstRemovedElement',
		'elementAfterRemovedGroup',
		'elementBeforeRemovedGroup'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElementsGroupRemoved class >> startedWith: firstRemovedElement between: elementBeforeRemovedGroup and: elementAfterRemovedGroup [ 

	^(self onText: firstRemovedElement text)
		firstRemovedElement: firstRemovedElement;
		elementAfterRemovedGroup: elementAfterRemovedGroup;
		elementBeforeRemovedGroup: elementBeforeRemovedGroup 
]

{ #category : #cancelling }
TwyElementsGroupRemoved >> cancel [

	firstRemovedElement previous: TwyTextStart new.
	elementBeforeRemovedGroup insertElement: firstRemovedElement 
]

{ #category : #'layout span correction' }
TwyElementsGroupRemoved >> correctAffectedLayoutSpansStartingAt: aLayoutSpan by: aLayoutBuilder [

	| firstAffectedLayoutSpan |

	(aLayoutSpan isOnlySpanRemovedBy: self) ifTrue: [^aLayoutSpan delete].

	firstAffectedLayoutSpan := aLayoutSpan findFirstSpanRemovedBy: self.	

	firstAffectedLayoutSpan correctSpansRemovedBy: self.

	aLayoutBuilder addCorrectionCommandFor: firstAffectedLayoutSpan.
	aLayoutSpan = firstAffectedLayoutSpan 
		ifFalse: [  aLayoutBuilder addCorrectionCommandFor: aLayoutSpan ]
]

{ #category : #'layout span correction' }
TwyElementsGroupRemoved >> correctFirstRemovedLayoutSpan: aLayoutSpan [ 

	| previousSpan nextSpan |
	
	aLayoutSpan isLayoutEnd ifTrue: [ 
		previousSpan := firstRemovedElement previousSpanIfAbsent: [ self error: 'should not happen'].
		^aLayoutSpan moveBorderToEndOf: previousSpan ].
		
	nextSpan := elementAfterRemovedGroup.
	nextSpan isSpan ifFalse: [nextSpan := nextSpan nextSpanIfAbsent: [self error: 'It should not happen']].
	
	aLayoutSpan moveBorderToStartOf: nextSpan
]

{ #category : #'cursor position correction' }
TwyElementsGroupRemoved >> correctPositionOf: aTextCursor [ 

	(aTextCursor isAfterElement: elementBeforeRemovedGroup) ifFalse: [ ^self ].
	(aTextCursor isBeforeElement: elementAfterRemovedGroup) ifFalse: [ ^self ].
		
	elementBeforeRemovedGroup isSpan ifTrue: [ ^aTextCursor moveToEndOf: elementBeforeRemovedGroup].
	
	elementAfterRemovedGroup isSpan ifTrue: [^aTextCursor moveToStartOf: elementAfterRemovedGroup ].

	self error: 'It should not happen'
]

{ #category : #accessing }
TwyElementsGroupRemoved >> elementAfterRemovedGroup [
	^ elementAfterRemovedGroup
]

{ #category : #accessing }
TwyElementsGroupRemoved >> elementAfterRemovedGroup: anObject [
	elementAfterRemovedGroup := anObject
]

{ #category : #accessing }
TwyElementsGroupRemoved >> elementBeforeRemovedGroup [
	^ elementBeforeRemovedGroup
]

{ #category : #accessing }
TwyElementsGroupRemoved >> elementBeforeRemovedGroup: anObject [
	elementBeforeRemovedGroup := anObject
]

{ #category : #accessing }
TwyElementsGroupRemoved >> firstRemovedElement [
	^ firstRemovedElement
]

{ #category : #accessing }
TwyElementsGroupRemoved >> firstRemovedElement: anObject [
	firstRemovedElement := anObject
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAffectLayoutLine: aLayoutLine [

	^(aLayoutLine isCoversElementsBetween: elementBeforeRemovedGroup and: elementAfterRemovedGroup) 
		or: [ aLayoutLine isLastLineWhichCovers: elementBeforeRemovedGroup  ]
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAffectLayoutSpan: aLayoutSpan [
	(aLayoutSpan isLastSpanWhichCovers: elementBeforeRemovedGroup) ifTrue: [ ^true ].
	
	^self isRemoveLayoutSpan: aLayoutSpan
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAffectTextAfterElement: aTextElement [
	^(elementBeforeRemovedGroup isBefore: aTextElement) not
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAffectTextAt: aTextCursor [
	^(aTextCursor isAfterElement: elementBeforeRemovedGroup) and: 
		[ aTextCursor isBeforeElement: elementAfterRemovedGroup  ]
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAffectTextBeforeElement: aTextElement [
	^(elementAfterRemovedGroup isAfter: aTextElement) not
]

{ #category : #testing }
TwyElementsGroupRemoved >> isAfter: aTextCursor [
	^aTextCursor isBeforeOrAtStartOfElement: firstRemovedElement 
]

{ #category : #testing }
TwyElementsGroupRemoved >> isBeforeChange: aTextChange [
	
	^aTextChange isAffectTextAfterElement: elementBeforeRemovedGroup
]

{ #category : #testing }
TwyElementsGroupRemoved >> isEmbody: anotherTextChange [
	^(anotherTextChange isAffectTextAfterElement: elementBeforeRemovedGroup)
		and: [ anotherTextChange isAffectTextBeforeElement: elementAfterRemovedGroup  ]
]

{ #category : #testing }
TwyElementsGroupRemoved >> isRedundant [
	^false
]

{ #category : #testing }
TwyElementsGroupRemoved >> isRemoveLayoutSpan: aLayoutSpan [
		
	(aLayoutSpan isCovers: firstRemovedElement) ifTrue: [ ^true ].	
	
	^aLayoutSpan isBetweenTextElement: elementBeforeRemovedGroup and: elementAfterRemovedGroup.
]

{ #category : #accessing }
TwyElementsGroupRemoved >> liveElementBeforeRemovedGroup [
	| liveElement |
	liveElement := elementBeforeRemovedGroup.
	[ liveElement isDeleted ] whileTrue: [ liveElement := liveElement previous ].
	^liveElement
]
