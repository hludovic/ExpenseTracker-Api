//
//  ExpenseController.swift
//  
//
//  Created by Ludovic HENRY on 30/07/2023.
//

import Fluent
import Vapor

struct ExpenseController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let expenses = routes.grouped("expenses")
        expenses.get(use: index)
        expenses.post(use: create)
        expenses.patch(use: update)
        expenses.delete(":expenseID", use: delete)
    }

    func index(req: Request) async throws -> [Expense] {
        try await Expense.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Expense {
        let expense = try req.content.decode(Expense.self)
        try await expense.save(on: req.db)
        return expense
    }

    func update(req: Request) async throws -> Expense {
        let patchExpense = try req.content.decode(PatchExpense.self)
        guard let expenseFromDB = try await Expense.find(patchExpense.id, on: req.db) else {
            throw Abort(.notFound)
        }
        if let accountID = patchExpense.accountID {
            expenseFromDB.$account.id = accountID
        }
        if let categoryID = patchExpense.categoryID {
            expenseFromDB.$category.id = categoryID
        }
        if let description = patchExpense.description {
            expenseFromDB.description = description
        }
        if let amount = patchExpense.amount {
            expenseFromDB.amount = amount
        }
        if let date = patchExpense.date {
            expenseFromDB.date = date
        }
        try await expenseFromDB.update(on: req.db)
        return expenseFromDB
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let expenseID = req.parameters.get("expenseID") else {
            throw Abort(.badRequest)
        }
        guard let expense = try await Expense.find(UUID(uuidString: expenseID), on: req.db) else {
            throw Abort(.notFound)
        }
        try await expense.delete(on: req.db)
        return .noContent
    }
}
