let MenuBtn = document.querySelector("#MenuBtn");
let Navbar = document.querySelector("header .navbar");

window.onscroll = () => {
    Navbar.classList.remove("active");
    MenuBtn.classList.remove("fa-times");
};

MenuBtn.onclick = () => {
    MenuBtn.classList.toggle("fa-times");
    Navbar.classList.toggle("active");
};

var swiper = new Swiper(".ReviewSlider", {
    slidesPerView: 1,
    grabCursor: true,
    loop: true,
    spaceBetween: 10,
    speed: 4000,
    breakpoints: {
        0: {
            slidesPerView: 1,
        },
        700: {
            slidesPerView: 2,
        },
        1050: {
            slidesPerView: 3,
        },
    },
    autoplay: {
        delay: 0,
        disableOnInteraction: false,
    }
});
