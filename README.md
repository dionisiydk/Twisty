# Twisty
Twisty - Text With actIve STate model

Twisty is text implementation based on active state idea. In this library text instances announce any change which happens with it. Due to this behavior Twisty provides cursors and layout objects which state are automatically restored after text changes. It is simplified implementation of text tools which operate on single text instance. They do not need to implement any synchronization of their state when somebody edit text.

Any text editing should be performed by:

```Smalltalk
text 
    editContentsBy: [cursor insert: ‘new string’] 
    andSubmitChangesBy: [text asString allDigits]
```

First block in this example performs text changes by cursor instance. Cursor can be fetched by "text newActiveCursor". Also text can be edited by text region instances. Last block is predicate which validate changes. At the time of its execution text already applied all changes from first block. So full and completed text state can be verified. If state is incorrect all changes will be cancelled. If anything ok text will accept all changes by announcing TwyTextChanged event. In this example changes will be cancelled and ’new string’ will be not accepted. There is short version of editing method without any validation:

```Smalltalk
text editContentsBy: [region backspaceKey]
```

Editing methods return announced event. It can be TwyTextChanged or TwyChangesCancelled events. This events contains all changes which happened during editing block execution. Changes are presented by first class objects subclasses of TwyImmediateChangeAnnouncement: TwyCharactersSpanIncreased, TwyElementInserted, TwyElementsGroupRemoved, TwyCursorMoved and others. Changes can be cancelled. Cancel should be performed inside editing block:

```Smalltalk
text editContentsBy: [textChanged cancel]
```

It is used for undo/redo implementation.

Twisty implements single text morph TwyTextMorph. Different behavior should be implemented by specific class of text tool (subclasses of TwyTextTool). It can be editor tool, selection tool, cursor tool, undo/redo tool and others. Text morph contains collection of such tools. Different combination of tools supplies different behavior. For example, text morph without any tools is simple readonly text field. Text morph with selection tool allows select text region and copy it to clipboard. If cursor tool are added to morph then blinked cursor are shown for visible text navigation. Tools approach allows replace usual hierarchy of text morphs by composition of tool classes. Tools are added to text morph by:

```Smalltalk
textMorph ensureTool: TwyCursorTool
```

TwyEditorTool adds editing behavior to text morph. It subscribes on key press events from morph to accept arbitrary characters input, cut selection or insert clipboard contents. All actions are delegated to instance of TwyEditor. Editor by itself delegates execution of actions to text decorator and then It validates resulted changes by text validator. Text validator is responsible for text changes verification. For example validator can check that text has only digits and forbid insertion of any other characters. By default editor has TwyNullTextValidator which allowed any text. Text decorator is responsible for specific processing of usual editing operations. Text decorator decides how characters should be inserted or removed, how selected text region should be changed. By default editor have TwyNativeTextDecorator which inserts characters with usual logic where characters are inserted at cursor position and selection region are reset. But there is TwyMaskedTextDecorator which implements it differently. It overrides asterix characters of mask with inserted string and skips non asterix characters.
