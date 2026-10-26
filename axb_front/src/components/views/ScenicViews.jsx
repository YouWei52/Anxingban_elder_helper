const SCENICS = {
    'scenic-hongyadong': { name: '洪崖洞夜景', region: '渝中区', image: 'hongyadong.jpg' },
    'scenic-ciqikou': { name: '磁器口古镇', region: '沙坪坝区', image: 'ciqikou.jpg' },
    'scenic-wulong': { name: '武隆天生三桥', region: '武隆区', image: 'wulong.jpg' },
    'scenic-cableway': { name: '长江索道', region: '南岸区', image: 'changjiangsuodao.jpg' },
};

export const ScenicListView = ({ onNavigate }) => (
    <section className="view active">
        <section className="glass-panel view-head">
            <button className="back-btn" onClick={() => onNavigate('home')}>← 返回首页</button>
            <h2>景区推荐</h2>
        </section>
        <section className="glass-panel module">
            <section className="scenic-grid">
                {Object.entries(SCENICS).map(([key, scenic]) => (
                    <button
                        key={key}
                        className={`scenic-card ${key}`}
                        onClick={() => onNavigate(key)}
                    >
                        <span className="scenic-fav">☆</span>
                        <span className="scenic-region">{scenic.region}</span>
                        <span className="scenic-name">{scenic.name}</span>
                    </button>
                ))}
            </section>
        </section>
    </section>
);

export const ScenicDetailView = ({ onNavigate, scenic }) => {
    const info = SCENICS[scenic];
    if (!info) return null;

    return (
        <section className="view active">
            <section className="glass-panel view-head">
                <button className="back-btn" onClick={() => onNavigate('scenic-list')}>← 返回推荐</button>
                <h2>{info.name}</h2>
            </section>
            <section className="glass-panel module scenic-detail">
                <img className="scenic-detail-image" src={`/poster/${info.image}`} alt={info.name} />
                <p className="scenic-detail-location">{info.region} · 建议游玩 1-2 小时</p>
                <button className="scenic-plan-btn" onClick={() => onNavigate('trip')}>加入行程</button>
            </section>
        </section>
    );
};
