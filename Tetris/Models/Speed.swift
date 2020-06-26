//
//  Speed.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/18/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation

enum Speed {
    case slow
    case fast
}

extension Speed {
    func reversed() -> Speed {
        if self == .fast {
            return .slow
        } else {
            return .fast
        }
    }
}
