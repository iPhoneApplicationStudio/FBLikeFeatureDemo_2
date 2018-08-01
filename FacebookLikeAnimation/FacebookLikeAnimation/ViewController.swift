//
//  ViewController.swift
//  FacebookLikeAnimation
//
//  Created by Abhinay on 11/07/18.
//  Copyright © 2018 ONS. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    let likeImageView:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "like"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let emojititle:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 27.0))
        label.text = "FB Like Demo"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Optima", size: 24.0)
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.backgroundColor = .clear
        return label
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "FB Like Demo2"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Optima", size: 37.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageNames = ["Laugh", "Smile", "Sad", "Love", "Wink"]
    
    let emojiContainerView:UIView = {
        
        let padding:CGFloat = 22
        let height:CGFloat = 38.0
        
        let images = [#imageLiteral(resourceName: "laugh"), #imageLiteral(resourceName: "joy"), #imageLiteral(resourceName: "sad"), #imageLiteral(resourceName: "love"), #imageLiteral(resourceName: "wink")]
        
        let totalImages = CGFloat(images.count)
        
        let view = UIView()
        let width = (totalImages * height) + ((totalImages + 1) * padding)
        
        view.backgroundColor = .white
        
        
        let arrangedSubviews = images.enumerated().map({ (index, image) -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = height/2.0
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.tag =  index
            return imageView
        })
        
        
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isBaselineRelativeArrangement = true
        view.addSubview(stackView)
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height + 15.0)//(2 * padding))
        view.layer.cornerRadius = view.frame.height/2.0
        
        //Add Shadow
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        
        stackView.frame = view.frame
        
        return view
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = Utility.getColorFromRGB(red: 72, green: 104, blue: 173)
        view.addSubview(likeImageView)
        view.addSubview(titleLabel)
        setAutoLayout()
        setLongPressGuesture()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func setAutoLayout()
    {
        let viewsDict = ["titleLabel":titleLabel]
        let constriantH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel]-15-|", options: [], metrics: nil, views: viewsDict)
        let constriantV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-74-[titleLabel]", options: [], metrics: nil, views: viewsDict)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(50)]", options: [], metrics: nil, views: ["v0":likeImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: [], metrics: nil, views: ["v0":likeImageView]))
        
        likeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        likeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        likeImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        likeImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        view.addConstraints(constriantH)
        view.addConstraints(constriantV)
        
        
    }
    
    fileprivate func setLongPressGuesture()
    {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapPressed))
        view.addGestureRecognizer(longTapGesture)
        
    }
    
    @objc fileprivate func longTapPressed(gesture:UILongPressGestureRecognizer)
    {
        
        if gesture.state == .began{
           handleGestureBegan(gesture: gesture)
        }else if gesture.state == .ended{
           handleGestureEnd(gesture: gesture)
        }else if gesture.state == .changed{
           handleGestureChanged(gesture: gesture)
        }
    }
    fileprivate var previousSelectedImage:UIImageView?
    
    
    //Gesture Began
    fileprivate func handleGestureBegan(gesture:UILongPressGestureRecognizer)
    {
        view.addSubview(emojiContainerView)
        view.addSubview(emojititle)
        
        previousSelectedImage = nil
        let pressedLocation = gesture.location(in: view)
        
        emojiContainerView.center.x = view.center.x
        self.emojiContainerView.alpha = 0.0
        
        emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: pressedLocation.y)
        
        
        UIView.animate(withDuration: 0.30, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emojiContainerView.alpha = 1.0
            self.emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: pressedLocation.y - self.emojiContainerView.frame.size.height)
        })
    }
    
    
    
    //Gesture Changed
    fileprivate func handleGestureChanged(gesture:UILongPressGestureRecognizer)
    {
        let location = gesture.location(in: emojiContainerView)
        let stackView = emojiContainerView.subviews.first
        //let fixedYLoc = CGPoint(x: location.x, y: emojiContainerView.frame.size.height / 2.0)
        
        guard let imageViews = stackView?.subviews else {
            return
        }
        
        let hitTestView = emojiContainerView.hitTest(location, with: nil)
        
        
        if hitTestView is UIImageView
        {
            if  previousSelectedImage != nil && previousSelectedImage == hitTestView{
                return
            }
            let hitTestViewRelativeToMainView = self.emojiContainerView.convert(hitTestView!.frame.origin, to: self.view)
            
            if self.emojititle.isHidden == true{
                self.emojititle.transform = CGAffineTransform(translationX: hitTestViewRelativeToMainView.x , y: emojiContainerView.frame.origin.y)
            }
            
            previousSelectedImage = hitTestView as? UIImageView
            UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseInOut, animations: {
                
                for imageView in imageViews
                {
                    UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseInOut, animations: {
                        imageView.transform = CGAffineTransform.identity
                    })
                }

                hitTestView!.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                
                
                print(hitTestViewRelativeToMainView)
                
                if self.emojititle.isHidden == false
                {
                    let index = (hitTestView as! UIImageView).tag
                    self.emojititle.text = self.imageNames[index]
                   // self.emojititle.transform = CGAffineTransform(translationX: (hitTestView?.center.x)!, y: self.emojiContainerView.frame.origin.y - self.emojiContainerView.frame.size.height)
                    self.emojititle.transform = CGAffineTransform(translationX: hitTestViewRelativeToMainView.x, y: self.emojiContainerView.frame.origin.y - self.emojiContainerView.frame.size.height)
                    
                }else{
                    self.emojititle.isHidden = false
                    let index = (hitTestView as! UIImageView).tag
                    self.emojititle.text = self.imageNames[index]
                    //self.emojititle.transform = CGAffineTransform(translationX: (hitTestView?.center.x)!, y: self.emojiContainerView.frame.origin.y - self.emojiContainerView.frame.size.height)
                    self.emojititle.transform = CGAffineTransform(translationX: hitTestViewRelativeToMainView.x, y: self.emojiContainerView.frame.origin.y - self.emojiContainerView.frame.size.height)
                }
                
                
                
            })
        }
        
    }
    //Gesture End
    fileprivate func handleGestureEnd(gesture:UILongPressGestureRecognizer)
    {
        let stackView = emojiContainerView.subviews.first
        
        guard let imageViews = stackView?.subviews else {
            return
        }
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations:
            {
            
            for imageView in imageViews
            {
                UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseIn, animations: {
                    imageView.transform = CGAffineTransform.identity
                })
            }
                self.emojiContainerView.alpha = 0
                self.emojiContainerView.transform = CGAffineTransform(translationX: 0.0, y: self.emojiContainerView.frame.origin.y + self.emojiContainerView.frame.size.height)
        }, completion: { (status) in
            self.emojiContainerView.removeFromSuperview()
            self.emojititle.isHidden = true
            self.emojiContainerView.removeFromSuperview()
            
        })
        
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

class Utility
{
    static func getColorFromRGB(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor
    {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}

