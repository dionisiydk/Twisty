"
I'm base announcement about collected changes during text>>#editContentsBy:  block execution.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	changes:		<TwyChangesCollection>
"
Class {
	#name : #TwyCollectedChangesAnnouncement,
	#superclass : #TwyChangesAnnouncement,
	#instVars : [
		'changes'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyCollectedChangesAnnouncement class >> changes: aTwyChangesCollection [
	^self new 
		changes: aTwyChangesCollection
]

{ #category : #accessing }
TwyCollectedChangesAnnouncement >> changes [
	
	^ changes
]

{ #category : #accessing }
TwyCollectedChangesAnnouncement >> changes: anObject [
	
	changes := anObject
]
