//
//  Income.swift
//  
//
//  Created by Ludovic HENRY on 28/07/2023.
//

import Fluent
import Vapor

final class Income: Model, Content {
    static let schema = "income"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "categories_id")
    var category: Category

    @Field(key: "amount")
    var amount: Int

    @Field(key: "currency")
    var currency: String

    @OptionalField(key: "invoice_number")
    var invoiceNumber: String?

    @OptionalField(key: "inovice_date")
    var invoiceDate: Date?

    @Field(key: "date_paid")
    var datePaid: Date

    @OptionalField(key: "description")
    var description: String?

    @Parent(key: "accounts_id")
    var account: Account

    init() { }

    init(id: UUID? = nil,
         categoryID: Category.IDValue,
         amount: Int,
         currency: String,
         invoiceNumber: String? = nil,
         invoiceDate: Date? = nil,
         datePaid: Date,
         description: String? = nil,
         accountID: Account.IDValue) {
        self.id = id
        self.$category.id = categoryID
        self.amount = amount
        self.currency = currency
        self.invoiceNumber = invoiceNumber
        self.invoiceDate = invoiceDate
        self.datePaid = datePaid
        self.description = description
        self.$account.id = accountID
    }
}
