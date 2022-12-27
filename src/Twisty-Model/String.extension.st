Extension { #name : #String }

{ #category : #'*Twisty-Model' }
String >> asTwySecretText [
	| text |
	text := self asTwyText.
	text spansDo: [ :each| each applyAttribute: (TwySecretAsterixAttribute with: $* ) ].
	^text
]

{ #category : #'*Twisty-Model' }
String >> asTwyText [
	| text |
	text := TwyText new.
	text readElementsFrom: (TwyElementsReadStream on: self readStream).
	^text
]
