export const CornerRibbon = () => {
    return (
        <div className="corner-ribbon" aria-hidden="true">
            <svg viewBox="0 0 120 120" role="presentation" focusable="false">
                <defs>
                    <linearGradient id="ribbon-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stopColor="#ff7ea8" />
                        <stop offset="50%" stopColor="#ffcc6a" />
                        <stop offset="100%" stopColor="#77cbff" />
                    </linearGradient>
                </defs>
                <path className="ribbon-path ribbon-straight" d="M10 20 C40 20, 80 20, 112 20" />
                <path className="ribbon-path ribbon-heart" d="M60 104 C18 76 6 54 6 34 C6 19 18 8 32 8 C44 8 53 16 60 25 C67 16 76 8 88 8 C102 8 114 19 114 34 C114 54 102 76 60 104" />
            </svg>
        </div>
    );
};
