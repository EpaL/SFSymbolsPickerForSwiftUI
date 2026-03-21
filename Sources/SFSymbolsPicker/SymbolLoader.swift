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
    "arrow.left.arrow.right",
    "arrow.up.arrow.down",
    "arrow.left.arrow.right.circle",
    "arrow.left.arrow.right.square",
    "arrow.up.arrow.down.circle",
    "arrow.up.arrow.down.square",
    "arrow.left.and.right",
    "arrow.up.and.down",
    "arrow.left.and.right.square",
    "arrow.up.and.down.square",
    "arrowshape.left.arrowshape.right",
    "arrowshape.left.arrowshape.right.fill",
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
    "gauge.with.dots.needle.bottom.50percent",
    "circle",
    "square",
    "app",
    "rectangle",
    "rectangle.portrait",
    "capsule",
    "capsule.portrait",
    "oval",
    "oval.portrait",
    "a.circle",
    "b.circle",
    "c.circle",
    "d.circle",
    "e.circle",
    "f.circle",
    "g.circle",
    "h.circle",
    "i.circle",
    "j.circle",
    "k.circle",
    "l.circle",
    "m.circle",
    "n.circle",
    "o.circle",
    "p.circle",
    "q.circle",
    "r.circle",
    "s.circle",
    "t.circle",
    "u.circle",
    "v.circle",
    "w.circle",
    "x.circle",
    "y.circle",
    "z.circle"
  ]

  /// All available SF Symbol names, with preferred symbols promoted to the front.
  public private(set) var allSymbols: [String] = []

  public init() {
    self.allSymbols = loadAllSymbols()
  }

  /// Returns symbols whose name contains the given query (case-insensitive).
  public func symbols(matching query: String) -> [String] {
    let trimmed = query.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return allSymbols }
    return allSymbols.filter { $0.localizedCaseInsensitiveContains(trimmed) }
  }

  // MARK: - Private

  private func loadAllSymbols() -> [String] {
    var symbols = [String]()
    if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
        let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
        let plist = NSDictionary(contentsOfFile: resourcePath),
        let plistSymbols = plist["symbols"] as? [String: String]
    {
      symbols = Array(plistSymbols.keys).sorted()
    }

    // Promote preferred symbols to the front
    var destIndex = 0
    for preferredSymbol in preferredSymbols {
      if let index = symbols.firstIndex(of: preferredSymbol) {
        let element = symbols.remove(at: index)
        symbols.insert(element, at: destIndex)
        destIndex += 1
      }
    }

    return symbols
  }
}
