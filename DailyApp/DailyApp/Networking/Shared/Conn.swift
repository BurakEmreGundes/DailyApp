//
//  Conn.swift
//  Conn
//
//  Created by Fernando Ortiz on 24/5/18.
//  Copyright © 2018 Fernando Ortiz. All rights reserved.
//

// A very small networking library

import Foundation

enum ConnError: Swift.Error {
    case invalidURL
    case noData
    case wrongData
    case noContent
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct RequestData {
     let path: String
     let method: HTTPMethod
     let params: [String: Any?]?
     let headers: [String: String]?
    
     init (
        path: String,
        method: HTTPMethod = .get,
        params: [String: Any?]? = nil,
        headers: [String: String]? = nil
        ) {
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
    }
}

protocol TaskReturningRequestType: ErrorLoggableRequest, CodableReturningRequest {
    var data: RequestData { get }
}

protocol RequestType {
    var data: RequestData { get }
}

protocol ErrorLoggableRequest: RequestType, Encodable {
    var errorData: [String : Any] { get }
}

protocol CodableReturningRequest: RequestType {
    associatedtype ResponseType: Codable
}

protocol RawReturningRequest: RequestType { }

extension ErrorLoggableRequest {
    var errorData: [String : Any] {
        let structName = type(of: self)
        var dict: [String : Any] = self.asDictionary() ?? [:]
        dict["requestName"] = String(reflecting: structName)
        return dict
    }
}

extension RawReturningRequest {
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Error) -> Void
        ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (data) in
                DispatchQueue.main.async {
                    onSuccess(data)
                }
        },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
        }
        )
    }
}

extension CodableReturningRequest {
    fileprivate func generateSuccessCompletion(
        _ userProvidedSuccessCompletion: @escaping (ResponseType) -> Void,
        _ userProvidedFailureCompletion: @escaping (Error) -> Void) -> (Data) -> Void {
        let closure = { (responseData: Data) in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let jsonDecoder = JSONDecoder()
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    DispatchQueue.main.async {
                        userProvidedSuccessCompletion(result)
                    }
                } catch let error {
                    DispatchQueue.global(qos: .background).async {
                        if let errorLoggable = self as? ErrorLoggableRequest {
                            var extras = errorLoggable.errorData
                            if !(IgnoreLog(endPoint: extras["requestName"] as! String)) {
                                extras["rawResponse"] = String(bytes: responseData, encoding: .ascii)
                              //  Logger.recordError(message: "Couldn't parse backend response", extras: extras)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        userProvidedFailureCompletion(error)
                    }
                }
            }
        }
        return closure
    }
    
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
        ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: generateSuccessCompletion(onSuccess, onError),
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
        }
        )
    }
    fileprivate func IgnoreLog(endPoint: String) -> Bool{
        for item in NetworkingConstants.rawRequestList {
            let value: String = endPoint
            if value.contains(item) {
                return true
            }
        }
        return false
        return false
    }
}

extension TaskReturningRequestType {
    func prepareTask (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
        ) -> URLSessionDataTask? {
        return dispatcher.prepareTask(
            request: self.data,
            onSuccess: generateSuccessCompletion(onSuccess, onError),
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        )
    }
}

extension RequestType {
    func execute (
        dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void
        ) {
        dispatcher.dispatch(
            request: self.data,
            onSuccess: { (_) in
                DispatchQueue.main.async {
                    onSuccess()
                }
            },
                onError: { (error: Error) in
                    DispatchQueue.main.async {
                        onError(error)
                    }
            }
        )
    }
}

extension RequestData {
    
    private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }

        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }

        return headers
    }
    
}

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
    func prepareTask(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask?
}

private struct URLSessionNetworkDispatcher: NetworkDispatcher {
    static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        prepareTask(request: request, onSuccess: onSuccess, onError: onError)?.resume()
    }
    
    func prepareTask(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: request.path) else {
            onError(ConnError.invalidURL)
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            //Logger.recordError(message: "Couldn't serialize URL request params", extras: ["params" : request.params ?? [:]])
            onError(error)
            return nil
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        
        #if DEBUG
        print("---------- OUT ----------")
        print(urlRequest.httpMethod ?? "")
        print(urlRequest.url?.absoluteString ?? "")
        if let body = urlRequest.httpBody {
            print(String(data: body, encoding: .ascii) ?? "")
        }
        print(urlRequest.allHTTPHeaderFields ?? "")
        print("-------------------------\n")
        #endif
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            #if DEBUG
            print("---------- IN ----------")
            print(response ?? "")
            if data != nil {
                print(String(data: data!, encoding: .ascii)!)
            }
            print("------------------------\n")
            #endif
            
            if (response as? HTTPURLResponse)?.statusCode == 204 {
                onError(ConnError.noContent)
                return
            }

            if let error = error {
                
                if request.path.contains("completeReservation"){
                  //  Analytics.logEvent("CompleteReservationFailed", parameters: ["responseDetail" : String(data: data ?? Data(), encoding: .ascii) as Any])
                }
                print(error)
                onError(error)
                return
            }
            
            guard let _data = data else {
                onError(ConnError.noData)
                return
            }
            onSuccess(_data)
        }
        return task
    }
}
