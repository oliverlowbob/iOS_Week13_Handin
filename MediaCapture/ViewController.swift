//
//  ViewController.swift
//  MediaCapture
//
//  Created by Frederik Søndergaard Jensen on 27/03/2020.
//  Copyright © 2020 Frederik Søndergaard Jensen. All rights reserved.
//

import UIKit

// ALLOW THE FOLLOWING:
// Privacy - Photo Library Usage Description
// Privacy - Photo Library Additions Usage Description
// Privacy - Microphone Usage Description
// Privacy - Camera Usage Description

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomImageTextField: UITextField!
    @IBOutlet weak var choosePictureButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    
//    Will handle fetching the image from the system
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func choosePictureButtonTapped(_ sender: Any) {
        //kører alert funktion i extension
        showImagePickerNavigation()
    }
    
    @IBAction func addTextButtonTapped(_ sender: Any) {
        //tjekker om der er skrevet en tekst i første felt
        if let topText = imageTextField.text {
            //tjekker om der er skrevet i andet felt
            if let bottomText = bottomImageTextField.text {
            //tjekker om der er et billede
            if let image = imageView.image {
                //tager en drawtext, et billede og et punkt til teksten
                let topImage = textToImage(drawText: topText, inImage: image, atPoint: CGPoint(x: 0, y: 0))
                //lægger bottomtext på billedet med toptext
                let topBottomImage = textToImage(drawText: bottomText, inImage: topImage, atPoint: CGPoint(x: 0, y: topImage.size.height-100))
                //sætter imageview til det nye billed med bund og toptekst
                imageView.image = topBottomImage
            }
          }
        }
    }
    //skal bruges til at swipe et billed
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = touches.first?.location(in: view) {
            imageView.transform = CGAffineTransform(translationX: p.x, y: 0)
        }
    }
    
    func textToImage(drawText: String, inImage: UIImage, atPoint: CGPoint) -> UIImage{

        // Setup the font specific variables
        let textColor = UIColor.white;
        let textFont = UIFont(name: "Helvetica Bold", size: 100)!

        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)

        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]

        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))

        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)

        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)

        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        //Pass the image back up to the caller
        return newImage!
    }
    
    // fjerner keyboardet, når der røres ved skærmen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageTextField.endEditing(true)
    }
    

}


//MARK: IMAGE PICKER & NAVIGATION CONTROLLER
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //laver alert, hvor du vælger sourcetype. bruges til at åbne den rigtige imagepickercontroller
    func showImagePickerNavigation() {
        //action sheet(altså det popper op i bunden), vælge mellem billede og kamera
        let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
        //tilføj action
        alert.addAction(UIAlertAction(title: "Photo libary", style: .default, handler: { action in
            //vælger billede fra biblioteket
            self.showImagePickerController(sourceType: .photoLibrary)
        }))
        //vælger kamera
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showImagePickerController(sourceType: .camera)
        }))
        //cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //viser alerten på skærmen
        self.present(alert, animated: true)
    }
    
    // viser kamera eller fotos efter sourceType
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //gør editing mulig
        imagePickerController.allowsEditing = true
        //sætter sourcetype alt efter hvad der fåes med, når metoden kaldes
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // sender valgte billede tilbage til viewcontroller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //laver et billede der skal sendest tilbage, sætter den via info til det valgte billed
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        //sætter imageview i viewcontroller til at være billedet der er valgt
        imageView.image = editedImage
        //lukker editoren til sidst
        dismiss(animated: true, completion: nil)
    }
    
}


