"
I implement editing operations with usual logic. I just insert characters at cursor position, I just remove selected text and I reset selection at the end of operations
"
Class {
	#name : #TwyNativeTextDecorator,
	#superclass : #TwyTextDecorator,
	#category : #'Twisty-Editor'
}

{ #category : #editing }
TwyNativeTextDecorator >> cutSelection: aTextRegion [
	aTextRegion cut
]

{ #category : #editing }
TwyNativeTextDecorator >> insertCharacters: aString at: aTextRegion [
	aTextRegion replaceWith: aString
]

{ #category : #editing }
TwyNativeTextDecorator >> removeNextCharacterAt: aTextRegion [
	aTextRegion deleteKey
]

{ #category : #editing }
TwyNativeTextDecorator >> removePreviousCharacterAt: aTextRegion [
	aTextRegion backspaceKey
]
