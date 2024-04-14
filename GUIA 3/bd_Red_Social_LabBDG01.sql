Create Database if not exists Red_social_baseTwitter;
use Red_social_baseTwitter;

CREATE TABLE if not exists users (
user_id INT AUTO_INCREMENT,
user_handle VARCHAR(50) NOT NULL UNIQUE,
email_address VARCHAR(50) NOT NULL UNIQUE,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
phonenumber CHAR(10) UNIQUE,
follower_count INT NOT NULL DEFAULT 0,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS tweets (
    tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    num_likes INT DEFAULT 0,
    num_retweets INT DEFAULT 0,
    num_comments INT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id)
);

CREATE TABLE IF NOT EXISTS retweets (
    retweet_id INT AUTO_INCREMENT PRIMARY KEY,
    tweet_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    quoted_tweet_text VARCHAR(280),
    is_quoted BOOLEAN NOT NULL,
    num_comments INT DEFAULT 0,
    num_likes INT DEFAULT 0,
    quoted_user_id INT,
    is_retweet BOOLEAN NOT NULL,
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (quoted_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    tweet_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text VARCHAR(280) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    parent_comment_id INT,
    num_likes INT DEFAULT 0,
    is_comment BOOLEAN NOT NULL,
    commented_tweet_text VARCHAR(280),
    commented_user_id INT NOT NULL,
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id),
    FOREIGN KEY (commented_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    tweet_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_liked BOOLEAN NOT NULL,
    liked_tweet_text VARCHAR(280),
    liked_user_id INT NOT NULL,
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (liked_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS hashtags (
    hashtag_id INT AUTO_INCREMENT PRIMARY KEY,
    hashtag_text VARCHAR(140) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    num_tweets INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS tweets_hashtags (
    tweet_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (tweet_id, hashtag_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (hashtag_id) REFERENCES hashtags(hashtag_id)
);

CREATE TABLE IF NOT EXISTS mentions (
    mention_id INT AUTO_INCREMENT PRIMARY KEY,
    tweet_id INT NOT NULL,
    mentioned_user_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mentioned_user_handle VARCHAR(50) NOT NULL,
    is_mention BOOLEAN NOT NULL,
    mentioned_tweet_text VARCHAR(280),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (mentioned_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    image_data MEDIUMBLOB NOT NULL,
    image_type VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS tweet_images (
    tweet_id INT NOT NULL,
    image_id INT NOT NULL,
    PRIMARY KEY (tweet_id, image_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    FOREIGN KEY (image_id) REFERENCES images(image_id)
);

CREATE TABLE IF NOT EXISTS user_profile_images (
    user_id INT NOT NULL PRIMARY KEY,
    image_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (image_id) REFERENCES images(image_id)
);

CREATE TABLE IF NOT EXISTS user_followers (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (following_id) REFERENCES users(user_id)
);

DELIMITER $$

CREATE TRIGGER increase_follower_count
AFTER INSERT ON user_followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count + 1
    WHERE user_id = NEW.following_id;
END $$

CREATE TRIGGER decrease_follower_count
AFTER DELETE ON user_followers
FOR EACH ROW
BEGIN
    UPDATE users SET follower_count = follower_count - 1
    WHERE user_id = OLD.following_id;
END $$

DELIMITER ;