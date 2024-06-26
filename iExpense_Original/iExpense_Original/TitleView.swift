//
//  TitleView.swift
//  iExpense
//
//  Created by Vounatsou, Maria on 10/6/24.
//

import SwiftUI

struct TitleView: View {
    let text: String
    let secondText: String
    
    var body: some View {
        
        Text("\(text)")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(Color("ColorTitle"))
        + Text("\(secondText)")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(Color("letters"))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(text: "A", secondText: "dd")
    }
}
