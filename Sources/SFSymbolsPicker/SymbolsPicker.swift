//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

public struct SymbolsPicker<Content: View>: View {
    
  @Binding var symbolSelection: String
  @ObservedObject var vm: SymbolsPickerViewModel
  @State private var searchText = ""
  let closeButtonView: Content
  var dismissAction: (() -> Void)

  /// Initialize the SymbolsPicker view
  /// - Parameters:
  ///   - selection: binding to the selected icon name.
  ///   - title: navigation title for the view.
  ///   - searchLabel: label for the search bar. Set to 'Search...' by default.
  ///   - autoDismiss: if true the view automatically dismisses itself when the symbols is selected.
  ///   - closeButton: a custom view for the picker close button. Set to 'Image(systemName: "xmark.circle")' by default.
  
public init(selection: Binding<String>, title: String, searchLabel: String = "Search for symbol...", @ViewBuilder closeButton: () -> Content = { Image(systemName: "xmark.circle") }, dismissAction: (() -> Void)?) {
    self._symbolSelection = selection
    self.vm = SymbolsPickerViewModel(title: title, searchbarLabel: searchLabel)
    self.closeButtonView = closeButton()
    self.dismissAction = dismissAction!
  }
  
  @ViewBuilder
  public var body: some View {
    VStack {
      SearchBar(searchText: $searchText, label: vm.searchbarLabel)
      ScrollView(.vertical) {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 5) {
          ForEach(vm.symbols, id: \.hash) { icon in
            Button {
              withAnimation {
                symbolSelection = icon
                dismissAction()
              }
            } label: {
              SymbolIcon(symbolName: icon, selection: $symbolSelection)
            }
            
          }.padding(.top, 5)
        }
        
        if(vm.hasMoreSymbols && searchText.isEmpty) {
          Button(action: {
            vm.loadSymbols()
          }, label: {
            Label("Load More", systemImage: "square.and.arrow.down")
          }).padding()
        }
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button(action: dismissAction,
                 label: { closeButtonView })
        }
      }.padding(.vertical, 5)
    }.padding(.horizontal, 5)
    .onChange(of: searchText) { newValue in
      if(newValue.isEmpty || searchText.isEmpty) {
        vm.reset()
      } else {
        vm.searchSymbols(with: newValue)
      }
    }
  }
}

#Preview {
  SymbolsPicker(selection: .constant("beats.powerbeatspro"), title: "Pick a symbol", dismissAction: nil)
}
