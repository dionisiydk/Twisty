"
I'm the root of the hierarchy of text changes like state changes or cursor movements.
All subclasses must implement #cancel method to revert changes

Public API and Key Messages

- cancel 
- isTextStateChange 

Internal Representation and Key Implementation Points.

    Instance Variables
	text:		<TwyText>

"
Class {
	#name : #TwyImmediateChangeAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'text'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyImmediateChangeAnnouncement class >> onText: aTwyText [

	^self new 
		text: aTwyText

]

{ #category : #cancelling }
TwyImmediateChangeAnnouncement >> cancel [
	self subclassResponsibility 
]

{ #category : #testing }
TwyImmediateChangeAnnouncement >> isTextStateChange [
	self subclassResponsibility 
]

{ #category : #accessing }
TwyImmediateChangeAnnouncement >> text [
	
	^ text
]

{ #category : #accessing }
TwyImmediateChangeAnnouncement >> text: anObject [
	
	text := anObject
]
