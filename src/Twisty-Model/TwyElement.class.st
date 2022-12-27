"
I'm the root of the hierarchy of text element types. See TwyText comment about text internal details.

Public API and Key Messages

- backwardDo:/forwardDo:  and friends enumerate text elements in particular direction.   
- attachTo: anotherElement  
- delete 
- insertElement:
- applyAttribute:
- removeAttribute:
- length returnes count of underlying text items (characters for example)
- itemAt:ifAbsent:
- nextSpanIfAbsent:
- previousSpanIfAbsent: 
 - isAfter:/isBefore another element

Internal Representation and Key Implementation Points.

    Instance Variables
	text:		<TwyText>
	next:		<TwyElement>
	previous:		<TwyElement>
	attributes:		<TwyAttributes>
	order:		<Float>


"
Class {
	#name : #TwyElement,
	#superclass : #Object,
	#instVars : [
		'text',
		'next',
		'previous',
		'attributes',
		'order'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyElement class >> of: aText [
	^self new
		text: aText

	
]

{ #category : #editing }
TwyElement >> applyAttribute: anAttribute [

	| currentAttribute |
	currentAttribute := attributes get: anAttribute class ifAbsent: [ nil ].
	
	currentAttribute = anAttribute ifTrue: [ ^self ].
	
	attributes add: anAttribute.
	
	self publishChange: (TwyElementAttributeChanged on: self initialAttribute: currentAttribute newAttribute: anAttribute).
]

{ #category : #converting }
TwyElement >> asStringOn: aStream [

]

{ #category : #editing }
TwyElement >> attachTo: aTextSpan [ 

	| initialNext change |
	next == aTextSpan ifTrue: [ ^self ].
	
	initialNext := next.
	
	self next: aTextSpan.

	change := TwyElementsGroupRemoved startedWith: initialNext between: self and: aTextSpan.
	text publishChange: change
]

{ #category : #accessing }
TwyElement >> attributes [
	
	^ attributes
]

{ #category : #accessing }
TwyElement >> attributes: anObject [
	
	attributes := anObject
]

{ #category : #accessing }
TwyElement >> attributesDo: aBlock [

	attributes do: aBlock
]

{ #category : #enumeration }
TwyElement >> backwardDo: actionBlock [

	self backwardDo: actionBlock while: [:each | true]
]

{ #category : #enumeration }
TwyElement >> backwardDo: actionBlock while: whileBlock [

	| each |
	each := previous.
	
	[each isTextStart not and: [whileBlock value: each]] whileTrue: [ 
		actionBlock value: each.
		each := each previous ]
]

{ #category : #private }
TwyElement >> basicNext: aTwyElement [
	
	next := aTwyElement
]

{ #category : #private }
TwyElement >> basicPrevious: aTwyElement [
	
	previous := aTwyElement
]

{ #category : #private }
TwyElement >> computeOrderBetween: beforeElement and: nextElement [
	order := beforeElement order + nextElement order / 2.0
]

{ #category : #copying }
TwyElement >> copy [

	| copy |
	copy := super copy.
	copy 
		basicNext: nil;
		basicPrevious: nil;
		text: nil;
		attributes: attributes copy.
		
	^copy
]

{ #category : #editing }
TwyElement >> delete [

	| change |
	previous next: next.
	
	change := TwyElementsGroupRemoved startedWith: self between: previous and: next.

	self publishChange: change
]

{ #category : #editing }
TwyElement >> deleteIfRedundant [
]

{ #category : #editing }
TwyElement >> ensureAnySpan [

	self requiredSpanBeforeNextElement ifFalse: [ ^self ].
		
	self insertEmptySpanSilently
]

{ #category : #accessing }
TwyElement >> findLiveElementBackward [
	self isDeleted ifFalse: [ ^self ].
	^previous findLiveElementBackward
]

{ #category : #accessing }
TwyElement >> findLiveElementForward [
	self isDeleted ifFalse: [ ^self ].
	^next findLiveElementForward
]

{ #category : #enumeration }
TwyElement >> forwardDo: actionBlock [

	self forwardDo: actionBlock while: [ :each | true ]
]

{ #category : #enumeration }
TwyElement >> forwardDo: actionBlock while: whileBlock [

	| each |
	each := next.
	
	[each notNil and: [each isTextEnd not and: [whileBlock value: each]]] whileTrue: [ 
		actionBlock value: each.
		each := each next ]
]

{ #category : #accessing }
TwyElement >> getAttribute: anAttributeClass [

	^self getAttribute: anAttributeClass ifAbsent: [^text getAttribute: anAttributeClass] 
]

{ #category : #accessing }
TwyElement >> getAttribute: anAttributeClass ifAbsent: aBlock [

	^attributes valueOf: anAttributeClass ifAbsent: aBlock
]

{ #category : #testing }
TwyElement >> hasAttribute: aTextAttributeClass [ 
	^attributes includes: aTextAttributeClass 
]

{ #category : #testing }
TwyElement >> hasSpecificAttributes [
	^attributes isEmpty not
]

{ #category : #editing }
TwyElement >> importAttributesFrom: anotherElement [

	self importAttributesFrom: anotherElement	excepting:  #()
]

{ #category : #editing }
TwyElement >> importAttributesFrom: anotherElement excepting: exceptionsListOfClasses [

	anotherElement attributesDo: [ :each |
		(exceptionsListOfClasses includes: each class) ifFalse: [ 
			self applyAttribute: each copy]
	]
]

{ #category : #'initialize-release' }
TwyElement >> initialOrderNumber [

	^0.0
]

{ #category : #'initialize-release' }
TwyElement >> initialize [
	super initialize.
	
	attributes := TwyAttributes new.
	order := self initialOrderNumber
]

{ #category : #editing }
TwyElement >> insertElement: newElement [
	| last elementAfterInsertion change |
	
	last := self.
	newElement withYourselfForwardDo: [ :each | 
		each prepareInsertionTo: text between: last and: next.
		last := each] while: [:each | each ~~  next].
	
	elementAfterInsertion := next.
	last next: next.
	self next: newElement.
	self ensureAnySpan.

	change := TwyElementInserted on: next after: self before: elementAfterInsertion.
	self publishChange: change.
		
	self deleteIfRedundant.
	elementAfterInsertion deleteIfRedundant.
	newElement deleteIfRedundant.
	last deleteIfRedundant
]

{ #category : #editing }
TwyElement >> insertEmptySpan [

	| span |
	span := self insertEmptySpanSilently.
	self publishChange: (TwyElementInserted on: span after: self before: span next)
]

{ #category : #private }
TwyElement >> insertEmptySpanSilently [

	| span |
	span := TwyCharactersSpan of: text.
	span computeOrderBetween: self and: next.
	span next: next.
	self next: span.
	^span
]

{ #category : #testing }
TwyElement >> isAfter: anotherElement [
	^order > anotherElement order
]

{ #category : #testing }
TwyElement >> isAttachedTo: aTwyElement [
	^next == aTwyElement or: [ previous == aTwyElement ]
]

{ #category : #testing }
TwyElement >> isBefore: anotherElement [
	^order < anotherElement order
]

{ #category : #testing }
TwyElement >> isDeleted [
	^(next previous == self) not
]

{ #category : #testing }
TwyElement >> isLineStart [
	^false
]

{ #category : #testing }
TwyElement >> isSpan [
	^false
]

{ #category : #testing }
TwyElement >> isTextEnd [
	^false
]

{ #category : #testing }
TwyElement >> isTextStart [
	^false
]

{ #category : #accessing }
TwyElement >> itemAt: anIndex ifAbsent: absentBlock [
	self subclassResponsibility 
]

{ #category : #accessing }
TwyElement >> length [
	self subclassResponsibility 
]

{ #category : #accessing }
TwyElement >> next [
	
	^ next
]

{ #category : #accessing }
TwyElement >> next: aTwyElement [
	
	next := aTwyElement.
	next text: text.
	next basicPrevious: self
]

{ #category : #accessing }
TwyElement >> nextSpanIfAbsent: aBlock [

	next isSpan ifTrue: [ ^next ].
	
	^next nextSpanIfAbsent: aBlock
]

{ #category : #accessing }
TwyElement >> order [
	^ order
]

{ #category : #accessing }
TwyElement >> order: anObject [
	order := anObject
]

{ #category : #'initialize-release' }
TwyElement >> prepareInsertionTo: aTwyText between: beforeElement and: nextElement [ 

	text := aTwyText.
	self computeOrderBetween: beforeElement and: nextElement
]

{ #category : #accessing }
TwyElement >> previous [
	
	^ previous
]

{ #category : #accessing }
TwyElement >> previous: aTwyElement [
	
	previous := aTwyElement.
	previous text: text.
	previous basicNext: self
]

{ #category : #accessing }
TwyElement >> previousSpanIfAbsent: aBlock [

	previous isSpan ifTrue: [ ^previous ].
	
	^previous previousSpanIfAbsent: aBlock
]

{ #category : #private }
TwyElement >> publishChange: aTwyStateChanged [
	text publishChange: aTwyStateChanged 
]

{ #category : #editing }
TwyElement >> removeAttribute: aTwyAttributeClass [

	| currentAttribute |
	currentAttribute := attributes get: aTwyAttributeClass ifAbsent: [ ^self ].
	
	attributes remove: aTwyAttributeClass.
	
	self publishChange: (TwyElementAttributeChanged on: self initialAttribute: currentAttribute newAttribute: nil).
]

{ #category : #testing }
TwyElement >> requiredSpanBeforeNextElement [

	^next isSpan not
]

{ #category : #accessing }
TwyElement >> text [
	
	^ text
]

{ #category : #accessing }
TwyElement >> text: anObject [
	
	text := anObject
]

{ #category : #enumeration }
TwyElement >> withYourselfBackwardDo: actionBlock [

	next backwardDo: actionBlock
]

{ #category : #enumeration }
TwyElement >> withYourselfForwardDo: actionBlock [

	self withYourselfForwardDo: actionBlock while: [ :each | true ]
]

{ #category : #enumeration }
TwyElement >> withYourselfForwardDo: actionBlock while: conditionBlock [

	previous ifNil: [ 
		^TwyTextStart new basicNext: self; forwardDo: actionBlock while: conditionBlock ].
	
	previous forwardDo: actionBlock while: conditionBlock
]
