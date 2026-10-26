import { useState, useEffect } from "react";
export const Header = ({ currentView, profileId, tripId, taskId }) => {
    const [online, setOnline] = useState(true);

    useEffect(() => {
        const handleOnline = () => setOnline(true);
        const handleOffline = () => setOnline(false);
        window.addEventListener('online', handleOnline);
        window.addEventListener('offline', handleOffline);
        return () => {
            window.removeEventListener('online', handleOnline);
            window.removeEventListener('offline', handleOffline);
        };
    }, []);

    const viewTitles = {
        home: '首页 · 功能总览',
        profile: '功能 · 家庭协同建档',
        trip: '功能 · 行程与动态通行码',
        sos: '功能 · 紧急求助 SOS',
        task: '功能 · 亲子任务',
        guide: '功能 · 景点讲解',
        card: '功能 · 回忆卡片',
        'scenic-list': '景区推荐 · 重庆',
        'scenic-hongyadong': '景区 · 洪崖洞夜景',
        'scenic-ciqikou': '景区 · 磁器口古镇',
        'scenic-wulong': '景区 · 武隆天生三桥',
        'scenic-cableway': '景区 · 长江索道',
    };

    return (
        <header className="glass-panel topbar">
            <p className="kicker">安行伴</p>
            <h1>安行伴</h1>
            <p className="subtitle">{viewTitles[currentView] || '首页'}</p>
            <div className="status-row">
                <span className={`pill ${online ? 'online' : 'offline'}`}>
                    网络状态：{online ? '在线' : '离线'}
                </span>
            </div>
            <p className="context-meta">
                档案ID：{profileId || '-'} ｜ 行程ID：{tripId || '-'} ｜ 任务ID：{taskId || '-'}
            </p>
        </header>
    );
};
