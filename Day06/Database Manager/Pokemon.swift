//
//  Pokemon.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation

class Pokemon: NSObject {
    var id: Int!
    var name: String!
    var tag: String!
    var gen: Int!
    var img: String!
    var color: String!
    
    init(id: Int, name: String, tag: String, gen: Int, img: String, color: String) {
        self.id = id
        self.name = name
        self.tag = tag
        self.gen = gen
        self.img = img
        self.color = color
        super.init()
    }
    
    override init() {
        super.init()
    }
}
