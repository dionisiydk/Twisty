"
I present text position by blinking cursor

Instance Variables
	cursor		<TwyLayoutCursor>
	updateTime:		<DateTime>
	cursorColor:		<Color>

updateTime
	- it is used to stop blink when editor position changed too often
"
Class {
	#name : #TwyCursorMorph,
	#superclass : #Morph,
	#instVars : [
		'updateTime',
		'cursorColor',
		'cursor',
		'active'
	],
	#category : #'Twisty-UI'
}

{ #category : #'focus management' }
TwyCursorMorph >> active: aBool [

	active := aBool.
	active 
		ifTrue: [ self show]
		ifFalse: [ self hide ]
]

{ #category : #menu }
TwyCursorMorph >> changeColor [
	"Change the color of the receiver -- triggered, e.g. from a menu"
	self active: true.
	
	UITheme current
		chooseColorIn: self
		title: 'Choose cursor color' translated
		color: self cursorColor
		for: [:newColor |				
			self cursorColor: newColor]
]

{ #category : #accessing }
TwyCursorMorph >> cursor [
	^cursor 
]

{ #category : #accessing }
TwyCursorMorph >> cursor: aTwyLayoutCursor [
	
	cursor := aTwyLayoutCursor.
	self hookupCursor
]

{ #category : #accessing }
TwyCursorMorph >> cursorColor [
	
	^ cursorColor
]

{ #category : #accessing }
TwyCursorMorph >> cursorColor: aColor [
	
	cursorColor := aColor.
	self active: true.
	self changed
]

{ #category : #'initialize-release' }
TwyCursorMorph >> defaultColor [ 
	^Color blue darker 
]

{ #category : #'focus management' }
TwyCursorMorph >> hide [

	super hide. 
	self stopStepping 
]

{ #category : #private }
TwyCursorMorph >> hookupCursor [

	cursor ifNotNil: [ cursor unsubscribe: self ].

	cursor when: TwyPositionChanged send: #updatePosition to: self
]

{ #category : #'initialize-release' }
TwyCursorMorph >> initialize [ 
	super initialize.
	
	active := false.
	cursorColor := self defaultColor.
	self width: 1.
	self visible: false
]

{ #category : #'focus management' }
TwyCursorMorph >> show [

	active ifFalse: [ ^self ].
	super show. 
	self startStepping 
]

{ #category : #'stepping and presenter' }
TwyCursorMorph >> step [
	updateTime ifNil: [ ^self color: cursorColor].
	DateAndTime now - updateTime < self stepTime milliSeconds ifTrue: [ ^self color: cursorColor  ].
	
	self color isTransparent
		ifTrue: [self color: cursorColor]
		ifFalse: [self color: Color transparent]
]

{ #category : #'stepping and presenter' }
TwyCursorMorph >> stepTime [
	^500
]

{ #category : #'stepping and presenter' }
TwyCursorMorph >> updatePosition [

	self height: cursor height.
	
	owner ifNil: [ ^self ].
	
	self position: owner position + cursor layoutPosition.
	updateTime := DateAndTime now.
	
]

{ #category : #'stepping and presenter' }
TwyCursorMorph >> wantsSteps [
	^self visible
]
