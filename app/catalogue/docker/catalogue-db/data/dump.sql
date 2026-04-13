CREATE USER IF NOT EXISTS 'catalogue_user'@'%' IDENTIFIED WITH mysql_native_password BY 'default_password';

GRANT ALL PRIVILEGES ON socksdb.* TO 'catalogue_user'@'%';
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS sock (
	sock_id varchar(40) NOT NULL,
	name varchar(50),
	description varchar(255),
	price float,
	count int,
	image_url_1 varchar(255),
	image_url_2 varchar(255),
	PRIMARY KEY(sock_id)
);

CREATE TABLE IF NOT EXISTS tag (
	tag_id MEDIUMINT NOT NULL AUTO_INCREMENT,
	name varchar(20),
	PRIMARY KEY(tag_id)
);

CREATE TABLE IF NOT EXISTS sock_tag (
	sock_id varchar(40),
	tag_id MEDIUMINT NOT NULL,
	FOREIGN KEY (sock_id)
		REFERENCES sock(sock_id),
	FOREIGN KEY(tag_id)
		REFERENCES tag(tag_id)
);

INSERT INTO sock (`sock_id`, `name`, `description`, `image_url_1`, `image_url_2`, `price`, `count`) VALUES
('6d62d909-f957-430e-8689-b5129c0bb75e', 'Bananas', 'Fresh bananas sold by the bunch. Great for breakfast, smoothies, and snacks.', '/catalogue/images/banana.jpg', '/catalogue/images/banana-2.jpg', 2.99, 120),
('a0a4f044-b040-410d-8ead-4de0446aec7e', 'Milk', 'Fresh whole milk, ideal for tea, coffee, cereal, and cooking.', '/catalogue/images/milk.jpg', '/catalogue/images/milk-2.jpg', 1.99, 90),
('808a2de1-1aaa-4c25-a9b9-6612e8f29a38', 'Brown Bread', 'Soft and healthy brown bread loaf, perfect for sandwiches and toast.', '/catalogue/images/bread.jpg', '/catalogue/images/bread-2.jpg', 1.75, 75),
('510a0d7e-8e83-4193-b483-e27e09ddc34d', 'Eggs', 'Farm fresh eggs, rich in protein and perfect for breakfast or baking.', '/catalogue/images/eggs.jpg', '/catalogue/images/eggs-2.jpg', 3.49, 200),
('03fef6ac-1896-4ce8-bd69-b798f85c6e0b', 'Olive Oil', 'Premium extra virgin olive oil for salads, cooking, and everyday kitchen use.', '/catalogue/images/olive-oil.jpg', '/catalogue/images/olive-oil-2.jpg', 9.99, 35),
('d3588630-ad8e-49df-bbd7-3167f7efb246', 'Tomatoes', 'Juicy red tomatoes, ideal for salads, sauces, and daily cooking.', '/catalogue/images/tomato.jpg', '/catalogue/images/tomato-2.jpg', 2.49, 140),
('819e1fbf-8b7e-4f6d-811f-693534916a8b', 'Rice', 'Long grain rice, a pantry staple for family meals and side dishes.', '/catalogue/images/rice.jpg', '/catalogue/images/rice-2.jpg', 6.99, 60),
('zzz4f044-b040-410d-8ead-4de0446aec7e', 'Chicken Fillet', 'Fresh chicken fillet, trimmed and ready for grilling, roasting, or pan cooking.', '/catalogue/images/chicken.jpg', '/catalogue/images/chicken-2.jpg', 8.50, 50),
('3395a43e-2d88-40de-b95f-e00e1502085b', 'Apples', 'Crisp sweet apples, perfect for snacking, lunch boxes, and desserts.', '/catalogue/images/apple.jpg', '/catalogue/images/apple-2.jpg', 3.25, 110),
('837ab141-399e-4c1f-9abc-bace40296bac', 'Yogurt', 'Creamy natural yogurt, delicious on its own or with fruit and honey.', '/catalogue/images/yogurt.jpg', '/catalogue/images/yogurt-2.jpg', 2.20, 85);
INSERT INTO tag (name) VALUES ('fruit');
INSERT INTO tag (name) VALUES ('dairy');
INSERT INTO tag (name) VALUES ('bakery');
INSERT INTO tag (name) VALUES ('fresh');
INSERT INTO tag (name) VALUES ('breakfast');
INSERT INTO tag (name) VALUES ('vegetable');
INSERT INTO tag (name) VALUES ('pantry');
INSERT INTO tag (name) VALUES ('protein');
INSERT INTO tag (name) VALUES ('meat');
INSERT INTO tag (name) VALUES ('cooking');
INSERT INTO tag (name) VALUES ('healthy');

