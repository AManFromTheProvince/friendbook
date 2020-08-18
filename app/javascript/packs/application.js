// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

const navNewSession = function(){
    let currentPage = ""
    
    function modifyNavbar(){
        let urlLink = window.location.href;
        if (urlLink.includes("sign_in")){
            currentPage = "log_in"
        }else if (urlLink.includes("sign_up")){
            currentPage = "sign_up"
        }
        document.querySelector(`.${currentPage} a`).id = "active-link";
    }

    function changeSessionPage(){
        let menuLinks = document.querySelectorAll(".menu-links a");
        menuLinks.forEach(link => link.addEventListener("click", (event)=>{
            link.id = "active-link" //the active link
            document.querySelector(`.${currentPage} a`).id = "" //remove the active link from the original one
            let classString = link.textContent.split(" ")
            classString = classString.map((str) => str[0].toLowerCase() + str.substr(1))
            currentPage = classString.join("_") //replace it
        }));
    }

    return{modifyNavbar, changeSessionPage}
};



const navbarNewSession = navNewSession()
navbarNewSession.modifyNavbar()
navbarNewSession.changeSessionPage()