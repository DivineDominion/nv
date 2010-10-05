#import "NSString-Markdown.h"

@implementation NSString (Markdown)

+ (NSString*)stringWithProcessedMarkdown:(NSString*)inputString
{
	// NSString* mdScriptPath = @"~/Library/Application Support/MultiMarkdown/bin/mmd2XHTML.pl";
	// NSString* mdScriptPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Markdown_1.0.1"] stringByAppendingPathComponent:@"Markdown.pl"];
    NSString* mdScriptPath = [[[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MultiMarkdown"] stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"mmd2ZettelXHTML.pl"];
	
	NSTask* task = [[NSTask alloc] init];
	NSMutableArray* args = [NSMutableArray array];
	
	//[args addObject:mdScriptPath];
	[task setArguments:args];
	
	NSPipe* stdinPipe = [NSPipe pipe];
	NSPipe* stdoutPipe = [NSPipe pipe];
	NSFileHandle* stdinFileHandle = [stdinPipe fileHandleForWriting];
	NSFileHandle* stdoutFileHandle = [stdoutPipe fileHandleForReading];
	
	[task setStandardInput:stdinPipe];
	[task setStandardOutput:stdoutPipe];
	
	//[task setLaunchPath:@"/usr/bin/perl"];
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