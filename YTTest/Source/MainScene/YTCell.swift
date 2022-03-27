//
//  YTCell.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import UIKit
import YouTubeiOSPlayerHelper

final class YTCell: UITableViewCell {
	
	private let playerView = YTPlayerView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with model: VideoModel) {
		playerView.stopVideo()
		playerView.load(withVideoId: model.id)
	}
}

private extension YTCell {
	func setup() {
		playerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(playerView)
		NSLayoutConstraint.activate([
			playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
