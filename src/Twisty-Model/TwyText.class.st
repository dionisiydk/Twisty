"
I'm active text.
I present text as linked list of TwyElement objects. Each element has specific collection of attributes like font or fore color. I supply default attributes when element has no one.
My first element is always TwyTextStart. My last element is TwyTextEnd. Every text line starts with TwyLineStart element. Characters are contained in TwyCharactersSpan. Tab is presented by TwyTabSpan.
I ensure two invariants in my structure:
- TwyLineStart is always folowed by span element (like characters or tabs). There are no two TwyLineStart elements which are adjacent.
- Empty TwyCharactersSpan exists only at empty text line as single element at line. When text line is not empty it can't contain empty characters span.

You can build me from any string:
	'hello' asTwyText
TwyElementsReadStream is used to read my elements from string. It splits long strings (>200 chars) by TwyCharactersSpan elements.

When my elements changed I announce event about it. There are two kind of announcement: TwyImmediateChangeAnnouncement and TwyChangesAnnouncement. First happens immediatelly after change happens. Last is announced about logical group of changes.

Any changes should be performed inside change block: 
	text editContentsBy: [ cursor insert: 'new text' ]

Publicly I should be modified by high level objects: TwyActiveTextCursor and TwyTextRegion. See it editing protocol. This objects incapsulate position inside me and provide navigation methods. When my structure is changed there positions will be restored automatically (there is passive version of cursor TwyPassiveCursor which not subscribe on my changes and can be broken after changes).
To obtain cursors and regions you can use:
	text newActiveCursor.
	text newRegion.
When this objects not needed anymore they should be untouched from me to release events subscription:
	cursor detachText.
	region detachText.

You can use another version of editing method to validate changes: 
	text editContentsBy: [ cursor insert: 'abcd' ] andSubmitChangesBy: [ text asString  isAllDigits ]	
Last condition is executed when my state is completelly changed (after first changes block). Any validation rules can be applied here and if I'm not valid all changes will be cancelled. 
It 's mean that you should not analize specific change operations like deletion or insertion. But instead you can validate full changed state at once.

During editing methods I announce few events:
- TwyChangesBegin is announced before changes block executed
- TwyChangesCompleted is announced always at the end of editing method (in case of failures too)
- TwyTextChanged is announced when changes successfully submitted by validation block
- TwyChangesCancelled is announced when changes was cancelled by validation block

Last two announcements contains TwyChangesCollection of all immediate events which happens during changes block execution: text state changes and cursor movements (subclasses of TwyImmediateChangeAnnouncement). 
Editing methods return TwyTextChanged or TwyChangesCancelled events which was announced.

    Instance Variables
	announcer:		<TwyAnnouncer>
	defaultAttributes:		<TwyAttributes>
	end:		<TwyTextEnd>
	start:		<TwyTextStart>
"
Class {
	#name : #TwyText,
	#superclass : #Object,
	#instVars : [
		'start',
		'end',
		'defaultAttributes',
		'announcer'
	],
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyText >> announcer [
	
	^ announcer
]

