//
//  SymbolsPickerViewModel.swift
//
//
//  Created by Alessio Rubicini on 25/02/24.
//

import Foundation
import SwiftUI

public class SymbolsPickerViewModel: ObservableObject {

  let title: String
  let searchbarLabel: String
  private let symbolLoader: SymbolLoader = SymbolLoader()

  @Published var searchText: String = "" {
    didSet { updateFilteredSymbols() }
  }
  @Published var symbols: [String] = []

  init(title: String, searchbarLabel: String) {
    self.title = title
    self.searchbarLabel = searchbarLabel
    self.symbols = symbolLoader.allSymbols
  }

  private func updateFilteredSymbols() {
    symbols = symbolLoader.symbols(matching: searchText)
  }
}
