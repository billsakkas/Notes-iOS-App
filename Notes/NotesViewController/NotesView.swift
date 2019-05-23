//
//  NotesView.swift
//  Notes
//
//  Created by Vasilis Sakkas on 28/03/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit

class NotesView: UIView {

    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        return tv
    }()
    
    init(note: Note?) {
        super.init(frame: CGRect.zero)
        textView.text = note?.text
        uiSetup()
    }
    
    private func uiSetup() {
        addSubview(textView)
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
