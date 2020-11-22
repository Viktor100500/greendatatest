//
//  StringExtension.swift
//  RandomUser
//
//  Created by Jun Jung on 9/16/19.
//  Copyright © 2019 JunJung. All rights reserved.
//

import UIKit

extension String {
    func makeFirstCharUpper() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
