"
I present horisontal alignment of text line.
I should be used only in LineStart text element.

My value is instance of TwyTextAlignment. See it class side 
"
Class {
	#name : #TwyLineAlignmentAttribute,
	#superclass : #TwyAttribute,
	#category : #'Twisty-Model'
}

{ #category : #accessing }
TwyLineAlignmentAttribute class >> defaultValue [
	^TwyTextAlignment leftToRight
]
