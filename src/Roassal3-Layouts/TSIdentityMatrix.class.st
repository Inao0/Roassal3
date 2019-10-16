"
TODO
"
Class {
	#name : #TSIdentityMatrix,
	#superclass : #RSObject,
	#instVars : [
		'rows'
	],
	#category : #'Roassal3-Layouts-Utils'
}

{ #category : #accessing }
TSIdentityMatrix >> at: u [
	
	| row |
	row := rows
		at: u
		ifAbsentPut: [IdentityDictionary new].
	^row keys
]

{ #category : #accessing }
TSIdentityMatrix >> at: u at: v [
	
	| row |
	row := rows
		at: u
		ifAbsentPut: [IdentityDictionary new].
	^row
		at: v
		ifAbsent: [false]
]

{ #category : #accessing }
TSIdentityMatrix >> at: u at: v put: aBoolean [
	
	| row |
	"u -> v"
	row := rows
		at: u
		ifAbsentPut: [IdentityDictionary new].
	row at: v put: aBoolean.	"v -> u"
	row := rows
		at: v
		ifAbsentPut: [IdentityDictionary new].
	row at: u put: aBoolean
]

{ #category : #'initialize-release' }
TSIdentityMatrix >> initialize [
	
	rows := IdentityDictionary new
]