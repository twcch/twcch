/* ============================================================
   謝志謙 · Academic Homepage — interactions
   ============================================================ */

/* Mark that JS is active. The CSS scroll-reveal hide rules are scoped to
   `html.js`, so if this script fails to load the page stays fully visible
   (progressive enhancement). Runs synchronously, before DOMContentLoaded. */
document.documentElement.classList.add('js');

document.addEventListener('DOMContentLoaded', () => {
    initResearch();
    initNavShadow();
    initScrollReveal();
    initBackToTop();
    initYear();
});

/* ---------- Research entries (rendered from data) ---------- */
function initResearch() {
    const items = [
        {
            icon: 'bi-graph-up-arrow',
            tagline: 'PhD Research',
            title: '金融時間序列波動率預測',
            venue: 'Hybrid decomposition + residual fusion · Transformer / GNN',
            desc: '針對高噪聲、非平穩、regime-switching 的金融序列，設計結合分解與殘差融合的混合架構，並探討為何 direct additive fusion 有時優於 learned gating。',
            tags: ['Time Series', 'Volatility', 'Transformer', 'GNN'],
        },
        {
            icon: 'bi-tree-fill',
            tagline: 'NLP Research',
            title: '漂綠行為檢測 (Greenwashing Detection)',
            venue: 'BERT / GPT-based text classification',
            desc: '運用大型語言模型分析企業 ESG 與永續報告文本，建構可辨識「漂綠」語言模式的檢測模型。',
            tags: ['NLP', 'BERT', 'GPT', 'ESG'],
        },
        {
            icon: 'bi-diagram-3',
            tagline: '產學合作 · 上海商業銀行',
            title: '供應鏈金融精準推薦系統',
            venue: 'Recommendation system for supply-chain finance',
            desc: '結合企業交易關係與金融需求，建立精準推薦模型，協助銀行在供應鏈金融場景中找到合適的客戶與產品配對。',
            tags: ['Recommendation', 'FinTech', 'Graph'],
        },
        {
            icon: 'bi-hospital',
            tagline: '產學合作 · 豐原醫院',
            title: '智慧醫療問答系統',
            venue: 'NLP / RAG-based medical QA',
            desc: '建構檢索增強生成 (RAG) 的醫療問答系統，將領域知識與大型語言模型結合，提供可追溯來源的回應。',
            tags: ['RAG', 'LLM', 'Healthcare', 'NLP'],
        },
    ];

    const list = document.getElementById('researchList');
    if (!list) return;

    const frag = document.createDocumentFragment();
    items.forEach((p) => {
        const el = document.createElement('article');
        el.className = 'pub-item';
        el.setAttribute('data-reveal', '');
        el.innerHTML = `
            <div class="pub-thumb"><i class="bi ${p.icon}" aria-hidden="true"></i></div>
            <div class="pub-body">
                <p class="pub-tagline">${p.tagline}</p>
                <h3 class="pub-title">${p.title}</h3>
                <p class="pub-venue">${p.venue}</p>
                <p class="pub-desc">${p.desc}</p>
                <div class="pub-tags">
                    ${p.tags.map((t) => `<span class="pub-tag">${t}</span>`).join('')}
                </div>
            </div>`;
        frag.appendChild(el);
    });
    list.appendChild(frag);
}

/* ---------- Navbar shadow on scroll ---------- */
function initNavShadow() {
    const nav = document.getElementById('siteNav');
    if (!nav) return;
    const onScroll = () => nav.classList.toggle('scrolled', window.scrollY > 40);
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
}

/* ---------- Scroll reveal (IntersectionObserver) ---------- */
function initScrollReveal() {
    const targets = document.querySelectorAll('[data-reveal]');
    if (!targets.length) return;

    if (!('IntersectionObserver' in window)) {
        targets.forEach((t) => t.classList.add('revealed'));
        return;
    }

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach((entry) => {
            if (!entry.isIntersecting) return;
            entry.target.classList.add('revealed');
            obs.unobserve(entry.target);
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });

    targets.forEach((t) => observer.observe(t));
}

/* ---------- Back to top ---------- */
function initBackToTop() {
    const btn = document.getElementById('backToTop');
    if (!btn) return;
    const onScroll = () => btn.classList.toggle('show', window.scrollY > 360);
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
    btn.addEventListener('click', () => {
        const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        window.scrollTo({ top: 0, behavior: reduce ? 'auto' : 'smooth' });
    });
}

/* ---------- Footer year ---------- */
function initYear() {
    const el = document.getElementById('year');
    if (el) el.textContent = new Date().getFullYear();
}
