CREATE DATABASE DB_GIFT_SHOP;
USE DB_GIFT_SHOP;

CREATE TABLE `CATEGORY`(
	`id` INT AUTO_INCREMENT,
    `cate_name` NVARCHAR(100) NOT NULL,
    `cate_desc` NVARCHAR(8000) NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    `id_category` INT DEFAULT NULL REFERENCES `CATEGORY`(`id`),
    CONSTRAINT pk_category PRIMARY KEY (id)
);

CREATE TABLE `PRODUCT`(
	`id` int auto_increment,
    `id_category` int references `CATEGORY`(`id`),
    `name_product` nvarchar(100) NOT NULL,
    `desc_product` nvarchar(8000) NOT NULL,
    `featured_product` tinyint(1),
    `new_product` tinyint(1),
    `image` varchar(100),
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
	`purchase_price` float NOT NULL,
	`promotional_price` float ,
	`color` nvarchar(50) NULL,
	`size` int NULL,
    CONSTRAINT pk_product PRIMARY KEY (id)
);

    
CREATE TABLE `INVENTORY`(
	`id` int auto_increment,
    `id_product` int references `PRODUCT`(`id`),
    `sale_price` float NOT NULL,
    `quantity` int NOT NULL,
    `sold` int NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_inventory PRIMARY KEY (id)
);

CREATE TABLE `IMAGE_PRODUCT`(
	`id` int auto_increment,
    `image` varchar(50) NOT NULL,
    `id_product` int references `PRODUCT`(`id`),
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_image_product PRIMARY KEY (id)
);

CREATE TABLE `ADDRESS`(
	`id` int auto_increment,
    `address_line_1` nvarchar(100) NOT NULL,
    `address_line_2` nvarchar(100) NOT NULL,
    `address_line_3` nvarchar(100) NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_address PRIMARY KEY (id)
);

CREATE TABLE `PAYMENT`(
	`id` int auto_increment,
    `payment_name` nvarchar(100) NOT NULL,
    `payment_desc` nvarchar(8000) NOT NULL,
    `image` varchar(100) NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_payment PRIMARY KEY (id)
);

CREATE TABLE `SHIPMENT`(
	`id` int auto_increment,
    `shipment_name` nvarchar(100) NOT NULL,
    `shipment_desc` nvarchar(8000) NOT NULL,
    `shipping_time_range` nvarchar(50) NOT NULL,
    `img` varchar(100) NOT NULL,
	`price_u` float NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_shipment PRIMARY KEY (id)
);

CREATE TABLE `PERMISSION`(
	`id` int auto_increment,
    `permission_name` nvarchar(50) NOT NULL,
    `desc_permission` nvarchar(8000) ,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_permission PRIMARY KEY (id)
);

CREATE TABLE `USER`(
	`id` int auto_increment,
    `login_name` varchar(20) NOT NULL UNIQUE,
    `salt` varchar(32) NULL,
    `hashed_passwd` varchar(20) NOT NULL,
    `full_name` nvarchar(100) NOT NULL,
    `image` varchar(50) NULL,
    `gender` tinyint NULL,
    `birthdate` DATE NULL,
    `phone` varchar(10) NULL,
    `id_address` int NULL REFERENCES `ADDRESS`(`id`),
    `email` varchar(50) NOT NULL,
    `id_permission` int  DEFAULT 1 REFERENCES `PERMISSION`(`id`),
	`last_login_at` TIMESTAMP ON UPDATE NOW(),
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
     `is_delete` tinyint DEFAULT 0 NOT NULL,
	CONSTRAINT pk_user PRIMARY KEY (id)
);

CREATE TABLE `STATUS`(
	`id` int auto_increment,
    `status_name` nvarchar(50),
    `desc_status` nvarchar(8000),
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_status PRIMARY KEY (id)
);

CREATE TABLE `ORDER`(
	`id` int auto_increment,
    `id_user` int REFERENCES `USER`(`id`),
    `id_inventory` int references `INVENTORY`(`id`),
    `id_payment` int references `PAYMENT`(`id`),
    `id_status` int references `STATUS`(`id`),
    `id_shipment` int references `SHIPMENT`(`id`),
    `id_address` int NOT NULL REFERENCES `ADDRESS`(`id`),
    `quantity` int NOT NULL,
	`payment_no` varchar(50),
    `total_purchase_price` float NOT NULL,
	`ship_fee` float NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_order PRIMARY KEY (id)
);

