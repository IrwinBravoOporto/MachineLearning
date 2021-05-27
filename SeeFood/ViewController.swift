//
//  ViewController.swift
//  SeeFood
//
//  Created by HITSS on 24/05/21.
//Apuntes CoreML :
// 1. No Training - No se puede usar ninguna data de la aplicación o los datos generados por el usuario mientras usa el aplicativo.
// 2. No Training - Static Model
// 3. Not Encrypted

import UIKit
import CoreML
import Vision
// Vision : Permite procesar imágenes mas fácilmente - CoreML

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    @IBAction func cameraTapeed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil )
    }
    
    // Este delegado "didFinishPickingMediaWithInfo" te consulta si deseas hacer algo con la imagen proporcionada por el usuario.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let userPickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickImage
            guard let ciimage = CIImage(image: userPickImage) else{
                fatalError("Could not convert to CIImage")
            }
            // CoreML
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreMl Model Failed.")
        }
        
        
        let request =  VNCoreMLRequest(model: model) { request, error in
            guard  let results =  request.results as? [VNClassificationObservation]
            else {fatalError("Model failed to process image.")}

            if let firtResult = results.first{
                if firtResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog!"
                }else{
                    self.navigationItem.title = "Not HotDog!"
                }
            }
        }
        
        let handler =  VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        
        catch{
            print(error)
        }
    }
    
    
   
}

