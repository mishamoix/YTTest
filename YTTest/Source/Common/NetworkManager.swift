//
//  NetworkManager.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

protocol Network {
	func fetch(host: String,
			   path: String,
			   params: [String: String],
			   completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?
	
}

final class NetworkManager: Network {
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		config.httpAdditionalHeaders = [
			"User-Agent": "MyTestYTApp",
			"Accept": "*/*",
			"Accept-Encoding": "gzip, deflate, br"
		]
		config.requestCachePolicy = .reloadIgnoringCacheData
		config.httpCookieAcceptPolicy = .never
		let session = URLSession(configuration: config)
		return session
	}()
	
	func fetch(host: String,
			   path: String,
			   params: [String: String],
			   completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = host
		components.path = path
		components.queryItems = params.map({ URLQueryItem(name: $0.key, value: $0.value) })
		
		guard let url = components.url else { return nil }
		
		let dataTask = session.dataTask(with: URLRequest(url: url)) { data, _, error in
			if let data = data, error == nil {
				completion(.success(data))
			} else if let error = error {
				completion(.failure(error))
			} else {
				completion(.failure(AppError.network))
			}
		}
		
		dataTask.resume()
		return dataTask
	}
}
