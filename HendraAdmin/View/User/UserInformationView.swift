//
//  UserInformationView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI

struct UserInformationView: View {
    
    @ObservedObject var user: Users
        
    @FocusState var activeField: Field?
    @State private var color =  Color.gray.opacity(0.8)

    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("Information")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                
                UserNameTextField()
                
                EmailTextField()

                CountryPicker()
                
                PhoneNumberUser()
                
            }
            .padding()
        }
        
        .font(Font.custom("Nunito Sans", size: 14))
        
    }
    
    func UserNameTextField () -> some View {
        VStack (alignment: .leading) {
            Text("Name")
            TextField("John", text: $user.name )
                .focused($activeField, equals: activeStateForIndex(index: 0))
                .fieldSelectedUserInformation(index: 0, activeField: activeField)
        }
    }
    
    func EmailTextField() -> some View {
        VStack (alignment: .leading)  {
            Text("E-mail")
            TextField("Email adress", text: $user.email)
                .keyboardType(.emailAddress)
                .focused($activeField, equals: activeStateForIndex(index: 1))
                .fieldSelectedUserInformation(index: 1, activeField: activeField)

        }
    }
    
    func CountryPicker() -> some View {
        VStack(alignment: .leading) {
            Text("Select your Country")
                .bold()
            FlowLayout(alignment: .leading, spacing: 10) {
                ForEach(Country.allCases, id: \.self) { country in
                    Text(country.rawValue)
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous).fill(color(for: country)))
                        .padding(5)
                        .cornerRadius(3.0)
                        .onTapGesture {
                            user.country = country
                        }
                }
            }
        }
    }
    
    func color(for country: Country) -> Color {
        user.country == country ? Color.indigo : Color.gray
    }
    
    func PhoneNumberUser() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.country.code)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .overlay(RoundedRectangle(cornerRadius: 5,
                                                 style: .continuous).stroke(color , lineWidth: 1))
                TextField("phoneNumber", text: $user.phoneNumber )
                    .focused($activeField, equals: activeStateForIndex(index: 2))

                    .fieldSelectedUserInformation(index: 2, activeField: activeField)
            }
        }
    }
    
    
   
}

func activeStateForIndex(index: Int ) -> Field {
    switch index {
    case 0: return .field1
    case 1: return .field2
    case 2: return .field3

    default : return .field4
    }
}

enum Field {
    case field1
    case field2
    case field3
    case field4

}
struct UserInformationView_Preview: PreviewProvider {
    static var previews: some View {
        let context =  PersistenceController.preview.container.viewContext
        UserInformationView(user: Users.nestedUserExemple(context: context))
            .environment(\.managedObjectContext, context)
    }
}
