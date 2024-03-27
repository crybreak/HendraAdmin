//
//  SceneView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 16/03/2024.
//

import SwiftUI
import SceneKit
import CoreData



struct CustomSceneView: UIViewRepresentable {
    
     var scene: SCNScene?
    
    func makeUIView(context: Context) -> some SCNView {
        let view = SCNView()
        
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        return view

    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct Home: View {
    @ObservedObject var product: Product
    @ObservedObject var attachment: AttahcmentUSDZ
    
    @State private var attachmentID: NSManagedObjectID? = nil
    @State private var scene: SCNScene? = nil
    
    @State var isVerticalLook: Bool = false
    @Namespace var animation
    
    @GestureState var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            HearderView()
            if (scene != nil) {
                CustomSceneView(scene: scene )
                    .frame(height: 300)
                    .zIndex(-10)
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
            CustomSeeker()
               
            Spacer()

        }
        .task (id: attachment.thumbnailImageData_){
            
            scene = nil
            attachmentID = attachment.objectID
            
            if self.attachmentID == attachment.objectID {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    scene = try? SCNScene(url: attachment.url!, options: nil)
                }
                
            }
            

        }
        .padding()

    }
    
    @ViewBuilder
    
    func CustomSeeker() -> some View {
        GeometryReader {_ in
            Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [.clear,
                                                 .clear,
                                                 Color(hex: "093855")!.opacity(0.2),
                                                 Color(hex: "093855")!.opacity(0.6),
                                                 Color(hex: "093855")!,
                                                 Color(hex: "093855")!.opacity(0.6),
                                                 Color(hex: "093855")!.opacity(0.2),
                                                 .clear,
                                                 .clear
                ], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .offset(x: offset)
                .overlay {
                    HStack (spacing: 13){
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.caption)
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(hex: "093855")!)

                    }
                    .offset(y: -12)
                    .offset(x: offset)
                    .gesture (
                        DragGesture ()
                            .updating($offset) { value, out, _ in
                                out = value.location.x - 20
                            }
                    )
                }
        }
        .frame(height: 20)
        .onChange(of: offset) { value in
            rotateObject(annimate: offset == .zero)
        }
        .animation(.easeInOut(duration: 0.4), value: offset == .zero)
    }
    
    func rotateObject(annimate: Bool = false) {
        let newAngle = Float((offset * .pi) / 180)
        
        if annimate {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
        }
        
        
        if isVerticalLook {
            scene?.rootNode.eulerAngles.x = newAngle
        } else {
            scene?.rootNode.eulerAngles.y = newAngle
        }
        
        if annimate {
            SCNTransaction.commit()
        }
    }
    
    
    func HearderView() -> some View {
        HStack {
            Spacer()
            
            Button  {
                withAnimation (.easeInOut) {isVerticalLook.toggle()}
            } label: {
                Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(Color(hex: "093855")!)
                    .rotationEffect(.init(degrees: isVerticalLook ? 90 : 0))
                    .frame(width: 42, height: 42)
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.gray.opacity(0.2))
                    }
            }

        }
    }
}
