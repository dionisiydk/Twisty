"
I'm base announcement about logical events during text>>#editContentsBy:  block execution.

   Instance Variables
	time:		<DateAndTime>

"
Class {
	#name : #TwyChangesAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'time'
	],
	#category : #'Twisty-Model'
}

{ #category : #initialize }
TwyChangesAnnouncement >> initialize [
	super initialize.
	
	time := DateAndTime now
]

{ #category : #accessing }
TwyChangesAnnouncement >> time [
	^ time
]

{ #category : #accessing }
TwyChangesAnnouncement >> time: anObject [
	time := anObject
]
