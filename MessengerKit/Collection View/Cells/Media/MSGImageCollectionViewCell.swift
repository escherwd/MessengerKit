//
//  MSGImageCollectionViewCell.swift
//  MessengerKit
//
//  Created by Stephen Radford on 11/06/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import UIKit

class MSGImageCollectionViewCell: MSGMessageCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardSubtitle: UILabel!
    
    @IBOutlet var cardTitleBG: UIView!
    @IBOutlet var cardTitleSecondaryBG: UIView!
    
    override public var message: MSGMessage? {
        didSet {
            
            guard let message = message else {
                return
            }
            
            if case let MSGMessageBody.image(image,_) = message.body {
                imageView.image = image
                cardTitle.text = (image.accessibilityIdentifier ?? "" == "story") ? "Story" : "Image"
                
                
            } else if case let MSGMessageBody.imageFromUrl(imageUrl,_) = message.body {
                self.downloadImage(from: imageUrl)
            }
            
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        
    }
    
    override func layoutSubviews() {
        cardTitle.textColor = (message?.user.isSender ?? false) ? .white : .black
        cardSubtitle.textColor = (message?.user.isSender ?? false) ? UIColor.white.withAlphaComponent(0.5) : UIColor.black.withAlphaComponent(0.5)
        if let s = self.style as? MSGIMessageStyle {
            let color = (message?.user.isSender ?? false) ? s.outgoingBubbleColor : .white
            cardTitleBG.backgroundColor = color
            cardTitleSecondaryBG.backgroundColor = color
        }
    }

}
