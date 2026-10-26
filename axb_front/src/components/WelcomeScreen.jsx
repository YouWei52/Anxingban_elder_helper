import { useState, useRef, useEffect } from 'react';

export const WelcomeScreen = ({ onEnter }) => {
    const [progress, setProgress] = useState(0);
    const [isDragging, setIsDragging] = useState(false);
    const trackRef = useRef(null);
    const startXRef = useRef(0);

    const handleStart = (clientX) => {
        setIsDragging(true);
        startXRef.current = clientX;
    };

    const handleMove = (clientX) => {
        if (!isDragging || !trackRef.current) return;
        
        const rect = trackRef.current.getBoundingClientRect();
        const maxWidth = rect.width - 56;
        const currentX = clientX - rect.left - 28;
        const newProgress = Math.max(0, Math.min(1, currentX / maxWidth));
        
        setProgress(newProgress);

        if (newProgress >= 0.92) {
            setIsDragging(false);
            setTimeout(() => onEnter(), 100);
        }
    };

    const handleEnd = () => {
        setIsDragging(false);
        if (progress < 0.92) {
            setProgress(0);
        }
    };

    const handleMouseDown = (e) => handleStart(e.clientX);
    const handleMouseMove = (e) => handleMove(e.clientX);
    const handleMouseUp = () => handleEnd();

    const handleTouchStart = (e) => handleStart(e.touches[0].clientX);
    const handleTouchMove = (e) => handleMove(e.touches[0].clientX);
    const handleTouchEnd = () => handleEnd();

    useEffect(() => {
        if (isDragging) {
            window.addEventListener('mousemove', handleMouseMove);
            window.addEventListener('mouseup', handleMouseUp);
            window.addEventListener('touchmove', handleTouchMove);
            window.addEventListener('touchend', handleTouchEnd);
            return () => {
                window.removeEventListener('mousemove', handleMouseMove);
                window.removeEventListener('mouseup', handleMouseUp);
                window.removeEventListener('touchmove', handleTouchMove);
                window.removeEventListener('touchend', handleTouchEnd);
            };
        }
    }, [isDragging, progress]);

    const progressWidth = 56 + progress * (trackRef.current?.getBoundingClientRect().width - 56 || 0);

    return (
        <section id="welcome-screen" aria-label="安行伴欢迎页">
            <div className="welcome-mask"></div>
            <div className="welcome-card">
                <p className="welcome-kicker">欢迎来到</p>
                <h2 className="welcome-title">安行伴</h2>
                <p className="welcome-subtitle">陪伴好他们的每场旅行</p>

                <div
                    ref={trackRef}
                    className="enter-slider"
                    role="button"
                    aria-label="向右滑动进入应用"
                >
                    <div
                        className="enter-slider-progress"
                        style={{ width: `${progressWidth}px` }}
                    ></div>
                    <span className="enter-slider-hint" style={{ opacity: progress > 0.3 ? 0 : 1 }}>
                        向右滑动进入
                    </span>
                    <button
                        type="button"
                        className="enter-slider-thumb"
                        style={{ left: `${progressWidth - 28}px` }}
                        onMouseDown={handleMouseDown}
                        onTouchStart={handleTouchStart}
                        aria-label="向右滑动进入"
                    >
                        <span>→</span>
                    </button>
                </div>
            </div>
        </section>
    );
};
