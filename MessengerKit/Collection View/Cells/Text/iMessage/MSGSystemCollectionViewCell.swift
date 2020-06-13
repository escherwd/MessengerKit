//
//  MSGOutgoingTailCollectionViewCell.swift
//  MessengerKit
//
//  Created by Stephen Radford on 10/06/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import UIKit

open class MSGSystemCollectionViewCell: MSGMessageCell {
    
    @IBOutlet public weak var text: UITextView!
    
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    
    override open var message: MSGMessage? {
        didSet {
            guard let message = message,
                case let MSGMessageBody.system(body,_) = message.body else { return }
            
            text.text = body
            isLastInSection = false
        }
    }
    
    override open var style: MSGMessengerStyle? {
        didSet {
            guard let message = message, let style = style as? MSGIMessageStyle else { return }
            text.font = style.systemMessageFont
            text.backgroundColor = style.systemMessageBackgroundColor
            text.textColor = style.systemMessageTextColor
        }
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleWidthConstraint.constant = bounds.size.width
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        isLastInSection = true
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        text.delegate = self
    }

}

extension MSGSystemCollectionViewCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        delegate?.cellLinkTapped(url: URL)
        
        return false
    }
    
}
