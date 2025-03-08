//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

// Инициализация модального окна после загрузки страницы
document.addEventListener('turbolinks:load', function() {
    var themeModal = new bootstrap.Modal(document.getElementById('themeModal'), {
        keyboard: false
    })

    // Обработчик закрытия модального окна
    document.getElementById('themeModal').addEventListener('hidden.bs.modal', function () {
        console.log('Модальное окно закрыто')
    })
})