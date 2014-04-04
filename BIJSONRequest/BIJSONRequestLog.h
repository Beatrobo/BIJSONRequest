#ifndef Beatrobo_BIJSONRequestLog_h
#define Beatrobo_BIJSONRequestLog_h

#import "BILog.h"
#import "BILogAdditionalMacros.h"
#import "BIXcodeConsoleLogger.h"

#define BIJSONRequestLogContext   @"BIJSONRequestLogContext"

// Alias
#define BIJRLogTrace(format, ...) __BIOLogTrace(BIJSONRequestLogContext, 0, format, ##__VA_ARGS__)
#define BIJRLogDebug(format, ...) __BIOLogDebug(BIJSONRequestLogContext, 0, format, ##__VA_ARGS__)
#define BIJRLogInfo(format, ...)  __BIOLogInfo(BIJSONRequestLogContext,  0, format, ##__VA_ARGS__)
#define BIJRLogWarn(format, ...)  __BIOLogWarn(BIJSONRequestLogContext,  0, format, ##__VA_ARGS__)
#define BIJRLogError(format, ...) __BIOLogError(BIJSONRequestLogContext, 0, format, ##__VA_ARGS__)
#define BIJRLogFatal(format, ...) __BIOLogFatal(BIJSONRequestLogContext, 0, format, ##__VA_ARGS__)
#define BIJRLog(format, ...)      __BIOLog(BIJSONRequestLogContext,      0, format, ##__VA_ARGS__)

#endif