CREATE TABLE `CART`(
	`id` int auto_increment,
    `id_user` int references `USER`(`id`),
    `id_payments` int REFERENCES `PAYMENT`(`id`),
    `id_status` int REFERENCES `STATUS`(`id`),
    `id_shipment` int references `SHIPMENT`(`id`),
    `id_address` int NOT NULL REFERENCES `ADDRESS`(`id`),
    `payment_no` varchar(50),
    `total_purchase_price` float NOT NULL,
	`ship_fee` float NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_cart PRIMARY KEY (id)
);

CREATE TABLE `CART_ITEM`(
	`id` int auto_increment,
    `id_inventory` int REFERENCES `INVENTORY`(`id`),
    `id_cart` int references `CART`(`id`),
    `quantity` int NOT NULL,
    `create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT pk_cart_item PRIMARY KEY (id)
);

CREATE TABLE `BILLS`(
	`id` int auto_increment,
    `login_name` varchar(20),
    `full_name` nvarchar(100) NOT NULL,
    `phone` varchar(10) NULL,
    `email` varchar(50) NOT NULL,
    `address` varchar(1000) NULL,
	`note` varchar(50) NOT NULL,
    `total` float,
    `quantity` int,
    `status` varchar(50) DEFAULT "chờ xác nhận",
    `is_delete` TinyINT DEFAULT 0 NOT NULL,
	`create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
	CONSTRAINT pk_bills PRIMARY KEY (id)
);

CREATE TABLE `BILL_DETAIL`(
	`id` int auto_increment,
    `id_product` int references `PRODUCT`(`id`),
    `id_bill` int references `BILLS`(`id`),
    `name_product` varchar(50),
	`total` float,
    `quantity` int,
	`image` varchar(100),
	`create_at` TIMESTAMP DEFAULT NOW(),
    `update_at` TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
	CONSTRAINT pk_billdetail PRIMARY KEY (id)
);

