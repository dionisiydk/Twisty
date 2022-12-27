"
I'm result of characters span override change.

Public API and Key Messages

- restString returns string after override position which was not overridden 
- hasRestString
- moveToEnd: aTextRegion will move text region to the end of overriden characters

TwyOverrideResult noChangesBy: change
TwyOverrideResult of: aTwySpanContentsOverriden by: aString
 
Internal Representation and Key Implementation Points.

    Instance Variables
	change:		<aTwySpanContentsOverriden>
	newString:		<String>

"
Class {
	#name : #TwyOverrideResult,
	#superclass : #Object,
	#instVars : [
		'change',
		'newString'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyOverrideResult class >> noChangesBy: aString [
	^self of: nil by: aString
]

{ #category : #'instance creation' }
TwyOverrideResult class >> of: aSpanContentsOverriden by: aString [
	^self new
		change: aSpanContentsOverriden;
		newString: aString
		
]

{ #category : #accessing }
TwyOverrideResult >> change [
	
	^ change
]

{ #category : #accessing }
TwyOverrideResult >> change: anObject [
	
	change := anObject
]

{ #category : #testing }
TwyOverrideResult >> hasRestString [

	change ifNil: [ ^newString notEmpty ].
	
	^change overridenItemsCount < newString size
]

{ #category : #controlling }
TwyOverrideResult >> moveToEnd: aTextRegion [

	change ifNil: [ ^self ].
	
	change moveToEnd: aTextRegion
]

{ #category : #accessing }
TwyOverrideResult >> newString [
	
	^ newString
]

{ #category : #accessing }
TwyOverrideResult >> newString: anObject [
	
	newString := anObject
]

{ #category : #accessing }
TwyOverrideResult >> restString [
	change ifNil: [ ^newString ].
	
	^newString copyFrom: change overridenItemsCount + 1 to: newString size
]
