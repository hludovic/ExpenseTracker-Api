//
//  CreateExpense.swift
//  
//
//  Created by Ludovic HENRY on 26/07/2023.
//

import Fluent

struct CreateExpense: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("expenses")
            .id()
            .field("categories_id", .uuid, .required, .references("categories", "id"))
            .field("amount", .int, .required)
            .field("currency", .string, .required)
            .field("date", .date, .required)
            .field("description", .string)
            .field("accounts_id", .uuid, .required, .references("accounts", "id"))
            .create()
    }

    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("expenses").delete()
    }
}
