//
//  Array.swift
//  Day06
//
//  Created by Duy Anh on 1/25/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation

extension Array {
    public var randomMember: Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
