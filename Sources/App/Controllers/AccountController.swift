//
//  AccountController.swift
//  
//
//  Created by Ludovic HENRY on 28/07/2023.
//

import Fluent
import Vapor

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("accounts")
        accounts.get(use: index)
        accounts.post(use: create)
        accounts.delete(":accountID", use: delete)
        accounts.put(use: update)
    }

    func index(req: Request) async throws -> [Account] {
        try await Account.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Account {
        let account = try req.content.decode(Account.self)
        try await account.save(on: req.db)
        return account
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let accountID = req.parameters.get("accountID") else {
            throw Abort(.badRequest)
        }
        guard let account = try await Account.find(UUID(uuidString: accountID), on: req.db) else {
            throw Abort(.notFound)
        }
        try await account.delete(on: req.db)
        return .noContent
    }

    func update(req: Request) async throws -> HTTPStatus {
        let account = try req.content.decode(Account.self)
        guard let accountFromDB = try await Account.find(account.id, on: req.db) else {
            throw Abort(.notFound)
        }
        accountFromDB.name = account.name
        try await accountFromDB.update(on: req.db)
        return .ok
    }
}
