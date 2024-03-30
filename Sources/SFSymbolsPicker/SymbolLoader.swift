//
//  SymbolLoader.swift
//
//
//  Created by Alessio Rubicini on 31/10/23.
//

import Foundation

// This class is responsible for loading symbols from system
public class SymbolLoader {

  private let preferredSymbols = [
    "globe",
    "globe.asia.australia",
    "globe.americas",
    "globe.europe.africa",
    "airport.express",
    "airport.extreme",
    "airport.extreme.tower",
    "wifi",
    "wifi.router",
    "wifi.circle",
    "wifi.square",
    "dot.radiowaves.left.and.right",
    "dot.radiowaves.left.and.right",
    "dot.radiowaves.left.and.right",
    "wave.3.backward",
    "wave.3.backward.circle",
    "house",
    "house.circle",
    "building.columns",
    "building",
    "building.2",
    "chart.bar",
    "cellularbars",
    "network",
    "personalhotspot",
    "icloud",
    "icloud.circle",
    "key.icloud",
    "bolt.horizontal",
    "externaldrive.badge.wifi",
    "tv.badge.wifi",
    "tv",
    "tv.circle",
    "play.tv",
    "appletv",
    "music.note.tv",
    "macstudio",
    "macmini",
    "macpro.gen2",
    "macpro.gen1",
    "macpro.gen3.server",
    "macbook.gen1",
    "macbook.gen2",
    "server.rack",
    "pc",
    "desktopcomputer",
    "play.desktopcomputer",
    "desktopcomputer.and.arrow.down",
    "laptopcomputer.and.arrow.down",
    "dot.scope.laptopcomputer",
    "laptopcomputer",
    "gamecontroller",
    "arcade.stick.console",
    "bolt.car",
    "car",
    "bonjour",
    "gauge.with.dots.needle.bottom.0percent",
    "gauge.with.dots.needle.bottom.50percent"
  ]
  
  private let symbolsPerPage = 100
  private var currentPage = 0
  private final var allSymbols: [String] = []
  
  public init() {
    self.allSymbols = getAllSymbols()
  }

  // Retrieves symbols for the current page
  public func getSymbols() -> [String] {
    currentPage += 1

    // Calculate start and end index for the requested page
    let startIndex = (currentPage - 1) * symbolsPerPage
    let endIndex = min(startIndex + symbolsPerPage, allSymbols.count)

    // Extract symbols for the page
    return Array(allSymbols[startIndex..<endIndex])
  }
  
  // Retrieves symbols that start with the specified name
  public func getSymbols(named name: String) -> [String] {
    return allSymbols.filter({$0.lowercased().starts(with: name.lowercased())})
  }
  
  // Checks if there are more symbols available
  public func hasMoreSymbols() -> Bool {
    return currentPage * symbolsPerPage < allSymbols.count
  }
  
  // Resets the pagination to the initial state
  public func resetPagination() {
    currentPage = 0
  }
  
  // Loads all symbols from the plist file
  private func getAllSymbols() -> [String] {
    var allSymbols = [String]()
    if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
        let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
        let plist = NSDictionary(contentsOfFile: resourcePath),
        let plistSymbols = plist["symbols"] as? [String: String]
    {
      // Get all symbol names, sorted alphabetically
      allSymbols = Array(plistSymbols.keys)
    }
    
    // Rearrange preferred symbols to the front
    var destIndex = 0
    for preferredSymbol in preferredSymbols {
      if let index = allSymbols.firstIndex(of: preferredSymbol) {
        allSymbols = rearrange(array: allSymbols, fromIndex: index, toIndex: destIndex)
        destIndex += 1
      }
    }
    
    return allSymbols
  }
  
  /// Rearrange an item in an array from one index to another.
  /// - Parameters:
  ///   - array: The array to rearrange.
  ///   - fromIndex: The starting index of the element
  ///   - toIndex: The index to move the element to.
  /// - Returns: The new, rearranged array.
  private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)

    return arr
  }
}

