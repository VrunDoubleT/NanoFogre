const loadCategoryContentAndEvent = (page) => {
    lucide.createIcons();
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingCategory').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    // Fetch category list and pagination
    Promise.all([
        fetch("/category/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/category/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([categoryHTML, paginationHTML]) => {

// UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = categoryHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCategory').innerHTML = '';
        // UPDATE URL WHEN CLICK PAGE
        function updatePageUrl(page) {
            const url = new URL(window.location);
            url.searchParams.delete('page');
            url.searchParams.set('page', page);
            history.pushState(null, '', url.toString());
        }

        // ADD EVENT FOR PAGINATION
        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick);
                    loadCategoryContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });
        // ADD EVENT FOR EDIT CATEGORY
        document.querySelectorAll(".openEditCategoryModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal");
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-category-id]');
                const categoryId = buttonItem ? buttonItem.getAttribute('data-category-id') : null;
                if (!categoryId) {
                    console.error("Category ID is missing or invalid.");
                    return;
                }
                openModal(modal);
                fetch(`/category/view?type=edit&categoryId=${categoryId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                            // Call method edit
                            loadEditCategoryEvent(categoryId, page);
                        })
                        .catch(error => {
                            console.error("Error fetching the category data:", error);
                        });
            });
        });
        // ADD EVENT FOR CREATE CATEGORY
        const createBtn = document.getElementById("create-category-button");
        if (createBtn) {
            createBtn.onclick = () => {
                openModal(document.getElementById('modal'));
                updateModalContent(`/category/view?type=create`, loadCreateCategoryEvent);
            };
        }
        
        /////hIDE cATEGFORY
        function confirmHideCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to hide this category?',
                text: "This category will be hidden from users but still kept in system records.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, hide it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=delete&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }

        function confirmEnableCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to restore this category?',
                text: "This category will be visible to users again.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, restore it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=enable&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }
        // DISABLE/HIDE
        document.querySelectorAll(".openDisableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmHideCategory(categoryId);
            });
        });
        // ENABLE
        document.querySelectorAll(".openEnableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmEnableCategory(categoryId);
            });
        });
        //// detail
        document.addEventListener("click", async function (e) {
            const modal = document.getElementById("modal");
            const modalContent = document.getElementById("modalContent");
            const detailCategoryBtn = e.target.closest(".detail-category-button");
            if (detailCategoryBtn) {
                const categoryId = detailCategoryBtn.dataset.id;
                try {
                    const response = await fetch(`/category/view?type=detail&categoryId=${categoryId}`);
                    const html = await response.text();
                    modalContent.innerHTML = html;
                    lucide.createIcons();
                    modal.classList.remove("hidden");
                    modal.classList.add("flex");
                    document.body.classList.add("overflow-hidden");
                } catch (err) {
                    alert("Cannot open details dialog.");
                }
            }
        });
/////////////////////////////////////////////
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.remove-attribute');
            if (!btn)
                return;
            const item = btn.closest('.attribute-item');
            const attributeId = item.querySelector('[name="attributeId"]').value;
            if (!confirm('Bạn có chắc muốn xoá attribute này không?'))
                return;
            fetch(`/category/view?type=deleteAttribute&attributeId=${attributeId}`, {
                method: 'POST'
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.isSuccess) {
                            item.remove();
                        } else {
                            alert('Delete Fail: ' + data.message);
                        }
                    })
                    .catch(() => alert('Delete attribute'));
        });
    });
};

//===================================================
//edit category
function loadEditCategoryEvent(categoryId, currentPage) {
    lucide.createIcons();
    bindDeleteButtons();
    const nameInput = document.getElementById("categoryName");
    const imageInput = document.getElementById("categoryImage");
    const preview = document.getElementById("image-preview");
    const form = document.getElementById("edit-category-form");
    const nameError = document.getElementById("categoryNameError");
    const statusDiv = document.getElementById("upload-status");
    const statusText = document.getElementById("status-text");
    const errorDiv = document.getElementById("upload-error");
    const errorText = document.getElementById("error-text");
    const oldImg = imageInput.getAttribute("data-old-image") || "";
    // Show initial preview
    preview.innerHTML = oldImg
            ? `<img src="${oldImg}" class="h-32 w-32 object-cover rounded-lg shadow"/>`
            : `<span class="text-gray-400 italic">No image available</span>`;
    imageInput.onchange = () => {
        const file = imageInput.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e =>
                preview.innerHTML = `<img src="${e.target.result}" class="h-32 w-32 object-cover rounded-lg shadow"/>`;
            reader.readAsDataURL(file);
        } else {
            preview.innerHTML = oldImg
                    ? `<img src="${oldImg}" class="h-32 w-32 object-cover rounded-lg shadow"/>`
                    : `<span class="text-gray-400 italic">No image available</span>`;
        }
    };
    function showStatus(msg) {
        statusDiv.classList.remove("hidden");
        statusText.textContent = msg;
        errorDiv.classList.add("hidden");
    }
    function showError(msg) {
        errorDiv.classList.remove("hidden");
        errorText.textContent = msg;
        statusDiv.classList.add("hidden");
    }

//===deleteAttribute===
    function bindDeleteButtons() {
        document.querySelectorAll('.attribute-item .remove-attribute').forEach(btn => {
            btn.onclick = () => {
                const itemDiv = btn.closest('.attribute-item');
                const idInput = itemDiv.querySelector('[name="attributeId"]');
                const attributeId = Number(idInput.value);
                // if attribute new create => only delete DOM
                if (attributeId === 0) {
                    itemDiv.remove();
                    updateCount();
                    return;
                }

                Swal.fire({
                    title: 'Are you sure you want to delete this attribute?',
                    text: "This attribute will be permanently removed.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Yes, delete it',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (!result.isConfirmed)
                        return;
                    fetch(`/category/view?type=deleteAttribute`, {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: `attributeId=${attributeId}`
                    })
                            .then(r => r.json())
                            .then(js => {
                                Toastify({
                                    text: js.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: js.isSuccess ? "#28a745" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                if (js.isSuccess) {
                                    itemDiv.remove();
                                    updateCount();
                                }
                            })
                            .catch(err => {
                                console.error(err);
                                Toastify({
                                    text: "Something went wrong while deleting.",
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: "#f44336"
                                    },
                                    close: true
                                }).showToast();
                            });
                });
            };
        });
    }

// --------Add new attribute-------------------- //
    let attributeCounter = document.querySelectorAll('#attributes-container .attribute-item').length;
    const btnAdd = document.querySelector('.openAddAttributeProduct');
    const container = document.getElementById('attributes-container');
    btnAdd.onclick = () => {

        attributeCounter++;
        if (!container.querySelector('#attribute-count')) {
            const tplCount = document.getElementById('attributes-container-template').innerHTML;
            container.insertAdjacentHTML('beforebegin', tplCount);
        }
        // clone item
        const itemTpl = document.getElementById('attribute-item-template')
                .querySelector('#main-attribute-item')
                .cloneNode(true);
        itemTpl.id = "";
        itemTpl.classList.remove("hidden");
        itemTpl.classList.add("attribute-item");
        //Set attributeId = 0
        itemTpl.querySelector('[name="attributeId"]').value = "0";
        // rename input counter
        itemTpl.querySelector('[name="attributeName"]').name = `attributeName_${attributeCounter}`;
        itemTpl.querySelector('[name="attributeRequired"]').name = `attributeRequired_${attributeCounter}`;
        itemTpl.querySelector('[name="attributeDatatype"]').name = `attributeDatatype_${attributeCounter}`;
        itemTpl.querySelector('[name="attributeUnit"]').name = `attributeUnit_${attributeCounter}`;
        // delete
        itemTpl.querySelector('.remove-attribute').onclick = () => {
            itemTpl.remove();
            updateCount();
        };
        // select datatype  -> render template min/max
        const dt = itemTpl.querySelector(`select[name="attributeDatatype_${attributeCounter}"]`);
        const mm = itemTpl.querySelector(".min-max-container");
        dt.onchange = () => {
            mm.innerHTML = "";
            const tpl = document.getElementById(dt.value + "-template");
            if (!tpl)
                return;
            const clone = tpl.firstElementChild.cloneNode(true);
            clone.classList.remove("hidden");
            // rename min/max/text inputs
            clone.querySelectorAll('[name="attributeMin"],[name="attributeMax"],[name="attributeTextValue"]')
                    .forEach(i => i.name = `${i.name}_${attributeCounter}`);
            // checkbox input
            clone.querySelectorAll('.show-min-input').forEach(chk =>
                chk.onchange = () => {
                    const inp = clone.querySelector('.min-input');
                    inp.style.display = chk.checked ? "" : "none";
                    if (!chk.checked)
                        inp.value = "";
                }
            );
            clone.querySelectorAll('.show-max-input').forEach(chk =>
                chk.onchange = () => {
                    const inp = clone.querySelector('.max-input');
                    inp.style.display = chk.checked ? "" : "none";
                    if (!chk.checked)
                        inp.value = "";
                }
            );
            mm.appendChild(clone);
        };
        container.appendChild(itemTpl);
        lucide.createIcons();
        updateCount();
    };
    function updateCount() {
        const cnt = document.querySelectorAll('#attributes-containerShow .attribute-itemShow').length;
        const el = document.getElementById('attribute-count');
        if (el)
            el.textContent = `${cnt} attribute${cnt !== 1 ? 's' : ''}`;
    }

    /////////=======ShowAttribute======////////
    const attributeState = new WeakMap();
    document.querySelectorAll('#attributes-container .attribute-item').forEach(item => {
        const dt = item.querySelector('select[name^="attributeDatatype"]');
        const mm = item.querySelector('.min-max-container');
        if (!dt || !mm)
            return;
        const saveState = () => {
            const data = {};
            mm.querySelectorAll('input').forEach(inp => {
                data[inp.name] = inp.value;
                data[inp.name + "_visible"] = inp.style.display !== "none";
            });
            attributeState.set(item, data);
        };
        const restoreState = () => {
            const data = attributeState.get(item);
            if (!data)
                return;
            mm.querySelectorAll('input').forEach(inp => {
                inp.value = data[inp.name] || '';
                const visible = data[inp.name + "_visible"];
                if (visible === false)
                    inp.style.display = "none";
                else if (visible === true)
                    inp.style.display = "";
            });
            // restore checkbox (Min/Max)
            mm.querySelectorAll('.show-min-input').forEach(chk => {
                const minInp = mm.querySelector('.min-input');

                chk.checked = !!(minInp && minInp.style.display !== "none");
            });

            mm.querySelectorAll('.show-max-input').forEach(chk => {
                const maxInp = mm.querySelector('.max-input');
                chk.checked = !!(maxInp && maxInp.style.display !== "none");
            });
        };
        dt.addEventListener('change', () => {
            // Save information current
            saveState();
            mm.innerHTML = '';
            const tpl = document.getElementById(dt.value + '-template');
            if (!tpl)
                return;
            const clone = tpl.firstElementChild.cloneNode(true);
            clone.classList.remove('hidden');
            clone.querySelectorAll('.show-min-input').forEach(chk => {
                const inp = clone.querySelector('.min-input');
                chk.onchange = () => {
                    inp.style.display = chk.checked ? '' : 'none';
                    if (!chk.checked)
                        inp.value = '';
                    validateAttributeNumberFields();
                    validateDateFields();
                };
            });
            clone.querySelectorAll('.show-max-input').forEach(chk => {
                const inp = clone.querySelector('.max-input');
                chk.onchange = () => {
                    inp.style.display = chk.checked ? '' : 'none';
                    if (!chk.checked)
                        inp.value = '';
                    validateAttributeNumberFields();
                    validateDateFields();
                };
            });
            mm.appendChild(clone);
            restoreState();
            // VALIDATE  TYPE
            validateAttributeNumberFields();
            validateAttributeTextFields();
            validateDateFields();
        });

        if (dt.value)
            dt.dispatchEvent(new Event('change'));
    });

    ///// ======Check valid======///////
    ///valid Date
    function validateDateFields() {
        let isValid = true;
        const today = new Date();
        const minAccept = new Date("2000-01-01");

        document.querySelectorAll('.attribute-item').forEach(item => {
            const minInput = item.querySelector('input.min-input[type="date"]');
            const maxInput = item.querySelector('input.max-input[type="date"]');

            clearDateErrors(minInput, maxInput);

            [minInput, maxInput].forEach(inp => {
                if (!inp || !inp.value)
                    return;
                const d = new Date(inp.value);
                let msg = "";

                if (isNaN(d.getTime()) || d < minAccept) {
                    msg = "Date must be on or after 01/01/2000";
                } else if (d > today) {
                    msg = "Date must not be in the future";
                }

                if (msg) {
                    isValid = false;
                    inp.classList.add("border-red-500");
                    inp.insertAdjacentHTML('afterend',
                            `<span class="text-red-500 text-xs mt-1 date-error-msg">${msg}</span>`);
                } else {
                    inp.classList.add("ring-1", "ring-green-500");
                }
            });

            // validate quan hệ Min < Max 
            if (
                    minInput && maxInput &&
                    minInput.value && maxInput.value &&
                    !minInput.classList.contains("border-red-500") &&
                    !maxInput.classList.contains("border-red-500")
                    ) {
                const minDate = new Date(minInput.value);
                const maxDate = new Date(maxInput.value);

                if (minDate.getTime() >= maxDate.getTime()) {
                    isValid = false;
                    [minInput, maxInput].forEach(inp => {
                        inp.classList.remove("ring-green-500");
                        inp.classList.add("border-red-500");
                    });

                    minInput.insertAdjacentHTML('afterend',
                            `<span class="text-red-500 text-xs mt-1 date-error-msg">Min date must be earlier than Max date</span>`
                            );
                    maxInput.insertAdjacentHTML('afterend',
                            `<span class="text-red-500 text-xs mt-1 date-error-msg">Max date must be later than Min date</span>`
                            );
                }
            }
        });
        return isValid;
    }

    function clearDateErrors(...inputs) {
        inputs.forEach(inp => {
            if (!inp)
                return;
            inp.parentElement
                    .querySelectorAll('.date-error-msg')
                    .forEach(el => el.remove());
            inp.classList.remove("border-red-500", "ring-1", "ring-green-500");
        });
    }

//===================================================
/////Valid Int and Float 

    function validateAttributeNumberFields() {
        let isValid = true;

        document.querySelectorAll('.attribute-item').forEach(item => {
            const dtSelect = item.querySelector('select[name^="attributeDatatype"]');
            if (!dtSelect)
                return;
            const type = dtSelect.value;
            if (type !== 'int' && type !== 'float')
                return;

            const minInput = item.querySelector('input[name^="attributeMin"]');
            const maxInput = item.querySelector('input[name^="attributeMax"]');

            // helpers...
            function clearErrors(input) {
                if (!input)
                    return;
                input.parentElement
                        .querySelectorAll('.number-error-msg')
                        .forEach(el => el.remove());
                input.classList.remove("border-red-500", "ring-1", "ring-green-500");
            }
            function showError(input, msg) {
                input.classList.add("border-red-500");
                const err = document.createElement("div");
                err.className = "text-red-500 text-xs mt-1 number-error-msg";
                err.textContent = msg;
                input.parentElement.appendChild(err);
            }

            // 1) clear 
            [minInput, maxInput].forEach(clearErrors);

            // 2) validate
            let fieldError = false;
            [minInput, maxInput].forEach(input => {
                if (!input)
                    return;
                const val = input.value.trim();
                if (val === "")
                    return;
                const num = Number(val);
                if (isNaN(num)) {
                    fieldError = true;
                    isValid = false;
                    showError(input, "Value must be a valid number.");
                } else if (num < 0) {
                    fieldError = true;
                    isValid = false;
                    showError(input, "Value cannot be negative.");
                } else if (type === 'int' && !Number.isInteger(num)) {
                    fieldError = true;
                    isValid = false;
                    showError(input, "Only integer numbers allowed.");
                }
            });


            [minInput, maxInput].forEach(input => {
                if (input && input.value.trim() !== "" && !input.classList.contains("border-red-500")) {
                    input.classList.add("ring-1", "ring-green-500");
                }
            });


            if (!fieldError
                    && minInput && maxInput
                    && minInput.value.trim() !== ""
                    && maxInput.value.trim() !== ""
                    ) {
                const minVal = Number(minInput.value);
                const maxVal = Number(maxInput.value);
                if (minVal >= maxVal) {
                    isValid = false;

                    [minInput, maxInput].forEach(inp => {
                        inp.classList.remove("ring-green-500");
                        // clearErrors(inp);
                    });
                    showError(minInput, "Min value must be less than Max value.");
                    showError(maxInput, "Max value must be greater than Min value.");
                } else {

                    [minInput, maxInput].forEach(i =>
                        i.classList.add("ring-1", "ring-green-500")
                    );
                }
            }
        });

        return isValid;
    }

//===================================================
////valid Name and unit

    function validateAttributeTextFields() {
        let isValid = true;

        // helper:clear error & class old
        function clearErrors(input) {
            if (!input)
                return;
            input.parentElement
                    .querySelectorAll('.text-error-msg')
                    .forEach(el => el.remove());
            input.classList.remove("border-red-500", "ring-1", "ring-green-500");
        }

        // helper: show error
        function showError(input, msg) {
            input.classList.add("border-red-500");
            const err = document.createElement("div");
            err.className = "text-red-500 text-xs mt-1 text-error-msg";
            err.textContent = msg;
            input.parentElement.appendChild(err);
        }

        // 1)  validate input individual 
        document.querySelectorAll('.attribute-item').forEach(item => {
            const nameInput = item.querySelector('input[name^="attributeName"]');

            [nameInput].forEach(input => {
                if (!input)
                    return;
                clearErrors(input);

                const value = input.value.trim();
                const isName = input === nameInput;
                const fieldLabel = isName ? "Attribute Name" : "Unit";
                const maxLen = isName ? 50 : 10;
                const validPattern = /^[A-Za-z0-9 ]+$/;

                if (!value) {
                    isValid = false;
                    showError(input, `${fieldLabel} is required.`);
                    return;
                }
                if (value.length > maxLen) {
                    isValid = false;
                    showError(input, `${fieldLabel} must be ≤ ${maxLen} chars.`);
                    return;
                }
                if (!validPattern.test(value)) {
                    isValid = false;
                    showError(input, `${fieldLabel} cannot contain special characterst.`);
                    return;
                }

                input.classList.add("ring-1", "ring-green-500");
            });
        });

        // 2) check attributeName already exists.
        const nameInputs = Array.from(
                document.querySelectorAll('input[name^="attributeName"]')
                ).filter(i => i.value.trim() !== "");
        const counts = nameInputs.reduce((acc, inp) => {
            const v = inp.value.trim().toLowerCase();
            acc[v] = (acc[v] || 0) + 1;
            return acc;
        }, {});


        nameInputs.forEach(inp => {
            const v = inp.value.trim().toLowerCase();
            if (counts[v] > 1) {
                isValid = false;
                inp.classList.remove("ring-green-500");
                showError(inp, "Attribute Name already exists.");
            }
        });

        return isValid;
    }

//===================================================
    /// real-time check rightnow valid when input
    const attrsContainer = document.getElementById('attributes-container');
    if (attrsContainer) {
        attrsContainer.addEventListener('input', e => {
            const tgt = e.target;
            if (tgt.matches('input[name^="attributeMin"], input[name^="attributeMax"]')) {
                validateAttributeNumberFields();
            }
            if (tgt.matches('input[name^="attributeName"], input[name^="attributeUnit"]')) {
                validateAttributeTextFields();
            }
            if (tgt.matches('input.min-input[type="date"], input.max-input[type="date"]')) {
                validateDateFields();
            }
        });
    }


    attrsContainer.addEventListener('blur', e => {
        const tgt = e.target;
        if (tgt.matches('input[name^="attributeMin"], input[name^="attributeMax"]')) {
            validateAttributeNumberFields();
        }
        if (tgt.matches('input[name^="attributeName"], input[name^="attributeUnit"]')) {
            validateAttributeTextFields();
        }
        if (tgt.matches('input.min-input[type="date"], input.max-input[type="date"]')) {
            validateDateFields();
        }
    }, true);
//===================================================
// ----- Submit form -----
    form.onsubmit = ev => {
        ev.preventDefault();

        statusDiv.classList.add("hidden");
        errorDiv.classList.add("hidden");
        nameError.textContent = "";

        if (!nameInput.value.trim()) {
            nameError.textContent = "Category name is required";
            return;
        }
        //  Validate attribute fields
        if (
                !validateDateFields() ||
                !validateAttributeNumberFields() ||
                !validateAttributeTextFields()
                )
            return;

        //  Build FormData
        const fd = new FormData();
        fd.append("type", "update");
        fd.append("categoryId", categoryId);
        fd.append("categoryName", nameInput.value.trim());
        if (imageInput.files[0]) {
            fd.append("categoryImage", imageInput.files[0]);
        }

        const attrs = [];
        document.querySelectorAll('.attribute-item').forEach(item => {
            const idEl = item.querySelector('[name="attributeId"]');
            const aid = idEl ? Number(idEl.value) : 0;

            // Note: selector bắt cả "attributeName" và "attributeName_<idx>"
            const nameEl = item.querySelector(
                    '[name="attributeName"], [name^="attributeName_"]'
                    );
            const dtEl = item.querySelector(
                    '[name="attributeDatatype"], [name^="attributeDatatype_"]'
                    );
            const unitEl = item.querySelector(
                    '[name="attributeUnit"], [name^="attributeUnit_"]'
                    );
            const minEl = item.querySelector(
                    '[name="attributeMin"], [name^="attributeMin_"]'
                    );
            const maxEl = item.querySelector(
                    '[name="attributeMax"], [name^="attributeMax_"]'
                    );
            const reqEl = item.querySelector(
                    '[name="attributeRequired"], [name^="attributeRequired_"]'
                    );
            const actEl = item.querySelector(
                    '[name="attributeActive"], [name^="attributeActive_"]'
                    );

            attrs.push({
                attributeId: aid,
                attributeName: nameEl ? nameEl.value.trim() : "",
                datatype: dtEl ? dtEl.value : "",
                unit: unitEl ? unitEl.value.trim() : null,
                minValue: minEl ? minEl.value.trim() : null,
                maxValue: maxEl ? maxEl.value.trim() : null,
                isRequired: reqEl ? reqEl.checked : false,
                isActive: actEl ? actEl.value === "true" : false
            });
        });
        fd.append("attributes", JSON.stringify(attrs));

        showLoading();
        fetch('/category/view?type=update', {
            method: 'POST',
            body: fd
        })
                .then(r => r.json())
                .then(js => {
                    hiddenLoading();
                    if (js.isSuccess) {
                        showStatus(js.message || "Updated!");
                        closeModal();
                        setTimeout(() => loadCategoryContentAndEvent(currentPage));
                    } else {
                        showError(js.message || "Update failed");
                    }
                })
                .catch(_ => {
                    hiddenLoading();
                    showError("Something went wrong");
                });
    }
    ;
}

//=====================Create Category====================//
function loadCreateCategoryEvent() {
    lucide.createIcons();
    const nameInput = document.getElementById("categoryName");
    const imageInput = document.getElementById("categoryImage");
    const preview = document.getElementById("image-preview");
    const btnCreate = document.getElementById("create-category-btn");
    const statusDiv = document.getElementById("upload-status");
    const statusText = document.getElementById("status-text");
    const errorDiv = document.getElementById("upload-error");
    const errorText = document.getElementById("error-text");
    // Error elements
    const nameError = document.getElementById("categoryNameError");
    const imageError = document.getElementById("categoryImageError");
    // Variables for attribute management
    let attributeCounter = 0;
    // Image preview handler
    imageInput.onchange = function () {

        preview.innerHTML = "";
        if (imageInput.files && imageInput.files[0]) {
            const file = imageInput.files[0];
            // Validate file size (max 5MB)
            if (file.size > 5 * 1024 * 1024) {
                imageError.textContent = "File size must be less than 5MB";
                imageInput.classList.add("border", "border-red-500");
                return;
            }
            // Validate file type
            const allowedTypes = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'];
            if (!allowedTypes.includes(file.type)) {
                imageError.textContent = "Only PNG, JPG, JPEG, GIF files are allowed";
                imageInput.classList.add("border", "border-red-500");
                return;
            }

            // Clear errors and show preview
            imageError.textContent = "";
            imageInput.classList.remove("border-red-500");
            imageInput.classList.add("ring-1", "ring-green-500");
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.innerHTML = `<img src="${e.target.result}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
            };
            reader.readAsDataURL(file);
        }
    };
    // Add attribute button handler
    document.querySelector(".openAddAttributeProduct").addEventListener("click", function () {
        addAttributeForm();
    });
    // Create attributes container if it doesn't exist
    function createAttributesContainer() {
        let attributesContainer = document.getElementById("attributes-container");
        if (!attributesContainer) {
            attributesContainer = document.createElement("div");
            attributesContainer.id = "attributes-container";
            attributesContainer.className = "mt-4 space-y-4";
            const containerWrapper = document.querySelector("#attribute-item-template").parentNode;
            if (containerWrapper) {
                containerWrapper.insertBefore(attributesContainer, document.getElementById("attribute-item-template"));
            } else {
                console.error("Not find attributes-container!");
            }
        }

        return attributesContainer;
    }

    // Add new attribute form
    function addAttributeForm() {
        attributeCounter++;
        const attributeId = `attribute-${attributeCounter}`;
        // Create container if not exists
        const attributesContainer = createAttributesContainer();
        // Clone attribute template
        const template = document.getElementById("main-attribute-item");
        const attributeElement = template.cloneNode(true);
        attributeElement.removeAttribute("id");
        attributeElement.classList.remove("hidden");
        attributeElement.classList.add("attribute-item");
        attributeElement.setAttribute("data-attribute-id", attributeId);
        // Update input names/ids
        updateAttributeInputs(attributeElement, attributeCounter);
        // Add to container
        attributesContainer.appendChild(attributeElement);
        lucide.createIcons();
        // Update count
        updateAttributeCount();
        // Add event handlers
        setupAttributeEvents(attributeElement, attributeId, attributeCounter);
    }

    // Update input names and IDs for the attribute
    function updateAttributeInputs(element, counter) {
        const nameInput = element.querySelector('input[name="attributeName"]');
        const requiredInput = element.querySelector('input[name="attributeRequired"]');
        const datatypeSelect = element.querySelector('select[name="attributeDatatype"]');
        const unitInput = element.querySelector('input[name="attributeUnit"]');
        const nameError = element.querySelector('.attribute-name-error');
        const datatypeError = element.querySelector('.attribute-datatype-error');
        nameInput.name = `attributeName_${counter}`;
        nameInput.id = `attributeName_${counter}`;
        requiredInput.name = `attributeRequired_${counter}`;
        requiredInput.id = `attributeRequired_${counter}`;
        datatypeSelect.name = `attributeDatatype_${counter}`;
        datatypeSelect.id = `attributeDatatype_${counter}`;
        unitInput.name = `attributeUnit_${counter}`;
        unitInput.id = `attributeUnit_${counter}`;
        nameError.id = `attributeNameError_${counter}`;
        datatypeError.id = `attributeDatatypeError_${counter}`;
    }


    // Setup event handlers for attribute
    function setupAttributeEvents(element, attributeId, counter) {
        // Real-time validate date
        element.querySelectorAll(`input[name="attributeMin_${counter}"][type="date"],
                             input[name="attributeMax_${counter}"][type="date"]`)
                .forEach(inp => {

                    //real-time Valid Date
                    inp.addEventListener('input', () => validateAttributeDateFields(counter));
                    inp.addEventListener('blur', () => validateAttributeDateFields(counter));
                });
        // Real-time validate number on input & blur
        element.querySelectorAll(
                `input[name="attributeMin_${counter}"], input[name="attributeMax_${counter}"]`
                ).forEach(inp => {
            inp.addEventListener('input', () => validateAttributeNumberFields(counter));
            inp.addEventListener('blur', () => validateAttributeNumberFields(counter));
        });
        // Remove button handler
        const removeBtn = element.querySelector(".remove-attribute");
        removeBtn.addEventListener("click", function () {
            removeAttribute(attributeId);
        });
        // Datatype change handler
        const datatypeSelect = element.querySelector(`select[name="attributeDatatype_${counter}"]`);
        const minMaxContainer = element.querySelector(".min-max-container");
        datatypeSelect.addEventListener("change", function () {
            updateMinMaxFields(this.value, minMaxContainer, counter);
        });
        // Add real-time validation for attribute name
        const nameInput = element.querySelector(`input[name="attributeName_${counter}"]`);
        nameInput.addEventListener("blur", function () {
            validateAttributeName(counter);
        });
        // Add real-time validation for datatype
        datatypeSelect.addEventListener("change", function () {
            validateAttributeDatatype(counter);
        });
        // validation for unit
        const unitInput = element.querySelector(`input[name="attributeUnit_${counter}"]`);
        if (unitInput) {
            unitInput.addEventListener("blur", function () {
                validateAttributeUnit(counter);
            });
            unitInput.addEventListener("input", function () {
                validateAttributeUnit(counter);
            });
        }
        //validate cho Text value
        const textValueInput = element.querySelector(`input[name="attributeTextValue_${counter}"]`);
        if (textValueInput) {
            textValueInput.addEventListener("blur", function () {
                validateAttributeTextValue(counter);
            });
            textValueInput.addEventListener("input", function () {
                validateAttributeTextValue(counter);
            });
        }


    }

    // Update min/max fields based on data type
    function updateMinMaxFields(dataType, container, counter) {
        container.innerHTML = "";
        if (!dataType)
            return;
        let templateId = "";
        switch (dataType) {
            case "int":
                templateId = "int-template";
                break;
            case "float":
                templateId = "float-template";
                break;
            case "text":
                templateId = "text-template";
                break;
            case "date":
                templateId = "date-template";
                break;
        }

        if (templateId) {
            const template = document.getElementById(templateId);
            const clonedTemplate = template.cloneNode(true);
            clonedTemplate.classList.remove("hidden");
            // Update input names
            const inputs = clonedTemplate.querySelectorAll('input[name="attributeMin"], input[name="attributeMax"], input[name="attributeTextValue"]');
            inputs.forEach(input => {
                if (input.name === "attributeMin") {
                    input.name = `attributeMin_${counter}`;
                } else if (input.name === "attributeMax") {
                    input.name = `attributeMax_${counter}`;
                } else if (input.name === "attributeTextValue") {
                    input.name = `attributeTextValue_${counter}`;
                }
            });
            container.appendChild(clonedTemplate);
            setupMinMaxCheckboxEvents(clonedTemplate, counter);
        }
    }
    ////////////
    function setupMinMaxCheckboxEvents(container, counter) {
        // Min checkbox and input
        const showMinCheckbox = container.querySelector('.show-min-input');
        const minInput = container.querySelector('.min-input');
        if (showMinCheckbox && minInput) {
            showMinCheckbox.addEventListener('change', function () {
                minInput.style.display = this.checked ? '' : 'none';
                if (!this.checked) {
                    minInput.value = "";
                }
            });
            // Add validation for min/max relationship
            minInput.addEventListener('blur', function () {
                validateMinMaxRelationship(counter);
            });
        }

        // Max checkbox and input
        const showMaxCheckbox = container.querySelector('.show-max-input');
        const maxInput = container.querySelector('.max-input');
        if (showMaxCheckbox && maxInput) {
            showMaxCheckbox.addEventListener('change', function () {
                maxInput.style.display = this.checked ? '' : 'none';
                if (!this.checked) {
                    maxInput.value = "";
                }
            });
            // Add validation for min/max relationship
            maxInput.addEventListener('blur', function () {
                validateMinMaxRelationship(counter);
            });
        }
    }

