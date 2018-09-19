//
//  AppDelegate.swift
//  WhatColorIsIt
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	// MARK: - Properties

	@IBOutlet weak var window: NSWindow? {
		didSet {
			window?.delegate = self
		}
	}

	// MARK: - Initializers

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Lifecycle

	func applicationDidFinishLaunching(_ notification: Notification) {
		if let application = notification.object as? NSApplication,
			let window = application.mainWindow {
			self.window = window
		}
	}
}


extension AppDelegate: NSWindowDelegate {
	func windowWillClose(_ notification: Notification) {
		// Quit the app if the main window is closed
		NSApplication.shared.terminate(window)
	}
}
