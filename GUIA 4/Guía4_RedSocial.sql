
-- 1. Realizar todas las inserciones necesarias para llenar la base de datos, por lo menos 
-- con 5 registros por cada tabla según sea necesario

-- Insertar usuarios
INSERT INTO users (user_handle, email_address, first_name, last_name, phonenumber)
VALUES
    ('user1', 'user1@example.com', 'John', 'Doe', '1234567890'),
    ('user2', 'user2@example.com', 'Jane', 'Smith', '0987654321'),
    ('user3', 'user3@example.com', 'Bob', 'Johnson', '5555555555'),
    ('user4', 'user4@example.com', 'Alice', 'Williams', '9876543210'),
    ('user5', 'user5@example.com', 'Tom', 'Brown', '7777777777');

-- Insertar tweets
INSERT INTO tweets (user_id, tweet_text)
VALUES
    (1, 'This is my first tweet!'),
    (2, 'Hello, world!'),
    (3, 'I love programming!'),
    (4, 'Enjoying a beautiful day!'),
    (5, 'Just had a great meal!');

-- Insertar retweets
INSERT INTO retweets (tweet_id, user_id, is_quoted, is_retweet)
VALUES
    (1, 2, FALSE, TRUE),
    (2, 3, TRUE, TRUE),
    (3, 4, FALSE, TRUE),
    (4, 5, TRUE, TRUE),
    (5, 1, FALSE, TRUE);

-- Insertar comentarios
INSERT INTO comments (tweet_id, user_id, comment_text, is_comment, commented_user_id)
VALUES
    (1, 3, 'Nice tweet!', TRUE, 1),
    (2, 4, 'Hello to you too!', TRUE, 2),
    (3, 5, 'Me too! What language do you prefer?', TRUE, 3),
    (4, 1, 'Indeed, it is a beautiful day!', TRUE, 4),
    (5, 2, 'What did you have?', TRUE, 5);

-- Insertar likes
INSERT INTO likes (tweet_id, user_id, is_liked, liked_user_id)
VALUES
    (1, 4, TRUE, 1),
    (2, 5, TRUE, 2),
    (3, 1, TRUE, 3),
    (4, 2, TRUE, 4),
    (5, 3, TRUE, 5);

-- Insertar hashtags
INSERT INTO hashtags (hashtag_text)
VALUES
    ('#tech'),
    ('#nature'),
    ('#food'),
    ('#travel'),
    ('#fun');

-- Insertar tweets_hashtags
INSERT INTO tweets_hashtags (tweet_id, hashtag_id)
VALUES
    (1, 1),
    (2, 5),
    (3, 1),
    (4, 2),
    (5, 3);

-- Insertar menciones
INSERT INTO mentions (tweet_id, mentioned_user_id, mentioned_user_handle, is_mention, mentioned_tweet_text)
VALUES
    (1, 2, 'user2', TRUE, 'This is my first tweet!'),
    (2, 3, 'user3', TRUE, 'Hello, world!'),
    (3, 4, 'user4', TRUE, 'I love programming!'),
    (4, 5, 'user5', TRUE, 'Enjoying a beautiful day!'),
    (5, 1, 'user1', TRUE, 'Just had a great meal!');

-- Insertar imágenes
INSERT INTO images (user_id, image_data, image_type)
VALUES
    (1, LOAD_FILE('/path/to/image1.jpg'), 'jpg'),
    (2, LOAD_FILE('/path/to/image2.png'), 'png'),
    (3, LOAD_FILE('/path/to/image3.gif'), 'gif'),
    (4, LOAD_FILE('/path/to/image4.bmp'), 'bmp'),
    (5, LOAD_FILE('/path/to/image5.jpg'), 'jpg');

-- Insertar tweet_images
INSERT INTO tweet_images (tweet_id, image_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Insertar user_profile_images
INSERT INTO user_profile_images (user_id, image_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Insertar user_followers
INSERT INTO user_followers (follower_id, following_id)
VALUES
    (1, 2),
    (2, 3),
    (3, 4),
    (4, 5),
    (5, 1);
    
    
-- 2. Realizar 2 consultas, que lleven al menos, un campo definido y WHERE.

-- Consulta 1: Obtener los tweets de un usuario específico con su nombre y apellido
SELECT u.first_name, u.last_name, t.tweet_text
FROM tweets t
JOIN users u ON t.user_id = u.user_id
WHERE u.user_handle = 'user1';

-- Consulta 2: Obtener los comentarios de un tweet específico con el nombre del usuario que comentó
SELECT c.comment_text, u.first_name, u.last_name
FROM comments c
JOIN users u ON c.user_id = u.user_id
WHERE c.tweet_id = 1;


-- 3. Realizar 2 actualizaciones que lleven al menos, un campo definido y WHERE.
-- Actualización 1: Incrementar el número de likes de un tweet específico
UPDATE tweets
SET num_likes = num_likes + 1
WHERE tweet_id = 1;

-- Actualización 2: Cambiar el nombre de usuario de un usuario específico
UPDATE users
SET user_handle = 'new_handle'
WHERE user_id = 1;

-- 4. Realizar 2 eliminaciones que lleven WHERE.

-- Eliminación 1: Eliminar los tweets de un usuario específico
DELETE FROM tweets
WHERE user_id = 2;

-- Eliminación 2: Eliminar los comentarios de un tweet específico que tengan un número de likes mayor a 5
DELETE FROM comments
WHERE tweet_id = 3 AND num_likes > 5;