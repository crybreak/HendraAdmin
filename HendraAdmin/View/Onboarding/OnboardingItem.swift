//
//  OnboardingItem.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 30/03/2024.
//

import Foundation
import Lottie

struct OnboardingItem: Identifiable, Equatable {
    var id:  UUID = .init()
    var title: String
    var subTitle: String
    var lottiView: LottieAnimationView = .init()
}
