import Foundation
import WZAlamofire

public typealias Manager = WZAlamofire.SessionManager
internal typealias Request = WZAlamofire.Request
internal typealias DownloadRequest = WZAlamofire.DownloadRequest
internal typealias UploadRequest = WZAlamofire.UploadRequest
internal typealias DataRequest = WZAlamofire.DataRequest

internal typealias URLRequestConvertible = WZAlamofire.URLRequestConvertible

/// Represents an HTTP method.
public typealias Method = WZAlamofire.HTTPMethod

/// Choice of parameter encoding.
public typealias ParameterEncoding = WZAlamofire.ParameterEncoding
public typealias JSONEncoding = WZAlamofire.JSONEncoding
public typealias URLEncoding = WZAlamofire.URLEncoding
public typealias PropertyListEncoding = WZAlamofire.PropertyListEncoding

/// Multipart form.
public typealias RequestMultipartFormData = WZAlamofire.MultipartFormData

/// Multipart form data encoding result.
public typealias MultipartFormDataEncodingResult = Manager.MultipartFormDataEncodingResult
public typealias DownloadDestination = WZAlamofire.DownloadRequest.DownloadFileDestination

/// Make the Alamofire Request type conform to our type, to prevent leaking Alamofire to plugins.
extension Request: RequestType { }

/// Internal token that can be used to cancel requests
public final class CancellableToken: Cancellable, CustomDebugStringConvertible {
    let cancelAction: () -> Void
    let request: Request?

    public fileprivate(set) var isCancelled = false

    fileprivate var lock: DispatchSemaphore = DispatchSemaphore(value: 1)

    public func cancel() {
        _ = lock.wait(timeout: DispatchTime.distantFuture)
        defer { lock.signal() }
        guard !isCancelled else { return }
        isCancelled = true
        cancelAction()
    }

    public init(action: @escaping () -> Void) {
        self.cancelAction = action
        self.request = nil
    }

    init(request: Request) {
        self.request = request
        self.cancelAction = {
            request.cancel()
        }
    }

    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        guard let request = self.request else {
            return "Empty Request"
        }
        return request.debugDescription
    }

}

internal typealias RequestableCompletion = (HTTPURLResponse?, URLRequest?, Data?, Swift.Error?) -> Void

internal protocol Requestable {
    func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self
}

extension DataRequest: Requestable {
    internal func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self {
        return response(queue: callbackQueue) { handler  in
            completionHandler(handler.response, handler.request, handler.data, handler.error)
        }
    }
}

extension DownloadRequest: Requestable {
    internal func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self {
        return response(queue: callbackQueue) { handler  in
            completionHandler(handler.response, handler.request, nil, handler.error)
        }
    }
}