/*User*/
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`)  VALUES ('user1','123456','Nguyễn Văn A','nva@gmail.com');
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`)  VALUES ('user2','123456','Nguyễn Văn B','nvb@gmail.com');
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`)  VALUES ('user3','123456','Nguyễn Văn C','nvc@gmail.com');
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`,`id_permission`)  VALUES ('admin','admin','Nguyễn Văn D','nvd@gmail.com','2');
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`,`id_permission`)  VALUES ('shipper','123456','Nguyễn Văn E','nve@gmail.com','3');
INSERT INTO `db_gift_shop`.`user`(`login_name`,`hashed_passwd`,`full_name`,`email`,`id_permission`)  VALUES ('nhanvien','123456','Nguyễn Văn F','nvf@gmail.com','4');
/*Permisssion*/
INSERT INTO `db_gift_shop`.`permission`(`permission_name`) VALUES ('user');
INSERT INTO `db_gift_shop`.`permission`(`permission_name`) VALUES ('Admin');
INSERT INTO `db_gift_shop`.`permission`(`permission_name`) VALUES ('shipper');
INSERT INTO `db_gift_shop`.`permission`(`permission_name`) VALUES ('nhanvien');
/*Category*/
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('1', 'Thú bông', 'Thú bông', '1');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('2', 'Mô hình', 'Mô hình', '1');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('3', 'Móc khóa', 'Móc khóa', '1');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('4', 'Đồ trang trí', 'Đồ trang trí', '1');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('5', 'Bookmark', 'Bookmark', '2');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('6', 'Đồ chơi', 'Toy', '2');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('7', 'Phụ kiện', 'Phụ kiện', '2');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('8', 'Sách', 'Sách và truyện ', '2');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('9', 'Đèn', 'Đèn dùng để trang trí', '3');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('10', 'Túi đeo', 'Túi đeo và ba lô ', '3');
INSERT INTO `db_gift_shop`.`category` (`id`, `cate_name`, `cate_desc`, `id_category`) VALUES ('11', 'Tranh', 'Tranh vẽ dùng trang trí', '3');


/*Product*/
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`, `color`, `size`) VALUES ('1', '1', 'Gấu bông Totoro', 'Gau bong', '1', '1', 'Thubong_Totoro.jpg', '140000', '0', 'Brown', '1');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`, `color`, `size`) VALUES ('2', '1', 'Gấu bông Corgi', 'Gau bong', '1', '1', 'Thubong_Corgi.jpg', '120000', '0', 'Yellow', '1');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`, `color`, `size`) VALUES ('3', '1', 'Gấu bông Cá mập cơ bắp', 'Gau bong', '1', '1', 'Thubong_MuscleShark.jpg', '200000', '0', 'Blue', '1');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('4', '1', 'Gấu bông Baron Bunny', 'Gau bong', '1', '0', 'Thubong_BaronBunny.jpg', '200000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('5', '2', 'Mô hình Lego Phi hành gia', 'Mo hinh', '1', '0', 'Mohinh_PhiHanhGia.jpg', '135000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`, `size`) VALUES ('6', '2', 'Mô hình Roronoa Zoro', 'Mo hinh', '0', '0', 'Mohinh_Zoro.jpg', '180000', '0', '1');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('7', '2', 'Mô hình Xe tăng bằng đạn', 'Mo hinh', '0', '0', 'Mohinh_Tank.jpg', '500000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('8', '2', 'Mô hình Elysia Honkai Impact 3rd', 'Mo hinh ', '1', '1', 'Mohinh_Elysia.jpeg', '2245000', '500000');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('9', '3', 'Móc khóa Mèo trong hộp', 'Moc khoa', '0', '0', 'Mockhoa_CatBox.jpg', '20000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('10', '3', 'Móc khóa Phi hành gia', 'Moc khoa', '0', '0 ', 'Mockhoa_PhiHanhGia.jpg', '30000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('11', '3', 'Móc khóa Bò Sữa cute', 'Moc khoa ', '1', '0', 'Mockhoa_Cow.jpg', '25000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('12', '3', 'Móc khóa Pikachu', 'Moc khoa', '0', '0', 'Mockhoa_Pikachu.jpg', '15000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('13', '4', 'Cầu tuyểt 4 mùa', 'Cầu tuyết 4 mùa', '0', '0', 'Decor_SnowballSpring.jpg', '350000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('14', '4', 'Quả cầu pha lê', 'Quả cầu pha lê', '0', '0', 'Decor_Crystalball.jpg', '200000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('15', '4', 'Đèn ngủ 3D', 'Đèn ngủ 3D', '1', '0', 'Decor_Lamp.jpg', '220000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('16', '4', 'Con lắc Newton', 'Con lắc Newton', '0', '0', 'Decor_ConLacNewton.jpg', '115000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('17', '5', 'Bộ 30 Bookmark', 'Bộ 30 Bookmark', '0', '0', 'Bookmark_Bo30.jpg', '25000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('18', '5', 'Bookmark kim loại', 'Bookmark kim loại', '0', '0', 'Bookmark_Metal.jpg', '35000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('19', '5', 'Bookmark nam châm', 'Bookmark nam châm', '0', '0', 'Bookmark_NamCham.jpg', '5000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('20', '8', 'Cho tôi xin một vé đi tuổi thơ', 'Cho tôi xin một vé đi tuổi thơ của Nguyễn Nhật Ánh', '0', '0', 'CTX_MVDiTuoiTho.jpg', '68000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('21', '8', 'Mong bạn đừng khóc một mình', 'Mong bạn đừng khóc một mình của Ahn Sang Hyun ', '0', '0', 'DungKhocMotMinh.jpg', '76000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('22', '8', 'Jujutsu Kaisen', 'Jujutsu Kaisen của Akutami Gege', '1', '1', 'Jujutsu_Kaisen.jpg', '30000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('23', '8', 'Nếu không là tình yêu', 'Nếu không là tình yêu của Diệp Lạc Vô Tâm', '0', '1', 'NeuKoLaTY.jpg', '92000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('24', '8', 'Tanaka lúc nào cũng vật vờ', 'Tanaka lúc nào cũng vật vờ của tác giả  Nozomi Uda', '0', '0', 'Tanaka.jpg', '38000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('25', '8', 'Tớ thích cậu hơn cả harvard', 'Tớ thích cậu hơn cả hảvard của tác giả Lan Rùa', '0', '0', 'ToThichCauHonHARVARD.jpg', '68000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('26', '9', 'Đèn ngủ hình tháp Eiffel Led 3D', 'Đèn ngủ để bàn bằng led mô hình tháp Eiffel 3D', '0', '1', 'DenNguEiffel3D.jpg', '51000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('27', '9', 'Đèn ngủ pha lê để bàn Kim Cương', 'Đèn ngủ pha lê để bàn decor', '0', '0', 'DenNguKC.jpg', '150000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('28', '9', 'Đèn ngủ hình mặt trăng  Led 3D', 'Đèn ngủ để bàn bằng led hình mặt trăng 3D', '1', '0', 'DenNguMatTrang3D.jpg', '49000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('39', '9', 'Đèn ngủ hình vòng quay mạo hiểm Led 3D', 'Đèn ngủ để bàn hình vòng quay 3D bằng led', '1', '1', 'DenNguVongQuay.jpg', '50000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('30', '9', 'Đèn pha lê để bàn hình trụ 36 màu ', 'Đèn ngủ để bàn hình trụ pha lê 39 màu decor', '1', '1', 'DenPhaLeDeBan.jpg', '201000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('31', '9', 'Đèn ngủ phi hành gia ', 'Đèn ngủ để bàn hình phi hành gia chiều trần thành các hải ngân hà ', '1', '1', 'DenPhiHanhGia.jpg', '569000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('32', '10', 'Túi đeo chéo Haras Nhật Bản', 'Túi đeo chéo nam phong cách nhật bản', '0', '0', 'HTuiDeoCheoHaras.jpg', '130000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('33', '10', 'Balo totoro mặt ngầu', 'Balo dễ thương hình totoro làm mặt ngầu', '0', '0', 'BaloTotoro.jpg', '250000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('34', '10', 'Túi đeo hình búp bê lông cừu', 'Túi đeo nữ dễ thương lông cừu ', '0', '0', 'TuiBupBeLongCuu.jpg', '50000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('35', '10', 'Túi đeo chéo hình khủng long', 'Túi đeo khủng long dễ thương nam nữ', '0', '0', 'TuiKhungLong.jpg', '80000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('36', '11', 'Tranh dán tường tết 2023', 'Tranh dán tường hình tết chúc mừng năm mới', '0', '0', 'TranhDanTet.jpg', '30000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('37', '11', 'Tranh tô màu thiếu nữ mơ', 'tranh tô màu số hóa thiếu nữ mơ', '0', '0', 'TranhToMau.jpg', '175000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('38', '11', 'Tranh tô màu chủ đề Phong cảnh thiên nhiên ', 'Tranh tô màu số hóa Phong Cảnh', '0', '0', 'TranhToMauPhongCanh.jpg', '50000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('40', '1', 'Gấu bông Doraemon', 'Gấu bông Doraemon', '0', '0', 'Thubong_Doraemon.jpg', '195000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('41', '1', 'Gấu bông Blazing Spirit', 'Gấu bông Blazing Spirit', '0', '0', 'Thubong_Ghost.jpg', '95000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('42', '1 ', 'Thú Bông Vịt', 'Thú bông Vịt', '0', '0', 'Thubong_Vit.jpg', '57000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('43', '1', 'Gấu bông quả bơ dễ thương', 'Gấu bông quả bơ dễ thương', '0 ', '0', 'Thubong_Bo.jpg', '60000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('44', '1', 'Gấu bông chó shiba', 'Gấu bông chó shiba', '0 ', '0', 'Thubong_Shiba.jpg', '99000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('45', '1', 'Gấu bông rồng Zhongli', 'Gấu bông rồng Zhongli', '0', '0', 'Thubong_RongZhongli.jpg', '300000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('46', '1', 'Gấu bông Psyduck', 'Gấu bông Psyduck', '0', '0', 'Thubong_Psyduck.jpg', '129000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('47', '1', 'Gấu bông Rau mầm', 'Gấu bông Rau mầm', '0', '0', 'Thubong_RauMam.jpg', '49000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('48', '1', 'Thỏ con nhồi bông', 'Thỏ con nhồi bông', '0', '0', 'Thubong_Tho.jpg', '61000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('49', '1', 'Gấu bông Miko fox', 'Gấu bông Miko fox', '0', '0', 'Thubong_PinkFox.jpg', '135000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('50', '7', 'Dây chuyền cặp đôi', 'Dây chuyền cặp đôi', '0', '0', 'Phukien_DayChuyenCap.jpg', '169000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('51', '6', 'Bài tây mạ vàng', 'Bài tây mạ vàng', '0', '0 ', 'Toy_GoldenCard.jpg', '52000', '0');
INSERT INTO `db_gift_shop`.`product` (`id`, `id_category`, `name_product`, `desc_product`, `featured_product`, `new_product`, `image`, `purchase_price`, `promotional_price`) VALUES ('52', '9', 'Đèn hộp cắt giấy nhiều lớp', 'Đèn hộp cắt giấy nhiều lớp', '1', '1', 'Den_DenHop.jpg', '255000', '0');


/*Inventory*/
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('1', '1', '140000', '10', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('2', '2', '120000', '5', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('3', '3', '200000', '2', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('4', '4', '200000', '1', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('5', '5', '135000', '4', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('6', '6', '180000', '2', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('7', '7', '500000', '1', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('8', '8', '2245000', '2', '1');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('9', '9', '20000', '20', '4');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('10', '10', '30000', '20', '5');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('11', '11', '25000', '15', '10');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('12', '12', '15000', '20', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('13', '13', '350000', '10', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('14', '14', '200000', '12', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('15', '15', '220000', '5', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('16', '16', '115000', '10', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('17', '17', '25000', '30', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('18', '18', '35000', '20', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('19', '19', '5000', '25', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('20', '20', '68000', '30', '4');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('21', '21', '76000', '10', '5');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('22', '22', '30000', '45', '30');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('23', '23', '92000', '23', '9');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('24', '24', '38000', '100', '60');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('25', '25', '68000', '54', '23');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('26', '26', '51000', '30', '21');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('27', '27', '150000', '35', '23');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('28', '28', '49000', '40', '30');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('29', '29', '50000', '21', '19');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('30', '30', '201000', '79', '49');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('31', '31', '569000', '50', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('32', '32', '130000', '38', '18');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('33', '33', '250000', '43', '13');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('34', '34', '50000', '500', '332');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('35', '35', '80000', '200', '194');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('36', '36', '30000', '400', '321');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('37', '37', '175000', '143', '85');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('38', '38', '50000', '234', '129');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('39', '39', '50000', '100', '10');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('40', '40', '195000', '50', '15');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('41', '41', '95000', '45', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('42', '42', '57000', '10', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('43', '43', '60000', '25', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('44', '44', '99000', '29', '12');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('45', '45', '30000', '20', '1');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('46', '46', '129000', '50', '12');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('47', '47', '49000', '46', '25');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('48', '48', '61000', '75', '35');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('49', '49', '135000', '16', '2');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('50', '50', '169000', '10', '0');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('51', '51', '52000', '24', '2');
INSERT INTO `db_gift_shop`.`inventory` (`id`, `id_product`, `sale_price`, `quantity`, `sold`) VALUES ('52', '52', '255000', '19', '1');

/*Image_Product*/
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('1', 'Decor_SnowballSummer.jpg', '13');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('2', 'Decor_SnowballAutumn.jpg', '13');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('3', 'Decor_SnowballWinter.jpg', '13');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('4', 'Decor_Lamp2.jpg', '14');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('5', 'Decor_ConLacNewton2.jpg', '15');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('6', 'Bookmark_Bo30_2.jpg', '17');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('7', 'Bookmark_Metal2.jpg', '18');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('8', 'Bookmark_Metal3.jpg', '18');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('9', 'Bookmark_NamCham2.jpg', '19');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('10', 'CTX_MVDiTuoiTho2.jpg', '20');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('11', 'DungKhocMotMinh2.jpg', '21');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('12', 'DungKhocMotMinh3.jpg', '21');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('13', 'Jujutsu_Kaisen.jpg', '22');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('14', 'NeuKoLaTY2.jpg', '23');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('15', 'NeuKoLaTY3.jpg', '23');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('16', 'Tanaka.jpg', '24');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('17', 'ToThichCauHonCaHARVARD2.jpg', '25');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('18', 'ToThichCauHonCaHARVARD3.jpg', '25');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('19', 'DenNguEiffel3D.jpg', '26');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('20', 'DenNguKC.jpg', '27');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('21', 'DenNguMatTrang3D.jpg', '28');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('22', 'DenNguVongQuay.jpg', '29');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('23', 'DenPhaLeDeBan2.jpg', '30');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('24', 'DenPhiHanhGia2.jpg', '31');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('25', 'HTuiDeoCheoHaras.jpg', '32');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('26', 'BaloTotoro2.jpg', '33');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('27', 'BaloTotoro3.jpg', '33');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('28', 'TuiBupBeLongCuu2.jpg', '34');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('29', 'TuiBupBeLongCuu3.jpg', '34');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('30', 'TuiKhungLong2.jpg', '35');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('31', 'TranhDanTet2.jpg', '36');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('32', 'TranhToMau2.jpg', '37');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('33', 'TranhToMau3.jpg', '37');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('34', 'TranhToMauPhongCanh2.jpg', '38');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('35', 'TranhToMauPhongCanh3.jpg', '38');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('36', 'Thubong_Totoro2.jpg', '1');
INSERT INTO `db_gift_shop`.`image_product` (`id`, `image`, `id_product`) VALUES ('37', 'Thubong_Totoro3.jpg', '1');

