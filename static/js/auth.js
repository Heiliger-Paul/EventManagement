document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('signUp').addEventListener('click', function (event) {
        event.preventDefault();
        document.querySelector('.login__form').classList.remove('active');
        document.querySelector('.register__form').classList.add('active');
        document.querySelector('.login__form').style.display = 'none';
        document.querySelector('.register__form').style.display = 'block';
    });

    document.getElementById('signIn').addEventListener('click', function (event) {
        event.preventDefault();
        document.querySelector('.register__form').classList.remove('active');
        document.querySelector('.login__form').classList.add('active');
        document.querySelector('.register__form').style.display = 'none';
        document.querySelector('.login__form').style.display = 'block';
    });
});
