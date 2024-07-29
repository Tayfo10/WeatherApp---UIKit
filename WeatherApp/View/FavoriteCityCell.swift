import UIKit

class FavoriteCityCell: UITableViewCell {
    
    static let reuseIdentifier = "FavoriteCityCell"
    
    let cityNameLabel       = UILabel()
    let temperatureLabel    = UILabel()
    let weatherImageView    = UIImageView()
    let timestampLabel      = UILabel()
    let gradientLayer       = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGradientLayer()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        timestampLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        cityNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        temperatureLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        weatherImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [weatherImageView, cityNameLabel, timestampLabel, temperatureLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherImageView.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(cityName: String, temperature: String, weatherDescription: String, timestamp: String) {
        cityNameLabel.text = cityName
        temperatureLabel.text = temperature
        let iconName = WeatherUtils.getWeatherIconName(for: weatherDescription)
        weatherImageView.image = UIImage(named: iconName)
        timestampLabel.text = timestamp
        animateBackground(for: weatherDescription)
    }
    
    private func animateBackground(for weatherDescription: String) {
        let colors = GradientHelper.getWeatherGradient(for: weatherDescription)
        gradientLayer.colors = colors.startColors
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = colors.startColors
        animation.toValue = colors.endColors
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.duration = 6
        animation.beginTime = CACurrentMediaTime() + Double.random(in: 0...6)

        gradientLayer.add(animation, forKey: "colorChange")
    }
}

