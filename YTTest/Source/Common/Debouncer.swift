//
//  Debouncer.swift
//  YTTest
//
//  Created by mike on 27.03.2022.
//

import Foundation

final class Debouncer {
	private let queue: DispatchQueue
	private var job = DispatchWorkItem(block: {})
	private let interval: TimeInterval
	
	init(interval: TimeInterval, qos: DispatchQoS.QoSClass? = nil) {
		self.interval = interval
		if let qos = qos {
			queue = DispatchQueue.global(qos: qos)
		} else {
			queue = DispatchQueue.main
		}
	}
	
	init(interval: TimeInterval, queue: DispatchQueue) {
		self.interval = interval
		self.queue = queue
	}
	
	func perform(_ block: @escaping () -> Void) {
		job.cancel()
		job = DispatchWorkItem {
			block()
		}
		queue.asyncAfter(deadline: .now() + interval, execute: job)
	}
	
	func cancel() {
		job.cancel()
	}
}
