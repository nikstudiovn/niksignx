//
//  Storage+Imported.swift
//  Feather
//
//  Created by samara on 11.04.2025.
//

import CoreData
import UIKit.UIImpactFeedbackGenerator

// MARK: - Class extension: Imported Apps
extension Storage {
	func addImported(
		uuid: String,
		source: URL? = nil,
		
		appName: String? = nil,
		appIdentifier: String? = nil,
		appVersion: String? = nil,
		appIcon: String? = nil,
		
		completion: @escaping (Error?) -> Void
	) {
		context.perform {
		
		let new = Imported(context: self.context)
		
		new.uuid = uuid
		new.source = source
		new.date = Date()
		// could possibly be nil, but thats fine.
		// ?
		new.identifier = appIdentifier
		new.name = appName
		new.icon = appIcon
		new.version = appVersion
		
        self.saveContext()
			DispatchQueue.main.async {
				UIImpactFeedbackGenerator(style: .light).impactOccurred()
				completion(nil)
			}
		}
	}
}
