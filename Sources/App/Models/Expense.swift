//
//  Expense.swift
//  
//
//  Created by Ludovic HENRY on 27/07/2023.
//

import Fluent
import Vapor

final class Expense: Model, Content {
    static let schema = "expenses"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "categories_id")
    var category: Category

    @Parent(key: "accounts_id")
    var account: Account

    @OptionalField(key: "description")
    var description: String?

    @Field(key: "amount")
    var amount: Int

    @Field(key: "currency")
    var currency: String

    @Field(key: "date")
    var date: Date

    init() { }

    init(id: UUID? = nil,
         categoryID: Category.IDValue,
         accountID: Account.IDValue,
         description: String? = nil,
         date: Date,
         amount: Int,
         currency: String) {
        self.id = id
        self.$category.id = categoryID
        self.$account.id = accountID
        self.description = description
        self.amount = amount
        self.currency = currency
        self.date = date
    }
}
