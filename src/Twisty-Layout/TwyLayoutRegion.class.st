"
I am region inside text layout between two layout cursors.  
You can get me from layout object by: 	
	layout newRegion

I subscribe on events from start, end and layout to announce my own TwyLayoutChanged event. I ensure that I announce it only when my start and end cursors are in correct fixed state.
Cursors can change they position in two cases: when user move cursor and when text changed and layout structure changed. 
For first case I should announce event immediatelly after cursor changed position.
But for last case I should announce event only when both cursors (start and end) fixed there positions. So I ask cursors to not look react on layout changes and I manually fix there positions on layout changed event (see #recomputeBounds method).

    Instance Variables
	layout:		<TwyLayout>
	start:		<TwyLayoutCursor>
	end:		<TwyLayoutCursor>
"
Class {
	#name : #TwyLayoutRegion,
	#superclass : #Announcer,
	#instVars : [
		'layout',
		'start',
		'end'
	],
	#category : #'Twisty-Layout'
}

{ #category : #'instance creation' }
TwyLayoutRegion class >> on: aTwyLayout [

	^self new 
		initializeOn: aTwyLayout
]

{ #category : #accessing }
TwyLayoutRegion >> actualEnd [
	
	^ (end isBefore: start) ifTrue: [ start ] ifFalse: [ end ]
]

{ #category : #accessing }
TwyLayoutRegion >> actualStart [
	
	^ (end isBefore: start) ifTrue: [ end ] ifFalse: [ start ]
]

{ #category : #private }
TwyLayoutRegion >> boundsChanged [
	self announce: TwyLayoutChanged 
]

{ #category : #controlling }
TwyLayoutRegion >> detachText [
	start detachText.
	end detachText
]

{ #category : #drawing }
TwyLayoutRegion >> drawHighlightsOn: aCanvas at: aPoint withColor: aColor [ 

	self isEmpty ifTrue: [ ^self ].

	(start isAtSameLineWith: end) ifTrue: [ 
		^aCanvas 
			fillRectangle: ((self actualStart rightSideLineBounds intersect: self actualEnd leftSideLineBounds) translateBy: aPoint)
			color: aColor].

	aCanvas fillRectangle: (self actualStart rightSideLineBounds translateBy: aPoint) color: aColor.
	aCanvas fillRectangle: (self actualEnd leftSideLineBounds translateBy: aPoint) color: aColor.
	
	start line == end aboveLine ifTrue: [^self].
	
	aCanvas 
		fillRectangle: ((self actualStart belowLayoutBoundsUpTo: self actualEnd aboveLine) translateBy: aPoint) 
		color: aColor
]

{ #category : #accessing }
TwyLayoutRegion >> end [
	
	^ end
]

{ #category : #accessing }
TwyLayoutRegion >> end: anObject [
	
	end := anObject
]

{ #category : #'initialize-release' }
TwyLayoutRegion >> initializeOn: aTwyLayout [
	
	layout := aTwyLayout.
	start := layout newCursor.
	start ignoreLayoutChanges.
	end := layout newCursor.
	end ignoreLayoutChanges.
	self subscribeOnBoundsChanges
]

{ #category : #testing }
TwyLayoutRegion >> isEmpty [
	^start isAtSameTextPositionWith: end
]

{ #category : #accessing }
TwyLayoutRegion >> layout [
	
	^ layout
]

{ #category : #accessing }
TwyLayoutRegion >> layout: aTwyLayout [
	
	layout := aTwyLayout
]

{ #category : #controlling }
TwyLayoutRegion >> recomputeBounds [
	| trigger boundsChanged |
	self unsubscribeFromStartAndEnd.
	
	trigger := [ boundsChanged := true ].
	start when: TwyPositionChanged send: #value to: trigger.
	end when: TwyPositionChanged send: #value to: trigger.
	
	start synchronizeWithTextCursor.
	end synchronizeWithTextCursor.
	
	start unsubscribe: trigger.
	end unsubscribe: trigger.	
	self subscribeOnStartAndEndChanges.
	
	boundsChanged = true ifTrue: [ self boundsChanged ].
]

{ #category : #accessing }
TwyLayoutRegion >> start [
	
	^ start
]

{ #category : #accessing }
TwyLayoutRegion >> start: anObject [
	
	start := anObject
]

{ #category : #private }
TwyLayoutRegion >> subscribeOnBoundsChanges [

	self subscribeOnStartAndEndChanges.
	layout when: TwyLayoutChanged send: #recomputeBounds to: self.
]

{ #category : #private }
TwyLayoutRegion >> subscribeOnStartAndEndChanges [

	start when: TwyPositionChanged send: #boundsChanged to: self.
	end when: TwyPositionChanged send: #boundsChanged to: self
]

{ #category : #accessing }
TwyLayoutRegion >> textRegion [
	^TwyTextRegion from: start textCursor to: end textCursor
]

{ #category : #private }
TwyLayoutRegion >> unsubscribeFromStartAndEnd [ 
	start unsubscribe: self.
	end unsubscribe: self
]
