document.addEventListener("DOMContentLoaded", function () {
const input = document.querySelector('input[name="keyword"]');
        let timer;
        let suggestionBox;
        if (input) {
const parent = input.closest('form'); // Lấy form làm parent, đảm bảo position:relative
        parent.classList.add('relative'); // Đảm bảo form có position:relative
        suggestionBox = document.createElement("div");
        suggestionBox.className = `
                suggestion-list
                absolute left-0 right-0 top-[110%]
                bg-white border border-gray-200 rounded-2xl shadow-xl z-30
                max-h-80 overflow-y-auto py-2 pb-2
              `.replace(/\s+/g, ' ');
        suggestionBox.style.display = "none";
        parent.appendChild(suggestionBox);
        input.addEventListener("input", function () {
        const value = input.value.trim();
                clearTimeout(timer);
                if (value.length === 0) {
        suggestionBox.style.display = "none";
                suggestionBox.innerHTML = "";
                return;
        }
        timer = setTimeout(() => {
        fetch("/searchproduct?type=items&keyword=" + encodeURIComponent(value), {
        headers: {'X-Requested-With': 'XMLHttpRequest'}
        })
                .then(res => res.json())
                .then(arr => {
                if (arr.length === 0) {
                suggestionBox.innerHTML = `<div class='px-4 py-2 text-gray-400'>No products found.</div>`;
                } else {
                suggestionBox.innerHTML = arr.map((item, idx) => `
                            <a href="/product/${item.slug}"
                               class="flex items-center gap-3 px-4 py-3
                                      ${idx < arr.length - 1 ? 'border-b border-gray-100' : ''}
                                      hover:bg-blue-50 focus:bg-blue-50 transition
                                      rounded-xl mx-2
                               ">
                                <img src="${item.urls[0] || '/default.jpg'}"
                                     class="w-12 h-12 object-cover rounded-xl border border-gray-200 shadow-sm bg-gray-50"
                                     alt="${item.title}" />
                                <div class="flex-1 min-w-0">
                                    <div class="font-semibold text-sm truncate">${item.title}</div>
                                    <div class="text-pink-600 font-bold text-xs">${formatPrice(item.price)}₫</div>
                                </div>
                            </a>
                        `).join('');
                }
                suggestionBox.style.display = "block";
                });
        }, 50);
        });
        function formatPrice(price) {
        if (!price)
                return '0';
                return Number(price).toLocaleString('vi-VN');
        }

document.addEventListener("mousedown", function (e) {
if (!input.contains(e.target) && !suggestionBox.contains(e.target)) {
suggestionBox.style.display = "none";
}
});
        input.addEventListener("focus", function () {
        if (suggestionBox.innerHTML.trim() !== "") {
        suggestionBox.style.display = "block";
        }
        });
}
}
);

// Button animation (không đổi)
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

