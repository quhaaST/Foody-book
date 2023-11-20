//
//  SearchField.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    @State private var isCloseButtonVisible = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $searchText) { _ in
                self.isCloseButtonVisible = true
            }
            .foregroundColor(.primary)
            
            Button {
                searchText = ""
            } label: {
                Image(systemName: "xmark.circle.fill").opacity(searchText.isEmpty ? 0 : 1)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(searchText: .constant(""))
    }
}
