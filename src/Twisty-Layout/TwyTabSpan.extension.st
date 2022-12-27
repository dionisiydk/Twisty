Extension { #name : #TwyTabSpan }

{ #category : #'*Twisty-Layout' }
TwyTabSpan >> createDrawerBy: aLayoutBuilder [ 
	| drawer |
	drawer := TwyTabSpanDrawer new.
	
	drawer font: (aLayoutBuilder selectFontFor: self).
	
	^drawer
]
