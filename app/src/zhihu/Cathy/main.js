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
function see(value){
var v1=document.querySelector(".logsee1");
var v2=document.querySelector(".logsee2");
if(value=='a'){
    v1.stype.display="block";
    v2.stype.display="none";
}
else{
    v1.stype.display="none";
    v2.stype.display="block";
}
}