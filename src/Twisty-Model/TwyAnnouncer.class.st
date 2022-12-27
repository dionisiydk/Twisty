"
I'm simple announcer which used by TwyText to publish events .
I know how collect text changes during block execution
"
Class {
	#name : #TwyAnnouncer,
	#superclass : #Announcer,
	#category : #'Twisty-Model'
}

{ #category : #controlling }
TwyAnnouncer >> collectChangesOf: aTwyText during: aBlockClosure [ 
	| changes collectionBlock |
	changes := TwyChangesCollection of: aTwyText.
	collectionBlock := [:ann | changes add: ann ].

	self when: TwyImmediateChangeAnnouncement send: #value: to: collectionBlock.

	aBlockClosure ensure: [self unsubscribe: collectionBlock].
	
	^changes
]
