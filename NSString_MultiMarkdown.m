//
//  NSString_MultiMarkdown.m
//  Notation
//
//  Created by Christian Tietze on 2010-10-10.
//

#import "NSString_MultiMarkdown.h"


@implementation NSString (MultiMarkdown)

/**
 * Locating a MultiMarkdown parsing script.  The options are as follows:
 *   1.  ~/Library/Application Support/MultiMarkdown/bin/mmd2ZettelXHTML.pl
 *   2.  ~/Library/Application Support/MultiMarkdown/bin/mmd2XHTML.pl
 *   3.  <Application>/MultiMarkdown/bin/mmd2ZettelXHTML.pl
 *
 * The third option should be a safe fallback since the appropriate MMD bundle
 * is included and shipped with this application.
 */
+(NSString*)mmdDirectory {
    // fallback path in this program's directiory
    NSString *bundlePath = [[[[[NSBundle mainBundle] resourcePath] 
                              stringByAppendingPathComponent:@"MultiMarkdown"] 
                             stringByAppendingPathComponent:@"bin"] 
                            stringByAppendingPathComponent:@"mmd2ZettelXHTML.pl"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0) {
        NSString *path = [[[paths objectAtIndex:0] 
                           stringByAppendingPathComponent:@"MultiMarkdown"] 
                          stringByAppendingPathComponent:@"bin"];
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *mmdZettel = [path stringByAppendingPathComponent:@"mmd2ZettelXHTML.pl"];
        NSString *mmdDefault = [path stringByAppendingPathComponent:@"mmd2XHTML.pl"];
        
        if ([mgr fileExistsAtPath:mmdZettel]) {
            return mmdZettel;
        } else if ([mgr fileExistsAtPath:mmdDefault]) {
            return mmdDefault;
        }
    }
    
    return bundlePath;
} // mmdDirectory

+(NSString*)stringWithProcessedMultiMarkdown:(NSString*)inputString
{
    NSString* mdScriptPath = [[self class] mmdDirectory];
    
	NSTask* task = [[[NSTask alloc] init] autorelease];
	NSMutableArray* args = [NSMutableArray array];
	
	[task setArguments:args];
	
	NSPipe* stdinPipe = [NSPipe pipe];
	NSPipe* stdoutPipe = [NSPipe pipe];
	NSFileHandle* stdinFileHandle = [stdinPipe fileHandleForWriting];
	NSFileHandle* stdoutFileHandle = [stdoutPipe fileHandleForReading];
	
	[task setStandardInput:stdinPipe];
	[task setStandardOutput:stdoutPipe];
	
	[task setLaunchPath: [mdScriptPath stringByExpandingTildeInPath]];
	[task launch];
	
	[stdinFileHandle writeData:[inputString dataUsingEncoding:NSUTF8StringEncoding]];
	[stdinFileHandle closeFile];
	
	NSData* outputData = [stdoutFileHandle readDataToEndOfFile];
	NSString* outputString = [[[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding] autorelease];
	[stdoutFileHandle closeFile];
	
	[task waitUntilExit];
	
	return outputString;
} // stringWithProcessedMultiMarkdown:

@end // NSString (MultiMarkdown)
