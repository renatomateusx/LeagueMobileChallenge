//
//  PostTableViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 11/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    
    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var avatarTitlePost: UILabel!
    @IBOutlet weak var avatarPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension PostTableViewCell {
    func configure(_ post: Post, _ user: User) {
        let url = URL(string: user.avatar)!
        avatarImageView.sd_setImage(with: url,
                                    placeholderImage: UIImage(named: "placeholder.png"))
        avatarName.text = user.name
        avatarTitlePost.text = post.title
        avatarPost.text = post.body
    }
}
