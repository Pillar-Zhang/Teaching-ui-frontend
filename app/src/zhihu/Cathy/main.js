function toggle(type) {
    const registerDom = document.querySelector(".register-content")
    const loginDom = document.querySelector(".login-content")
    if (type === "register") {
        registerDom.style.display = "block"
        loginDom.style.display = "none"
    } else {
        registerDom.style.display = "none"
        loginDom.style.display = "block"
    }
}
