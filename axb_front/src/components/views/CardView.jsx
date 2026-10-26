export const CardView = ({ onNavigate }) => (
    <section className="view active">
        <section className="glass-panel view-head">
            <button className="back-btn" onClick={() => onNavigate('home')}>← 返回首页</button>
            <h2>回忆卡片</h2>
        </section>
        <section className="glass-panel module">
            <p className="hint">功能开发中...</p>
        </section>
    </section>
);
