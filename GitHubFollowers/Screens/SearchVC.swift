//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class SearchVC: UIViewController {
    
    var dogConfetti = GFDogEmitterLayerView()
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let pugView = GFPugDogModeView()
    let dogModeButton = GFButton(backgroundColor: .systemRed, title: "Dog mode!")
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    var isDogModeOn = false
            
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty // isUsernameEntered will be 'true' only when usernameTextField is not empty.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroundColor(forDogMode: isDogModeOn)
        view.addSubviews(logoImageView, usernameTextField, callToActionButton, dogModeButton, dogConfetti, pugView)
        configureLogoImageView()
        configureTextField()
        configurePugView()
        configureDogModeButton()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) { // we hide the navigation bar every time the searchVC appears. We don't do it in viewDidLoad(), as the view would load only ONCE.
        super.viewWillAppear(animated)
        usernameTextField.text = "" // clear the text field every time the view appears.
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))) // now wherever a user will tap the view, the first responder (our text field) will resign, which will automatically hide the keyboard.
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty username", message: "Please enter a username. We need to know who to look for 😀!", buttonTitle: "OK")
            return
        }
        
        usernameTextField.resignFirstResponder() // hide the keyboard when the new VC is pushed.
        
        let followerListVC = FollowerListVC(username: usernameTextField.text!)
        followerListVC.isDogModeOn = isDogModeOn
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    @objc func toggleDogMode() {
        if isDogModeOn == false {
            GlobalVariables.isDogModeOn = true
            isDogModeOn = true
            
            dogConfetti.emit(with: [.emoji("🐾", nil)], for: 2)
            UIView.animate(withDuration: 0.2) {
                self.view.setBackgroundColor(forDogMode: self.isDogModeOn)
            }
            pugView.animatePugUp()
            
        } else {
            GlobalVariables.isDogModeOn = false
            isDogModeOn = false
            
            UIView.animate(withDuration: 0.2) {
                self.view.setBackgroundColor(forDogMode: self.isDogModeOn)
            }
            pugView.animatePugDown()
        }
    }

    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80 // if our device is iPhone SE (old) ore iPhone 8 zoomed - which practically is an iPhone SE - set the top constraint of the logo to 20. Otherwise, set it to 80.
                
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        usernameTextField.delegate = self // the delegate of usernameTextField is SearchVC. It means it will 'listen' to the textField now.
        
        // we don't have to call '.translatesAutoResizing... = false' because we already did that in the GFTextField initializer.
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50), // 50 points from the leading anchor.
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), // 50 points from the trailing anchor. When dealing with trailing anchors, we need to make the constant numbers negative!
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configurePugView() {
        view.sendSubviewToBack(pugView)
        NSLayoutConstraint.activate([
            pugView.bottomAnchor.constraint(equalTo: dogModeButton.topAnchor),
            pugView.leadingAnchor.constraint(equalTo: dogModeButton.leadingAnchor, constant: 50),
            pugView.trailingAnchor.constraint(equalTo: dogModeButton.trailingAnchor, constant: -50),
            pugView.heightAnchor.constraint(equalTo: dogModeButton.widthAnchor, constant: -100)
        ])
    }
    
    func configureDogModeButton() {
        dogModeButton.addTarget(self, action: #selector(toggleDogMode), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dogModeButton.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -12), // like with the trailing anchors, the bottom ones need negative constant values as well.
            dogModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            dogModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            dogModeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside) // wherever we tap the callToActionButton, 'pushFollowerListVC' action will be called.
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50), // like with the trailing anchors, the bottom ones need negative constant values as well.
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
    
}
