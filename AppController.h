/* AppController */

#import <Cocoa/Cocoa.h>

#import "NotationController.h"
#import "NotesTableView.h"

@class LinkingEditor;
@class EmptyView;
@class NotesTableView;
@class GlobalPrefs;
@class PrefsWindowController;
@class DualField;
@class RBSplitView;
@class RBSplitSubview;
@class TitlebarButton;
@class LinearDividerShader;

@interface AppController : NSObject {
    IBOutlet DualField *field;
	IBOutlet RBSplitSubview *splitSubview;
	IBOutlet RBSplitView *splitView;
    IBOutlet NotesTableView *notesTableView;
    IBOutlet LinkingEditor *textView;
	IBOutlet EmptyView *editorStatusView;
	IBOutlet NSMenuItem *sparkleUpdateItem;
    IBOutlet NSWindow *window;
	IBOutlet NSPanel *syncWaitPanel;
	IBOutlet NSProgressIndicator *syncWaitSpinner;
	
    // Rendered Text Preview
    IBOutlet NSWindow *previewWindow;
    IBOutlet WebView *previewWebView;
    BOOL isPreviewOutdated;
    
	NSToolbar *toolbar;
	NSToolbarItem *dualFieldItem;
	TitlebarButton *titleBarButton;
	
	BOOL waitedForUncommittedChanges;
	
	LinearDividerShader *dividerShader;
	
	NSMutableArray *notesToOpenOnLaunch;
	
    NSUndoManager *windowUndoManager;
    PrefsWindowController *prefsWindowController;
    GlobalPrefs *prefsController;
    NotationController *notationController;
	
	ViewLocationContext listUpdateViewCtx;
	BOOL isFilteringFromTyping, typedStringIsCached;
	BOOL isCreatingANote;
	NSString *typedString;
	
	NoteObject *currentNote;
	NSArray *savedSelectedNotes;
}

@property (readonly) NSWindow *window;
@property (readonly) NSWindow *previewWindow;
@property BOOL isPreviewOutdated;

void outletObjectAwoke(id sender);

- (void)setNotationController:(NotationController*)newNotation;

- (void)setupViewsAfterAppAwakened;
- (void)runDelayedUIActionsAfterLaunch;
- (void)updateNoteMenus;

- (BOOL)addNotesFromPasteboard:(NSPasteboard*)pasteboard;
- (IBAction)renameNote:(id)sender;
- (IBAction)deleteNote:(id)sender;
- (IBAction)exportNote:(id)sender;
- (IBAction)printNote:(id)sender;
- (IBAction)tagNote:(id)sender;
- (IBAction)importNotes:(id)sender;

- (IBAction)fieldAction:(id)sender;
- (NoteObject*)createNoteIfNecessary;
- (void)searchForString:(NSString*)string;
- (NSUInteger)_revealNote:(NoteObject*)note options:(NSUInteger)opts;
- (BOOL)displayContentsForNoteAtIndex:(int)noteIndex;
- (void)processChangedSelectionForTable:(NSTableView*)table;
- (void)setEmptyViewState:(BOOL)state;
- (void)_setCurrentNote:(NoteObject*)aNote;
- (NoteObject*)selectedNoteObject;

- (void)restoreListStateUsingPreferences;

- (IBAction)syncWaitQuit:(id)sender;

- (void)setTableAllowsMultipleSelection;

- (NSString*)fieldSearchString;
- (void)cacheTypedStringIfNecessary:(NSString*)aString;
- (NSString*)typedString;

- (IBAction)showHelpDocument:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)toggleNVActivation:(id)sender;
- (IBAction)bringFocusToControlField:(id)sender;
- (NSWindow*)window;

- (NSWindow *)previewWindow;
- (IBAction)switchPreviewRenderingMode:(id)sender;
- (IBAction)togglePreviewWindow:(id)sender;
- (void)requestPreviewUpdate;
- (void)updatePreview:(id)context;

@end
