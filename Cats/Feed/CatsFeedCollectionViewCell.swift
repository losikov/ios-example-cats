//
//  CatsFeedCollectionViewCell.swift
//  Cats
//
//  Created by Alex Losikov on 11/17/22.
//

import UIKit

class CatsFeedCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var cat: Cat?
    
    lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.secondaryBackground.cgColor
        view.layer.cornerRadius = .cellRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageTag: String?
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .imageRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.isUserInteractionEnabled = true
        roundedBackgroundView.isUserInteractionEnabled = true
        contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(image)
        roundedBackgroundView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            roundedBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            roundedBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: roundedBackgroundView.topAnchor, constant: .imageSpacing),
            image.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: .imageSpacing),
            image.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -.imageSpacing),
            image.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: -.imageSpacing)
            
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor)
        ])
    }
    
    // MARK: - prepareForReuse
    override func prepareForReuse() {
        imageTag = ""
        image.image = nil
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Cell Configuration
    public func configure(with cat: Cat?) {
        self.cat = cat
        
        guard let cat = cat else {
            return
        }

        imageTag = cat.imageUrl()
        image.loadImageWithUrl(
            string: cat.imageUrl(),
            placeholder: #imageLiteral(resourceName: "placeholder"),
            startedHandler: {
                activityIndicator.startAnimating()
            },
            completionHandler: {[weak self] image in
                if self?.imageTag == cat.imageUrl() {
                    self?.activityIndicator.stopAnimating()
                    self?.image.image = image
                }
            }
        )
    }
}