// Remove attribute
    function removeAttribute(attributeId) {
        const attributeElement = document.querySelector(`[data-attribute-id="${attributeId}"]`);
        if (attributeElement) {
            attributeElement.remove();
            // If no attributes remain, remove container
            const remainingAttributes = document.querySelectorAll('.attribute-item').length;
            if (remainingAttributes === 0) {
                const container = document.getElementById("attributes-container");
                if (container)
                    container.remove();
            } else {
                updateAttributeCount();
            }
        }
    }
    // Update attribute count
    function updateAttributeCount() {
        const container = document.getElementById('attributes-container');
        if (!container)
            return;
        const count = container.querySelectorAll('.attribute-item').length;
        const countElement = container.querySelector('#attribute-count');
        if (countElement) {
            countElement.textContent = `${count} attribute${count !== 1 ? 's' : ''}`;
        }
    }

////
    let lastCheckedName = "";
    let lastCheckedExists = false;
    let checkingNameInProgress = false;

// Validate category name (có check trùng)
    function validateCategoryName(asyncCheck = false) {
        const name = nameInput.value.trim();

        // Basic validate
        if (name === "") {
            nameError.textContent = "Category name is required";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }
        if (name.length < 2) {
            nameError.textContent = "Category name must be at least 2 characters";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }
        if (name.length > 100) {
            nameError.textContent = "Category name must be less than 100 characters";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        // Nếu asyncCheck thì check trùng qua API
        if (asyncCheck) {
            if (name === lastCheckedName) {
                // dùng lại kết quả cũ
                if (lastCheckedExists) {
                    nameError.textContent = "Category name already exists";
                    nameInput.classList.add("border", "border-red-500");
                    nameInput.classList.remove("ring-1", "ring-green-500");
                    return false;
                } else {
                    nameError.textContent = "";
                    nameInput.classList.remove("border-red-500");
                    nameInput.classList.add("ring-1", "ring-green-500");
                    return true;
                }
            }
            if (checkingNameInProgress) {
                nameError.textContent = "Checking...";
                return false;
            }
            // gọi API
            lastCheckedName = name;
            checkingNameInProgress = true;
            nameError.textContent = "Checking...";
            fetch(`/category/view?type=check-name&categoryName=${encodeURIComponent(name)}`)
                    .then(res => res.json())
                    .then(data => {
                        checkingNameInProgress = false;
                        lastCheckedExists = !!data.exists;
                        // Nếu người dùng đổi input thì thôi
                        if (nameInput.value.trim() !== name)
                            return;
                        if (data.exists) {
                            nameError.textContent = "Category name already exists";
                            nameInput.classList.add("border", "border-red-500");
                            nameInput.classList.remove("ring-1", "ring-green-500");
                        } else {
                            nameError.textContent = "";
                            nameInput.classList.remove("border-red-500");
                            nameInput.classList.add("ring-1", "ring-green-500");
                        }
                    })
                    .catch(() => {
                        checkingNameInProgress = false;
                        nameError.textContent = "";
                    });
            // Trong lúc chờ kết quả thì cho false
            return false;
        } else {
            // Khi submit, dùng lại kết quả đã check
            if (lastCheckedExists && name === lastCheckedName) {
                nameError.textContent = "Category name already exists";
                nameInput.classList.add("border", "border-red-500");
                nameInput.classList.remove("ring-1", "ring-green-500");
                return false;
            }
            if (checkingNameInProgress) {
                nameError.textContent = "Checking...";
                return false;
            }
            nameError.textContent = "";
            nameInput.classList.remove("border-red-500");
            nameInput.classList.add("ring-1", "ring-green-500");
            return true;
    }
    }

///// ======Valid create FUNCTIONS======///////
    // valid date
    function validateAttributeDateFields(counter) {
        let isValid = true;
        const today = new Date();
        const minAccept = new Date("2000-01-01");
        const minInput = document.querySelector(
                `input[name="attributeMin_${counter}"][type="date"]`
                );
        const maxInput = document.querySelector(
                `input[name="attributeMax_${counter}"][type="date"]`
                );
        // 1) delete & highlight   old    
        [minInput, maxInput].forEach(input => {
            if (!input)
                return;
            const parent = input.parentElement;
            parent.querySelectorAll('.date-error-msg').forEach(e => e.remove());
            input.classList.remove("border-red-500", "ring-1", "ring-green-500");
        });
        // 2) Validate  (Min / Max)
        [[minInput, "Min"], [maxInput, "Max"]].forEach(([input, label]) => {
            if (!input || !input.value)
                return;
            const d = new Date(input.value);
            let msg = "";
            if (isNaN(d.getTime())) {
                msg = `${label} date is invalid`;
            } else if (d < minAccept) {
                msg = `${label} date must be on or after 01/01/2000`;
            } else if (d > today) {
                msg = `${label} date must not be in the future`;
            }

            if (msg) {
                isValid = false;
                input.classList.add("border", "border-red-500");
                const err = document.createElement("div");
                err.className = "text-red-500 text-xs mt-1 date-error-msg";
                err.textContent = msg;
                input.parentElement.appendChild(err);
            } else {
                input.classList.add("ring-1", "ring-green-500");
        }
        });
        // 3) Check Min < Max 
        if (minInput && maxInput && minInput.value && maxInput.value) {
            const dMin = new Date(minInput.value);
            const dMax = new Date(maxInput.value);
            // delete
            [minInput, maxInput].forEach(input => {
                input.parentElement.querySelectorAll('.date-error-msg').forEach(e => e.remove());
                input.classList.remove("ring-green-500");
            });
            if (dMin.getTime() >= dMax.getTime()) {
                isValid = false;
                [minInput, maxInput].forEach(input => {
                    input.classList.add("border", "border-red-500");
                });
                //error Min
                const errMin = document.createElement("div");
                errMin.className = "text-red-500 text-xs mt-1 date-error-msg";
                errMin.textContent = "Min date must be earlier than Max date";
                minInput.parentElement.appendChild(errMin);
                // error Max
                const errMax = document.createElement("div");
                errMax.className = "text-red-500 text-xs mt-1 date-error-msg";
                errMax.textContent = "Max date must be later than Min date";
                maxInput.parentElement.appendChild(errMax);
            }
        }

        return isValid;
    }

///Valid Int and Float 
    function validateAttributeNumberFields() {
        let isValid = true;
        document.querySelectorAll('.attribute-item').forEach(item => {
            const dataTypeSelect = item.querySelector('select[name^="attributeDatatype"]');
            if (!dataTypeSelect)
                return;
            const type = dataTypeSelect.value;
            if (type !== 'int' && type !== 'float')
                return;
            const minInput = item.querySelector('input[name^="attributeMin"]');
            const maxInput = item.querySelector('input[name^="attributeMax"]');
            [minInput, maxInput].forEach(input => {
                if (!input)
                    return;
                const inputParent = input.parentElement;
                // delete error
                const oldError = inputParent.querySelector('.number-error-msg');
                if (oldError)
                    oldError.remove();
                input.classList.remove("border-red-500", "ring-1", "ring-green-500");
                const val = input.value.trim();
                if (val !== "") {
                    const number = Number(val);
                    if (isNaN(number)) {
                        isValid = false;
                        input.classList.add("border", "border-red-500");
                        const err = document.createElement("div");
                        err.className = "text-red-500 text-xs mt-1 number-error-msg";
                        err.textContent = "Value must be a valid number.";
                        inputParent.appendChild(err);
                    } else if (number < 0) {
                        // Check negative
                        isValid = false;
                        input.classList.add("border", "border-red-500");
                        const err = document.createElement("div");
                        err.className = "text-red-500 text-xs mt-1 number-error-msg";
                        err.textContent = "Value cannot be negative.";
                        inputParent.appendChild(err);
                    } else if (type === "int" && !Number.isInteger(number)) {
                        // Check Positive
                        isValid = false;
                        input.classList.add("border", "border-red-500");
                        const err = document.createElement("div");
                        err.className = "text-red-500 text-xs mt-1 number-error-msg";
                        err.textContent = "Only integer numbers allowed.";
                        inputParent.appendChild(err);
                    } else {
                        input.classList.add("ring-1", "ring-green-500");
                    }
                }
            });
            // check min <= max
            if (minInput && maxInput && minInput.value.trim() !== "" && maxInput.value.trim() !== "") {
                const minVal = Number(minInput.value);
                const maxVal = Number(maxInput.value);
                if (minVal >= maxVal) {
                    isValid = false;
                    [minInput, maxInput].forEach(input => {
                        input.classList.remove("ring-green-500");
                        input.classList.add("border", "border-red-500");
                    });
                    const err = document.createElement("div");
                    err.className = "text-red-500 text-xs mt-1 number-error-msg";
                    err.textContent = "Min value must not exceed Max value.";
                    maxInput.parentElement.appendChild(err);
                }
            }
        });
        return isValid;
    }
//////


    // Validate category image
    function validateCategoryImage() {
        if (!imageInput.files || !imageInput.files[0]) {
            imageError.textContent = "Category image is required";
            imageInput.classList.add("border", "border-red-500");
            imageInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        const file = imageInput.files[0];
        // Validate file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
            imageError.textContent = "File size must be less than 5MB";
            imageInput.classList.add("border", "border-red-500");
            imageInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        // Validate file type
        const allowedTypes = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'];
        if (!allowedTypes.includes(file.type)) {
            imageError.textContent = "Only PNG, JPG, JPEG, GIF files are allowed";
            imageInput.classList.add("border", "border-red-500");
            imageInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }
        imageError.textContent = "";
        imageInput.classList.remove("border-red-500");
        imageInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate individual attribute name
    function validateAttributeName(counter) {
        const nameInput = document.querySelector(`input[name="attributeName_${counter}"]`);
        const nameError = document.getElementById(`attributeNameError_${counter}`);
        if (!nameInput || !nameError)
            return true;
        const name = nameInput.value.trim();
        if (name === "") {
            nameError.textContent = "Attribute name is required";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        if (name.length < 2) {
            nameError.textContent = "Attribute name must be at least 2 characters";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        if (name.length > 50) {
            nameError.textContent = "Attribute name must be less than 50 characters";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        // Check duplicate attribute names
        const allAttributeNames = Array.from(document.querySelectorAll('input[name^="attributeName_"]'))
                .map(input => input.value.trim().toLowerCase())
                .filter(name => name !== "");
        const duplicateCount = allAttributeNames.filter(attrName => attrName === name.toLowerCase()).length;
        if (duplicateCount > 1) {
            nameError.textContent = "Attribute name already exists";
            nameInput.classList.add("border", "border-red-500");
            nameInput.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        nameError.textContent = "";
        nameInput.classList.remove("border-red-500");
        nameInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate individual attribute datatype
    function validateAttributeDatatype(counter) {
        const datatypeSelect = document.querySelector(`select[name="attributeDatatype_${counter}"]`);
        const datatypeError = document.getElementById(`attributeDatatypeError_${counter}`);
        if (!datatypeSelect || !datatypeError)
            return true;
        if (datatypeSelect.value === "") {
            datatypeError.textContent = "Data type is required";
            datatypeSelect.classList.add("border", "border-red-500");
            datatypeSelect.classList.remove("ring-1", "ring-green-500");
            return false;
        }

        datatypeError.textContent = "";
        datatypeSelect.classList.remove("border-red-500");
        datatypeSelect.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate min/max relationship
    function validateMinMaxRelationship(counter) {
        const minInput = document.querySelector(`input[name="attributeMin_${counter}"]`);
        const maxInput = document.querySelector(`input[name="attributeMax_${counter}"]`);
        const dtSelect = document.querySelector(`select[name="attributeDatatype_${counter}"]`);
        if (!minInput || !maxInput || !dtSelect)
            return true;
        // show error
        function applyError(el, msg, isDate = false) {
            const cls = isDate ? 'date-error-msg' : 'number-error-msg';
            el.classList.add('border-red-500', 'ring-1', 'ring-red-500');
            el.insertAdjacentHTML('afterend',
                    `<div class="text-red-500 text-xs mt-1 ${cls}">${msg}</div>`
                    );
        }

        // 1) delete old &  highlight
        [minInput, maxInput].forEach(inp => {
            inp.parentElement.querySelectorAll('.date-error-msg, .number-error-msg')
                    .forEach(e => e.remove());
            inp.classList.remove('border-red-500', 'ring-1', 'ring-red-500', 'ring-green-500');
        });
        const rawMin = minInput.value.trim();
        const rawMax = maxInput.value.trim();
        const datatype = dtSelect.value.trim().toLowerCase();
        // === DATE ===
        if (datatype === 'date') {
            const today = new Date();
            const dMin = rawMin ? new Date(rawMin) : null;
            const dMax = rawMax ? new Date(rawMax) : null;
            // error future
            if (dMin && dMin > today) {
                applyError(minInput, 'Min date must not be in the future', true);
                return false;
            }
            if (dMax && dMax > today) {
                applyError(maxInput, 'Max date must not be in the future', true);
                return false;
            }

            // error min ≥ max
            if (dMin && dMax && dMin.getTime() >= dMax.getTime()) {
                applyError(minInput, 'Min date must be earlier than Max date', true);
                applyError(maxInput, 'Max date must be later than Min date', true);
                return false;
            }


            [minInput, maxInput].forEach(inp => inp.value && inp.classList.add('ring-1', 'ring-green-500'));
            return true;
        }

        // === NUMBER ===
        if (datatype === 'int' || datatype === 'float') {
            const nMin = rawMin !== '' ? Number(rawMin) : null;
            const nMax = rawMax !== '' ? Number(rawMax) : null;
            if (nMin !== null && isNaN(nMin)) {
                applyError(minInput, 'Value must be a valid number.');
                return false;
            }
            if (nMax !== null && isNaN(nMax)) {
                applyError(maxInput, 'Value must be a valid number.');
                return false;
            }
            if (nMin !== null && nMin < 0) {
                applyError(minInput, 'Min value cannot be negative.');
                return false;
            }
            if (nMax !== null && nMax < 0) {
                applyError(maxInput, 'Max value cannot be negative.');
                return false;
            }
            if (datatype === 'int') {
                if (nMin !== null && !Number.isInteger(nMin)) {
                    applyError(minInput, 'Only integer numbers allowed.');
                    return false;
                }
                if (nMax !== null && !Number.isInteger(nMax)) {
                    applyError(maxInput, 'Only integer numbers allowed.');
                    return false;
                }
            }
            if (nMin !== null && nMax !== null && nMin >= nMax) {
                applyError(minInput, 'Min value must be less than Max value.');
                applyError(maxInput, 'Max value must be greater than Min value.');
                return false;
            }

            [minInput, maxInput].forEach(inp => inp.value && inp.classList.add('ring-1', 'ring-green-500'));
            return true;
        }

        return true;
    }

    ////Valid AttributeUnit
    function validateAttributeUnit(counter) {
        const unitInput = document.querySelector(`input[name="attributeUnit_${counter}"]`);
        if (!unitInput)
            return true;
        // Reset styles
        unitInput.classList.remove("border-red-500");
        unitInput.classList.remove("ring-1", "ring-green-500");
        // Get value
        const value = unitInput.value.trim();
        // Find or create error element
        let unitError = unitInput.parentElement.querySelector('.attribute-unit-error');
        if (!unitError) {
            unitError = document.createElement("p");
            unitError.className = "attribute-unit-error text-red-500 text-xs mt-1";
            unitInput.parentElement.appendChild(unitError);
        }
        unitError.textContent = "";
        // Optional: If empty, just return true (no style)
        if (value != "") {
            // Validate: only letters, numbers, %, /, °, ., -, no space, max 10 chars
            const validPattern = /^[A-Za-z0-9%\/°\.\-]+$/;
            if (!validPattern.test(value)) {
                unitInput.classList.add("border", "border-red-500");
                unitError.textContent = "Unit only allows letters, numbers, %, /, °, ., - (no spaces).";
                return false;
            }
            if (value.length > 10) {
                unitInput.classList.add("border", "border-red-500");
                unitError.textContent = "Unit must be at most 10 characters.";
                return false;
            }
        }
        // If valid, green border
        unitInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate Text Value input for attribute
    function validateAttributeTextValue(counter) {
        // Get the input element
        const textValueInput = document.querySelector(`input[name="attributeTextValue_${counter}"]`);
        if (!textValueInput)
            return true;
        // Reset border and highlight styles
        textValueInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
        // Get and trim the value
        const value = textValueInput.value.trim();
        // Find or create the error element
        let textValueError = textValueInput.parentElement.querySelector('.attribute-textvalue-error');
        if (!textValueError) {
            textValueError = document.createElement("p");
            textValueError.className = "attribute-textvalue-error text-red-500 text-xs mt-1";
            textValueInput.parentElement.appendChild(textValueError);
        }
        textValueError.textContent = "";
        // If the field is empty, show error
        if (value === "") {
            textValueInput.classList.add("border", "border-red-500");
            textValueError.textContent = "Text value cannot be empty.";
            return false;
        }

        // If valid, add green highlight
        textValueInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate all attributes
    function validateAttributes() {
        let isValid = true;
        const attributeItems = document.querySelectorAll('.attribute-item');
        attributeItems.forEach((item) => {
            const attributeId = item.getAttribute('data-attribute-id');
            if (!attributeId)
                return;
            const counter = attributeId.split('-')[1];
            // Validate attribute name
            if (!validateAttributeName(counter)) {
                isValid = false;
            }

            //Check Number  Min Max
            if (!validateAttributeNumberFields(counter)) {
                isValid = false;
            }

            // Validate datatype
            if (!validateAttributeDatatype(counter)) {
                isValid = false;
            }

            // Validate min/max relationship
            if (!validateMinMaxRelationship(counter)) {
                isValid = false;
            }
            // Validate unit
            if (!validateAttributeUnit(counter)) {
                isValid = false;
            }
            if (!validateAttributeTextValue(counter)) {
                isValid = false;
            }
        });
        return isValid;
    }

    // Validate entire form
    function validateForm() {
        let isValid = true;
        // Validate category name
        if (!validateCategoryName(false)) {
            isValid = false;
        }


        // Validate category image
        if (!validateCategoryImage()) {
            isValid = false;
        }

        // Validate attributes
        if (!validateAttributes()) {
            isValid = false;
        }

        return isValid;
    }

    //Fixed collectAttributesData function
    function collectAttributesData() {
        const attributesData = [];
        const attributeItems = document.querySelectorAll('.attribute-item');
        console.log(attributeItems);
        attributeItems.forEach((item) => {
            const attributeId = item.getAttribute('data-attribute-id');
            if (!attributeId)
                return;
            const counter = attributeId.split('-')[1];
            const nameInput = document.querySelector(`input[name="attributeName_${counter}"]`);
            const requiredInput = document.querySelector(`input[name="attributeRequired_${counter}"]`);
            const datatypeSelect = document.querySelector(`select[name="attributeDatatype_${counter}"]`);
            const unitInput = document.querySelector(`input[name="attributeUnit_${counter}"]`);
            const minInput = document.querySelector(`input[name="attributeMin_${counter}"]`);
            const maxInput = document.querySelector(`input[name="attributeMax_${counter}"]`);
            const textValueInput = document.querySelector(`input[name="attributeTextValue_${counter}"]`);
            if (!nameInput || !datatypeSelect)
                return;
            const attributeData = {
                name: nameInput.value.trim(),
                required: requiredInput ? requiredInput.checked : false,
                datatype: datatypeSelect.value,
                unit: unitInput ? unitInput.value.trim() : null,
                minValue: null,
                maxValue: null,
                textValue: null
            };
            // Handle different data types
            if (datatypeSelect.value === 'text') {
                // For text type, use textValue instead of min/max
                if (textValueInput && textValueInput.value.trim()) {
                    attributeData.textValue = textValueInput.value.trim();
                }
            } else {
                // For numeric and date types, use min/max values
                if (minInput && minInput.value.trim()) {
                    attributeData.minValue = minInput.value.trim();
                }
                if (maxInput && maxInput.value.trim()) {
                    attributeData.maxValue = maxInput.value.trim();
                }
            }

            attributesData.push(attributeData);
        });
        return attributesData;
    }

    // Show error message
    function showError(message) {
        errorDiv.classList.remove("hidden");
        errorText.textContent = message;
        statusDiv.classList.add("hidden");
    }

    // Show success message
    function showSuccess(message) {
        statusDiv.classList.remove("hidden");
        statusText.textContent = message;
        errorDiv.classList.add("hidden");
    }

    nameInput.addEventListener("blur", function () {
        validateCategoryName(true);
    });
    nameInput.addEventListener("input", function () {
        validateCategoryName(true);
    });


//////////////
    ///// Submit form///////    
    btnCreate.onclick = function (e) {
        e.preventDefault();
        // Clear previous status messages
        errorDiv.classList.add("hidden");
        statusDiv.classList.add("hidden");
        if (!validateForm()) {
            return;
        }

        const formData = new FormData();
        formData.append("categoryName", nameInput.value.trim());
        formData.append("categoryImage", imageInput.files[0]);
        // Add attributes data
        const attributesData = collectAttributesData();
        if (attributesData.length > 0) {
            formData.append("attributes", JSON.stringify(attributesData));
        }

        showLoading();
        fetch('/category/view?type=create', {
            method: 'POST',
            body: formData
        })
                .then(response => response.json())
                .then(data => {
                    hiddenLoading();
                    if (data.isSuccess) {

                        setTimeout(() => {
                            hiddenLoading();
                            closeModal();
                            if (typeof loadCategoryContentAndEvent === 'function') {
                                loadCategoryContentAndEvent(1);
                            }
                        });
                    } else {
                        showError(data.message || "Failed to create category");
                    }
                })
                .catch(() => {

                    showError("Something went wrong, please try again!");
                });
    }
}

////////////////////////////////////////////////////////////
document.getElementById("modal").onclick = () => {
    document.getElementById("modal").classList.remove("flex");
    document.body.classList.remove("overflow-hidden");
    document.getElementById("modal").classList.add("hidden");
};
document.getElementById("modalContent").addEventListener("click", function (event) {
    event.stopPropagation();
});
function showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `fixed top-4 right-4 px-4 py-2 rounded shadow-lg text-white z-50 transition-all duration-300 ${
            type === "success" ? "bg-[#2196F3]" : "bg-[#f44336]"
            }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

function getPageFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get('page')) || 1;
}


// Update total category when deleted success or created new ctegory 
function updateCategoryCount() {
    fetch("/category/view?type=total")
            .then(response => response.json())
            .then(data => {
                const countElement = document.querySelector(".category-count");
                if (countElement) {
                    countElement.textContent = `Total Category: ${data.total}`;
                }
            })
            .catch(error => {
                console.error("Error fetching category count:", error);
            });
}


