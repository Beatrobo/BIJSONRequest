#import "BIJSONRequest.h"
#import "BIReachability.h"
#import "NSURLConnection+bi_sendAsynchronousRequestOnMainThread.h"


@interface BIJSONRequest ()
@end


@implementation BIJSONRequest

#pragma mark - Initializer

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithURLString:(NSString*)urlString method:(BIHTTPRequestMethod)method parameters:(NSDictionary*)parameters
{
    self = [super init];
    if (self) {
        _urlString  = urlString;
        _method     = method;
        _parameters = parameters.copy;
        
        _feedbackNetworkActivityIndicator = YES;
    }
    return self;
}

#pragma mark -

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, %@(%@)%@", [super description], _urlString, [[self class] HTTPMethodStringForRequestMethod:_method], _parameters];
}

#pragma mark - null

+ (NSArray*)arrayForRemoveNullObjects:(NSArray*)array
{
    if ([array isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }
    
    NSMutableArray* mutableArray = [NSMutableArray array];
    for (id obj in array) {
        if (obj != [NSNull null]) {
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray* a = [self arrayForRemoveNullObjects:obj];
                if (a) {
                    [mutableArray addObject:a];
                }
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary* d = [self dictionaryForRemoveNullObjects:obj];
                if (d) {
                    [mutableArray addObject:d];
                }
            }
            else if (obj) {
                [mutableArray addObject:obj];
            }
        }
    }
    
    if (mutableArray.count > 0) {
        return mutableArray.copy;
    } else {
        return nil;
    }
}

+ (NSDictionary*)dictionaryForRemoveNullObjects:(NSDictionary*)dictionary
{
    if ([dictionary isKindOfClass:[NSDictionary class]] == NO) {
        return nil;
    }
    
    NSMutableDictionary* mutableDictionary = [dictionary mutableCopy];
    for (id key in dictionary.allKeys) {
        id value = mutableDictionary[key];
        if (value == [NSNull null]) {
            [mutableDictionary removeObjectForKey:key];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary* d = [self dictionaryForRemoveNullObjects:value];
            [mutableDictionary removeObjectForKey:key];
            if (d) {
                [mutableDictionary setObject:d forKey:key];
            }
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray* a = [self arrayForRemoveNullObjects:value];
            [mutableDictionary removeObjectForKey:key];
            if (a) {
                [mutableDictionary setObject:a forKey:key];
            }
        }
    }
    
    if (mutableDictionary.allKeys.count > 0) {
        return mutableDictionary.copy;
    } else {
        return nil;
    }
}

+ (id)objectForRemoveNullObjects:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        return [self arrayForRemoveNullObjects:object];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        return [self dictionaryForRemoveNullObjects:object];
    }
    else if (object == [NSNull null]) {
        return nil;
    }
    else {
        return object;
    }
}

#pragma mark - Request

- (void)sendJSONRequestWithCallback:(BIJSONRequestCallback)callback
{
    // Check network connection
    if ([BIReachability isInternetConnectionAvailable] == NO) {
        // PADLogError(@"failed: no internet connection, %@", self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                NSHTTPURLResponse* httpUrlResponse;
                id                 jsonObject;
                NSError*           connectionError = [NSError errorWithDomain:@"BIJSONRequest" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"No internet connection"}];
                NSError*           jsonError;
                callback(httpUrlResponse, jsonObject, connectionError, jsonError);
            }
        });
        return;
    }
    
    NSMutableURLRequest* request = [[self class] URLRequestForURLString:_urlString method:_method parameters:_parameters];
    
    if (self.feedbackNetworkActivityIndicator) {
        [BIReachability beginNetworkConnection];
    }
    [NSURLConnection bi_sendAsynchronousRequest:request
                                          queue:[[self class] requestQueue]
                              completionHandler:^(NSURLResponse* urlResponse, NSData* data, NSError* connectionError) {
                                  NSHTTPURLResponse* httpUrlResponse = nil;
                                  if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                                      httpUrlResponse = (NSHTTPURLResponse*)urlResponse;
                                  } else {
                                      if (!connectionError) {
                                          connectionError = [NSError errorWithDomain:@"BIJSONRequest" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"NSURLConnection connection error"}];
                                      }
                                  }
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (self.feedbackNetworkActivityIndicator) {
                                          [BIReachability endNetworkConnection];
                                      }
                                      
                                      NSError* jsonError = nil;
                                      id jsonObject = nil;
                                      if (data) {
                                          jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                          jsonObject = [[self class] objectForRemoveNullObjects:jsonObject];
                                      }
                                      
                                      if (callback) {
                                          callback(httpUrlResponse, jsonObject, connectionError, jsonError);
                                      }
                                  });
                              }];

}

