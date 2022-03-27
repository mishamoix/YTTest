//
//  YoutubeSearchParser.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

protocol YoutubeSearchParserProtocol {
	func parse(text: String) -> [VideoModel]
}

final class YoutubeSearchParser: YoutubeSearchParserProtocol {
	func parse(text: String) -> [VideoModel] {
		do {
			let regex = try NSRegularExpression(pattern: "\"videoId\":\"[a-zA-Z0-9]*\"")
			let nsText = text as NSString
			let results = regex.matches(in: text,
										options: [],
										range: NSMakeRange(0, nsText.length))
			
			let videos = results
				.lazy
				.map { nsText.substring(with: $0.range) }
				.map({ $0.replacingOccurrences(of: "videoId", with: "") })
				.map({ $0.replacingOccurrences(of: ":", with: "") })
				.map({ $0.replacingOccurrences(of: "\"", with: "") })
				.map({ VideoModel(id: $0) })
			
			return Array(Set(videos))
		} catch {
			return []
		}
	}
}
