//
//  View.swift
//  What Color Is It
//
//  Created by Sam Soffes on 7/17/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import AppKit
import ScreenSaver

/// What Color Is It screen saver.
public class View: ScreenSaverView {

	// MARK: - Properties

	/// The text font
	private var font: NSFont!

	// MARK: - NSView

	// This is where the drawing happens. It gets called indirectly from `animateOneFrame`.
	public override func draw(_ rect: NSRect) {
		// Get the current time as a color
		let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
		let red = pad(comps.hour)
		let green = pad(comps.minute)
		let blue = pad(comps.second)
		let color = NSColor(srgbRed: hexValue(red), green: hexValue(green), blue: hexValue(blue), alpha: 1)

		// Draw that color as the background
		color.setFill()
		NSBezierPath.fill(rect)

		// Get the color as text so we can display it
		let string = "#\(red)\(green)\(blue)" as NSString
		let attributes: [NSAttributedStringKey: Any] = [
			.foregroundColor: NSColor.white,
			.font: font,
		]

		// Calculate where the text will be drawn
		let stringSize = string.size(withAttributes: attributes)
		let stringRect = CGRect(
			x: round((bounds.width - stringSize.width) / 2),
			y: round((bounds.height - stringSize.height) / 2),
			width: stringSize.width,
			height: stringSize.height
		)

		// Draw the text
		string.draw(in: stringRect, withAttributes: attributes)
	}

	// Update the font size when the view is first laid out
	public override func viewWillMove(toSuperview newSuperview: NSView?) {
		super.viewWillMove(toSuperview: newSuperview)
		updateFont()
	}

	// If the screen saver changes size, update the font
	public override func resize(withOldSuperviewSize oldSize: NSSize) {
		super.resize(withOldSuperviewSize: oldSize)
		updateFont()
	}

	// MARK: - ScreenSaverView

	public override init?(frame: NSRect, isPreview: Bool) {
		super.init(frame: frame, isPreview: isPreview)
		initialize()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	/// The screen saver engine calls this whenever it wants to display a new frame.
	public override func animateOneFrame() {
		setNeedsDisplay(bounds)
	}


	// MARK: - Private

	/// Setup
	private func initialize() {
		// Set to 15fps
		animationTimeInterval = 1.0 / 4.0
		updateFont()
	}

	/// Turn an integer into a 2 character string. `1` becomes "01". `12` becomes "12".
	private func pad(_ integer: Int?) -> String {
		var string = String(integer ?? 0)
		if string.lengthOfBytes(using: .utf8) == 1 {
			string = "0" + string
		}
		return string
	}

	/// Get the value of a hex string from 0.0 to 1.0
	private func hexValue(_ string: String) -> CGFloat {
		let value = Double(strtoul(string, nil, 16))
		return CGFloat(value / 255.0)
	}

	/// Update the font for the current size
	private func updateFont() {
		font = fontWithSize(fontSize: bounds.size.width / 6.0)
	}

	/// Get a monospaced font
	private func fontWithSize(fontSize: CGFloat) -> NSFont {
		let font: NSFont
		if #available(OSX 10.11, *) {
			font = .systemFont(ofSize: fontSize, weight: .thin)
		} else if let helveticaNeueThin = NSFont(name: "HelveticaNeue-Thin", size: fontSize) {
			font = helveticaNeueThin
		} else {
			font = .systemFont(ofSize: fontSize)
		}

		let fontDescriptor = font.fontDescriptor.addingAttributes([
			.featureSettings: [
				[
					NSFontDescriptor.FeatureKey.typeIdentifier: kNumberSpacingType,
					NSFontDescriptor.FeatureKey.selectorIdentifier: kMonospacedNumbersSelector
				]
			]
		])
		return NSFont(descriptor: fontDescriptor, size: fontSize)!
	}
}
