//
//  FTChatMessageBubbleItem.swift
//  ChatMessageDemoProject
//
//  Created by liufengting on 16/3/23.
//  Copyright © 2016年 liufengting. All rights reserved.
//

import UIKit
import SDWebImage

extension FTChatMessageBubbleItem {
    
}

class FTChatMessageBubbleItem: UIButton {
    
    var message = FTChatMessageModel()
    var messageBubblePath = UIBezierPath()
    var messageLabel : UILabel!

    convenience init(frame: CGRect, aMessage : FTChatMessageModel , image : UIImage?) {
        self.init(frame: frame)
        NSException(name: "SubClassing", reason: "Subclass must impliment this ethod", userInfo: nil).raise()
    }
    
    
    

    /**
     getBubbleShapePathWithSize
     
     - parameter size:       text size
     - parameter isUserSelf: isUserSelf
     
     - returns: UIBezierPath
     */
    func getBubbleShapePathWithSize(size:CGSize , isUserSelf : Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let bubbleWidth = size.width - FTDefaultAngleWidth
        let bubbleHeight = size.height
        let y : CGFloat = 0
        
        if (isUserSelf){
            let x : CGFloat = 0
            
            path.moveToPoint(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y))
            path.addLineToPoint(CGPointMake(x+FTDefaultMessageRoundCorner, y))
            path.addArcWithCenter(CGPointMake(x+FTDefaultMessageRoundCorner, y+FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(-M_PI), clockwise: false);
            path.addLineToPoint(CGPointMake(x, y+bubbleHeight-FTDefaultMessageRoundCorner))
            path.addArcWithCenter(CGPointMake(x+FTDefaultMessageRoundCorner, y+bubbleHeight-FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: false);
            path.addLineToPoint(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y+bubbleHeight))
            path.addArcWithCenter(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y+bubbleHeight-FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false);
            path.addLineToPoint(CGPointMake(x+bubbleWidth, y+FTDefaultMessageRoundCorner*2+8))
            
            path.addQuadCurveToPoint(CGPointMake(x+bubbleWidth+FTDefaultAngleWidth, y+FTDefaultMessageRoundCorner-2), controlPoint: CGPointMake(x+bubbleWidth+2.5, y+FTDefaultMessageRoundCorner+2))
            path.addQuadCurveToPoint(CGPointMake(x+bubbleWidth, y+FTDefaultMessageRoundCorner), controlPoint: CGPointMake(x+bubbleWidth+4, y+FTDefaultMessageRoundCorner-1))

            path.addArcWithCenter(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y+FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(0), endAngle: CGFloat(-M_PI_2), clockwise: false);
            path.closePath()
        }else{
            let x = FTDefaultAngleWidth
            path.moveToPoint(CGPointMake(x+FTDefaultMessageRoundCorner, y))
            path.addLineToPoint(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y))
            path.addArcWithCenter(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y+FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(-M_PI_2), endAngle: 0, clockwise: true);
            path.addLineToPoint(CGPointMake(x+bubbleWidth, y+bubbleHeight-FTDefaultMessageRoundCorner))
            path.addArcWithCenter(CGPointMake(x+bubbleWidth-FTDefaultMessageRoundCorner, y+bubbleHeight-FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true);
            path.addLineToPoint(CGPointMake(x+FTDefaultMessageRoundCorner, y+bubbleHeight))
            path.addArcWithCenter(CGPointMake(x+FTDefaultMessageRoundCorner, y+bubbleHeight-FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true);
            path.addLineToPoint(CGPointMake(x, y+FTDefaultMessageRoundCorner*2+8))
            
            path.addQuadCurveToPoint(CGPointMake(x-FTDefaultAngleWidth, y+FTDefaultMessageRoundCorner-2), controlPoint: CGPointMake(x-2.5, y+FTDefaultMessageRoundCorner+2))
            path.addQuadCurveToPoint(CGPointMake(x, y+FTDefaultMessageRoundCorner), controlPoint: CGPointMake(x-4, y+FTDefaultMessageRoundCorner-1))
            
            path.addArcWithCenter(CGPointMake(x+FTDefaultMessageRoundCorner, y+FTDefaultMessageRoundCorner), radius: FTDefaultMessageRoundCorner, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI_2), clockwise: true);
            path.closePath()
        }
        return path;
    }
    
}

