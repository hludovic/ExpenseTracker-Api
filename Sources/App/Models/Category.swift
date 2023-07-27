//
//  Category.swift
//  
//
//  Created by Ludovic HENRY on 27/07/2023.
//

import Fluent
import Vapor

enum CategoryType: String, Codable {
    case income, expense
}


final class Category: Model, Content {
    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Enum(key: "category_type")
    var type: CategoryType

    @Field(key: "isArchived")
    var isArchived: Bool

    init() { }

    init(id: UUID? = nil, name: String, type: CategoryType, isArchived: Bool) {
        self.id = id
        self.name = name
        self.type = type
        self.isArchived = isArchived
    }
}
