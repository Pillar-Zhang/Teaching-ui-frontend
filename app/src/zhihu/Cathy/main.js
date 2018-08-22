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
function see(v){
var v1=document.querySelector(".s1");
var v2=document.querySelector(".s2");
if(v==='a'){
    v1.style.display="block";
    v2.style.display="none";
}
else{
    v1.style.display="none";
    v2.style.display="block";
}
}