{ #category : #accessing }
TwyText >> announcer: anObject [
	
	announcer := anObject
]

{ #category : #editing }
TwyText >> applyDefaultAttribute: anAttribute [

	| initialAttr |
	initialAttr := defaultAttributes get: anAttribute class ifAbsent: [ nil ].
	defaultAttributes add: anAttribute.

	self publishChange: (TwyDefaultAttributeChanged on: self initialAttribute: initialAttr newAttribute: anAttribute)
]

{ #category : #converting }
TwyText >> asString [ 
	^ String streamContents: [:str | self asStringOn: str ]
	
]

{ #category : #converting }
TwyText >> asStringOn: aStream [

	start forwardDo: [ :each | each asStringOn:  aStream ]
]

{ #category : #converting }
TwyText >> asTwyText [
	^self
]

{ #category : #editing }
TwyText >> collectChangesDuring: aBlock [

	| textSelection |
	aBlock argumentCount = 0 ifTrue: [ 
		 ^announcer collectChangesOf: self during: aBlock].
	
	textSelection := self newRegion.
	
	[^announcer collectChangesOf: self during: [aBlock value: textSelection]] 
		ensure: [ textSelection detachText ]
]

{ #category : #copying }
TwyText >> copy [

	| copy copyLastElement |
	copy := TwyText new.
	copyLastElement := copy start.

	start forwardDo: [ :each |

		copyLastElement next: each copy.
		copyLastElement := copyLastElement next.
		
	 ].
	 copyLastElement next: copy end.

	^copy
]

{ #category : #accessing }
TwyText >> defaultAttributes [
	
	^ defaultAttributes
]

{ #category : #accessing }
TwyText >> defaultAttributes: anObject [
	
	defaultAttributes := anObject
]

{ #category : #editing }
TwyText >> editContentsBy: aBlock [

	^self editContentsBy: aBlock andSubmitChangesBy: [ true ]
]

{ #category : #editing }
TwyText >> editContentsBy: editBlock andSubmitChangesBy: validationBlock [

	| changes isChangesSubmitted |
	self publishEvent: TwyChangesBegin new.
	
	[
		changes := self collectChangesDuring: editBlock.	
		isChangesSubmitted := validationBlock value.
	
		isChangesSubmitted ifFalse: [ 
			changes cancel.
			^self publishEvent: (TwyChangesCancelled changes: changes) ].
	
		^self publishEvent: (TwyTextChanged changes: changes)
	] ensure: [ self publishEvent: TwyChangesCompleted new ]
]

{ #category : #accessing }
TwyText >> elements [
	| result |
	result := OrderedCollection new.
	start forwardDo: [ :each | result add: each ].
	result addFirst: start; addLast: end.
	^result
]

{ #category : #accessing }
TwyText >> end [
	
	^ end
]

{ #category : #accessing }
TwyText >> end: anObject [
	
	end := anObject
]

{ #category : #accessing }
TwyText >> firstSpan [
	^start nextSpanIfAbsent: [self error: 'Should not happen. Any text should have span']
]

{ #category : #accessing }
TwyText >> getAttribute: anAttributeClass [ 

	^defaultAttributes valueOf: anAttributeClass ifAbsent: [anAttributeClass defaultValue] 
]

{ #category : #subscribing }
TwyText >> hasSubscriber: anObject [

	^announcer hasSubscriber: anObject
]

{ #category : #'initialize-release' }
TwyText >> initialize [ 
	super initialize.
	
	announcer := TwyAnnouncer new.
	defaultAttributes := TwyAttributes new.
	start := TwyTextStart of: self.
	end := TwyTextEnd of: self.
	start next: end.
	start insertEmptySpanSilently
]

{ #category : #testing }
TwyText >> isEmpty [

	| firstSpan |
	firstSpan := self firstSpan.
	^firstSpan isFirst & firstSpan isLast & firstSpan isEmpty
]

{ #category : #accessing }
TwyText >> lastSpan [
	^end previousSpanIfAbsent: [self error: 'Should not happen. Any text should have span']
]

{ #category : #accessing }
TwyText >> newActiveCursor [
	^TwyActiveTextCursor on: self
]

{ #category : #accessing }
TwyText >> newPassiveCursor [
	^TwyPassiveTextCursor on: self
]

{ #category : #accessing }
TwyText >> newPassiveCursorAtStart [
	^self newPassiveCursor
]

{ #category : #accessing }
TwyText >> newRegion [

	^TwyTextRegion from: self newActiveCursor to: self newActiveCursor
]

{ #category : #subscribing }
TwyText >> publishChange: aModelChanged [ 
	self publishEvent: aModelChanged
]

{ #category : #subscribing }
TwyText >> publishEvent: anAnnouncenemt [ 
	^announcer announce: anAnnouncenemt 
]

{ #category : #reading }
TwyText >> readElementsFrom: aTwyElementsReadStream [ 

	| current |
	current := start.

	aTwyElementsReadStream do: [ :each |
		current next: each.
		each computeOrderBetween: current and: end.
		current ensureAnySpan.
		current := each
	 ].

	current next: end.
	current ensureAnySpan

]

{ #category : #editing }
TwyText >> removeAttribute: aTwyAttributeClass [ 

	| attribute |
	attribute := defaultAttributes get: aTwyAttributeClass ifAbsent: [ ^self ].
	
	defaultAttributes remove: aTwyAttributeClass.
	
	self publishChange: (TwyDefaultAttributeChanged on: self initialAttribute: attribute newAttribute: nil)
]

{ #category : #accessing }
TwyText >> setNewContents [
"
this is temp implementation.
"
 	| currentAttributes |
	currentAttributes := defaultAttributes.
	self initialize.
	defaultAttributes := currentAttributes
]

{ #category : #enumeration }
TwyText >> spansDo: aBlock [

	start forwardDo: [ :eachElement |
		eachElement isSpan ifTrue: [ aBlock value: eachElement ]	
	 ]
]

{ #category : #accessing }
TwyText >> start [
	
	^ start
]

{ #category : #accessing }
TwyText >> start: anObject [
	
	start := anObject
]

{ #category : #subscribing }
TwyText >> unsubscribe: anObject [
	announcer unsubscribe: anObject
]

{ #category : #controlling }
TwyText >> validateSpansOrder [

	| beforeElement |
	beforeElement := start.
	start 
		forwardDo: [ :each | beforeElement order < each order ifFalse: [ self error: 'spans has incorrect order numbers' ].
			beforeElement := each ]
]

{ #category : #subscribing }
TwyText >> when: anAnnouncement do: aBlock [
	announcer when: anAnnouncement do: aBlock
]

{ #category : #subscribing }
TwyText >> when: anAnnouncement send: aSymbol to: anObject [
	announcer when: anAnnouncement send: aSymbol to: anObject
]

{ #category : #enumeration }
TwyText >> withRegionsWhereCharactersAre: charConditionBlock do: actionBlock [

	| fullRegion |
	fullRegion := self newRegion.
	fullRegion selectFullText.
	
	[
		fullRegion splittedByGroupsWhereCharactersAre: charConditionBlock do: actionBlock.
	] ensure: [ fullRegion detachText ]
]

{ #category : #enumeration }
TwyText >> withSubRegionDo: threeArgsBlock [

	| fullRegion |
	fullRegion := self newRegion.
	fullRegion selectFullText.
	
	[ 
		fullRegion withSubRegionDo: threeArgsBlock 
	 ] ensure: [ fullRegion detachText ]
]
