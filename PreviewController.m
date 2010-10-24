//
//  PreviewController.m
//  Notation
//
//  Created by Christian Tietze on 15.10.10.
//  Copyright 2010

#import "PreviewController.h"
#import "AppController.h" // TODO for the defines only, can you get around that?
#import "AppController_Preview.h"
#import "NSString_MultiMarkdown.h"
#import "NSString_Markdown.h"
#import "NSString_Textile.h"

@implementation PreviewController

@synthesize preview;
@synthesize isPreviewOutdated;

-(id)init
{
    if ((self = [super initWithWindowNibName:@"MarkupPreview" owner:self])) {
        self.isPreviewOutdated = YES;
    }
    return self;
}

-(void)requestPreviewUpdate:(NSNotification *)notification
{
    if (![[self window] isVisible]) {
        self.isPreviewOutdated = YES;
        return;
    }
    
    AppController *app = [notification object];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preview:) object:app];
    
    [self performSelector:@selector(preview:) withObject:app afterDelay:0.5];
}

-(void)togglePreview:(id)sender
{
    NSWindow *wnd = [self window];
    
    if ([wnd isVisible]) {
        [wnd orderOut:self];
    } else {
        if (self.isPreviewOutdated) {
            // TODO high coupling; too many assumptions on architecture:
            [self performSelector:@selector(preview:) withObject:[[NSApplication sharedApplication] delegate] afterDelay:0.0];
        }
        
        [wnd orderFront:self];
    }
}

-(void)preview:(id)object
{
    AppController *app = object;
    NSString *rawString = [app noteContent];
    SEL mode = [self markupProcessorSelector:[app currentPreviewMode]];
    NSString *processedString = [NSString performSelector:mode withObject:rawString];
    
    [[preview mainFrame] loadHTMLString:processedString baseURL:nil];
    
    self.isPreviewOutdated = NO;
}

-(SEL)markupProcessorSelector:(NSInteger)previewMode
{
    if (previewMode == MarkdownPreview) {
        return @selector(stringWithProcessedMarkdown:);
    } else if (previewMode == MultiMarkdownPreview) {
        return @selector(stringWithProcessedMultiMarkdown:);
    } else if (previewMode == TextilePreview) {
        return @selector(stringWithProcessedTextile:);
    }
    
    return nil;
}

-(IBAction)saveHTML:(id)sender
{
    // TODO high coupling; too many assumptions on architecture:
    AppController *app = [[NSApplication sharedApplication] delegate];
    NSString *rawString = [app noteContent];
    NSString *processedString = [NSString stringWithProcessedMultiMarkdown:rawString];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    NSArray *fileTypes = [[NSArray alloc] initWithObjects:@"html",@"xhtml",@"htm",nil];
    [savePanel setAllowedFileTypes:fileTypes];
    
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        NSURL *file = [savePanel URL];
        NSError *error;
        [processedString writeToURL:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
    }
    
    [fileTypes release];
}
@end
