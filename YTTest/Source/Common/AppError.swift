//
//  AppError.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

enum AppError: Error {
	case network
	case parse
	case custom(Error)
}
