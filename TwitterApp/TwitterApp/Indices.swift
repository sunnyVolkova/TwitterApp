//
// Created by RWuser on 09/02/16.
// Copyright (c) 2016 RWuser. All rights reserved.
//

import Foundation

class Indices: NSCoding {
    var indices: [NSNumber]?

    @objc internal func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(indices, forKey: "indices")
    }

    @objc internal required init?(coder aDecoder: NSCoder){
        indices = aDecoder.decodeObjectForKey("indices") as![NSNumber]
    }
}
