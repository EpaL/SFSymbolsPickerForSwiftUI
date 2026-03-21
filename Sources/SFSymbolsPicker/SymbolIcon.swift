//
//  SymbolIcon.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SymbolIcon: View {

  let symbolName: String
  @Binding var selection: String
  @State private var isHovered: Bool = false

  private var isSelected: Bool { selection == symbolName }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(backgroundColor)
        .overlay(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .strokeBorder(isSelected ? Color.accentColor.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
      Image(systemName: symbolName)
        .font(.system(size: 20))
        .foregroundColor(isSelected ? .white : .primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      if isSelected {
        ZStack {
          Circle()
            .fill(Color.accentColor)
            .frame(width: 14, height: 14)
          Image(systemName: "checkmark")
            .font(.system(size: 8, weight: .bold))
            .foregroundColor(.white)
        }
        .offset(x: -3, y: -3)
      }
    }
    .frame(width: 44, height: 44)
    .contentShape(RoundedRectangle(cornerRadius: 8))
    .onHover { hovering in
      isHovered = hovering
    }
    .onTapGesture {
      withAnimation(.easeInOut(duration: 0.15)) {
        selection = symbolName
      }
    }
  }

  private var backgroundColor: Color {
    if isSelected {
      return Color.accentColor
    } else if isHovered {
#if os(iOS)
      return Color(.systemGray5)
#else
      return Color(.controlBackgroundColor)
#endif
    } else {
      return Color.clear
    }
  }
}

#Preview {
    SymbolIcon(symbolName: "wifi.router", selection: .constant("wifi.router"))
        .padding()
}
