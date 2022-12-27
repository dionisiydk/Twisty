Extension { #name : #TwyCharactersSpan }

{ #category : #'*Twisty-Layout' }
TwyCharactersSpan >> createDrawerBy: aLayoutBuilder [

	| drawer |
	(self hasAttribute: TwySecretAsterixAttribute)
		ifTrue: [ 
			drawer := TwySecretCharactersSpanDrawer withSubstitutionChar: (self getAttribute: TwySecretAsterixAttribute).
			(self hasAttribute: TwyMaskAsterixAttribute) ifTrue: [ 
				drawer excludeChar: (self getAttribute: TwyMaskAsterixAttribute) ] ]
		ifFalse: [ drawer := TwyCharactersSpanDrawer new].
	
	drawer font: (aLayoutBuilder selectFontFor: self).
	
	^drawer
]
