//
//  ProgressView.swift
//  WorkoutApp
//
//  Created by Viktor Prikolota on 18.06.2022.
//

import UIKit

extension TimerView {
    final class ProgressView: UIView {
        func drawProgress(with percent: CGFloat) {
            layer.sublayers?.removeAll()

            // MARK: - Circle
            let circleFrame = UIScreen.main.bounds.width - (15 + 40) * 2
            let radius = circleFrame / 2
            let center = CGPoint(x: radius, y: radius)
            let startAngle = -CGFloat.pi * 7 / 6
            let endAngle = CGFloat.pi * 1 / 6

            let circlePath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: true)

            let defaultCircleLayer = CAShapeLayer()
            defaultCircleLayer.path = circlePath.cgPath
            defaultCircleLayer.strokeColor = R.Colors.separator.cgColor
            defaultCircleLayer.lineWidth = 20
            defaultCircleLayer.strokeEnd = 1
            defaultCircleLayer.fillColor = UIColor.clear.cgColor
            defaultCircleLayer.lineCap = .round

            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.strokeColor = R.Colors.active.cgColor
            circleLayer.lineWidth = 20
            circleLayer.strokeEnd = percent
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round

            // MARK: - Dot
            let dotAngle = CGFloat.pi * (7 / 6 - (8 / 6 * percent))
            let dotPoint = CGPoint(x: cos(-dotAngle) * radius + center.x,
                                   y: sin(-dotAngle) * radius + center.y)

            let dotPath = UIBezierPath()
            dotPath.move(to: dotPoint)
            dotPath.addLine(to: dotPoint)

            let bigDotLayer = CAShapeLayer()
            bigDotLayer.path = dotPath.cgPath
            bigDotLayer.fillColor = UIColor.clear.cgColor
            bigDotLayer.strokeColor = R.Colors.active.cgColor
            bigDotLayer.lineCap = .round
            bigDotLayer.lineWidth = 20

            let dotLayer = CAShapeLayer()
            dotLayer.path = dotPath.cgPath
            dotLayer.fillColor = UIColor.clear.cgColor
            dotLayer.strokeColor = UIColor.white.cgColor
            dotLayer.lineCap = .round
            dotLayer.lineWidth = 8

            // MARK: - Bars
            let barsFrame = UIScreen.main.bounds.width - (15 + 40 + 25) * 2
            let barsRadius = barsFrame / 2

            let barsPath = UIBezierPath(arcCenter: center,
                                        radius: barsRadius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)

            let barsLayer = CAShapeLayer()
            barsLayer.path = barsPath.cgPath
            barsLayer.fillColor = UIColor.clear.cgColor
            barsLayer.strokeColor = UIColor.clear.cgColor
            barsLayer.lineWidth = 6

            let startBarRadius = barsRadius - barsLayer.lineWidth * 0.5
            let endBarRadius = startBarRadius + 6

            var angle: CGFloat = 7 / 6
            (1...9).forEach { _ in
                let barAngle = CGFloat.pi * angle
                let startBarPoint = CGPoint(
                    x: cos(-barAngle) * startBarRadius + center.x,
                    y: sin(-barAngle) * startBarRadius + center.y
                )

                let endBarPoint = CGPoint(
                    x: cos(-barAngle) * endBarRadius + center.x,
                    y: sin(-barAngle) * endBarRadius + center.y
                )

                let barPath = UIBezierPath()
                barPath.move(to: startBarPoint)
                barPath.addLine(to: endBarPoint)

                let barLayer = CAShapeLayer()
                barLayer.path = barPath.cgPath
                barLayer.fillColor = UIColor.clear.cgColor
                barLayer.strokeColor = angle >= (7 / 6 - (8 / 6 * percent))
                    ? R.Colors.active.cgColor : R.Colors.separator.cgColor
                barLayer.lineCap = .round
                barLayer.lineWidth = 4

                barsLayer.addSublayer(barLayer)

                angle -= 1 / 6
            }

            layer.addSublayer(defaultCircleLayer)
            layer.addSublayer(circleLayer)
            layer.addSublayer(bigDotLayer)
            layer.addSublayer(dotLayer)
            layer.addSublayer(barsLayer)
        }
    }
}

enum TimerState {
    case isRuning
    case isPaused
    case isStopped
}

final class TimerView: WABaseInfoView {

    private let elapsedTimeLable: UILabel = {
        let lable = UILabel()
        lable.text = R.Strings.Session.elapsedTime
        lable.font = R.Fonts.helvelticaRegular(with: 14)
        lable.textColor = R.Colors.inactive
        lable.textAlignment = .center
        return lable
    }()

    private let elapsedTimeValueLable: UILabel = {
        let lable = UILabel()
        lable.font = R.Fonts.helvelticaRegular(with: 46)
        lable.textColor = R.Colors.titleGray
        lable.textAlignment = .center
        return lable
    }()

