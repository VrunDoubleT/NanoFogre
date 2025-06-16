
const showLoading = () => {
    console.log("show");
    const loadingElm = document.getElementById("mainLoading")
    if(loadingElm){
        loadingElm.classList.remove("hidden")
        loadingElm.classList.add("flex")
        document.body.classList.add('overflow-hidden')
    }
}

const hiddenLoading = () => {
    const loadingElm = document.getElementById("mainLoading")
    if(loadingElm){
        loadingElm.classList.remove("flex")
        loadingElm.classList.add("hidden")
        document.body.classList.remove('overflow-hidden')
    }
}
