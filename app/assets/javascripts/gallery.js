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

    // Проверяем, выбрана ли тема, и скрываем элементы, если нет
    if ($('.up-theme').text() === "Выберите тему") {
        $('.img-left-side').hide();
        $('.img-right-side').hide();
        $('.card-footer').hide();
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
            card.data('current-index', data.new_image_index);
            card.data('image-id', data.image_id);
            $('.up-theme').text(data.theme);
            $('.scalable-image').attr('src', `/assets/pictures/${data.file}`);
            $('.up').text(data.name);
            $('#rating-slider').val(data.user_score);
            $('#current-rating').text(data.user_score);
            $('#average-rating').text(data.ave_value);
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

// Обработчик изменения слайдера с делегированием
$(document).on('input', '#rating-slider', function() {
    const score = $(this).val();
    const imageId = $('.card').data('image-id');
    console.log('Slider changed:', score, imageId); // Отладка

    $.ajax({
        type: "POST",
        url: "/api/rate_image",
        data: {
            image_id: imageId,
            score: score
        },
        dataType: 'json',
        success: function(data) {
            if (data.status === 'success') {
                $('#current-rating').text(data.user_score);
                $('#average-rating').text(data.ave_value);
                console.log('Оценка сохранена:', data);
            } else {
                console.error('Ошибка от сервера:', data.notice);
            }
        },
        error: function(xhr) {
            console.error('Ошибка AJAX:', xhr.statusText);
        }
    });
});