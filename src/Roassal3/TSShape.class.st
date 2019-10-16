"
I am the top class of shapes
"
Class {
	#name : #TSShape,
	#superclass : #TSAttributableObject,
	#instVars : [
		'paint',
		'path',
		'border',
		'parent',
		'isFixed',
		'encompassingRectangle'
	],
	#category : #'Roassal3-Shapes'
}

{ #category : #adding }
TSShape >> addedIn: aCanvas [
	| evt |
	self isFixed
		ifTrue: [ aCanvas addFixedShape: self ]
		ifFalse: [ aCanvas addBasicShape: self ].
	parent ifNotNil: [ self remove ].
	parent := aCanvas.
	
	evt := TSShapeAddedEvent new shape: self.
	self announce: evt.
	parent announce: evt.
]

{ #category : #converting }
TSShape >> asMarker [
	^ TSMarker new shape: self
]

{ #category : #border }
TSShape >> border [
	^ border
]

{ #category : #border }
TSShape >> border: aBorder [
	border := aBorder
]

{ #category : #border }
TSShape >> borderColor [
	^ self border color
]

{ #category : #border }
TSShape >> borderColor: aColor [
	self border color: aColor
]

{ #category : #border }
TSShape >> borderDo: aBlock [
	border ifNil: [ border := TSBorder new ].
	aBlock value: border
]

{ #category : #'accessing - computed' }
TSShape >> canvas [
	"Return the canvas in which I belong to. Can return nil if the shape is not added to a canvas" 
	parent ifNil: [ ^ nil ].
	^ parent isShape 
		ifTrue: [ parent canvas ]
		ifFalse: [ parent ]
]

{ #category : #accessing }
TSShape >> color [
	^ paint 
]

{ #category : #accessing }
TSShape >> color: aColor [
	paint := aColor.
	paint isColor ifTrue: [ ^ self ].
	paint := Color colorFrom: aColor.
]

{ #category : #accessing }
TSShape >> computeEncompassingRectangle [
	self subclassResponsibility
]

{ #category : #accessing }
TSShape >> encompassingRectangle [
	^ encompassingRectangle ifNil: [ 
		encompassingRectangle := self computeEncompassingRectangle ].
]

{ #category : #accessing }
TSShape >> encompassingRectangle: aRectangle [
	encompassingRectangle := aRectangle
]

{ #category : #accessing }
TSShape >> extent [
	^ self encompassingRectangle extent
]

{ #category : #testing }
TSShape >> hasBorder [
	^ border notNil and: [ border width > 0 ].
]

{ #category : #testing }
TSShape >> hasEventCallback [
	"Return true if at least one event callback has been added to the shape"
	^ announcer notNil and: [ announcer numberOfSubscriptions > 0 ]
]

{ #category : #accessing }
TSShape >> height [
	^ self extent y
]

{ #category : #testing }
TSShape >> includesPoint: aPoint [
	"Return true or false"
	^ false
]

{ #category : #accessing }
TSShape >> index [
	^ self attributeAt: #index ifAbsent: [ nil ].
]

{ #category : #accessing }
TSShape >> index: anInteger [
	^ self attributeAt: #index put: anInteger.
]

{ #category : #initialization }
TSShape >> initialize [
	super initialize.
	paint := Color lightGray.
	isFixed := false.
]

{ #category : #testing }
TSShape >> isFixed [ 
	^ isFixed
]

{ #category : #accessing }
TSShape >> isFixed: aBool [
	isFixed := aBool
]

{ #category : #testing }
TSShape >> isInACanvas [
	^ parent notNil
]

{ #category : #testing }
TSShape >> isShape [
	"Useful to lookup the canvas in a hierarchy of nested shapes"
	^ true
]

{ #category : #actions }
TSShape >> loadShape: aShape [
	self subclassResponsibility
]

{ #category : #accessing }
TSShape >> model [
	^ self attributeAt: #model ifAbsent: [ nil ].
]

{ #category : #accessing }
TSShape >> model: anObject [
	^ self attributeAt: #model put: anObject.
]

{ #category : #accessing }
TSShape >> noPaint [
	paint := nil
]

{ #category : #accessing }
TSShape >> paint [
	^ paint
]

{ #category : #accessing }
TSShape >> paint: aPaint [
	paint := aPaint
]

{ #category : #accessing }
TSShape >> paintOn: visitor [
	^ visitor paintFor: self form: self paint
]

{ #category : #accessing }
TSShape >> parent [
	^ parent
]

{ #category : #accessing }
TSShape >> parent: aCanvasOrComposite [
	parent := aCanvasOrComposite
]

{ #category : #path }
TSShape >> path [
	^ path
]

{ #category : #path }
TSShape >> path: aPath [
	path := aPath
]

{ #category : #copying }
TSShape >> postCopy [
	self 
		parent: nil; 
		announcer: nil;
		resetPath;
		resetBBox
]

{ #category : #actions }
TSShape >> pushBack [
	"Move the element behind. This method can be called only if the shape is in a canvas"
	self assert: [ parent notNil ] description: 'Should add the shape in a canvas first'.
	parent pushBack: self.
]

{ #category : #actions }
TSShape >> pushFront [
	parent pushFront: self.
]

{ #category : #actions }
TSShape >> remove [
	"Do nothing if the line is not already in a canvas"
	self isInACanvas ifFalse: [ ^ self ]. 
	parent removeShape: self
]

{ #category : #initialization }
TSShape >> resetBBox [
	encompassingRectangle := nil.
]

{ #category : #path }
TSShape >> resetPath [
	path := nil
]

{ #category : #path }
TSShape >> sessionChanged [
	self resetPath
]

{ #category : #actions }
TSShape >> setAsFixed [
	parent ifNil: [ self error: 'Add first this shape in the canvas' ].
	parent setAsFixed: self.
	isFixed := true.
]

{ #category : #accessing }
TSShape >> shape [
	^ self
]

{ #category : #'accessing - computed' }
TSShape >> shapeWithAction: eventClass forPosition: position [
	^ (self hasEventCallback and: [ 
		(self announcer handleEventClass: eventClass)
			and: [ self includesPoint: position ] ]) 
			
			ifTrue: [ self ]
			ifFalse: [ ^ nil ]
]

{ #category : #'accessing - computed' }
TSShape >> shapeWithActionForPosition: position [
	^ (self hasEventCallback and: [ self includesPoint: position ] ) 
			ifTrue: [ self ]
			ifFalse: [ ^ nil ]
]

{ #category : #accessing }
TSShape >> shapes [
	"only TSComposite can use shapes "
	^ nil
]

{ #category : #actions }
TSShape >> signalUpdate [
	"Refresh the canvas"
	parent ifNil: [ ^ self ].
	parent signalUpdate
]

{ #category : #accessing }
TSShape >> topParent [
	^ parent topParent
]

{ #category : #accessing }
TSShape >> width [
	^ self extent x
]