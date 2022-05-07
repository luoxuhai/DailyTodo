import Foundation
import Alamofire

class HTTPClient {
    func request(_ url: String,
                 method: HTTPMethod = .get,
                 params: Parameters?,
                 encoder: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil) -> DataRequest {
      return AF.request(url,
                        method: method,
                        parameters: params,
                        encoding: encoder,
                        headers: headers)
    }
    
    /**
     Get
     */
    func get(_ url:String, params: Parameters?, headers: HTTPHeaders? = nil) -> DataRequest {
        return self.request(url,
                            method: .get,
                            params: params,
                            headers: headers)
    }
    
    func post(_ url:String, params: Parameters?, headers: HTTPHeaders? = nil) -> DataRequest {
        return self.request(url,
                            method: .post,
                            params: params,
                            encoder: JSONEncoding.default,
                            headers: headers)
    }
}
