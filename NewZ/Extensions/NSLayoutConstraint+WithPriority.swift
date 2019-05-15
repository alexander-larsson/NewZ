//
//  NSLayoutConstraint+WithPriority.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-15.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
