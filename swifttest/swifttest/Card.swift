//
//  Card.swift
//  swifttest
//
//  Created by Kapil Rathan on 6/22/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

struct Card{
    var card: String
    var isAllowed = false
    var isValid = false
    
    init(card: String) {
        self.card = card
    }
}


