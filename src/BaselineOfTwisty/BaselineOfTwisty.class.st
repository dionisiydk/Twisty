Class {
	#name : #BaselineOfTwisty,
	#superclass : #BaselineOf,
	#category : #BaselineOfTwisty
}

{ #category : #baselines }
BaselineOfTwisty >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry:v6.0.4' ].
		spec 
			package: #'Twisty-Model';
			package: #'Twisty-Layout' with: [
				spec requires: #(#'Twisty-Model' ). ];
			package: #'Twisty-Editor' with: [
				spec requires: #(#'Twisty-Model' ). ];
			package: #'Twisty-UI' with: [
				spec requires: #(#'Twisty-Model' #'Twisty-Layout' #'Twisty-Editor' ). ];
			package: #'TwistyTests-Model' with: [
				spec requires: #('Mocketry' #'Twisty-Model' ). ];
			package: #'TwistyTests-Layout' with: [
				spec requires: #('Mocketry' #'Twisty-Model' #'Twisty-Layout' ). ];
			package: #'TwistyTests-Editor' with: [
				spec requires: #('Mocketry' #'Twisty-Model' #'Twisty-Editor' ). ].
		spec 
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #(#'Twisty-Model' #'Twisty-Layout' #'Twisty-Editor' #'Twisty-UI' );
			group: 'Tests' with: #(#'TwistyTests-Model' #'TwistyTests-Layout' #'TwistyTests-Editor' ). ].

]
