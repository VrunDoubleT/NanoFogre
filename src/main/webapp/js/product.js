const MAX_FILES = 10
let handleCategoryChange = null
let handleCategoryCreateProductChange = null
let handleCategoryProductChangeEvent = null
let handleBrandChangeEvent = null
let selectedImages = []
let productAttributes = null
let pageReviewList = 1;
let isLoadingReviewList = false;
let isLastPageReview = false;
let isLoadScroll = false
let starActive = 0

// UPDATE URL WHEN CLICK PAGE
function updatePageUrl(page) {
    const url = new URL(window.location)
    url.searchParams.delete('page')
    url.searchParams.set('page', page)
    history.pushState(null, '', url.toString())
}

const updateModalContent = (path, loadEvent, skeletonLoading) => {
    document.getElementById('modalContent').innerHTML = skeletonLoading
    fetch(path)
        .then((res) => res.text())
        .then((html) => {
            document.getElementById('modalContent').innerHTML = html
        })
        .then(() => {
            // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
            loadEvent()
        })
}

/**
 * @param {int} categoryId
 * @param {int} page
 * */
const loadProductContentAndEvent = (categoryId, page) => {
    //
    lucide.createIcons()
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = ''
    document.getElementById('loadingProduct').innerHTML = `
  <div class="flex w-full justify-center items-center h-32">
    <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
  </div>
`
    // PUSH PARAMS URL TO CALL SERVERLET
    let paramUrl = ''
    if (categoryId > 0) {
        paramUrl = '&categoryId=' + categoryId
    }
    // Fetch servlet to get list product html and add event for list
    Promise.all([
        fetch('/product/view?type=list&page=' + page + paramUrl).then((res) =>
            res.text()
        ),
        fetch('/product/view?type=pagination&page=' + page + paramUrl).then(
            (res) => res.text()
        ),
    ]).then(([productHTML, paginationHTML]) => {
        // UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = productHTML
        document.getElementById('pagination').innerHTML = paginationHTML
        document.getElementById('loadingProduct').innerHTML = ''
        // ADD EVENT FOR VIEW DETAIL PRODUCT
        document.querySelectorAll('.openViewModal').forEach((element) => {
            element.addEventListener('click', (e) => {
                const modal = document.getElementById('modal')
                const clickedElement = e.target
                const buttonItem = clickedElement.closest('[data-product-id]')
                const productId = buttonItem.getAttribute('data-product-id')
                // OPEN AND LOAD CONTEND FOR MODAL
                openModal(modal)
                document.getElementById('modalContent').innerHTML =
                    productDetailSkeletonLoading
                fetch(`/product/view?productId=${productId}`)
                    .then((res) => res.text())
                    .then((html) => {
                        document.getElementById('modalContent').innerHTML = html
                    })
                    .then(() => {
                        // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
                        loadProductDetailEvent()
                    })
            })
        })

        // ADD EVENT FOR EDIT PRODUCT
        document.querySelectorAll('.openEditProdctModal').forEach((element) => {
            element.addEventListener('click', (e) => {
                const modal = document.getElementById('modal')
                const clickedElement = e.target
                const buttonItem = clickedElement.closest('[data-product-id]')
                const productId = buttonItem.getAttribute('data-product-id')
                // OPEN AND LOAD CONTEND FOR MODAL
                openModal(modal)
                document.getElementById('modalContent').innerHTML =
                    createAndUpdateProductSkeletonLoading
                fetch(`/product/view?type=edit&productId=${productId}`)
                    .then((res) => res.text())
                    .then((html) => {
                        document.getElementById('modalContent').innerHTML = html
                    })
                    .then(() => {
                        // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
                        loadUpdateProductEvent(categoryId, page)
                    })
            })
        })

        function confirmDelete(productId) {
            Swal.fire({
                title: 'Are you sure you want to delete this product?',
                text: 'This action is irreversible',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it',
                cancelButtonText: 'Cancel',
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/product/view?type=delete&productId=${productId}`, {
                        method: 'POST',
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            Toastify({
                                text: data.message,
                                duration: 5000,
                                gravity: 'top',
                                position: 'right',
                                style: {
                                    background: data.isSuccess
                                        ? '#2196F3'
                                        : '#f44336',
                                },
                                close: true,
                            }).showToast()
                            updateProductStat()
                            loadProductContentAndEvent(categoryId, page)
                        })
                }
            })
        }

        // ADD EVENT FOR DISABLE PRODUCT
        document.querySelectorAll('.openDeleteProdct').forEach((element) => {
            element.addEventListener('click', (e) => {
                const modal = document.getElementById('modal')
                const clickedElement = e.target
                const buttonItem = clickedElement.closest('[data-product-id]')
                const productId = buttonItem.getAttribute('data-product-id')
                confirmDelete(productId)
            })
        })

        // ADD EVENT FOR PAGINATION
        document.querySelectorAll('div.pagination').forEach((element) => {
            element.addEventListener('click', function () {
                const pageClick = this.getAttribute('page')
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick)
                    loadProductContentAndEvent(
                        categoryId,
                        parseOptionNumber(pageClick, 1)
                    )
                }
            })
        })

        // GET CATEGORY SELECT
        const selectElement = document.getElementById('categorySelect')
        // HANDLE UPDATE URL WHEN CATEGORY CHANGE
        function updateCategoryURL(categoryId, page) {
            const url = new URL(window.location)
            if (categoryId <= 0) {
                url.searchParams.delete('categoryId')
            } else {
                url.searchParams.set('categoryId', categoryId)
            }
            if (page <= 1) {
                url.searchParams.delete('page')
            } else {
                url.searchParams.set('page', page) // Fixed: was setting categoryId instead of page
            }
            history.pushState(null, '', url.toString())
        }

        // DEFINE OR REPLACE EVENT HANDLER
        if (handleCategoryChange !== null) {
            selectElement.removeEventListener('change', handleCategoryChange)
        }

        // DEFINE HANDLER FUNCTION
        handleCategoryChange = function () {
            const selectedOption = this.options[this.selectedIndex]
            const categoryIdSelectString =
                selectedOption.getAttribute('data-category-id')
            const categoryIdSelect = parseOptionNumber(
                categoryIdSelectString,
                0
            )
            if (categoryId !== categoryIdSelect) {
                updateCategoryURL(categoryIdSelect, page)
                loadProductContentAndEvent(categoryIdSelect, 1)
            }
        }
        // ADD EVENT LISTENER
        selectElement.addEventListener('change', handleCategoryChange)
        // SHOW SELECTED CATEGORY
        const options = selectElement.options
        for (let i = 0; i < options.length; i++) {
            if (options[i].dataset.categoryId == categoryId) {
                selectElement.selectedIndex = i
                break
            }
        }
    })

    // Handle click new product button
    document.getElementById('create-product-button').onclick = () => {
        const modal = document.getElementById('modal')
        openModal(modal)
        updateModalContent(
            `/product/view?type=create`,
            () => {
                loadCreateProductEvent(categoryId, page)
            },
            createAndUpdateProductSkeletonLoading
        )
    }
}

// HANDLE CHANGE IMAGE IN PRODUCT DETAIL
function changeMainImage(imageUrl) {
    document.getElementById('main-image').src = imageUrl
}

// HANDLE LOAD EVENT FOR PRODUCT DETAIL
function loadProductDetailEvent() {
    const detailTab = document.getElementById('details-tab')
    if (detailTab) {
        detailTab.addEventListener('click', function () {
            showTab('details')
        })
    }
    const reviewTab = document.getElementById('preview-tab')
    if (reviewTab) {
        reviewTab.addEventListener('click', function () {
            showTab('preview')
        })
    }
}

// Function support for create or update product
function required(value, message = 'This field is required') {
    if (!value || value.trim() === '') {
        return message
    }
    return null
}

function parsePositiveDouble(
    value,
    message = 'Please enter a valid positive number'
) {
    const normalized = value.replace(',', '.')
    const number = parseFloat(normalized)
    if (isNaN(number) || number <= 0) {
        return message
    }
    return null
}

function parsePositiveInteger(
    value,
    message = 'Please enter a valid positive integer'
) {
    const number = Number(value)
    if (!Number.isInteger(number) || number <= 0) {
        return message
    }
    return null
}

function validateRatio(
    value,
    message = "Please enter a valid ratio like '1:64' where the first number is smaller"
) {
    if (!value || value.trim() === '') {
        return message
    }
    const parts = value.split(':')
    if (parts.length !== 2) {
        return message
    }
    const [left, right] = parts.map((part) => Number(part.trim()))
    if (
        !Number.isInteger(left) ||
        !Number.isInteger(right) ||
        left <= 0 ||
        right <= 0
    ) {
        return message
    }
    if (left >= right) {
        return message
    }
    return null
}

function validateInteger(value, message = 'Value must be an integer') {
    if (value === null || value === undefined || value === '') {
        return message
    }
    const number = Number(value)
    if (isNaN(number) || !Number.isInteger(number)) {
        return message
    }
    return null
}

function validateMin(
    min,
    message = `Value must be greater than or equal to ${min}`
) {
    return function (value) {
        if (value === null || value === undefined || value === '') {
            return message
        }
        const number = Number(value)
        if (isNaN(number) || number < min) {
            return message
        }
        return null
    }
}

const configValidate = [
    {
        id: 'title',
        validate: [required],
    },
    {
        id: 'description',
        validate: [required],
    },
    {
        id: 'material',
        validate: [required],
    },
    {
        id: 'price',
        validate: [required, parsePositiveDouble, validateMin(1000)],
    },
    {
        id: 'quantity',
        validate: [required, validateMin(0), validateInteger],
    },
]

// Handle config validate for input
const checkValidate = (config) => {
    const inputElement = document.getElementById(config.id)
    const value = inputElement?.value
    let errorMessage = null
    for (let i = 0; i < config.validate.length; i++) {
        const error = config.validate[i](value)
        if (error !== null) {
            errorMessage = error
            break
        }
    }
    if (errorMessage !== null) {
        const errorElement = inputElement.parentElement.querySelector('span')
        if (errorElement) {
            errorElement.textContent = errorMessage
            errorElement.classList.remove('text-red-500', 'text-sm')
            errorElement.classList.add('text-red-500', 'text-sm')
            inputElement.classList.remove(
                'border-gray-300',
                'border-red-500',
                'border-green-500'
            )
            inputElement.classList.add('border-red-500')
        } else {
            errorElement.textContent = ''
        }
        return true
    } else {
        inputElement.classList.remove(
            'border-gray-300',
            'border-red-500',
            'border-green-500'
        )
        inputElement.classList.add('border-green-500')
    }
    return false
}

const handleValidateAndGetBasicProductData = (configValidate) => {
    let isError = false
    const data = []
    configValidate.forEach((config) => {
        const isErrorValidate = checkValidate(config)
        if (isErrorValidate) {
            isError = true
        }
        const obj = {
            id: config.id,
            value: document.getElementById(config.id)?.value?.trim(),
        }
        data.push(obj)
    })
    return {
        isError,
        data,
    }
}

const handleValidateCategoryAndBrand = (categoryObj, brandObj) => {
    const convertArr = [categoryObj, brandObj]
    let isError = false
    const dataObj = {}
    convertArr.forEach((elm) => {
        if (elm !== null) {
            const selectElm = document.getElementById(elm.id)
            const selectOption = selectElm.options[selectElm.selectedIndex]
            const selectId = parseOptionNumber(
                selectOption.getAttribute(elm.optionId),
                0
            )
            if (selectId <= 0) {
                isError = true
                selectElm.classList.remove(
                    'border-gray-300',
                    'border-red-500',
                    'border-green-500'
                )
                selectElm.classList.add('border-red-500')
            } else {
                selectElm.classList.remove(
                    'border-gray-300',
                    'border-red-500',
                    'border-green-500'
                )
                selectElm.classList.add('border-green-500')
            }
            dataObj[elm.name] = selectId
        }
    })
    return {
        isError,
        data: dataObj,
    }
}

const handleFocusAndBlur = (configValidates) => {
    configValidates.forEach((config) => {
        const inputElement = document.getElementById(config.id)
        if (inputElement) {
            inputElement.onfocus = () => {
                const errorElement =
                    inputElement.parentElement.querySelector('span')
                errorElement.textContent = ''
                inputElement.classList.remove(
                    'border-gray-300',
                    'border-red-500',
                    'border-green-500'
                )
                inputElement.classList.add('border-green-500')
            }
            inputElement.onblur = () => {
                checkValidate(config)
            }
        }
    })
}

const handleUploadImage = (state, imageConfig) => {
    const imageInput = document.getElementById(imageConfig.inputImageId)
    const previewGrid = document.getElementById(imageConfig.imageReviewId)
    const uploadStatus = document.getElementById(imageConfig.uploadStatusId)
    const uploadError = document.getElementById(imageConfig.uploadErrorId)
    const statusText = document.getElementById(imageConfig.statusTextId)
    const errorText = document.getElementById(imageConfig.errorTextId)

    imageInput.onchange = function (event) {
        const files = Array.from(event.target.files)
        const newImages = []

        for (const file of files) {
            const isDuplicate = state.selectedImages.some(
                (img) => img.name === file.name && img.size === file.size
            )
            if (!isDuplicate) {
                newImages.push(file)
            }
        }

        state.selectedImages.push(...newImages)

        if (state.selectedImages.length > MAX_FILES) {
            state.selectedImages.splice(MAX_FILES)
            showStatus(
                'A maximum of 10 images is allowed. Some images have been ignored'
            )
        } else {
            showStatus(`${state.selectedImages.length} images selected`)
        }

        updatePreview()
    }

    function updatePreview() {
        previewGrid.innerHTML = ''
        state.selectedImages.forEach((file) => {
            const reader = new FileReader()
            reader.onload = function (e) {
                const wrapper = document.createElement('div')
                wrapper.className = 'relative group'

                const img = document.createElement('img')
                img.src = e.target.result
                img.alt = file.name
                img.className = 'w-full h-32 object-cover rounded-lg shadow'

                const deleteBtn = document.createElement('button')
                deleteBtn.innerHTML = '&times;'
                deleteBtn.className =
                    'absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 text-sm hidden group-hover:flex items-center justify-center'

                deleteBtn.onclick = (e) => {
                    e.preventDefault()
                    state.selectedImages = state.selectedImages.filter(
                        (f) => !(f.name === file.name && f.size === file.size)
                    )
                    wrapper.remove()

                    if (state.selectedImages.length) {
                        showStatus(
                            `${state.selectedImages.length} images selected`
                        )
                    } else {
                        uploadStatus.classList.add('hidden')
                    }

                    updatePreview()
                }

                wrapper.appendChild(img)
                wrapper.appendChild(deleteBtn)
                previewGrid.appendChild(wrapper)
            }
            reader.readAsDataURL(file)
        })
    }

    function showStatus(message) {
        uploadStatus.classList.remove('hidden')
        statusText.textContent = message
        hiddenError()
    }

    function showError(message) {
        uploadError.classList.remove('hidden')
        errorText.textContent = message
    }

    function hiddenError() {
        uploadError.classList.add('hidden')
    }
}

const getValueSelect = (selectId) => {
    const selectElement = document.getElementById(selectId)
    const selectedValue = selectElement.value
    return parseOptionNumber(selectedValue, 0)
}

const handleChangeCategory = (
    productId,
    configSelectCategoryObj,
    configAttributeObj
) => {
    // GET CATEGORY SELECT
    const selectCategoryElm = document.getElementById(
        configSelectCategoryObj.id
    )
    // DEFINE OR REPLACE EVENT HANDLER
    if (handleCategoryProductChangeEvent !== null) {
        selectCategoryElm.removeEventListener(
            'change',
            handleCategoryCreateProductChange
        )
    }
    // DEFINE HANDLER FUNCTION
    handleCategoryProductChangeEvent = function () {
        productAttributes = null
                console.log(productAttributes);
        const result = handleValidateCategoryAndBrand(
            {
                ...configSelectCategoryObj,
                name: 'categoryId',
            },
            null
        )
        if (!result.isError) {
            fetch(
                '/product/view?type=productAttribute&categoryId=' +
                    result.data.categoryId +
                    '&productId=' +
                    productId
            )
                .then((res) => res.text())
                .then((html) => {
                    document.getElementById(
                        configSelectCategoryObj.wrapperAttributeId
                    ).innerHTML = html
                })
                .then(() => {
                    handleFocusAndBlurAttribute(
                        configAttributeObj,
                        result.data.categoryId
                    )
                })
        } else {
            document.getElementById(
                configSelectCategoryObj.wrapperAttributeId
            ).innerHTML = ''
        }
    }
    // ADD EVENT LISTENER
    selectCategoryElm.addEventListener(
        'change',
        handleCategoryProductChangeEvent
    )
}

const handleChangeBrand = (configSelectBrandObj) => {
    // GET CATEGORY SELECT
    const selectBrandElm = document.getElementById(configSelectBrandObj.id)
    // DEFINE OR REPLACE EVENT HANDLER
    if (handleBrandChangeEvent !== null) {
        selectBrandElm.removeEventListener(
            'change',
            handleCategoryCreateProductChange
        )
    }
    // DEFINE HANDLER FUNCTION
    handleBrandChangeEvent = function () {
        handleValidateCategoryAndBrand(
            {
                ...configSelectBrandObj,
                name: 'brandId',
            },
            null
        )
    }
    // ADD EVENT LISTENER
    selectBrandElm.addEventListener('change', handleBrandChangeEvent)
}

const handleValidateAttributeItem = async (elm, categoryId) => {
    if (!elm) return
    if (productAttributes === null) {
        const response = await fetch(
            `/product/view?type=productAttributeData&categoryId=${categoryId}`,
            {
                method: 'GET',
            }
        )

        const data = await response.json()
        productAttributes = data.data
    }
        console.log(productAttributes);

    const attributeId = parseOptionNumber(elm.dataset.attributeId, 0)
    const atbObj = productAttributes.find((attr) => attr.id === attributeId)

    let isValidate = false
    let errorMessage = ''
    const value = elm.value.trim()

    if (atbObj.isRequired) {
        if (!value.length) {
            isValidate = true
            errorMessage = 'This field is required'
        }

        validateBorderInput(elm, value.length)

        if (
            (atbObj.dataType === 'int' || atbObj.dataType === 'float') &&
            !isValidate
        ) {
            let inputValue = value
            if (atbObj.dataType === 'float') {
                inputValue = inputValue.replace(',', '.')
            }

            let isNumber = false
            const num = Number(inputValue)

            if (atbObj.dataType === 'int') {
                isNumber = Number.isInteger(num)
            } else {
                isNumber = !isNaN(num)
            }

            if (!isNumber) {
                errorMessage =
                    atbObj.dataType === 'int'
                        ? 'This field must be an integer'
                        : 'This field must be a valid number'
                isValidate = true
                validateBorderInput(elm, false)
            }

            if (!isValidate && atbObj.minValue?.trim().length > 0) {
                const min = parseFloat(atbObj.minValue)
                const val = parseFloat(inputValue)
                if (val < min) {
                    errorMessage = `Please enter a number greater than or equal to ${atbObj.minValue}`
                    isValidate = true
                    validateBorderInput(elm, false)
                }
            }

            if (!isValidate && atbObj.maxValue?.trim().length > 0) {
                const max = parseFloat(atbObj.maxValue)
                const val = parseFloat(inputValue)
                if (val > max) {
                    errorMessage = `Please enter a number less than or equal to ${atbObj.maxValue}`
                    isValidate = true
                    validateBorderInput(elm, false)
                }
            }
        }

        if (atbObj.dataType === 'date' && !isValidate) {
            const inputDate = new Date(value)
            const isValidDate = !isNaN(inputDate.getTime())

            if (!isValidDate) {
                errorMessage =
                    'This field must be a valid date in the format YYYY-MM-DD'
                isValidate = true
                validateBorderInput(elm, false)
            }

            if (!isValidate && atbObj.minValue?.trim().length > 0) {
                const minDate = new Date(atbObj.minValue)
                if (inputDate < minDate) {
                    errorMessage = `Please enter a date on or after ${atbObj.minValue}`
                    isValidate = true
                    validateBorderInput(elm, false)
                }
            }

            if (!isValidate && atbObj.maxValue?.trim().length > 0) {
                const maxDate = new Date(atbObj.maxValue)
                if (inputDate > maxDate) {
                    errorMessage = `Please enter a date on or before ${atbObj.maxValue}`
                    isValidate = true
                    validateBorderInput(elm, false)
                }
            }
        }

        const errorElm = document.getElementById(
            `product-attibute-${atbObj.id}-error`
        )
        if (!isValidate) {
            validateBorderInput(elm, true)
            if (errorElm) errorElm.textContent = ''
        } else {
            isFinalError = true
            validateBorderInput(elm, false)
            if (errorElm) errorElm.textContent = errorMessage
        }
    } else {
        validateBorderInput(elm, value.length, false)
    }
    return {
        isError: isValidate,
        value,
        attributeId,
    }
}

const handleValidateAttribute = async (
    configValidateAttributeObj,
    categoryId
) => {
    const inputs = document
        .getElementById(configValidateAttributeObj.wrapperAttributeId)
        .querySelectorAll(
            `input.${configValidateAttributeObj.inputAttributeId}`
        )

    let isFinalError = false
    const data = []

    for (const elm of inputs) {
        const resultValidate = await handleValidateAttributeItem(
            elm,
            categoryId
        )
        if (resultValidate.isError) {
            isFinalError = true
        }
        data.push({
            id: resultValidate.attributeId,
            value: resultValidate.value,
        })
    }

    return {
        isError: isFinalError,
        data,
    }
}

const handleFocusAndBlurAttribute = (configAttributeObj, categoryId) => {
    const inputs = document
        .getElementById(configAttributeObj.wrapperAttributeId)
        .querySelectorAll(`input.${configAttributeObj.inputAttributeId}`)
    inputs.forEach((elm) => {
        elm.onfocus = null
        elm.onblur = null

        elm.onfocus = () => {
            const errorElement = elm.parentElement.querySelector('span')
            if (errorElement) {
                errorElement.textContent = ''
            }
            elm.classList.remove(
                'border-gray-300',
                'border-red-500',
                'border-green-500'
            )
            elm.classList.add('border-green-500')
        }

        elm.onblur = () => {
            handleValidateAttributeItem(elm, categoryId)
        }
    })
}

const loadCreateProductEvent = async (categoryIdURL, pageIdURL) => {
    lucide.createIcons()
    const configValidateBasicInfo = [
        {
            id: 'title',
            validate: [required],
        },
        {
            id: 'description',
            validate: [required],
        },
        {
            id: 'material',
            validate: [required],
        },
        {
            id: 'price',
            validate: [required, parsePositiveDouble, validateMin(1000)],
        },
        {
            id: 'quantity',
            validate: [required, validateMin(0), validateInteger],
        },
    ]
    const configValidateImageUpload = {
        inputImageId: 'image-files-create',
        imageReviewId: 'image-preview-grid-create',
        uploadStatusId: 'upload-status-create',
        uploadErrorId: 'upload-error-create',
        statusTextId: 'status-text-create',
        errorTextId: 'error-text-create',
    }
    const element = {
        selectCategoryId: 'create-product-category',
        categoryValueId: 'data-category-id',
        wrapperAttributeId: 'createAtrributeProduct',
        inputAttributeId: 'product-attribute',
        selectBrandId: 'create-product-brand',
        brandValueId: 'data-brand-id',
        checkboxActiveId: 'isActiveCreateProduct',
    }
    handleFocusAndBlur(configValidateBasicInfo)
    const stateImages = { selectedImages: [] }
    handleUploadImage(stateImages, configValidateImageUpload)
    handleChangeCategory(
        0,
        {
            id: element.selectCategoryId,
            optionId: element.categoryValueId,
            wrapperAttributeId: element.wrapperAttributeId,
        },
        {
            wrapperAttributeId: element.wrapperAttributeId,
            inputAttributeId: element.inputAttributeId,
        }
    )
    handleChangeBrand({
        id: element.selectBrandId,
        optionId: element.brandValueId,
    })
    handleFocusAndBlurAttribute(
        {
            wrapperAttributeId: element.wrapperAttributeId,
            inputAttributeId: element.inputAttributeId,
        },
        getValueSelect(element.selectCategoryId)
    )
    const createProductButton = document.getElementById('create-product-btn')
    if (createProductButton) {
        createProductButton.onclick = async () => {
            const resultValidateBasic = handleValidateAndGetBasicProductData(
                configValidateBasicInfo
            )
            const resultValidateSelect = handleValidateCategoryAndBrand(
                {
                    id: element.selectCategoryId,
                    name: 'categoryId',
                    optionId: element.categoryValueId,
                },
                {
                    id: element.selectBrandId,
                    name: 'brandId',
                    optionId: element.brandValueId,
                }
            )
            if (stateImages.selectedImages.length === 0) {
                document
                    .getElementById(configValidateImageUpload.uploadErrorId)
                    .classList.remove('hidden')
                document.getElementById(
                    configValidateImageUpload.errorTextId
                ).textContent = 'Must have at least one image selected'
            }
            const isValidImage =
                stateImages.selectedImages.length <= MAX_FILES &&
                stateImages.selectedImages.length > 0
            const resultValidateAttribute = await handleValidateAttribute(
                {
                    wrapperAttributeId: element.wrapperAttributeId,
                    inputAttributeId: element.inputAttributeId,
                },
                resultValidateSelect.data.categoryId
            )

            if (
                !resultValidateBasic.isError &&
                !resultValidateSelect.isError &&
                !resultValidateAttribute.isError &&
                isValidImage
            ) {
                const formData = new FormData()
                const isCheckedActive = document.getElementById(
                    element.checkboxActiveId
                ).checked
                resultValidateBasic.data.forEach((data) => {
                    formData.append(data.id, data.value)
                })
                formData.append('isActive', isCheckedActive)
                formData.append(
                    'categoryId',
                    resultValidateSelect.data.categoryId
                )
                formData.append('brandId', resultValidateSelect.data.brandId)
                formData.append(
                    'attributes',
                    JSON.stringify(resultValidateAttribute.data)
                )
                for (let i = 0; i < stateImages.selectedImages.length; i++) {
                    formData.append('imageFiles', stateImages.selectedImages[i])
                }

                showLoading()
                fetch('/product/view?type=create', {
                    method: 'POST',
                    body: formData,
                })
                    .then((response) => response.json())
                    .then((data) => {
                        console.log(data)
                        hiddenLoading()
                        closeModal()
                        Toastify({
                            text: data.message,
                            duration: 5000,
                            gravity: 'top',
                            position: 'right',
                            style: {
                                background: data.isSuccess
                                    ? '#2196F3'
                                    : '#f44336',
                            },
                            close: true,
                        }).showToast()
                        updateProductStat()
                        updatePageUrl(1)
                        loadProductContentAndEvent(categoryIdURL, 1)
                    })
            }
        }
    }
}

const loadUpdateProductEvent = async (categoryIdURL, pageIdURL) => {
    productAttributes = null
    lucide.createIcons()
    const configValidateBasicInfo = [
        {
            id: 'title',
            validate: [required],
        },
        {
            id: 'description',
            validate: [required],
        },
        {
            id: 'material',
            validate: [required],
        },
        {
            id: 'price',
            validate: [required, parsePositiveDouble, validateMin(1000)],
        },
        {
            id: 'quantity',
            validate: [required, validateMin(0), validateInteger],
        },
    ]
    const configValidateImageUpload = {
        inputImageId: 'image-files-update',
        imageReviewId: 'image-preview-grid-update',
        uploadStatusId: 'upload-status-update',
        uploadErrorId: 'upload-error-update',
        statusTextId: 'status-text-update',
        errorTextId: 'error-text-update',
    }
    const element = {
        selectCategoryId: 'edit-product-category',
        categoryValueId: 'data-category-id',
        wrapperAttributeId: 'attributeEditProduct',
        inputAttributeId: 'product-attribute',
        selectBrandId: 'edit-product-brand',
        brandValueId: 'data-brand-id',
        checkboxActiveId: 'isActiveEditProduct',
        productId: 'productId',
    }
    handleFocusAndBlur(configValidateBasicInfo)
    addEventForOldImages()
    const productId = parseOptionNumber(
        document.getElementById(element.productId).value,
        0
    )
    const stateImages = { selectedImages: [] }
    handleUploadImage(stateImages, configValidateImageUpload)
    handleChangeCategory(
        productId,
        {
            id: element.selectCategoryId,
            optionId: element.categoryValueId,
            wrapperAttributeId: element.wrapperAttributeId,
        },
        {
            wrapperAttributeId: element.wrapperAttributeId,
            inputAttributeId: element.inputAttributeId,
        }
    )
    handleChangeBrand({
        id: element.selectBrandId,
        optionId: element.brandValueId,
    })
    handleFocusAndBlurAttribute(
        {
            wrapperAttributeId: element.wrapperAttributeId,
            inputAttributeId: element.inputAttributeId,
        },
        getValueSelect(element.selectCategoryId)
    )

    const updateProductButton = document.getElementById('update-product-btn')
    if (updateProductButton) {
        updateProductButton.onclick = async () => {
            const resultValidateBasic = handleValidateAndGetBasicProductData(
                configValidateBasicInfo
            )
            const resultValidateSelect = handleValidateCategoryAndBrand(
                {
                    id: element.selectCategoryId,
                    name: 'categoryId',
                    optionId: element.categoryValueId,
                },
                {
                    id: element.selectBrandId,
                    name: 'brandId',
                    optionId: element.brandValueId,
                }
            )
            // Get imageId of selected images
            const selectedImageIds = []
            document
                .querySelectorAll(
                    "#already-preview-grid input[type='checkbox']:checked"
                )
                .forEach((checkbox) => {
                    const imageId = checkbox.getAttribute('data-image-id')
                    if (imageId) {
                        selectedImageIds.push(imageId)
                    }
                })
            // Handle for already image and selected images
            if (
                selectedImageIds.length === 0 &&
                stateImages.selectedImages.length === 0
            ) {
                document
                    .getElementById(configValidateImageUpload.uploadErrorId)
                    .classList.remove('hidden')
                document.getElementById(
                    configValidateImageUpload.errorTextId
                ).textContent = 'Must have at least one image selected'
            }
            if (
                selectedImageIds.length + stateImages.selectedImages.length >
                MAX_FILES
            ) {
                document
                    .getElementById(configValidateImageUpload.uploadErrorId)
                    .classList.remove('hidden')
                document.getElementById(
                    configValidateImageUpload.errorTextId
                ).textContent = 'A maximum of 10 images is allowed'
            }
            const isValidImage =
                selectedImageIds.length + stateImages.selectedImages.length <=
                    MAX_FILES &&
                selectedImageIds.length + stateImages.selectedImages.length > 0
            const resultValidateAttribute = await handleValidateAttribute(
                {
                    wrapperAttributeId: element.wrapperAttributeId,
                    inputAttributeId: element.inputAttributeId,
                },
                resultValidateSelect.data.categoryId
            )

            console.log(resultValidateBasic)
            console.log(resultValidateSelect)
            console.log(resultValidateAttribute)
            console.log(selectedImageIds)
            console.log(stateImages.selectedImages)

            if (
                !resultValidateBasic.isError &&
                !resultValidateSelect.isError &&
                !resultValidateAttribute.isError &&
                isValidImage
            ) {
                const formData = new FormData()
                const isCheckedActive = document.getElementById(
                    element.checkboxActiveId
                ).checked
                resultValidateBasic.data.forEach((data) => {
                    formData.append(data.id, data.value)
                })
                formData.append('isActive', isCheckedActive)
                formData.append(
                    'productId',
                    document.getElementById(element.productId).value
                )
                formData.append(
                    'categoryId',
                    resultValidateSelect.data.categoryId
                )
                formData.append('brandId', resultValidateSelect.data.brandId)
                formData.append(
                    'attributes',
                    JSON.stringify(resultValidateAttribute.data)
                )
                for (var i = 0; i < selectedImageIds.length; i++) {
                    formData.append('urlsId', selectedImageIds[i])
                }
                for (let i = 0; i < stateImages.selectedImages.length; i++) {
                    formData.append('imageFiles', stateImages.selectedImages[i])
                }

                showLoading()
                fetch('/product/view?type=update', {
                    method: 'POST',
                    body: formData,
                })
                    .then((response) => response.json())
                    .then((data) => {
                        console.log(data)
                        hiddenLoading()
                        closeModal()
                        Toastify({
                            text: data.message,
                            duration: 5000,
                            gravity: 'top',
                            position: 'right',
                            style: {
                                background: data.isSuccess
                                    ? '#2196F3'
                                    : '#f44336',
                            },
                            close: true,
                        }).showToast()
                        updateProductStat()
                        loadProductContentAndEvent(categoryIdURL, pageIdURL)
                    })
            }
        }
    }
}

const updateProductStat = () => {
    const totalProductELm = document.getElementById('totalProduct')
    const totalInventoryELm = document.getElementById('totalInventory')
    const inventoryValueELm = document.getElementById('inventoryValue')
    const outOfStockELm = document.getElementById('outOfStock')

    function formatCurrencyShort(amount) {
        if (amount >= 1000000000) {
            return (amount / 1000000000).toFixed(2) + 'B'
        } else if (amount >= 1000000) {
            return (amount / 1000000).toFixed(2) + 'M'
        } else if (amount >= 1000) {
            return (amount / 1000).toFixed(2) + 'K'
        } else {
            return Math.floor(amount).toString()
        }
    }

    fetch('/product/view?type=stat', {
        method: 'GET',
    })
        .then((response) => response.json())
        .then((data) => {
            console.log(data)
            totalProductELm.textContent = data.data.totalProducts + ''
            totalInventoryELm.textContent = data.data.inventory + ''
            inventoryValueELm.textContent = formatCurrencyShort(
                data.data.inventoryValue
            )
            outOfStockELm.textContent = data.data.outOfStockProducts + ''
        })
}

function toggleReplyForm(reviewId) {
                const replyForm = document.getElementById(
                    `replyForm${reviewId}`
                )
                const replyText = document.getElementById(
                    `replyText${reviewId}`
                )

                if (replyForm.classList.contains('hidden')) {
                    replyForm.classList.remove('hidden')
                    replyForm.classList.add('animate-slide-down')
                    replyText.focus()
                } else {
                    replyForm.classList.add('hidden')
                    replyText.value = ''
                }
            }

const toggleReviewLoading = (show) => {
    const loadingContainer = document.getElementById('reviewListLoading');

    if (show) {
        loadingContainer.innerHTML = `
            <div class="flex w-full justify-center items-center h-32">
                <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
            </div>
        `;
    } else {
        loadingContainer.innerHTML = '';
    }
};


const loadReviews = async (productId, star = 0, page = 1) => {
    toggleReviewLoading(true)
    const response = await fetch('/review?type=review&productId=' + productId + "&star=" + star + "&page=" + page);
    const HTML = await response.text();
    if (HTML === null || HTML.trim().length === 0) {
        isLastPageReview = true;
        toggleReviewLoading(false)
        const noMoreReviewHTML = `
    <div class="w-full mt-8 relative overflow-hidden rounded-xl bg-gradient-to-br from-blue-50 to-indigo-100 px-8 py-6 shadow-lg border border-blue-200/50 backdrop-blur-sm">
        <!-- Decorative elements -->
        <div class="absolute top-0 right-0 w-20 h-20 bg-gradient-to-br from-blue-200/30 to-transparent rounded-full -mr-10 -mt-10"></div>
        <div class="absolute bottom-0 left-0 w-16 h-16 bg-gradient-to-tr from-indigo-200/30 to-transparent rounded-full -ml-8 -mb-8"></div>
        
        <!-- Icon -->
        <div class="flex items-center justify-center mb-3">
            <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center shadow-md">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>
        </div>
        
        <!-- Content -->
        <div class="text-center relative z-10">
            <h3 class="text-lg font-semibold text-gray-800 mb-1">All Reviews Displayed</h3>
            <p class="text-sm text-gray-600 leading-relaxed">You've reached the end of all available reviews.</p>
        </div>
        
        <!-- Bottom accent line -->
        <div class="absolute bottom-0 left-1/2 transform -translate-x-1/2 w-16 h-1 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full"></div>
    </div>
`;


        document.getElementById("reviewList").insertAdjacentHTML('beforeend', noMoreReviewHTML);
        return;
    }
    document.getElementById("reviewList").insertAdjacentHTML('beforeend', HTML);
    toggleReviewLoading(false)
    lucide.createIcons();
}


function sendReply(reviewId) {
    const isValidData = handleBlurReplyText(reviewId)
    if(!isValidData){
        return
    }
    const replyText = document.getElementById(`replyText${reviewId}`).value.trim()
    const employeeId = 1
    fetch("/review?type=reply",{
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            reviewId: reviewId,
            replyText: replyText,
            employeeId: employeeId
        })
    })
    .then((response) => response.text())
    .then((HTML) => {
        document.getElementById(`wrapper-review-${reviewId}`).innerHTML = HTML
    })
            .then(()=>{
                lucide.createIcons()
                Toastify({
                            text: "Reply submitted successfully!",
                            duration: 5000,
                            gravity: 'top',
                            position: 'right',
                            style: {
                                background: true
                                    ? '#2196F3'
                                    : '#f44336',
                            },
                            close: true,
                        }).showToast()
            })        
}

const handleLoadActiveStarFilter = (star) => {
    // Loop through all star filter buttons
    document.querySelectorAll(".star-filter-btn").forEach(elm => {
        // For each button, check its classes
        elm.classList.forEach(cls => {
            // If the class is a hover:* class, remove the equivalent non-hover version
            if (cls.startsWith("hover:")) {
                const normalCls = cls.replace("hover:", "");
                elm.classList.remove(normalCls);
            }
        });

        // Remove any previously added highlight classes (optional custom highlight)
        elm.classList.remove("border-[#fbbf24]", "bg-[#fef3c7]", "text-[#f59e0b]");
    });

    // Get the clicked star button by ID
    const selectedBtn = document.getElementById("star-" + star);

    // Loop through its classes
    selectedBtn.classList.forEach(cls => {
        // If the class is a hover:* class, add its normal version to apply hover style permanently
        if (cls.startsWith("hover:")) {
            const normalCls = cls.replace("hover:", "");
            selectedBtn.classList.add(normalCls);
        }
    });

    // Optionally add some custom highlight classes to the selected button
    selectedBtn.classList.add("border-[#fbbf24]", "bg-[#fef3c7]", "text-[#f59e0b]");
};

const handleFocusReplyText = (reviewId) => {
//    const value = document.getElementById(`replyForm${reviewId}`).value.trim()
                console.log(reviewId);
    document.getElementById(`replyText${reviewId}`).classList.remove("border-green-500","border-red-500")
    document.getElementById(`replyText${reviewId}`).classList.add("border-green-500")
}

const handleBlurReplyText = (reviewId) => {
    document.getElementById(`replyText${reviewId}`).classList.remove("border-green-500", "border-red-500")
    const value = document.getElementById(`replyText${reviewId}`).value.trim()
    if(!value){
        document.getElementById(`replyText${reviewId}`).classList.add("border-red-500")
        return false;
    }else{
        document.getElementById(`replyText${reviewId}`).classList.add("border-green-500")
        return true;
    }
    
}

const handleClickStarFilter = async (star) => {
    if(star === starActive){
        return
    }
    handleLoadActiveStarFilter(star);
    starActive = star;
    
    const productId = parseOptionNumber(
        document.getElementById('productDetailId').value,
        0
    );
    pageReviewList = 1;
    isLastPageReview = false;
    isLoadingReviewList = true;
    const contentContainer = document.getElementById("reviewList");
    const currentHeight = contentContainer.offsetHeight;
    contentContainer.style.minHeight = currentHeight + "px";
    document.getElementById("reviewList").innerHTML = '';
    await loadReviews(productId, star, pageReviewList);
    isLoadingReviewList = false;
    contentContainer.style.minHeight = null;
}



const loadReviewEvent = () => {
    if (isLoadScroll) return;

    isLoadScroll = true;
    const container = document.getElementById('containerScroll');
    const productId = parseOptionNumber(
            document.getElementById('productDetailId').value,
            0
    )
    container.addEventListener('scroll', async () => {
        const nearBottom = container.scrollTop + container.clientHeight >= container.scrollHeight - 50;

        if (nearBottom && !isLoadingReviewList && !isLastPageReview) {
            isLoadingReviewList = true;
            pageReviewList++;
            try {
                await loadReviews(productId, starActive, pageReviewList);
            } catch (error) {
                console.error('Lỗi tải dữ liệu:', error);
            }
            isLoadingReviewList = false;
        }
    });
};



// HANDLE SHOW SELECT TAB
function showTab(tabName) {
    document.querySelectorAll('.tab-content').forEach((content) => {
        content.classList.add('hidden')
    })
    document.querySelectorAll('.tab-button').forEach((button) => {
        button.classList.remove(
            'active',
            'text-gray-500',
            'border-transparent',
            'hover:text-blue-600',
            'hover:border-blue-300',
            'transition-all',
            'duration-200'
        )
        button.classList.add(
            'text-gray-500',
            'border-transparent',
            'hover:text-blue-600',
            'hover:border-blue-300',
            'transition-all',
            'duration-200'
        )
    })
    document.getElementById(tabName + '-content').classList.remove('hidden')
    document.getElementById(tabName + '-tab').classList.add('active')
    const container = document.getElementById('containerScroll');
    container.scrollTop = 0;
    if (tabName === 'preview') {
        pageReviewList = 1;
        isLastPageReview = false;
        starActive = 0
        const productId = parseOptionNumber(
            document.getElementById('productDetailId').value,
            0
        )
        document.getElementById("reviewList").innerHTML = ''
        Promise.all([
            fetch('/product/view?type=reviewStats&productId=' + productId).then(
                (res) => res.text()
            ),
            loadReviews(productId)
        ]).then(([reviewStatsHTML, paginationHTML]) => {
            document.getElementById('reviewStats').innerHTML = reviewStatsHTML
        }).then(() => {
            lucide.createIcons()
            handleLoadActiveStarFilter(0)
            loadReviewEvent()
        })
    }
}

function validateBorderInput(elm, isSuccess, isRequired = true) {
    if (!elm) {
        return
    }
    elm.classList.remove(
        'border-gray-300',
        'border-yellow-400',
        'border-red-500',
        'border-green-600'
    )
    if (!isSuccess) {
        if (isRequired) {
            elm.classList.add('border-red-500')
        } else {
            elm.classList.add('border-yellow-400')
        }
    } else {
        elm.classList.add('border-green-600')
    }
}

const addEventForOldImages = () => {
    // Init all checkbox is ticked
    const checkboxes = document.querySelectorAll('[data-index]')
    checkboxes.forEach((checkbox) => {
        const index = checkbox.getAttribute('data-index')
        const icon = document.querySelector(`.checkbox-icon-${index}`)
        if (checkbox.checked) {
            icon.classList.add('opacity-100')
        }
    })
    // Add opacity for product
    function toggleImageOpacity(index, isChecked) {
        const image = document.querySelector(`.image-${index}`)
        const icon = document.querySelector(`.checkbox-icon-${index}`)
        if (isChecked) {
            image.classList.remove('opacity-30', 'grayscale')
            icon.classList.remove('opacity-0')
            icon.classList.add('opacity-100')
        } else {
            image.classList.add('opacity-30', 'grayscale')
            icon.classList.remove('opacity-100')
            icon.classList.add('opacity-0')
        }
    }

    // Handle checkbox change
    document
        .getElementById('already-preview-grid')
        .addEventListener('change', function (event) {
            if (
                event.target.type === 'checkbox' &&
                event.target.hasAttribute('data-index') &&
                event.target.id.startsWith('checkbox-')
            ) {
                const index = event.target.getAttribute('data-index')
                toggleImageOpacity(index, event.target.checked)
            }
        })
    // Handle click or no click with already image
    document
        .getElementById('already-preview-grid')
        .addEventListener('click', function (event) {
            const group = event.target.closest('.group')
            if (group) {
                const checkbox = group.querySelector('input[type="checkbox"]')
                if (checkbox && event.target !== checkbox) {
                    checkbox.checked = !checkbox.checked
                    const index = checkbox.getAttribute('data-index')
                    toggleImageOpacity(index, checkbox.checked)
                }
            }
        })
}