class FTChatMessageBubbleTextItem: FTChatMessageBubbleItem {
    
    convenience init(frame: CGRect, aMessage : FTChatMessageModel ) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        message = aMessage
        
        messageBubblePath = self.getBubbleShapePathWithSize(frame.size, isUserSelf: aMessage.isUserSelf)
        
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.CGPath
        layer.fillColor = aMessage.messageSender.isUserSelf ? FTDefaultOutgoingColor.CGColor : FTDefaultIncomingColor.CGColor
        self.layer.addSublayer(layer)
        
        
        //text
        messageLabel = UILabel(frame: self.getTextRectWithSize(frame.size, isUserSelf: aMessage.isUserSelf));
        messageLabel.text = message.messageText
        messageLabel.numberOfLines = 0
        messageLabel.textColor = aMessage.messageSender.isUserSelf ? UIColor.whiteColor() : UIColor.blackColor()
        messageLabel.font = FTDefaultFontSize
        self.addSubview(messageLabel)
        let attributeString = NSMutableAttributedString(attributedString: messageLabel.attributedText!)
        attributeString.addAttributes([NSFontAttributeName:FTDefaultFontSize,NSParagraphStyleAttributeName: FTChatMessagePublicMethods.getFTDefaultMessageParagraphStyle()], range: NSMakeRange(0, (messageLabel.text! as NSString).length))
        messageLabel.attributedText = attributeString
        
    }

    func getTextRectWithSize(size:CGSize , isUserSelf : Bool) -> CGRect {
        let bubbleWidth = size.width - FTDefaultAngleWidth  - FTDefaultTextMargin*2
        let bubbleHeight = size.height - FTDefaultTextMargin*2
        let y = FTDefaultTextMargin
        let x : CGFloat = isUserSelf ? FTDefaultTextMargin : FTDefaultAngleWidth + FTDefaultTextMargin
        return CGRectMake(x,y,bubbleWidth,bubbleHeight);
    }

    

    
}

class FTChatMessageBubbleImageItem: FTChatMessageBubbleItem {
    
    convenience init(frame: CGRect, aMessage : FTChatMessageModel ) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        message = aMessage
        messageBubblePath = self.getBubbleShapePathWithSize(frame.size, isUserSelf: aMessage.isUserSelf)
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = messageBubblePath.CGPath
        maskLayer.frame = self.bounds
        maskLayer.contentsScale = UIScreen.mainScreen().scale;
        
        let layer = CAShapeLayer()
        layer.mask = maskLayer
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        
        if let image = UIImage(named : "dog.jpg") {
            layer.contents = image.CGImage
        }
        //
//        SDWebImageManager.sharedManager().downloadWithURL(NSURL(string : message.messageText),
//                                                          options: .ProgressiveDownload,
//                                                          progress: { (a, b) in
//                                                            },
//                                                          completed: { (downloadImage, error, cachType, finished) in
//                                                            
//                                                            if finished == true && downloadImage != nil{
//                                                                layer.contents = downloadImage.CGImage
//                                                            }
//                                                            
//                                                            })
    }
    
    
    
}
class FTChatMessageBubbleVideoItem: FTChatMessageBubbleItem {
    
    var mediaPlayImageView : UIImageView!

    
    convenience init(frame: CGRect, aMessage : FTChatMessageModel ) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        message = aMessage
        messageBubblePath = self.getBubbleShapePathWithSize(frame.size, isUserSelf: aMessage.isUserSelf)
        
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.CGPath
        layer.fillColor = aMessage.messageSender.isUserSelf ? FTDefaultOutgoingColor.CGColor : FTDefaultIncomingColor.CGColor
        self.layer.addSublayer(layer)
        
        let mediaImageRect = self.getMediaImageViewFrame(aMessage.isUserSelf)

        mediaPlayImageView = UIImageView(frame : mediaImageRect)
        mediaPlayImageView.backgroundColor = UIColor.clearColor()
        mediaPlayImageView.image = UIImage(named: "Media_Play")
        self.addSubview(mediaPlayImageView)

    }
    func getMediaImageViewFrame(isUserSelf : Bool) -> CGRect {
        let xx = isUserSelf ?
            (self.frame.size.width - FTDefaultAngleWidth - FTDefaultMessageBubbleMediaIconHeight)/2 :
            FTDefaultAngleWidth + (self.frame.size.width - FTDefaultAngleWidth - FTDefaultMessageBubbleMediaIconHeight)/2
        
        let yy = (self.frame.size.height - FTDefaultMessageBubbleMediaIconHeight)/2
        return CGRectMake(xx, yy, FTDefaultMessageBubbleMediaIconHeight, FTDefaultMessageBubbleMediaIconHeight)
    }
}
class FTChatMessageBubbleAudioItem: FTChatMessageBubbleItem {
    
