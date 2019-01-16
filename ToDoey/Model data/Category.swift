//
//  Category.swift
//  ToDoey
//
//  Created by Meisam Rezaei on 1/10/19.
//  Copyright © 2019 Meysam Rezaeei. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
