"
I'm text region between start and end cursors.
I provide interface to edit text and enumeration text elements inside my bounds.

You can create region from text by #newRegion. It will be active region.
So you should detach it from text by #detachText at the end of usage.

You can create passive region between two passive cursors: class side method #from:to:
 
Internal Representation and Key Implementation Points.

    Instance Variables
	end:		<TwyCursor>
	start:		<TwyCursor>
"
Class {
	#name : #TwyTextRegion,
	#superclass : #Object,
	#instVars : [
		'start',
		'end'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyTextRegion class >> from: startTextPosition to: endTextPosition [

	^self new
		start: startTextPosition;
		end: endTextPosition 
		
]

{ #category : #accessing }
TwyTextRegion >> actualEnd [
	
	^ (end isBefore: start) ifTrue: [ start ] ifFalse: [ end ]
]

{ #category : #accessing }
TwyTextRegion >> actualStart [
	
	^ (end isBefore: start) ifTrue: [ end ] ifFalse: [ start ]
]

{ #category : #operations }
TwyTextRegion >> applyAttribute: aTextAttribute [ 
	
	self actualStart applyAttribute: aTextAttribute upTo: self actualEnd
]

{ #category : #operations }
TwyTextRegion >> applyAttribute: aTextAttributeClass with: attributeValue [
	
	^self applyAttribute: (aTextAttributeClass with: attributeValue)
]

{ #category : #operations }
TwyTextRegion >> applyParagraphAttribute: aTextAttribute [ 
	
	self actualStart applyParagraphAttribute: aTextAttribute upTo: self actualEnd
]

{ #category : #operations }
TwyTextRegion >> applyParagraphAttribute: aTextAttributeClass with: attributeValue [
	
	^self applyParagraphAttribute: (aTextAttributeClass with: attributeValue)
]

{ #category : #converting }
TwyTextRegion >> asString [ 
	
	^String streamContents: [ :s | 
		self actualStart printTextOn: s upTo: self actualEnd.		
	]
]

{ #category : #converting }
TwyTextRegion >> asTextPart [

	^TwyTextPart from: start to: end
]

{ #category : #operations }
TwyTextRegion >> backspaceKey [

	self isEmpty ifTrue: [ start moveBackward ].
	
	self delete
]

{ #category : #operations }
TwyTextRegion >> collapseAtEnd [
	start moveTo: end
]

{ #category : #operations }
TwyTextRegion >> collapseAtStart [
	end moveTo: start
]

{ #category : #copying }
TwyTextRegion >> copy [

	| startCopy endCopy |
	startCopy := start copy.
	endCopy := end copy.
	^startCopy selectTextUpTo: endCopy
]

{ #category : #operations }
TwyTextRegion >> delete [
	^self actualStart deleteUpTo: self actualEnd
]

{ #category : #operations }
TwyTextRegion >> deleteKey [

	self isEmpty ifTrue: [ end moveForward ].
	
	self delete
]

{ #category : #controlling }
TwyTextRegion >> detachText [

	start detachText.
	end detachText
]

{ #category : #accessing }
TwyTextRegion >> end [
	
	^ end
]

{ #category : #accessing }
TwyTextRegion >> end: anObject [
	
	end := anObject
]

{ #category : #accessing }
TwyTextRegion >> getStartAttribute: aTextAttributeClass [
	
	^start span getAttribute: aTextAttributeClass
]

{ #category : #testing }
TwyTextRegion >> hasAttribute: aTextAttributeClass [

	self isCoversSingleSpan ifFalse: [ self error: 'It is only supported for single span region' ].
	
	^start hasAttribute: aTextAttributeClass
]

{ #category : #testing }
TwyTextRegion >> isCoversSingleSpan [

	^start isAtSameSpanWith: end
]

{ #category : #testing }
TwyTextRegion >> isEmpty [
	^start isAtSamePositionWith: end
]

{ #category : #enumeration }
TwyTextRegion >> itemsDo: aBlock [
	| iteratorCursor |
	
	iteratorCursor := self actualStart copy.
	
	[ 
	[end isAtSamePositionWith: iteratorCursor] whileFalse: [ 
		aBlock value: iteratorCursor nextItemAtSpan. 
		iteratorCursor moveForward] 
	] ensure: [ iteratorCursor detachText ]
]

{ #category : #operations }
TwyTextRegion >> moveTo: aTextCursor [
	start moveTo: aTextCursor.
	end moveTo: aTextCursor.
]

{ #category : #accessing }
TwyTextRegion >> newPassiveCursorAtStart [
	^start asPassiveCursor
]

{ #category : #operations }
TwyTextRegion >> overridePossibleCharactersWith: newString [ 

	^self actualStart overridePossibleCharactersWith: newString upTo: self actualEnd
]

{ #category : #operations }
TwyTextRegion >> replaceWith: aTwyTextSource [
	
	self delete.
	end insert: aTwyTextSource.
	start moveTo: end
]

{ #category : #operations }
TwyTextRegion >> selectFullText [
	start moveToTextStart.
	end moveToTextEnd
]

{ #category : #operations }
TwyTextRegion >> selectTextBetween: startPosition and: endPosition [
	start textPosition: startPosition.
	end textPosition: endPosition
]

{ #category : #accessing }
TwyTextRegion >> spanAtEnd [
	^end span
]

{ #category : #enumeration }
TwyTextRegion >> splittedByGroupsWhereCharactersAre: charConditionBlock do: regionActionBlock [

	self withSubRegionDo: [ :groupStart :groupEnd :groupRegion |
	
		[groupEnd isAtSamePositionWith: end ] whileFalse: [ 
		
			groupStart moveForwardToItemWhich: charConditionBlock butNotFarThan: end.
			groupEnd moveTo: groupStart.
			groupEnd moveForwardToItemWhich: [ :eachChar | (charConditionBlock value: eachChar) not ] butNotFarThan: end.
		
			groupRegion isEmpty ifTrue: [ ^self].
			regionActionBlock value: groupRegion.
			groupStart moveTo: groupEnd]	
	]
]

{ #category : #enumeration }
TwyTextRegion >> splittedBySpansDo: aBlock [

	self splittedBySpansDo: aBlock while: [ :spanRegion | true  ]
]

{ #category : #enumeration }
TwyTextRegion >> splittedBySpansDo: aBlock while: conditionBlock [

	self withSubRegionDo: [ :spanStart :spanEnd :spanRegion |
	
		spanEnd moveToSpanEnd.
	
		[ spanEnd isAtSameSpanWith: end ] whileFalse: [ 
			(conditionBlock value: spanRegion) ifFalse: [ ^self ].
			aBlock value: spanRegion.
			spanStart moveToStartOfNextSpan.
			spanEnd moveTo: spanStart; moveToSpanEnd ].
	
		(conditionBlock value: spanRegion) ifTrue: [ aBlock value: spanRegion]
	]
]

{ #category : #accessing }
TwyTextRegion >> start [
	
	^ start
]

{ #category : #accessing }
TwyTextRegion >> start: anObject [
	
	start := anObject
]

{ #category : #accessing }
TwyTextRegion >> text [
	^self start text
]

{ #category : #enumeration }
TwyTextRegion >> withSubRegionDo: threeArgsBlock [
		
	| subRegionStart subRegionEnd subRegion |
	subRegionStart := self actualStart copy.
	subRegionEnd := self actualStart copy.
	subRegion := subRegionStart selectTextUpTo: subRegionEnd.

	[threeArgsBlock value: subRegionStart value: subRegionEnd value: subRegion ]
		ensure: [ subRegion detachText ]

]
