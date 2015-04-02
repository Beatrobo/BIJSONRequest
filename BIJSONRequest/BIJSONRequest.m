#import "BIJSONRequest.h"
#import "BIJSONRequestLog.h"
#import "BINullRemoveUtil.h"


@implementation BIJSONRequest

#pragma mark - Request

- (void)sendJSONRequestWithCallback:(BIJSONRequestCallback)callback
{
    [self sendHTTPRequestWithCallback:^(NSHTTPURLResponse* httpUrlResponse, NSData* data, NSError* connectionError) {
        NSError* jsonError = nil;
        id jsonObject = nil;
        if (data) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            jsonObject = [BINullRemoveUtil objectForRemoveNullObjects:jsonObject];
        }
        BIJRLogTrace(@"\n httpUrlResponse: %@\n jsonObject: %@\n connectionError: %@\n jsonError: %@", httpUrlResponse, jsonObject, connectionError, jsonError);
        if (callback) {
            callback(httpUrlResponse, jsonObject, connectionError, jsonError);
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
