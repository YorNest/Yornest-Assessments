import UIKit
import SnapKit

/// A button that can show a loading indicator.
/// Matches the main YorNest app's LoadingButton.swift
final class LoadingButton: UIButton {
    
    private let activityIndicator = UIActivityIndicatorView()
    private var originalTitle: String?
    private var originalImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func showLoading(
        _ show: Bool,
        indicatorStyle: UIActivityIndicatorView.Style = .medium,
        indicatorColor: UIColor = Colors.segmentColor,
        size: CGFloat? = nil
    ) {
        if (self.title(for: .normal)?.isEmpty ?? true) == false {
            originalTitle = self.title(for: .normal)
        }
        if self.image(for: .normal) != nil {
            originalImage = self.image(for: .normal)
        }

        if show {
            setTitle("", for: .normal)
            setImage(nil, for: .normal)
            isEnabled = false
            
            activityIndicator.style = indicatorStyle
            activityIndicator.color = indicatorColor

            if let size = size {
                activityIndicator.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.height.equalTo(size)
                }
            }
            
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            isEnabled = true
            setTitle(originalTitle, for: .normal)
            setImage(originalImage, for: .normal)
        }
    }
}

