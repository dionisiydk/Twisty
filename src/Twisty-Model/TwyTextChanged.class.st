"
I announce that text was changed during text>>#editContentsBy:  block execution.

My collected text changes can be cancelled by #cancel message
"
Class {
	#name : #TwyTextChanged,
	#superclass : #TwyCollectedChangesAnnouncement,
	#category : #'Twisty-Model'
}

{ #category : #cancelling }
TwyTextChanged >> cancel [
	changes cancel
]

{ #category : #layout }
TwyTextChanged >> collectLayoutCommandsFor: aLayoutBuilder [
	
	changes textChanges do: [ :each |
		
		aLayoutBuilder addLayoutCommand: (TwyProcessTextChangeCommand on: each)
	]
]
