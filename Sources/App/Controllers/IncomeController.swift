//
//  IncomeController.swift
//  
//
//  Created by Ludovic HENRY on 08/08/2023.
//

import Fluent
import Vapor

struct IncomeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let incomes = routes.grouped("incomes")
        incomes.get(use: index)
        incomes.post(use: create)
        incomes.patch(use: update)
        incomes.delete(":incomeID", use: delete)
    }

    func index(req: Request) async throws -> [Income] {
        try await Income.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Income {
        let income = try req.content.decode(Income.self)
        try await income.save(on: req.db)
        return income
    }

    func update(req: Request) async throws -> Income {
        let patchIncome = try req.content.decode(PatchIncome.self)
        guard let incomeFromDB = try await Income.find(patchIncome.id, on: req.db) else {
            throw Abort(.notFound)
        }
        if let categoryID = patchIncome.categoryID {
            incomeFromDB.$category.id = categoryID
        }
        if let amount = patchIncome.amount {
            incomeFromDB.amount = amount
        }
        if let invoiceNumber = patchIncome.invoiceNumber {
            incomeFromDB.invoiceNumber = invoiceNumber
        }
        if let invoiceDate = patchIncome.invoiceDate {
            incomeFromDB.invoiceDate = invoiceDate
        }
        if let datePaid = patchIncome.datePaid {
            incomeFromDB.datePaid = datePaid
        }
        if let description = patchIncome.description {
            incomeFromDB.description = description
        }
        if let accountID = patchIncome.accountID {
            incomeFromDB.$account.id = accountID
        }
        try await incomeFromDB.update(on: req.db)
        return incomeFromDB
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let incomeID = req.parameters.get("incomeID") else {
            throw Abort(.badRequest)
        }
        guard let income = try await Income.find(UUID(uuidString: incomeID), on: req.db) else {
            throw Abort(.notFound)
        }
        try await income.delete(on: req.db)
        return .noContent
    }
}
