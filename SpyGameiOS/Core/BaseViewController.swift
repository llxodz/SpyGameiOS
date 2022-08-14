//
//  BaseViewController.swift
//  SpyGameiOS
//
//  Created by Andrew Firsenko on 11.01.2022.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    
    public init(bundle: Bundle) {
        super.init(nibName: nil, bundle: bundle)
        modalPresentationStyle = .fullScreen
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
