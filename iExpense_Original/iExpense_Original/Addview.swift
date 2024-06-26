//
//  Addview.swift
//  iExpense
//
//  Created by Vounatsou, Maria on 11/6/24.
//

import SwiftUI

struct Addview: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var title0 = TitleView(text: "A", secondText: "dd")
    @State private var title1 = TitleView(text: "N", secondText: "ew")
    @State private var title2 = TitleView(text: "E", secondText: "xpence")
    
    @State private var keyboardHeight: CGFloat = 10
    
    var expenses: Expenses
    
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                
                ZStack {
                    Color.colorV
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                       VStack {
                        Form {
                            Section {
                                
                                TextField("name", text: $name)
                                    .bold()
                                
                                Picker("Type", selection: $type) {
                                    ForEach(types, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .bold()
                                
                                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .padding(5)
                                    .background(backgroundColor(for: amount))
                                    .keyboardType(.decimalPad)
                                    .bold()
                                    .cornerRadius(20)
                                    .frame(maxWidth: 100)
                            }
                            .listRowBackground(Color("Colortext"))
                        }
                        .padding(0)
                        .background(Color("ColorV"))
                        .scrollContentBackground(.hidden)
                    }
                    
                    Image("paper")
                        .ignoresSafeArea()
                        .padding()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 750, alignment: .bottom)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            title0
                            title1
                            title2
                        }
                    }
                }
                .toolbar {
                    Button("Save",systemImage: "square.and.arrow.down") {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.append(item)
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                    .bold()
                }
            } .ignoresSafeArea(.keyboard)
        }
    }
    
    func backgroundColor(for amount: Double) -> Color {
        if amount < 50 {
            return Color.blue.opacity(0.3)
        } else if amount < 150 {
            return Color.yellow.opacity(0.3)
        } else {
            return Color.red.opacity(0.3)
        }
    }
}

#Preview {
    Addview(expenses: Expenses())
}
