//
//  OnboardingScreen.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 30/03/2024.
//

import SwiftUI
import Lottie

struct OnboardingScreen: View {
    @AppStorage(wrappedValue: false, AppStorageKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool

    @State var onboardingItems: [OnboardingItem] = [
        .init( title: "Display object ",
               subTitle: "Explore a fascinating new world by displaying your products in your real environment through augmented reality.",
               lottiView: .init(name: "ARPlacement", bundle: .main)),
        .init(title: "Buy Product", subTitle: "Purchase your favorite items with ease and speed through our user-friendly platform, regardless of your location",
              lottiView: .init(name: "buyProduct", bundle: .main)),
        .init(title: "Track Delivery", subTitle: "Track your product's journey effortlessly and in real-time, right up to delivery.",
              lottiView: .init(name: "productTracking")),
        .init(title: "Receive package", subTitle: "Track your product's journey effortlessly and in real-time, right up to delivery.",
              lottiView: .init(name: "receiveProduct", bundle: .main))
    ]
    
    @State var currentIndex: Int = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0, content: {
                ForEach($onboardingItems) {$item  in
                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
                    VStack {
                        HStack {
                            Button("Back") {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                    playAnimation()
                                }
                            }
                            .opacity(currentIndex > 0 ? 1 : 0)
                            
                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                            
                            Button("Skip") {
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            }
                            .opacity(isLastSlide ? 0 : 1)
                        }
                        .tint(Color(hex: "093855")!)
                        .fontWeight(.bold)
                        VStack (spacing: 15){
                            let offset = -CGFloat(currentIndex) * size.width
                            ResizableLottiView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear{
                                    if currentIndex == indexOf(item) {
                                        item.lottiView.play(toProgress: 0.9)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                            
                            Text(item.title)
                                .offset(x: offset)

                                .font(.title.bold())
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)

                            Text(item.subTitle)
                                .offset(x: offset)

                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)

                        }
                        Spacer(minLength: 0)
                        VStack (spacing: 15) {
                            Text(isLastSlide ? "Get started" : "Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, isLastSlide ? 13 : 12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color(hex: "093855")!)
                                }
                                .padding(.horizontal,  isLastSlide ? 30 : 100)
                                .onTapGesture {
                                    hasSeenOnboarding = (isLastSlide) ? true : false
                                    if currentIndex < onboardingItems.count - 1 {
                                        onboardingItems[currentIndex].lottiView.pause()
                                        let currentProgress =  onboardingItems[currentIndex].lottiView.currentProgress
                                        
                                        onboardingItems[currentIndex].lottiView.currentProgress = (currentProgress == 0 ? 0.9 : currentProgress)
                                        onboardingItems[currentIndex].lottiView.currentProgress = (currentProgress == 0 ? 0.9 : currentProgress)
                                        currentIndex += 1
                                       playAnimation()
                                        
                                    }
                                }
                            
                            HStack {
                                Text("Terms of service")
                                Text("Privacy Policy")
                            }
                            .font(.caption2)
                            .underline(true, color: .primary)
                            .offset(y: 5)
                            
                        }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
                
                
            }).frame(width: size.width * CGFloat(onboardingItems.count), alignment: .leading)
        }
        
        
    }
    
    func playAnimation() {
        onboardingItems[currentIndex].lottiView.currentProgress = 0
        onboardingItems[currentIndex].lottiView.play(toProgress: 0.9)

    }
    
    func indexOf(_ item: OnboardingItem) -> Int {
        if let index = onboardingItems.firstIndex(of: item) {
            return index
        }
        return 0;
    }
}

struct ResizableLottiView: UIViewRepresentable {
    @Binding var onboardingItem: OnboardingItem
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        setupLottiView(view)
        return view
       
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func setupLottiView(_ to: UIView) {
        let lottiView = onboardingItem.lottiView
        lottiView.backgroundColor = .clear
        lottiView.translatesAutoresizingMaskIntoConstraints = false

        let contraints = [
            lottiView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottiView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        to.addSubview(lottiView)
        to.addConstraints(contraints)
    }
}

#Preview {
    OnboardingScreen()
}
