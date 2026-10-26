import { useState } from 'react';

const FEATURES = [
    { label: '家庭建档', desc: '建立家庭成员档案', icon: '👤', view: 'profile' },
    { label: '创建行程', desc: '定制专属旅行计划', icon: '📅', view: 'trip' },
    { label: '紧急求助', desc: '一键联系紧急救助', icon: 'SOS', view: 'sos' },
    { label: '亲子任务', desc: '亲子互动趣味任务', icon: '👥', view: 'task' },
    { label: '景点讲解', desc: '智能语音景点介绍', icon: '🎧', view: 'guide' },
    { label: '回忆卡片', desc: '记录旅行美好瞬间', icon: '🖼', view: 'card' },
];

export const HomeView = ({ onNavigate }) => {
    const [selectedIndex, setSelectedIndex] = useState(3);

    const handleFeatureClick = (index) => {
        setSelectedIndex(index);
        setTimeout(() => {
            onNavigate(FEATURES[index].view);
        }, 300);
    };

    return (
        <section className="view active" id="view-home" data-view-title="首页 · 重庆景区推荐">
            <section className="home-canvas home-selector-layout">
                <section className="semi-wheel-zone" aria-label="半圆功能选择器">
                    <div id="feature-wheel" className="semi-wheel" tabIndex="0" aria-label="旋转半圆选择功能"></div>
                    <div className="selector-arc arc-outer" aria-hidden="true"></div>
                    <div className="selector-arc arc-inner" aria-hidden="true"></div>
                    {[1, 2, 3, 4, 5, 6, 7].map((n) => (
                        <span key={n} className={`selector-dot dot-${n}`} aria-hidden="true"></span>
                    ))}

                    <div id="feature-orbit" className="feature-orbit" role="list" aria-label="功能选择">
                        {FEATURES.map((feature, index) => (
                            <button
                                key={index}
                                type="button"
                                className={`orbit-item ${selectedIndex === index ? 'active' : ''}`}
                                data-slot={index}
                                role="listitem"
                                onClick={() => handleFeatureClick(index)}
                            >
                                <span className="orbit-text">
                                    <span className="orbit-title">{feature.label}</span>
                                    <span className="orbit-desc">{feature.desc}</span>
                                </span>
                                <span className="orbit-icon">{feature.icon}</span>
                            </button>
                        ))}
                    </div>

                    <div className="scenic-tabs" aria-label="推荐分类">
                        <button
                            type="button"
                            className="scenic-tab active"
                            onClick={() => onNavigate('scenic-list')}
                        >
                            <span className="scenic-tab-icon">☾</span>
                            <span className="scenic-tab-label">夜景</span>
                        </button>
                        <button type="button" className="scenic-tab" onClick={() => onNavigate('scenic-list')}>
                            <span className="scenic-tab-icon">🏯</span>
                            <span className="scenic-tab-label">人文</span>
                        </button>
                        <button type="button" className="scenic-tab" onClick={() => onNavigate('scenic-list')}>
                            <span className="scenic-tab-icon">⛰</span>
                            <span className="scenic-tab-label">山水</span>
                        </button>
                        <button type="button" className="scenic-tab" onClick={() => onNavigate('scenic-list')}>
                            <span className="scenic-tab-icon">♡</span>
                            <span className="scenic-tab-label">亲子</span>
                        </button>
                    </div>
                </section>
            </section>
        </section>
    );
};
