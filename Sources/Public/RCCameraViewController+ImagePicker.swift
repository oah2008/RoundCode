//
//  File.swift
//  
//
//  Created by Omar Hariri on 06/11/1442 AH.
//

import Foundation
import UIKit

extension RCCameraViewController: ImagePickerDelegate{
    
    func  ImagePicker_configureUI(){
        let cancelHolderView = UIControl()
        cancelHolderView.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        cancelHolderView.backgroundColor = .clear
        view.addSubview(cancelHolderView)
        cancelHolderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            cancelHolderView.topAnchor.constraint(equalTo:  view.layoutMarginsGuide.topAnchor, constant: 15),
            cancelHolderView.heightAnchor.constraint(equalToConstant: 40),
            cancelHolderView.widthAnchor.constraint(equalToConstant: 40)
        ])
      
        
        let cancelimg = UIImageView()
        cancelimg.backgroundColor = .clear
        cancelimg.contentMode = .scaleAspectFit
        cancelimg.image = UIImage(systemName: "xmark.circle")
        cancelimg.tintColor = .white
        cancelHolderView.addSubview(cancelimg)
        cancelimg.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelimg.trailingAnchor.constraint(equalTo: cancelHolderView.trailingAnchor, constant: -5),
            cancelimg.bottomAnchor.constraint(equalTo: cancelHolderView.bottomAnchor, constant: -5),
            cancelimg.topAnchor.constraint(equalTo: cancelHolderView.topAnchor, constant: 5),
            cancelimg.leadingAnchor.constraint(equalTo: cancelHolderView.leadingAnchor, constant: 5),
        ])
        

        
        let scanerInfo = UILabel()
        scanerInfo.text = "Scan QR Code"
        scanerInfo.textAlignment = .center
        scanerInfo.backgroundColor = .darkGray
        scanerInfo.textColor = .white.withAlphaComponent(0.7)
        scanerInfo.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(scanerInfo)
        scanerInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanerInfo.centerYAnchor.constraint(equalTo: cancelHolderView.centerYAnchor, constant: 0),
            scanerInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            scanerInfo.heightAnchor.constraint(equalToConstant: 30),
            scanerInfo.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        
        let IconHolderView = UIControl()
        IconHolderView.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        IconHolderView.backgroundColor = .clear
        view.addSubview(IconHolderView)
        IconHolderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            IconHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            IconHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
            IconHolderView.heightAnchor.constraint(equalToConstant: 50),
            IconHolderView.widthAnchor.constraint(equalToConstant: 50)
        ])
      
        
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: "photo.on.rectangle.angled")
        img.tintColor = .white
        IconHolderView.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            img.trailingAnchor.constraint(equalTo: IconHolderView.trailingAnchor, constant: -5),
            img.bottomAnchor.constraint(equalTo: IconHolderView.bottomAnchor, constant: -5),
            img.topAnchor.constraint(equalTo: IconHolderView.topAnchor, constant: 5),
            img.leadingAnchor.constraint(equalTo: IconHolderView.leadingAnchor, constant: 5),
        ])
      
        
        let PickLable = UILabel()
        PickLable.text = "Select Qr from Photos >"
        PickLable.textColor = .white.withAlphaComponent(0.7)
        PickLable.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(PickLable)
        PickLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            PickLable.centerYAnchor.constraint(equalTo: IconHolderView.centerYAnchor, constant: 0),
            PickLable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            PickLable.heightAnchor.constraint(equalToConstant: 30),
            PickLable.widthAnchor.constraint(equalToConstant: 180)
        ])
        view.layoutIfNeeded()
        PickLable.layer.masksToBounds = true
        scanerInfo.layer.masksToBounds = true
        PickLable.layer.cornerRadius = 15
        scanerInfo.layer.cornerRadius = 15
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

      }
    
    
    public func ImagePickerDidSelectQrCodeImage(UserPin: String) {
        self.delegate?.cameraViewControllerDidSelectPickImage(userPin: UserPin,vc: self)
    }

    @objc private func selectPhoto() {
        self.imagePicker.present(from:view)
    }
    
  
}
