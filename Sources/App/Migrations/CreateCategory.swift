//
//  CreateCategory.swift
//  
//
//  Created by Ludovic HENRY on 25/07/2023.
//

import Fluent

struct CreateCategory: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let categoryType =  try await database.enum("category_type")
            .case("income")
            .case("expense")
            .create()
        
        try await database.schema("categories")
            .id()
            .field("name", .string, .required)
            .field("isArchived", .bool, .required)
            .field("type", categoryType, .required)
            .create()
    }

    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("categories").delete()
    }
}
