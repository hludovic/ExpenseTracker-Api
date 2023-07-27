//
//  CreateIncome.swift
//  
//
//  Created by Ludovic HENRY on 26/07/2023.
//

import Fluent

struct CreateIncome: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("income")
            .id()
            .field("categories_id", .uuid, .required, .references("categories", "id"))
            .field("amount", .int, .required)
            .field("currency", .string, .required)
            .field("invoice_number", .string)
            .field("inovice_date", .date)
            .field("date_paid", .date, .required)
            .field("description", .string)
            .field("accounts_id", .uuid, .required, .references("accounts", "id"))
            .create()
    }

    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("income").delete()
    }
}
