import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedTimerWidget extends StatefulWidget {
  final int durationSeconds;
  final String message;
  final VoidCallback? onComplete;
  final bool showProgress;

  const AnimatedTimerWidget({
    super.key,
    this.durationSeconds = 3,
    this.message = 'Processing...',
    this.onComplete,
    this.showProgress = true,
  });

  @override
  State<AnimatedTimerWidget> createState() => _AnimatedTimerWidgetState();
}

class _AnimatedTimerWidgetState extends State<AnimatedTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    
    // Rotation animation for the spinner
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // Pulse animation for the container
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Progress animation
    _progressController = AnimationController(
      duration: Duration(seconds: widget.durationSeconds),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _progressController.forward();
    
    // Start countdown timer
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });
      
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _isComplete = true;
        _rotationController.stop();
        _pulseController.stop();
        
        // Call onComplete callback
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _progressAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated spinner
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.blue.shade300,
                            width: 3,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.receipt,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Message
                Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Progress bar
                if (widget.showProgress) ...[
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isComplete ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Countdown timer
                Text(
                  _isComplete ? 'Complete!' : '$_remainingSeconds seconds',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _isComplete ? Colors.green : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Status text
                Text(
                  _isComplete 
                    ? 'Receipt generated successfully!'
                    : 'Generating receipt and processing payment...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
