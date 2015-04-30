#import "BIHTTPStringRequest.h"
#import "BIJSONRequestLog.h"


@implementation BIHTTPStringRequest

#pragma mark - Request

- (void)sendHTTPStringRequestWithCallback:(BIHTTPStringRequestCallback)callback
{
    [self sendHTTPRequestWithCallback:^(NSHTTPURLResponse* httpUrlResponse, NSData* data, NSError* connectionError) {
        if (connectionError || [httpUrlResponse isKindOfClass:[NSHTTPURLResponse class]] == NO) {
            BIJRLogTrace(@"\n httpUrlResponse: %@\n httpBody: %@\n connectionError: %@", httpUrlResponse, nil, connectionError);
            if (callback) {
                callback(httpUrlResponse, nil, connectionError);
            }
        }
        else {
            CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)[httpUrlResponse textEncodingName]);
            NSStringEncoding encoding   = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
            NSString*        httpBody   = [[NSString alloc] initWithData:data encoding:encoding];
            BIJRLogTrace(@"\n httpUrlResponse: %@\n httpBody: %@\n connectionError: %@", httpUrlResponse, httpBody, connectionError);
            if (callback) {
                callback(httpUrlResponse, httpBody, connectionError);
            }
        }
    }];
}

#pragma mark - Private Class Method

+ (NSOperationQueue*)requestQueue
{
    static NSOperationQueue* requestQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestQueue = [[NSOperationQueue alloc] init];
        requestQueue.maxConcurrentOperationCount = 1;
    });
    return requestQueue;
}

@end
