# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Очистка данных
[Image, Theme, User, Value].each do |model|
  model.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
end

# Темы
themes = Theme.create([
                        { name: "-----" },
                        { name: "Лучшая картинка спанчи боби?" },
                        { name: "Лучшая картинка гравити фолси?" },
                        { name: "Лучшая картинка маои маленькии поне?" }
                      ])

# Изображения
Image.create([
               {
                 name: "Спанги бобе додеп",
                 file: "sponge_bob_1.jpg",
                 theme_id: themes[1].id
               },
               {
                 name: "Спанги бобе типа крутой",
                 file: "sponge_bob_2.jpg",
                 theme_id: themes[1].id
               },
               {
                 name: "Спанги бобе милий",
                 file: "sponge_bob_3.jpg",
                 theme_id: themes[1].id
               },
               {
                 name: "Планктон скушал лимон",
                 file: "sponge_bob_4.jpg",
                 theme_id: themes[1].id
               },
               {
                 name: "Спанги бобе мони лиза",
                 file: "sponge_bob_5.jpg",
                 theme_id: themes[1].id
               },
               {
                 name: "Иисус людит маленький пони",
                 file: "my_little_pony_1.jpg",
                 theme_id: themes[2].id
               },
               {
                 name: "Советский поне",
                 file: "my_little_pony_2.jpg",
                 theme_id: themes[2].id
               },
               {
                 name: "Рейнбов реп",
                 file: "my_little_pony_3.jpg",
                 theme_id: themes[2].id
               },
               {
                 name: "Круглий поне",
                 file: "my_little_pony_4.jpg",
                 theme_id: themes[2].id
               },
               {
                 name: "Техасская резня поне",
                 file: "my_little_pony_5.jpg",
                 theme_id: themes[2].id
               },
               {
                 name: "Гномек блюет радугой",
                 file: "gravity_fals_1.jpg",
                 theme_id: themes[3].id
               },
               {
                 name: "Дипенс фоткается",
                 file: "gravity_fals_2.jpg",
                 theme_id: themes[3].id
               },
               {
                 name: "Маленький дипенс",
                 file: "gravity_fals_3.jpg",
                 theme_id: themes[3].id
               },
               {
                 name: "Страшилка",
                 file: "gravity_fals_4.jpg",
                 theme_id: themes[3].id
               },
               {
                 name: "Страшный масоне",
                 file: "gravity_fals_5.jpg",
                 theme_id: themes[3].id
               }
             ])

# Тестовый пользователь
User.create(
  name: "Example User",
  email: "example@railstutorial.org",
  password: "222222",
  password_confirmation: "222222"
)