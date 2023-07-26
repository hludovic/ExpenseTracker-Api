//
//  CreateAccount.swift
//  
//
//  Created by Ludovic HENRY on 26/07/2023.
//

import Fluent

struct CreateAccount: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("accounts")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("accounts").delete()
    }
}
