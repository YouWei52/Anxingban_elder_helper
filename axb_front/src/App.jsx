import { useState, useEffect } from 'react';
import './App.css';

const API_BASE = 'http://47.237.188.77:8000/api';

function App() {
  const [activeTab, setActiveTab] = useState('profiles');
  const [profiles, setProfiles] = useState([]);
  const [trips, setTrips] = useState([]);
  const [tasks, setTasks] = useState([]);
  const [sosRecords, setSosRecords] = useState([]);
  const [loading, setLoading] = useState(false);

  const fetchProfiles = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/profiles`);
      const data = await res.json();
      setProfiles(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error('获取档案失败:', error);
      alert('获取档案失败');
    } finally {
      setLoading(false);
    }
  };

  const fetchTrips = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/trips`);
      const data = await res.json();
      setTrips(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error('获取行程失败:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchTasks = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/tasks`);
      const data = await res.json();
      setTasks(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error('获取任务失败:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchSOS = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/sos`);
      const data = await res.json();
      setSosRecords(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error('获取SOS记录失败:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    switch (activeTab) {
      case 'profiles':
        fetchProfiles();
        break;
      case 'trips':
        fetchTrips();
        break;
      case 'tasks':
        fetchTasks();
        break;
      case 'sos':
        fetchSOS();
        break;
      default:
        break;
    }
  }, [activeTab]);

  return (
    <div className="admin-container">
      <header className="admin-header">
        <h1>安行伴 - 管理后台</h1>
        <div className="header-info">
          <span>管理员</span>
        </div>
      </header>

      <div className="admin-layout">
        <aside className="admin-sidebar">
          <nav>
            <button
              className={activeTab === 'profiles' ? 'active' : ''}
              onClick={() => setActiveTab('profiles')}
            >
              📋 档案管理
            </button>
            <button
              className={activeTab === 'trips' ? 'active' : ''}
              onClick={() => setActiveTab('trips')}
            >
              🗺️ 行程管理
            </button>
            <button
              className={activeTab === 'tasks' ? 'active' : ''}
              onClick={() => setActiveTab('tasks')}
            >
              ✅ 任务管理
            </button>
            <button
              className={activeTab === 'sos' ? 'active' : ''}
              onClick={() => setActiveTab('sos')}
            >
              🚨 SOS记录
            </button>
          </nav>
        </aside>

        <main className="admin-content">
          {loading && <div className="loading">加载中...</div>}

          {activeTab === 'profiles' && (
            <div className="content-section">
              <div className="section-header">
                <h2>档案管理</h2>
              </div>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>长辈姓名</th>
                    <th>长辈电话</th>
                    <th>子女姓名</th>
                    <th>子女电话</th>
                    <th>创建时间</th>
                  </tr>
                </thead>
                <tbody>
                  {profiles.map((profile) => (
                    <tr key={profile.id}>
                      <td>{profile.id}</td>
                      <td>{profile.parent_name}</td>
                      <td>{profile.parent_phone}</td>
                      <td>{profile.child_name}</td>
                      <td>{profile.child_phone}</td>
                      <td>{new Date(profile.created_at).toLocaleString('zh-CN')}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {profiles.length === 0 && !loading && (
                <div className="empty-state">暂无档案数据</div>
              )}
            </div>
          )}

          {activeTab === 'trips' && (
            <div className="content-section">
              <div className="section-header">
                <h2>行程管理</h2>
              </div>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>档案ID</th>
                    <th>目的地</th>
                    <th>出行日期</th>
                    <th>创建时间</th>
                  </tr>
                </thead>
                <tbody>
                  {trips.map((trip) => (
                    <tr key={trip.id}>
                      <td>{trip.id}</td>
                      <td>{trip.profile_id}</td>
                      <td>{trip.destination}</td>
                      <td>{trip.travel_date}</td>
                      <td>{new Date(trip.created_at).toLocaleString('zh-CN')}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {trips.length === 0 && !loading && (
                <div className="empty-state">暂无行程数据</div>
              )}
            </div>
          )}

          {activeTab === 'tasks' && (
            <div className="content-section">
              <div className="section-header">
                <h2>任务管理</h2>
              </div>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>档案ID</th>
                    <th>任务描述</th>
                    <th>状态</th>
                    <th>创建时间</th>
                  </tr>
                </thead>
                <tbody>
                  {tasks.map((task) => (
                    <tr key={task.id}>
                      <td>{task.id}</td>
                      <td>{task.profile_id}</td>
                      <td>{task.description}</td>
                      <td>
                        <span className={`status-badge ${task.status}`}>
                          {task.status === 'completed' ? '已完成' : '进行中'}
                        </span>
                      </td>
                      <td>{new Date(task.created_at).toLocaleString('zh-CN')}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {tasks.length === 0 && !loading && (
                <div className="empty-state">暂无任务数据</div>
              )}
            </div>
          )}

          {activeTab === 'sos' && (
            <div className="content-section">
              <div className="section-header">
                <h2>SOS紧急求助记录</h2>
              </div>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>档案ID</th>
                    <th>位置</th>
                    <th>时间</th>
                    <th>状态</th>
                  </tr>
                </thead>
                <tbody>
                  {sosRecords.map((sos) => (
                    <tr key={sos.id}>
                      <td>{sos.id}</td>
                      <td>{sos.profile_id}</td>
                      <td>{sos.location}</td>
                      <td>{new Date(sos.timestamp).toLocaleString('zh-CN')}</td>
                      <td>
                        <span className="status-badge danger">已发送</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {sosRecords.length === 0 && !loading && (
                <div className="empty-state">暂无SOS记录</div>
              )}
            </div>
          )}
        </main>
      </div>
    </div>
  );
}

export default App;
