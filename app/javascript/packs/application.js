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

const app = function(){
    let currentPage = ""
    
    function modifyNavbar(){
        let urlLink = window.location.href;
        let signIn = false
        if (urlLink.includes("sign_in")){
            currentPage = "log_in"
            signIn = true
        }else if (urlLink.includes("sign_up")){
            currentPage = "sign_up"
            signIn = true
        }else if (urlLink.includes("friendships")){
            currentPage = "friend_request"
        } else if (urlLink.includes("users")){
            currentPage = "profile_account"
        } else if (urlLink.includes("posts") || urlLink.includes("/")){
            currentPage = "timeline"
        }
        if (signIn){
            document.querySelector(`.${currentPage} a`).id = "active-link";
        } else {
            document.querySelector(`.${currentPage}`).classList.add("active");
        }
    }

    function changeSessionPage(){
        let menuLinks = document.querySelectorAll(".menu-links a");
        menuLinks.forEach(link => link.addEventListener("click", (event)=>{
            link.id = "active-link" //the active link
            if (!currentPage){ currentPage = "log_in"}
            document.querySelector(`.${currentPage} a`).id = "" //remove the active link from the original one
            let classString = link.textContent.split(" ")
            classString = classString.map((str) => str[0].toLowerCase() + str.substr(1))
            currentPage = classString.join("_") //replace it
        }));
    }

    function changeMainNavbar(){
        let navLinks = document.querySelectorAll(".users-links a span");
        navLinks.forEach(link=> link.addEventListener("click", (e)=>{
            document.querySelector(`.${currentPage}`).classList.remove("active");
            currentPage = link.classList[2];    
            document.querySelector(`.${currentPage}`).classList.add("active");
        }));
    }

    function viewComments(){
        let commentLink = document.querySelectorAll(".comments");
        commentLink.forEach(view=> view.addEventListener("click", (e)=>{
            let postNumber = view.classList[1].split("-")[2]
            let commentSection = document.querySelector(`.comments-section-${postNumber}`)
            if (commentSection.classList.contains("hide-section")){
                commentSection.classList.remove("hide-section");
                commentSection.setAttribute("title", "Hide comments");
            } else{
                commentSection.classList.add("hide-section");
                commentSection.setAttribute("title", "View comments");
            }
        }));
    }

    function getPicture(pictureTag, fileTag){
        let profilePicture = document.querySelector(pictureTag);
        let fileInput = document.querySelector(fileTag);
        fileInput.addEventListener("change", (e)=>{
            let target = e.target;
            let files = target.files;

            if (FileReader){ //we have filereader
                let fr = new FileReader();
                fr.onload = () =>{
                    profilePicture.src = fr.result;
                };
                fr.readAsDataURL(files[0]);
            }
        });
    }

    return{modifyNavbar, changeSessionPage, changeMainNavbar, viewComments, getPicture}
};



const application = app();
let url = window.location.href;
application.modifyNavbar();
if (url.includes("users") && !(/[0-9]/).test(url)){
    application.changeSessionPage();
} else{
   application.changeMainNavbar()
}

if (url.includes("posts") || (url.includes("users") && (/[0-9]/).test(url) )  && !url.includes("edit")){    
    application.viewComments();
    application.getPicture(".post-pic", "#post-picture-file");
}

if (url.includes("users/edit") || url.includes("sign_up")){
    application.getPicture(".profile-picture", "#profile-pic-file");
}





