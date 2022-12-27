"
I validate state of text which is decorated by specific text decorator. 
I have valid text spec which check native text contents extracted by given decorator. 

Instance Variables
	textSpec:		<TwyTextSpec>

textSpec
	- should implement #check: to validate given text

"
Class {
	#name : #TwyTextValidator,
	#superclass : #Object,
	#instVars : [
		'textSpec'
	],
	#category : #'Twisty-Editor'
}

{ #category : #'instance creation' }
TwyTextValidator class >> withSpec: aTextSpec [
	^self new
		textSpec: aTextSpec
]

{ #category : #'initialize-release' }
TwyTextValidator >> initialize [ 
	super initialize.
	
	textSpec := TwyAnyTextSpec new
]

{ #category : #accessing }
TwyTextValidator >> textSpec [
	^ textSpec
]

{ #category : #accessing }
TwyTextValidator >> textSpec: anObject [
	textSpec := anObject
]

{ #category : #operations }
TwyTextValidator >> validateText: aTwyText decoratedBy: aTextDecorator [

	| textString |
	
	textString := aTextDecorator extractNativeStringFrom: aTwyText.
	
	^textSpec check: textString
	
]