    var playImageView : UIImageView!
    var mediaInfoLabel : UILabel!
    
    
    convenience init(frame: CGRect, aMessage : FTChatMessageModel ) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        message = aMessage
        messageBubblePath = self.getAudioBubblePath(frame.size, isUserSelf: aMessage.isUserSelf)
        
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.CGPath
        layer.fillColor = aMessage.messageSender.isUserSelf ? FTDefaultOutgoingColor.CGColor : FTDefaultIncomingColor.CGColor
        self.layer.addSublayer(layer)
        
        let mediaImageRect = self.getPlayImageViewFrame(aMessage.isUserSelf)
        playImageView = UIImageView(frame : mediaImageRect)
        playImageView.backgroundColor = UIColor.clearColor()
        playImageView.image = UIImage(named: "Media_Play")
        self.addSubview(playImageView)
        
        let mediaInfoLabelRect = self.getMediaInfoLabelFrame(aMessage.isUserSelf)
        mediaInfoLabel = UILabel(frame : mediaInfoLabelRect)
        mediaInfoLabel.backgroundColor = UIColor.clearColor()
        mediaInfoLabel.font = FTDefaultFontSize
        mediaInfoLabel.textColor = UIColor.whiteColor()
        mediaInfoLabel.textAlignment = aMessage.isUserSelf ? NSTextAlignment.Left : NSTextAlignment.Right
        mediaInfoLabel.text = "1′ 22″"
        self.addSubview(mediaInfoLabel)

    }
    
    func getAudioBubblePath(size:CGSize , isUserSelf : Bool) -> UIBezierPath {
        let bubbleRect = CGRectMake(isUserSelf ? 0 : FTDefaultAngleWidth, 0, size.width - FTDefaultAngleWidth , size.height)
        let path = UIBezierPath.init(roundedRect: bubbleRect, cornerRadius:  size.height/2)
        return path;
    }
    
    func getPlayImageViewFrame(isUserSelf : Bool) -> CGRect {
        let margin = (FTDefaultMessageBubbleAudioHeight - FTDefaultMessageBubbleAudioIconHeight)/2
        return isUserSelf ?
            CGRectMake(margin, margin, FTDefaultMessageBubbleAudioIconHeight, FTDefaultMessageBubbleAudioIconHeight) :
            CGRectMake(self.frame.size.width - FTDefaultMessageBubbleAudioHeight + margin , margin, FTDefaultMessageBubbleAudioIconHeight, FTDefaultMessageBubbleAudioIconHeight)
        
    }
    func getMediaInfoLabelFrame(isUserSelf : Bool) -> CGRect {
        let margin = (FTDefaultMessageBubbleAudioHeight - FTDefaultMessageBubbleAudioIconHeight)/2
        return isUserSelf ?
            CGRectMake(FTDefaultMessageBubbleAudioHeight, margin, self.frame.size.width - FTDefaultMessageBubbleAudioHeight - FTDefaultAngleWidth - margin, FTDefaultMessageBubbleAudioIconHeight) :
            CGRectMake( FTDefaultAngleWidth + margin, margin, self.frame.size.width - FTDefaultMessageBubbleAudioHeight - FTDefaultAngleWidth - margin, FTDefaultMessageBubbleAudioIconHeight)
    }

}

class FTChatMessageBubbleLocationItem: FTChatMessageBubbleItem {
    
    
    
    convenience init(frame: CGRect, aMessage : FTChatMessageModel ) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        message = aMessage
        messageBubblePath = self.getBubbleShapePathWithSize(frame.size, isUserSelf: aMessage.isUserSelf)
        
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.CGPath
        layer.fillColor = aMessage.messageSender.isUserSelf ? FTDefaultOutgoingColor.CGColor : FTDefaultIncomingColor.CGColor
        self.layer.addSublayer(layer)
        
//        let map = MKMapView()
//        
//        layer.contents = map
        

    }

}



