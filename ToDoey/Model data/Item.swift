//
//  Item.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 1/10/19.
//  Copyright © 2019 Meysam Rezaeei. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
