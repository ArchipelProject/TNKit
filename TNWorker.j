/*
 * TNWorker.j
 *
 * Copyright (C) 2010  Antoine Mercadal <antoine.mercadal@inframonde.eu>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

@import <Foundation/Foundation.j>

@global Worker


/*! @ingroup tnkit
    Wrapper for Web Worker in Cappuccino
*/
@implementation TNWorker: CPObject
{
    DOMWorker       _worker;
    CPString        _workerBlob     @accessors(property=workerBlob);
    CPURL           _workerURL      @accessors(property=workerURL);
    id              _delegate       @accessors(property=delegate);
}

/*! Initialize the TNWorker with a given script as string blob
    @param aBlob CPString containing the script blob
*/
- (TNWorker)initWithBlob:(CPString)aBlob
{
    if (self = [super init])
    {
        _workerBlob = aBlob;

        var blobBuilder,
            blobURL;

        if (window.BlobBuilder)
            blobBuilder = new window.BlobBuilder();
        else if (window.WebKitBlobBuilder)
            blobBuilder = new window.WebKitBlobBuilder();
        else if (window.MozBlobBuilder)
            blobBuilder = new window.MozBlobBuilder();

        blobBuilder.append(_workerBlob);

        if (window.webkitURL)
            blobURL = window.webkitURL.createObjectURL(blobBuilder.getBlob());
        else if (window.URL)
            blobURL = window.URL.createObjectURL(blobBuilder.getBlob());

        _worker = new Worker(blobURL);
        _worker.onmessage = function(e) {
            [self _didReceiveData:e.data];
        };
        _worker.onerror = function(error) {
            [self _didReceiveError:error];
        };
    }

    return self;
}

/*! Initialize the TNWorker with a given URL
    @param anURL CPURL representing the worker script URL
*/
- (TNWorker)initWithURL:(CPURL)anURL
{
    if (self = [super init])
    {
        _workerURL = anURL;
        _worker = new Worker([_workerURL absoluteString]);
        _worker.onmessage = function(e) {
            [self _didReceiveData:e.data];
        }
        _worker.onerror = function(error) {
            [self _didReceiveError:error];
        }
    }

    return self;
}

/*! post a message
    @param anObject an object to send to the worker. Beware! you can't manipulate DOM object
    in worker, so don't give any object containing a reference to the DOM.
*/
- (void)postMessage:(id)anObject
{
    _worker.postMessage(anObject)
}

/*! Terminate the worker it will be unusable
*/
- (void)terminate
{
    _worker.terminate()
    _worker.onmessage = function() {};
    _worker.onerror = function() {};
}

/*! @ignore
*/
- (void)_didReceiveData:(id)someData
{
    if (!_delegate)
        return;
    if ([_delegate respondsToSelector:@selector(worker:didReceiveData:)])
        [_delegate worker:self didReceiveData:someData];
}

/*! @ignore
*/
- (void)_didReceiveError:(id)anError
{
    if (!_delegate)
        return;

    if ([_delegate respondsToSelector:@selector(worker:didReceiveError:file:line:)])
        [_delegate worker:self didReceiveError:anError.message file:anError.filename line:anError.lineno];
}


@end
