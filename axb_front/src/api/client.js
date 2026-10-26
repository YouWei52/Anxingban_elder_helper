const API_BASE = '/api/app';

async function request(endpoint, options = {}) {
    const url = `${API_BASE}${endpoint}`;
    const config = {
        headers: {
            'Content-Type': 'application/json',
            ...options.headers,
        },
        ...options,
    };

    if (config.body && typeof config.body === 'object') {
        config.body = JSON.stringify(config.body);
    }

    const response = await fetch(url, config);

    if (!response.ok) {
        const error = await response.json().catch(() => ({ detail: 'Request failed' }));
        throw new Error(error.detail || `HTTP ${response.status}`);
    }

    return response.json();
}

// Profiles API
export const profilesAPI = {
    list: (limit = 20) => request(`/profiles?limit=${limit}`),
    create: (data) => request('/profiles', { method: 'POST', body: data }),
    get: (id) => request(`/profiles/${id}`),
};

// Trips API
export const tripsAPI = {
    create: (data) => request('/trips', { method: 'POST', body: data }),
    getPass: (id) => request(`/trips/${id}/pass`),
};

// Tasks API
export const tasksAPI = {
    create: (data) => request('/tasks', { method: 'POST', body: data }),
    complete: (id, data) => request(`/tasks/${id}/complete`, { method: 'POST', body: data }),
    feedback: (id, data) => request(`/tasks/${id}/feedback`, { method: 'POST', body: data }),
    listByProfile: (profileId) => request(`/tasks/profile/${profileId}`),
};

// SOS API
export const sosAPI = {
    trigger: (data) => request('/sos/trigger', { method: 'POST', body: data }),
};

// Guide API
export const guideAPI = {
    ask: (question) => request('/guide/ask', { method: 'POST', body: { question } }),
};

// Cards API
export const cardsAPI = {
    generate: (data) => request('/cards/generate', { method: 'POST', body: data }),
    get: (id) => request(`/cards/${id}`),
};
