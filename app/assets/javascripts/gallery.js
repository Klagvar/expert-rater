
// Инициализация данных при загрузке страницы
document.addEventListener("turbolinks:load", function() {
    const card = $('.card');
    if (card.length && !card.data('current-index')) {
        card.data({
            'current-index': 0,
            'theme-id': card.data('theme-id') || 1,
            'total-images': card.data('total-images') || 10
        });
    }
});
// Функция для загрузки нового изображения
function loadImage(direction) {
    const card = $('.card');
    const themeId = card.data('theme-id');
    const currentIndex = parseInt(card.data('current-index'));
    const totalImages = parseInt(card.data('total-images'));

    $.ajax({
        type: "GET",
        url: `/api/${direction}_image`,
        data: {
            theme_id: themeId,
            index: currentIndex,
            length: totalImages
        },
        dataType: 'json',
        success: function(data) {
            // Обновляем данные карточки
            card.data('current-index', data.new_image_index);

            // Обновляем DOM
            $('.up-theme').text(data.theme);
            $('.scalable-image').attr('src', `/assets/pictures/${data.file}`);
            $('.up').text(data.name);

            // Принудительно обновляем ширину
            $('.card').css('width', 'auto');
        },
        error: function(xhr) {
            console.error('Ошибка:', xhr.statusText);
        }
    });
}

// Назначаем обработчики кнопок
$(document).on('click', '[data-action="prev"]', () => loadImage('prev'));
$(document).on('click', '[data-action="next"]', () => loadImage('next'));