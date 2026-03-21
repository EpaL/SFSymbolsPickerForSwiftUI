//
//  SymbolsPicker.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

public struct SymbolsPicker<Content: View>: View {

  @Binding var symbolSelection: String
  @StateObject var vm: SymbolsPickerViewModel
  let closeButtonView: Content
  var okAction: (() -> Void)
  var cancelAction: (() -> Void)

  /// Initialize the SymbolsPicker view
  /// - Parameters:
  ///   - selection: binding to the selected icon name.
  ///   - title: navigation title for the view.
  ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
  ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
  ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.

  public init(selection: Binding<String>, title: String, searchLabel: String = "Search for symbol...", @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }, okAction: (() -> Void)?, cancelAction: (() -> Void)?) {
    self._symbolSelection = selection
    self._vm = StateObject(wrappedValue: SymbolsPickerViewModel(title: title, searchbarLabel: searchLabel))
    self.closeButtonView = closeButton()
    self.okAction = okAction!
    self.cancelAction = cancelAction!
  }

  @ViewBuilder
  public var body: some View {
    VStack(spacing: 0) {
      // ── Search Field ──
      HStack(spacing: 6) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.secondary)
          .font(.system(size: 13))
        TextField(vm.searchbarLabel, text: $vm.searchText)
          .textFieldStyle(.plain)
          .font(.system(size: 13))
        if !vm.searchText.isEmpty {
          Button {
            vm.searchText = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.secondary)
              .font(.system(size: 12))
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 7)
      .background(
        RoundedRectangle(cornerRadius: 8, style: .continuous)
#if os(iOS)
          .fill(Color(.systemGray6))
#else
          .fill(Color(.controlBackgroundColor))
#endif
      )
      .overlay(
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .strokeBorder(Color(.separatorColor), lineWidth: 0.5)
      )
      .padding(.horizontal, 14)
      .padding(.top, 14)
      .padding(.bottom, 10)

      // ── Symbol Grid ──
      if vm.symbols.isEmpty {
        Spacer()
        VStack(spacing: 8) {
          Image(systemName: "magnifyingglass")
            .font(.system(size: 28, weight: .light))
            .foregroundColor(.gray.opacity(0.3))
          Text("No symbols found")
            .font(.subheadline)
            .foregroundColor(.secondary)
          if !vm.searchText.isEmpty {
            Text("Try a different search term")
              .font(.caption)
              .foregroundColor(.secondary.opacity(0.6))
          }
        }
        Spacer()
      } else {
        ScrollView(.vertical) {
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 48), spacing: 6)], spacing: 6) {
            ForEach(vm.symbols, id: \.hash) { icon in
              SymbolIcon(symbolName: icon, selection: $symbolSelection)
            }
          }
          .padding(.horizontal, 14)
          .padding(.bottom, 10)
        }
      }

      // ── Bottom Bar ──
      Divider()
      HStack {
        Button("Cancel") {
          cancelAction()
        }
        .keyboardShortcut(.cancelAction)
        Spacer()
        if !symbolSelection.isEmpty {
          HStack(spacing: 6) {
            Image(systemName: symbolSelection)
              .font(.system(size: 13))
              .foregroundColor(.secondary)
            Text(symbolSelection)
              .font(.caption)
              .foregroundColor(.secondary)
              .lineLimit(1)
          }
          Spacer()
        }
        if #available(macOS 12.0, iOS 15.0, *) {
          Button("Done") {
            okAction()
          }
          .keyboardShortcut(.defaultAction)
          .buttonStyle(.borderedProminent)
          .tint(.accentColor)
        } else {
          Button("Done") {
            okAction()
          }
          .keyboardShortcut(.defaultAction)
        }
      }
      .padding(.horizontal, 14)
      .padding(.vertical, 10)
    }
  }
}

#Preview {
  SymbolsPicker(selection: .constant("wifi.router"), title: "Pick a symbol", okAction: {}, cancelAction: {})
    .frame(width: 440, height: 400)
}
