"
I'm collection of text changes .
I contain separate lists of text state changes and text cursor movements.
I can be cancelled by #cancel message

Public API and Key Messages

- cancel 

Internal Representation and Key Implementation Points.

    Instance Variables
	text:		<TwyText>
	cursorsChanges:		<Collection of TwyCursorMoved>	
	textChanges:		<Collection of TwyTextStateChanged>
"
Class {
	#name : #TwyChangesCollection,
	#superclass : #Object,
	#instVars : [
		'text',
		'cursorsChanges',
		'textChanges'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyChangesCollection class >> of: aTwyText [
	^self new 
		text: aTwyText
]

{ #category : #accessing }
TwyChangesCollection >> add: aChangeAnnouncement [

	aChangeAnnouncement isTextStateChange 
		ifTrue: [self addTextChange: aChangeAnnouncement]
		ifFalse: [ self addCursorChange: aChangeAnnouncement ]
]

{ #category : #accessing }
TwyChangesCollection >> addCursorChange: aCursorChanged [
		
	(cursorsChanges anySatisfy: [ :each | each isAboutSameCursorAs: aCursorChanged ])
		ifTrue: [ ^self ].
		
	cursorsChanges add: aCursorChanged
]

{ #category : #accessing }
TwyChangesCollection >> addTextChange: aStateChanged [
		
	textChanges add: aStateChanged 
]

{ #category : #cancelling }
TwyChangesCollection >> cancel [

	text when: TwyCursorMoved send: #add: to: self.
	[
		textChanges reverseDo: [:each | each cancel ].
	] ensure: [ text unsubscribe: self].
	
	cursorsChanges reverseDo: [:each | each cancel ]
]

{ #category : #accessing }
TwyChangesCollection >> cursorsChanges [
	
	^ cursorsChanges
]

{ #category : #accessing }
TwyChangesCollection >> cursorsChanges: anObject [
	
	cursorsChanges := anObject
]

{ #category : #'initialize-release' }
TwyChangesCollection >> initialize [ 
	super initialize.
	
	textChanges := OrderedCollection new.
	cursorsChanges := OrderedCollection new.
]

{ #category : #accessing }
TwyChangesCollection >> text [
	
	^ text
]

{ #category : #accessing }
TwyChangesCollection >> text: anObject [
	
	text := anObject
]

{ #category : #accessing }
TwyChangesCollection >> textChanges [
	^textChanges
]

{ #category : #accessing }
TwyChangesCollection >> textChanges: anObject [
	
	textChanges := anObject
]
