"
I am null object for editor textValidator. Any text is valid for me
"
Class {
	#name : #TwyNullTextValidator,
	#superclass : #Object,
	#category : #'Twisty-Editor'
}

{ #category : #operations }
TwyNullTextValidator >> validateText: aTwyText decoratedBy: aTextDecorator [
	^true
]
