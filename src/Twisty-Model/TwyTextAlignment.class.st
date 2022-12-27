"
I represent text alignment method which holds at lineAlignmentSelector. I apply it to line object to align it within given extent

Instance Variables
	lineAlignmentSelector:		Symbol
"
Class {
	#name : #TwyTextAlignment,
	#superclass : #Object,
	#instVars : [
		'lineAlignmentSelector'
	],
	#category : #'Twisty-Model'
}

{ #category : #'instance creation' }
TwyTextAlignment class >> centered [
	^self new 
		lineAlignmentSelector: #alignCenteredWithin: 
]

{ #category : #'instance creation' }
TwyTextAlignment class >> leftToRight [
	^self new 
		lineAlignmentSelector: #alignLeftToRightWithin: 
]

{ #category : #'instance creation' }
TwyTextAlignment class >> rightToLeft [
	^self new 
		lineAlignmentSelector: #alignRightToLeftWithin: 
]

{ #category : #layout }
TwyTextAlignment >> layoutLine: aLayoutLine within: maxLineWidth [

	aLayoutLine perform: lineAlignmentSelector with: maxLineWidth 
]

{ #category : #accessing }
TwyTextAlignment >> lineAlignmentSelector [
	^ lineAlignmentSelector
]

{ #category : #accessing }
TwyTextAlignment >> lineAlignmentSelector: anObject [
	lineAlignmentSelector := anObject
]