    private let remainingTimeLable: UILabel = {
        let lable = UILabel()
        lable.text = R.Strings.Session.remainingTime
        lable.font = R.Fonts.helvelticaRegular(with: 13)
        lable.textColor = R.Colors.inactive
        lable.textAlignment = .center
        return lable
    }()

    private let remainingTimeValueLable: UILabel = {
        let lable = UILabel()
        lable.font = R.Fonts.helvelticaRegular(with: 13)
        lable.textColor = R.Colors.titleGray
        lable.textAlignment = .center
        return lable
    }()

    private let timeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()

    private let bottomStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 25
        return view
    }()

    private let completedPercentView = PercentView()
    private let remainigPercetnView = PercentView()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        return view
    }()

    private let progressView = ProgressView()

    private var timer = Timer()
    private var timerProgress: CGFloat = 0
    private var timerDuration = 0.0

    var state: TimerState = .isStopped
    var callBack: (() -> Void)?

    func configure(with duration: Double, progress: Double) {
        timerDuration = duration

        let tempCurrentValue = progress > duration ? duration : progress
        let goalValueDevider = duration == 0 ? 1 : duration
        let percent = tempCurrentValue / goalValueDevider
        let roundedPercent = Int(round(percent * 100))

        elapsedTimeValueLable.text = getDisplayedString(from: Int(tempCurrentValue))
        remainingTimeValueLable.text = getDisplayedString(from: Int(duration) - Int(tempCurrentValue))
        completedPercentView.configure(with: R.Strings.Session.completed.uppercased(),
                                       andValue: roundedPercent)
        remainigPercetnView.configure(with: R.Strings.Session.remaining.uppercased(),
                                      andValue: 100 - roundedPercent)
        progressView.drawProgress(with: CGFloat(percent))
    }

    func startTimer() {
        timer.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                     repeats: true,
                                     block: { [weak self] timer in
            guard let self = self else { return }
            self.timerProgress += 0.01

            if self.timerProgress > self.timerDuration {
                self.timerProgress = self.timerDuration
                timer.invalidate()
            }

            self.configure(with: self.timerDuration, progress: self.timerProgress)
        })
    }

    func pauseTimer() {
        timer.invalidate()
    }

    func stopTimer() {
        guard self.timerProgress > 0 else { return }
        timer.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                     repeats: true,
                                     block: { [weak self] timer in
            guard let self = self else { return }
            self.timerProgress -= self.timerDuration * 0.02

            if self.timerProgress <= 0 {
                self.timerProgress = 0
                timer.invalidate()
            }

            self.configure(with: self.timerDuration, progress: self.timerProgress)
        })
    }
}

extension TimerView {
    override func setupViews() {
        super.setupViews()

        setupView(progressView)
        setupView(timeStackView)
        setupView(bottomStackView)

        [
            elapsedTimeLable,
            elapsedTimeValueLable,
            remainingTimeLable,
            remainingTimeValueLable
        ].forEach(timeStackView.addArrangedSubview)

        [
            completedPercentView,
            bottomSeparatorView,
            remainigPercetnView
        ].forEach(bottomStackView.addArrangedSubview)
    }

    override func constaintViews() {
        super.constaintViews()

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),

            timeStackView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            timeStackView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),

            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            bottomStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 35),
            bottomStackView.widthAnchor.constraint(equalToConstant: 175),

            bottomSeparatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    override func configureAppearance() {
        super.configureAppearance()
    }
}

private extension TimerView {
    func getDisplayedString(from value: Int) -> String {
        let seconds = value % 60
        let minutes = (value / 60) % 60
        let hours = value / 3600

        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let hoursStr = hours < 10 ? "0\(hours)" : "\(hours)"

        return hours == 0
            ? [minutesStr, secondsStr].joined(separator: ":")
            : [hoursStr, minutesStr, secondsStr].joined(separator: ":")
    }
}

extension TimerView {
    final class PercentView: WABaseView {

        private let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 5
            return view
        }()

        private let percentLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelticaRegular(with: 23)
            label.textColor = R.Colors.titleGray
            label.textAlignment = .center
            return label
        }()

        private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelticaRegular(with: 10)
            label.textColor = R.Colors.inactive
            label.textAlignment = .center
            return label
        }()

        override func setupViews() {
            super.setupViews()

            setupView(stackView)
            stackView.addArrangedSubview(percentLabel)
            stackView.addArrangedSubview(subtitleLabel)
        }

        override func constaintViews() {
            super.constaintViews()

            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        func configure(with title: String, andValue value: Int) {
            subtitleLabel.text = title
            percentLabel.text = "\(value)%"
        }
    }
}
