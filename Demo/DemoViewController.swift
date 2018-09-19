//
//  DemoViewController.swift
//  What Color Is It
//
//  Created by Sam Soffes on 7/19/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import AppKit
import ScreenSaver

class DemoViewController: NSViewController {

	// MARK: - Properties

	let screenSaver: ScreenSaverView = {
		let view = View()
		view.autoresizingMask = [.width, .height]
		return view
	}()

	// MARK: - NSViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		// Add the clock view to the window
		screenSaver.frame = view.bounds
		view.addSubview(screenSaver)

		// Start animating the clock
		screenSaver.startAnimation()
		Timer.scheduledTimer(timeInterval: screenSaver.animationTimeInterval, target: screenSaver, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
	}
}
