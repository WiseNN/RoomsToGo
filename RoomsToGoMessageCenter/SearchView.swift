//
//  ContentView.swift
//  RoomsToGoMessageCenter
//
//  Created by Norris Wise Jr on 5/9/24.
//

import SwiftUI

struct SearchView: View {
	@State var emailText = ""
	
	
	@EnvironmentObject var network: Network
	
	var body: some View {
		NavigationStack {
			ZStack {
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
					TextField("email address", text: $emailText)
						.textContentType(.emailAddress)
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
				if network.isFetching {
					ProgressView()
						.progressViewStyle(.circular)
						.scaleEffect(1.7, anchor: .center)
						
				}
			}
			.navigationDestination(isPresented: $network.shouldPresent, destination: {
				MessagesView(emailAddress: emailText)
			})
			.alert(isPresented: $network.hasError) { () -> Alert in
				Alert(title: Text(network.error.title),
					  message: Text(network.error.msg),
					  dismissButton: .default(Text("Ok"), action: {
						network.error = nil
				}))
			}
			.onAppear(perform: {
				emailText = ""
			})
			
		}
		
	}
		
}


#Preview {
    SearchView()
		.environmentObject(Network())
}
