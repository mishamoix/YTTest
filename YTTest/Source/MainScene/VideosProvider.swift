//
//  VideosProvider.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

protocol VideosProvidable {
	func fetch(with text: String,
			   page: Int?,
			   completion: @escaping (Result<[VideoModel], AppError>) -> Void)
	func cancelCurrentRequest()
}

final class VideosProvider: VideosProvidable {
	
	private var dataTask: URLSessionDataTask?
	private let network: Network
	private let parser: YoutubeSearchParserProtocol
	
	init(network: Network, parser: YoutubeSearchParserProtocol) {
		self.network = network
		self.parser = parser
	}
	
	func fetch(with text: String,
			   page: Int?,
			   completion: @escaping (Result<[VideoModel], AppError>) -> Void) {		
		var params: [String: String] = [Constants.searchParam: text]
		
		if let page = page {
			params[Constants.page] = String(page)
		}
		
		dataTask = network.fetch(host: Constants.host,
								 path: Constants.path,
								 params: params,
								 completion: { [weak self] result in
			guard let self = self else { return }
			switch result {
			case let .success(data):
				if let string = String(data: data, encoding: .utf8) {
					let result = self.parser.parse(text: string)
					completion(.success(result))
				} else {
					completion(.failure(.parse))
				}
			case .failure:
				completion(.failure(AppError.network))
			}
		})
	}
	
	func cancelCurrentRequest() {
		dataTask?.cancel()
		dataTask = nil
	}
}