INSERT INTO sock_tag VALUES ('6d62d909-f957-430e-8689-b5129c0bb75e', 1);
INSERT INTO sock_tag VALUES ('6d62d909-f957-430e-8689-b5129c0bb75e', 4);
INSERT INTO sock_tag VALUES ('6d62d909-f957-430e-8689-b5129c0bb75e', 11);

INSERT INTO sock_tag VALUES ('a0a4f044-b040-410d-8ead-4de0446aec7e', 2);
INSERT INTO sock_tag VALUES ('a0a4f044-b040-410d-8ead-4de0446aec7e', 5);
INSERT INTO sock_tag VALUES ('a0a4f044-b040-410d-8ead-4de0446aec7e', 11);

INSERT INTO sock_tag VALUES ('808a2de1-1aaa-4c25-a9b9-6612e8f29a38', 3);
INSERT INTO sock_tag VALUES ('808a2de1-1aaa-4c25-a9b9-6612e8f29a38', 5);

INSERT INTO sock_tag VALUES ('510a0d7e-8e83-4193-b483-e27e09ddc34d', 2);
INSERT INTO sock_tag VALUES ('510a0d7e-8e83-4193-b483-e27e09ddc34d', 5);
INSERT INTO sock_tag VALUES ('510a0d7e-8e83-4193-b483-e27e09ddc34d', 8);

INSERT INTO sock_tag VALUES ('03fef6ac-1896-4ce8-bd69-b798f85c6e0b', 7);
INSERT INTO sock_tag VALUES ('03fef6ac-1896-4ce8-bd69-b798f85c6e0b', 10);
INSERT INTO sock_tag VALUES ('03fef6ac-1896-4ce8-bd69-b798f85c6e0b', 11);

INSERT INTO sock_tag VALUES ('d3588630-ad8e-49df-bbd7-3167f7efb246', 4);
INSERT INTO sock_tag VALUES ('d3588630-ad8e-49df-bbd7-3167f7efb246', 6);
INSERT INTO sock_tag VALUES ('d3588630-ad8e-49df-bbd7-3167f7efb246', 11);

INSERT INTO sock_tag VALUES ('819e1fbf-8b7e-4f6d-811f-693534916a8b', 7);
INSERT INTO sock_tag VALUES ('819e1fbf-8b7e-4f6d-811f-693534916a8b', 10);

INSERT INTO sock_tag VALUES ('zzz4f044-b040-410d-8ead-4de0446aec7e', 8);
INSERT INTO sock_tag VALUES ('zzz4f044-b040-410d-8ead-4de0446aec7e', 9);
INSERT INTO sock_tag VALUES ('zzz4f044-b040-410d-8ead-4de0446aec7e', 11);

INSERT INTO sock_tag VALUES ('3395a43e-2d88-40de-b95f-e00e1502085b', 1);
INSERT INTO sock_tag VALUES ('3395a43e-2d88-40de-b95f-e00e1502085b', 4);
INSERT INTO sock_tag VALUES ('3395a43e-2d88-40de-b95f-e00e1502085b', 11);

INSERT INTO sock_tag VALUES ('837ab141-399e-4c1f-9abc-bace40296bac', 2);
INSERT INTO sock_tag VALUES ('837ab141-399e-4c1f-9abc-bace40296bac', 5);
INSERT INTO sock_tag VALUES ('837ab141-399e-4c1f-9abc-bace40296bac', 11);