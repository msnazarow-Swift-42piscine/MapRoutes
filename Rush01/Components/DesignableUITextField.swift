//
//  DesignableUITextField.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    @IBInspectable var leftViewLeftPadding: CGFloat = 0
    @IBInspectable var leftViewRightPadding: CGFloat = 0
    @IBInspectable var rightViewLeftPadding: CGFloat = 0
    @IBInspectable var rightViewRightPadding: CGFloat = 0

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var righImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var color = UIColor.lightGray {
        didSet {
            updateView()
        }
    }

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        if let image = righImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.leftViewRect(forBounds: bounds)
        return textRect.offsetBy(dx: leftViewLeftPadding, dy: 0).insetBy(dx: -leftViewRightPadding, dy: 0)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.rightViewRect(forBounds: bounds)
        return textRect.offsetBy(dx: rightViewLeftPadding, dy: 0).insetBy(dx: -rightViewRightPadding, dy: 0)
    }
}
