document.addEventListener("DOMContentLoaded", function () {
    const input = document.querySelector('input[name="keyword"]');
    let timer;
    let suggestionBox, wrapper;

    if (input) {
        const parent = input.closest('form');
        parent.classList.add('relative');

        wrapper = document.createElement("div");
        wrapper.className = `
            suggestion-list-wrapper
            absolute left-0 right-0 top-[110%]
            z-30
            rounded-2xl
            overflow-hidden
            shadow-xl
            border border-gray-200
            bg-white
        `.replace(/\s+/g, ' ');
        wrapper.style.display = "none";
        suggestionBox = document.createElement("div");
        suggestionBox.className = `
            suggestion-list
            max-h-80 overflow-y-auto py-2 pb-2
        `.replace(/\s+/g, ' ');
        wrapper.appendChild(suggestionBox);
        parent.appendChild(wrapper);

        // Suggestion search
        input.addEventListener("input", function () {
            const value = input.value.trim();
            clearTimeout(timer);
            if (value.length === 0) {
                wrapper.style.display = "none";
                suggestionBox.innerHTML = "";
                return;
            }
            timer = setTimeout(() => {
                fetch("/searchproduct?type=items&keyword=" + encodeURIComponent(value), {
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                })
                .then(res => res.json())
                .then(arr => {
                    if (!Array.isArray(arr) || arr.length === 0) {
                        suggestionBox.innerHTML = `<div class='px-4 py-2 text-gray-400'>No products found.</div>`;
                    } else {
                        suggestionBox.innerHTML = arr.map((item, idx) => `
                            <a href="/product/${item.slug}"
                               class="flex items-center gap-3 px-4 py-3
                                      ${idx < arr.length - 1 ? 'border-b border-gray-100' : ''}
                                      hover:bg-blue-50 focus:bg-blue-50 transition
                                      rounded-xl mx-2
                               ">
                                <img src="${(item.img || (item.urls && item.urls[0]) || '/default.jpg')}"
                                     class="w-12 h-12 object-cover rounded-xl border border-gray-200 shadow-sm bg-gray-50"
                                     alt="${item.title}" />
                                <div class="flex-1 min-w-0">
                                    <div class="font-semibold text-sm truncate">${item.title}</div>
                                    <div class="text-pink-600 font-bold text-xs">${formatPrice(item.price)}₫</div>
                                </div>
                            </a>
                        `).join('');
                    }
                    wrapper.style.display = "block";
                });
            }, 200); // Delay 200ms
        });

        function formatPrice(price) {
            if (!price) return '0';
            return Number(price).toLocaleString('vi-VN');
        }

        document.addEventListener("mousedown", function (e) {
            if (!input.contains(e.target) && !wrapper.contains(e.target)) {
                wrapper.style.display = "none";
            }
        });

        input.addEventListener("focus", function () {
            if (suggestionBox.innerHTML.trim() !== "") {
                wrapper.style.display = "block";
            }
        });
    }
});

// ---- Reset search input & suggestion 
function resetInputIfNeed() {
    var input = document.querySelector('input[name="keyword"]');
    if (!input) return;
    if (
        window.location.pathname === "/" ||
        window.location.pathname === "/index" ||
        window.location.pathname === "/index.jsp" ||
        window.location.pathname === "/search-products"
    ) {
        input.value = "";
        var wrapper = document.querySelector('.suggestion-list-wrapper');
        if (wrapper) wrapper.style.display = "none";
    }
}
document.addEventListener("DOMContentLoaded", resetInputIfNeed);
window.addEventListener("pageshow", resetInputIfNeed);

// Button animation
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll('a,button').forEach(el => {
        el.addEventListener('mousedown', function () {
            this.classList.add('scale-95');
        });
        el.addEventListener('mouseup', function () {
            this.classList.remove('scale-95');
        });
        el.addEventListener('mouseleave', function () {
            this.classList.remove('scale-95');
        });
    });
});
