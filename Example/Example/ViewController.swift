//  MIT License

//  Copyright (c) 2020 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import RoundCode

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var messageLabel: UILabel!
  var coder = RCCoder()
  var image = RCImage(message: "")
  let colors: [[UIColor]] = [[.orange, .magenta], [.systemPink, .systemTeal], [.systemTeal, .systemGreen], [.orange, .brown], [.purple, .cyan]]
  var isScanningFromLibrary = false
}

extension ViewController {
  
  @IBAction func changeConfig(_ sender: Any) {
    textField.text = ""
    image.message = ""
    imageView.image = try? coder.encode(image)
    let vc = UIAlertController(title: "Select Configuration", message: nil, preferredStyle: .actionSheet)
    let uuidAction = UIAlertAction(title: "UUID", style: .default) { _ in
      self.coder = RCCoder(configuration: .uuidConfiguration)
    }
    let numericAction = UIAlertAction(title: "Numeric", style: .default) { _ in
      self.coder = RCCoder(configuration: .numericConfiguration)
    }
    let shortAction = UIAlertAction(title: "Short", style: .default) { _ in
      self.coder = RCCoder(configuration: .shortConfiguration)
    }
    let defaultAction = UIAlertAction(title: "Default", style: .default) { _ in
      self.coder = RCCoder(configuration: .defaultConfiguration)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    vc.addAction(uuidAction)
    vc.addAction(numericAction)
    vc.addAction(shortAction)
    vc.addAction(defaultAction)
    vc.addAction(cancelAction)
    present(vc, animated: true)
  }
  
  
  @IBAction func scanImage(_ sender: Any) {
    isScanningFromLibrary = true
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.allowsEditing = true
    vc.delegate = self
    present(vc, animated: true)
  }
  
  
  @IBAction func scan(_ sender: Any) {
    let vc = RCCameraViewController()
    coder.scanningMode  = .lightBackground
    vc.coder = coder
    vc.delegate = self
    present(vc, animated: true)
  }
  
  @IBAction func share(_ sender: Any) {
    image.size = 1000
    image.contentInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    let uiImage = try? coder.encode(image)
    image.size = 300
    image.contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let vc = UIActivityViewController.init(activityItems: [uiImage!], applicationActivities: nil)
    present(vc, animated: true)
  }
  
  @IBAction func setImage(_ sender: Any) {
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.allowsEditing = true
    vc.delegate = self
    present(vc, animated: true)
  }
  
  @IBAction func setColor(_ sender: UISegmentedControl) {
    image.tintColors = colors[sender.selectedSegmentIndex]
    imageView.image = try? coder.encode(image)
  }
  
  @IBAction func didType(_ sender: UITextField) {
    image.message = sender.text ?? ""
    imageView.image = try? coder.encode(image)
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string) as String
    let status = coder.validate(newString)
    return status
  }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let camImage = info[.editedImage] as! UIImage
    if isScanningFromLibrary {
      if let message = try? coder.decode(camImage) {
        messageLabel.text = message
        messageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          self.messageLabel.isHidden = true
        }
      }
    } else {
      image.attachmentImage = camImage
      imageView.image = try? coder.encode(image)
    }
    isScanningFromLibrary = false
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    isScanningFromLibrary = false
    picker.dismiss(animated: true)
  }
}

extension ViewController: RCCameraViewControllerDelegate {
    func cameraViewControllerDidSelectPickImage(userPin: String, vc: UIViewController) {
        
    }
    
  func cameraViewController(userPin: String) {
    messageLabel.text = userPin
    messageLabel.isHidden = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.messageLabel.isHidden = true
    }
  }
}
