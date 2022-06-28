//
//  ContentView.swift
//  Resnet50Demo by "SWIFTUI/COREML（機械学習）実践入門"
//
//  Created by 霜村恭子 on 2022/06/28.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {

    // 4 label
    @State var classificationLabel = "Wmm..."
    
    // create request
    func createClassificationRequest() -> VNCoreMLRequest {
        do {
            // create settings of Model instance
            let configuration = MLModelConfiguration()
            
            // create Model Instance
            let model = try VNCoreMLModel(for: Resnet50(configuration: configuration).model)
            
            // create Request
            let request = VNCoreMLRequest(model:model, completionHandler: { request, error in
                // clasification of images when request is finished
                performClassification(request: request)
            })
            
            return request
        }catch {
            fatalError("Cannot read Model !")
        }
    }

    // clasification of images
    func performClassification(request:VNRequest) {
        
        guard let results = request.results else {
            return
        }
        
        let classification = results as! [VNClassificationObservation]
        
        classificationLabel = "I guess this is a " + classification[0].identifier + "!"
    }
    
    // classification in action
    func classifyImage(image: UIImage){
        
        // convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            fatalError("Cannot Convert to CIImage !")
        }
        
        // create VNImageRequestHandler instance
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        // create request
        let classificationRequest = createClassificationRequest()
        
        // do handler
        do{
            try handler.perform([classificationRequest])
        }catch{
            fatalError("failed classification of image")
        }
    }
    
    var body: some View {
        VStack{
            Text("Classification Image Demo App")
                .padding()
                .font(.title)
            Divider().padding()
            Text(classificationLabel)
            .padding()
            .font(.title)
            Image("cat")
                .resizable()
                .frame(width: 300, height:200)
            Button(action: {
                classifyImage(image: UIImage(named: "cat")!)
            },label: {
                Text("What is this?")
                    .padding()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
