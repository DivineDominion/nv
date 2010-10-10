//
//  NSString_MultiMarkdown.m
//  Notation
//
//  Created by Christian Tietze on 2010-10-10.
//

#import "NSString_MultiMarkdown.h"


@implementation NSString (MultiMarkdown)

+ (NSString*)stringWithProcessedMultiMarkdown:(NSString*)inputString
{
    // TODO: first try ~/Lib/... and fall back to internal MMD
    //NSString* mdScriptPath = @"~/Library/Application Support/MultiMarkdown/bin/mmd2ZettelXHTML.pl";
    NSString* mdScriptPath = [[[[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"MultiMarkdown"] 
                               stringByAppendingPathComponent:@"bin"] 
                              stringByAppendingPathComponent:@"mmd2ZettelXHTML.pl"];

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
}

@end
