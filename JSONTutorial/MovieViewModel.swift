//
//  MovieViewModel.swift
//  JSONTutorial
//
//  Created by Zaur Giyasov on 29/08/2018.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    let title: String
    let imageURL: String
    let releaseDate: String
    let purchasePrice: String
    let summary: String
    
    init(model: Movie) {
        self.title = model.title.uppercased()
        self.imageURL = model.imageURL
        self.releaseDate = "Release date: \(model.releaseDate)"
        if let doublePurchasePrice = Double(model.purchasePrice.amount) {
            self.purchasePrice = String(format: "%.2f %@", doublePurchasePrice, model.purchasePrice.currency)
        } else {
            self.purchasePrice = "Not available for Purchase"
        }
        self.summary = model.summary == "" ? "No data provided" : model.summary
    }
}
