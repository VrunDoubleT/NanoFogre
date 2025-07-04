document.addEventListener("DOMContentLoaded", function () {
    const input = document.querySelector('input[name="keyword"]');
    let timer;
    let suggestionBox;

    if (input) {
        input.parentElement.style.position = "relative";
        suggestionBox = document.createElement("div");
        suggestionBox.className = "suggestion-list absolute left-0 right-0 mt-1 bg-white border border-gray-200 rounded-b-2xl shadow z-30 max-h-80 overflow-y-auto";
        suggestionBox.style.display = "none";
        input.parentElement.appendChild(suggestionBox);

        input.addEventListener("input", function () {
            const value = input.value.trim();
            clearTimeout(timer);
            if (value.length === 0) {
                suggestionBox.style.display = "none";
                suggestionBox.innerHTML = "";
                return;
            }
            timer = setTimeout(() => {
                fetch("/SearchServlet?keyword=" + encodeURIComponent(value), {
                    headers: {'X-Requested-With': 'XMLHttpRequest'}
                })
                .then(res => res.json())
                .then(arr => {
                    if (arr.length === 0) {
                        suggestionBox.innerHTML = `<div class='px-4 py-2 text-gray-400'>No products found.</div>`;
                    } else {
                        suggestionBox.innerHTML = arr.map(item => `
                            <a href="/product/${item.slug}" class="flex items-center gap-2 px-3 py-2 hover:bg-blue-50 rounded cursor-pointer transition group">
                                <img src="${item.img || '/default.jpg'}" class="w-12 h-12 object-cover rounded border" alt="${item.title}" />
                                <div class="flex-1">
                                    <div class="font-semibold text-sm group-hover:text-blue-700">${item.title}</div>
                                    <div class="text-pink-600 font-bold text-xs">${formatPrice(item.price)}₫</div>
                                </div>
                            </a>
                        `).join('');
                    }
                    suggestionBox.style.display = "block";
                });
            }, 250);
        });

        function formatPrice(price) {
            return price ? price.toLocaleString('vi-VN') : '0';
        }

        document.addEventListener("click", function (e) {
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
});

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
