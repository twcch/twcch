document.addEventListener('DOMContentLoaded', () => {
    initTypedText();
    initNavbarScroll();
    initCounters();
    initProjects();
    initBackToTop();
    initContactForm();
    initYear();
});

function initTypedText() {
    const texts = [
        'Full Stack Developer',
        'Software Engineer',
        'Problem Solver',
        'Lifelong Learner',
    ];
    const el = document.querySelector('.typed-text');
    if (!el) return;

    let textIdx = 0;
    let charIdx = 0;
    let deleting = false;

    function tick() {
        const current = texts[textIdx];
        el.textContent = deleting
            ? current.substring(0, charIdx--)
            : current.substring(0, charIdx++);

        let delay = deleting ? 50 : 100;

        if (!deleting && charIdx === current.length + 1) {
            deleting = true;
            delay = 1500;
        } else if (deleting && charIdx === -1) {
            deleting = false;
            textIdx = (textIdx + 1) % texts.length;
            charIdx = 0;
            delay = 300;
        }

        setTimeout(tick, delay);
    }

    tick();
}

function initNavbarScroll() {
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        navbar.classList.toggle('scrolled', window.scrollY > 50);
    });
}

function initCounters() {
    const counters = document.querySelectorAll('.counter');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (!entry.isIntersecting) return;
            const el = entry.target;
            const target = +el.dataset.target;
            const duration = 1500;
            const step = target / (duration / 16);
            let value = 0;

            const update = () => {
                value += step;
                if (value < target) {
                    el.textContent = Math.ceil(value).toLocaleString();
                    requestAnimationFrame(update);
                } else {
                    el.textContent = target.toLocaleString();
                }
            };
            update();
            observer.unobserve(el);
        });
    }, { threshold: 0.5 });

    counters.forEach((c) => observer.observe(c));
}

function initProjects() {
    const projects = [
        {
            icon: 'bi-kanban',
            gradient: 'bg-grad-1',
            title: '任務管理系統',
            description: '使用 React 與 Node.js 打造的企業級任務協作平台，支援即時通知與權限控管。',
            tags: ['React', 'Node.js', 'MongoDB'],
        },
        {
            icon: 'bi-cart-check',
            gradient: 'bg-grad-2',
            title: '電商網站平台',
            description: '完整的電子商務解決方案，含金流串接、庫存管理、訂單追蹤等功能。',
            tags: ['Vue.js', 'Python', 'PostgreSQL'],
        },
        {
            icon: 'bi-graph-up',
            gradient: 'bg-grad-3',
            title: '數據分析儀表板',
            description: '互動式資料視覺化平台，整合多種資料來源，協助企業即時掌握營運狀況。',
            tags: ['D3.js', 'Flask', 'Redis'],
        },
        {
            icon: 'bi-chat-dots',
            gradient: 'bg-grad-4',
            title: '即時聊天應用',
            description: '採用 WebSocket 實作的多人即時通訊系統，支援群組、檔案傳輸與訊息加密。',
            tags: ['Socket.io', 'Express', 'MySQL'],
        },
        {
            icon: 'bi-robot',
            gradient: 'bg-grad-5',
            title: 'AI 智能助理',
            description: '整合大型語言模型的智能客服系統，提供自動應答與語意搜尋功能。',
            tags: ['Python', 'LangChain', 'FastAPI'],
        },
        {
            icon: 'bi-phone',
            gradient: 'bg-grad-6',
            title: '行動應用程式',
            description: '跨平台行動應用開發，提供 iOS / Android 一致的使用者體驗。',
            tags: ['React Native', 'Firebase', 'TypeScript'],
        },
    ];

    const list = document.getElementById('projectList');
    if (!list) return;

    projects.forEach((p) => {
        const col = document.createElement('div');
        col.className = 'col-md-6 col-lg-4';
        col.innerHTML = `
            <div class="card project-card">
                <div class="project-header ${p.gradient}">
                    <i class="bi ${p.icon}"></i>
                </div>
                <div class="card-body">
                    <h5 class="card-title">${p.title}</h5>
                    <p class="card-text text-muted">${p.description}</p>
                    <div>${p.tags.map((t) => `<span class="tech-tag">${t}</span>`).join('')}</div>
                </div>
            </div>
        `;
        list.appendChild(col);
    });
}

function initBackToTop() {
    const btn = document.getElementById('backToTop');
    window.addEventListener('scroll', () => {
        btn.classList.toggle('show', window.scrollY > 300);
    });
    btn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

function initContactForm() {
    const form = document.getElementById('contactForm');
    if (!form) return;
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        const btn = form.querySelector('button[type="submit"]');
        const original = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="bi bi-check-circle"></i> 訊息已發送！';
        btn.classList.replace('btn-primary', 'btn-success');
        form.reset();
        setTimeout(() => {
            btn.disabled = false;
            btn.innerHTML = original;
            btn.classList.replace('btn-success', 'btn-primary');
        }, 3000);
    });
}

function initYear() {
    const el = document.getElementById('year');
    if (el) el.textContent = new Date().getFullYear();
}
