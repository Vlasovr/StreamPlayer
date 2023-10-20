import UIKit
import MobileVLCKit

final class ViewController: UIViewController {
    
    private lazy var streamView = UIView()

    private lazy var player = VLCMediaPlayer()
    
    private lazy var button =  {
        let button = UIButton()
        button.setTitle(Constants.playText, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let url = URL(string: URLComponents.randomStreamURL) {
            checkStreamAvailability(url: url)
            setupPlayer(with: url)
        }
    }
    
    private func setupPlayer(with urlToPlay: URL) {
        player.media = VLCMedia(url: urlToPlay)
        player.drawable = streamView
    }
    
    @objc func play(_ sender: UIButton) {
        if !player.isPlaying {
            player.play()
            button.setTitle(Constants.pauseText, for: .normal)
        } else {
            player.pause()
            button.setTitle(Constants.playText, for: .normal)
        }
    }
    
    private func checkStreamAvailability(url: URL) {
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == Constants.correctStatusCode {
                    print(Constants.streamAvailableText)
                } else {
                    print(Constants.streamNotAvailableText)
                }
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        button.layer.cornerRadius = Constants.cornerRadius
    }
}

extension ViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.defaultOffset).isActive = true
        button.widthAnchor.constraint(equalToConstant: Constants.buttonSize).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.buttonSize).isActive = true

        view.addSubview(streamView)
        streamView.translatesAutoresizingMaskIntoConstraints = false
        streamView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultOffset / 2).isActive = true
        streamView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        streamView.widthAnchor.constraint(equalToConstant: Constants.streamViewWidth).isActive = true
        streamView.heightAnchor.constraint(equalToConstant: Constants.streamViewHeight).isActive = true
    }
}