#pragma mark - public class method

+ (NSString*)HTTPMethodStringForRequestMethod:(BIHTTPRequestMethod)method
{
    NSString* methodString = nil;
    
    switch (method) {
        case BIHTTPRequestMethodGET:
            methodString = @"GET";
            break;
            
        case BIHTTPRequestMethodPOST:
            methodString = @"POST";
            break;
            
        case BIHTTPRequestMethodPUT:
            methodString = @"PUT";
            break;
            
        case BIHTTPRequestMethodDELETE:
            methodString = @"DELETE";
            break;
            
        default:
            break;
    }
    
    return methodString;
}

#pragma mark - private class method

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

+ (NSMutableURLRequest*)URLRequestForURLString:(NSString*)URLString method:(BIHTTPRequestMethod)method parameters:(NSDictionary*)parameters
{
    NSMutableString* urlString = URLString.mutableCopy;
    if (method == BIHTTPRequestMethodGET && parameters.allKeys.count > 0) {
        [urlString appendString:[self buildGetParameterStringWithDictionary:parameters]];
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    // [req addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = [self HTTPMethodStringForRequestMethod:method];
    
    if (method == BIHTTPRequestMethodPOST || method == BIHTTPRequestMethodPUT || method == BIHTTPRequestMethodDELETE) {
        if (parameters) {
            [self buildPostBodyForRequest:request parameters:parameters];
        }
    }
    
    return request;
}

+ (NSString*)buildGetParameterStringWithDictionary:(NSDictionary*)parameters
{
    static NSString* (^urlEncoder)(NSString*) = ^(NSString* string){
        return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, CFSTR (";,/?:@&=+$#"), kCFStringEncodingUTF8);
    };
    
    NSMutableString* getParameterString = nil;
    if (parameters.allKeys.count > 0) {
        getParameterString = [NSMutableString stringWithString:@"?"];
        for (NSString* key in parameters.allKeys) {
            [getParameterString appendFormat:@"%@=%@", urlEncoder(key), urlEncoder(parameters[key])];
            [getParameterString appendString:@"&"];
        }
        [getParameterString deleteCharactersInRange:NSMakeRange(getParameterString.length - 1, 1)];
    }
    return getParameterString;
}

+ (void)buildPostBodyForRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters
{
    NSString* charset = (NSString*)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    // We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString* uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    
    NSString* stringBoundary = [NSString stringWithFormat:@"0xHxRnCeQyVzSqKCwUEe-%@", uuidString];

    [request addValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary] forHTTPHeaderField:@"Content-Type"];

    NSMutableString* postString = [NSMutableString string];
    
    [postString appendString:[NSString stringWithFormat:@"--%@\r\n", stringBoundary]];

    // Adds post data
    NSString* endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary];
    __block NSUInteger i=0;
    NSUInteger count = parameters.count;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if ([key isKindOfClass:[NSString class]] == NO) {
            key = [key stringValue];
        }
        if ([obj isKindOfClass:[NSString class]] == NO) {
            obj = [obj stringValue];
        }
        [postString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]];
        [postString appendString:obj];
        i++;
        if (i != count) { // Only add the boundary if this is not the last item in the post body
            [postString appendString:endItemBoundary];
        }
    }];
    
    [postString appendString:[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary]];
    
    // PADLog(@"params: %@", postString);
    
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
