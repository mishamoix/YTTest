//
//  MainInteractor.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

protocol MainInteractable {
	func searchTextDidChange(text: String)
	func needLoadNext()
}

final class MainInteractor {
	private enum State {
		case ready
		case loadingNextPage
		case loadingFirstPage
	}
	
	weak var view: MainViewProtocol?
	
	private var currentPage = 0
	private var currentText = ""
	private var state: State = .ready
	
	private var data: [VideoModel] = [] {
		didSet {
			view?.show(videos: data)
		}
	}
	
	private let provider: VideosProvidable
	private let debouncer = Debouncer(interval: 0.5)
	
	init(provider: VideosProvidable) {
		self.provider = provider
	}
	
}

extension MainInteractor: MainInteractable {
	func searchTextDidChange(text: String) {
		debouncer.perform { [weak self] in
			self?.currentText = text
			self?.performSearch(newState: .loadingFirstPage)
		}
	}
	
	func needLoadNext() {
		self.performSearch(newState: .loadingNextPage)
	}
	
}

private extension MainInteractor {
	private func performSearch(newState: State) {
			
		if newState == .loadingFirstPage {
			currentPage = 0
		}
		
		if state == .loadingFirstPage && newState == .loadingNextPage
			|| state == .loadingNextPage && newState == .loadingNextPage  {
			return
		}
		
		provider.cancelCurrentRequest()
		
		let text = currentText
		currentPage += 1
		let page = currentPage
		
		if currentText.isEmpty {
			view?.show(videos: [])
			state = .ready
		} else {
			state = newState
			provider.fetch(with: text, page: page == 1 ? nil : page) { [weak self] result in
				self?.state = .ready
				DispatchQueue.main.async {
					switch result {
					case let .success(result):
						if page > 1 {
							self?.data += result
						} else {
							self?.data = result
						}
					case let .failure(error):
						// TODO
						break
					}
				}
			}
		}
	}
}
