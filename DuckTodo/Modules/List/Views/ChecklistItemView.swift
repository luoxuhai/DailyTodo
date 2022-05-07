//
//  ChecklistItemView.swift
//  DuckTodo
//
//  Created by 罗绪海 on 2022/5/5.
//

import SwiftUI
import SwiftUIX
import Coordinator

struct ChecklistItemView: View {
    @Coordinator(for: AppDestination.self) var coordinator
    var item: Checklist
    
    var body: some View {
        NavigationLink(destination: TodoItemsView()) {
            HStack {
                CircularProgressBar(0.6)
                    .lineWidth(4)
                    .frame(width: 28)
                    .padding(.trailing, 6)
                    .foregroundColor(.blue)

                Text("\(item.name)+\(item.id)").font(.callout).lineLimit(10)
                Spacer()
                Text("6").foregroundColor(Color(UIColor.secondaryLabel))
                Image(systemName: "chevron.right").foregroundColor(Color(UIColor.tertiaryLabel))
            }
        }.frame(minHeight: 44)
    }
}

