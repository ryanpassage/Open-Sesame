//
//  Door.swift
//  Open Sesame
//
//  Created by Ryan Passage on 10/21/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import Foundation

struct Door {
    let beaconMajor: Int?
    let emergeId: Int?
    let name: String?

    init(major beaconMajor: Int, emergeId: Int, name: String) {
        self.beaconMajor = beaconMajor
        self.emergeId = emergeId
        self.name = name
    }
}