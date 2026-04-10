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
('6d62d909-f957-430e-8689-b5129c0bb75e', 'Bananas', 'Fresh bananas sold by the bunch. Great for breakfast, smoothies, and snacks.', 'https://picsum.photos/seed/banana1/400', 'https://picsum.photos/seed/banana2/400', 2.99, 120),
('a0a4f044-b040-410d-8ead-4de0446aec7e', 'Milk', 'Fresh whole milk, ideal for tea, coffee, cereal, and cooking.', 'https://picsum.photos/seed/milk1/400', 'https://picsum.photos/seed/milk2/400', 1.99, 90),
('808a2de1-1aaa-4c25-a9b9-6612e8f29a38', 'Brown Bread', 'Soft and healthy brown bread loaf, perfect for sandwiches and toast.', 'https://picsum.photos/seed/bread1/400', 'https://picsum.photos/seed/bread2/400', 1.75, 75),
('510a0d7e-8e83-4193-b483-e27e09ddc34d', 'Eggs', 'Farm fresh eggs, rich in protein and perfect for breakfast or baking.', 'https://picsum.photos/seed/eggs1/400', 'https://picsum.photos/seed/eggs2/400', 3.49, 200),
('03fef6ac-1896-4ce8-bd69-b798f85c6e0b', 'Olive Oil', 'Premium extra virgin olive oil for salads, cooking, and everyday kitchen use.', 'https://picsum.photos/seed/oil1/400', 'https://picsum.photos/seed/oil2/400', 9.99, 35),
('d3588630-ad8e-49df-bbd7-3167f7efb246', 'Tomatoes', 'Juicy red tomatoes, ideal for salads, sauces, and daily cooking.', 'https://picsum.photos/seed/tomato1/400', 'https://picsum.photos/seed/tomato2/400', 2.49, 140),
('819e1fbf-8b7e-4f6d-811f-693534916a8b', 'Rice', 'Long grain rice, a pantry staple for family meals and side dishes.', 'https://picsum.photos/seed/rice1/400', 'https://picsum.photos/seed/rice2/400', 6.99, 60),
('zzz4f044-b040-410d-8ead-4de0446aec7e', 'Chicken Fillet', 'Fresh chicken fillet, trimmed and ready for grilling, roasting, or pan cooking.', 'https://picsum.photos/seed/chicken1/400', 'https://picsum.photos/seed/chicken2/400', 8.50, 50),
('3395a43e-2d88-40de-b95f-e00e1502085b', 'Apples', 'Crisp sweet apples, perfect for snacking, lunch boxes, and desserts.', 'https://picsum.photos/seed/apple1/400', 'https://picsum.photos/seed/apple2/400', 3.25, 110),
('837ab141-399e-4c1f-9abc-bace40296bac', 'Yogurt', 'Creamy natural yogurt, delicious on its own or with fruit and honey.', 'https://picsum.photos/seed/yogurt1/400', 'https://picsum.photos/seed/yogurt2/400', 2.20, 85);

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