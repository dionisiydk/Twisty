"
I provide ""overwrite mode"" editing when new inserted characted replace existed which follows cursor position
"
Class {
	#name : #TwyOverwriteModeDecorator,
	#superclass : #TwyNativeTextDecorator,
	#category : #'Twisty-Editor'
}

{ #category : #editing }
TwyOverwriteModeDecorator >> insertCharacters: aString at: aTextRegion [

	aTextRegion end moveForward: aString size.
	aTextRegion replaceWith: aString
]
