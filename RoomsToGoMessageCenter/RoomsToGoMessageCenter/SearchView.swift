//
//  ContentView.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import SwiftUI

struct SearchView: View {
	@State var emailText = ""
	@State var isBtnActive = false
	
	@EnvironmentObject var network: Network
	
	var body: some View {
		NavigationStack {
			VStack {
				Image("RTG-LOGO")
					.imageScale(.large)
					.padding()
				Text("Message Center")
					.font(Font.custom("Poppins-Light", size: 24))
					.padding()
				Text("Enter your email to search for your\nmessages")
					.font(Font.custom("Poppins-Light", size: 16))
					.foregroundStyle(Color.init(hex: "#07263B"))
					.multilineTextAlignment(.center)
					.padding()
				TextField("email@domain.com", text: $emailText)
					.overlay(
						Divider()
							.frame(minHeight: 0.7)
							.overlay(Color.black)
							.offset(x: 0, y: 24)
					)
					.multilineTextAlignment(.leading)
					.font(Font.custom("Poppins-Medium", size: 16))
					.padding()
				Spacer()
				Button(action: {
					network.getMessages(emailAddress: emailText)
				}, label: {
					Text("Search")
						.frame(maxWidth: .infinity)
						.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
						.font(Font.custom("Poppins-Light", size: 16))
						.fontWeight(.heavy)
				})
				.buttonStyle(.borderedProminent)
				.buttonBorderShape(.capsule)
				.tint(Color.init(hex: "#004FB5"))
				.padding()
			}
			.navigationDestination(isPresented: $network.shouldPresent, destination: {
				MessagesView()
			})
			.alert(isPresented: $network.hasError) { () -> Alert in
				Alert(title: Text("Error"),
					  message: Text(network.error.msg),
					  dismissButton: .default(Text("Ok"), action: {
//						network.error = nil
				}))
			}
			
		}
		
	}
}


#Preview {
    SearchView()
		.environmentObject(Network())
}
