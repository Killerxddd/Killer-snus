CREATE TABLE `snus_cooldown` (
	`pk` int(11) NOT NULL,
	`id` text DEFAULT NULL,
	`cooldown` bigint(20) DEFAULT NULL,
	`timestamp` bigint(20) DEFAULT NULL,
	`identifier` varchar(50) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('snustock', 'Stock Snus', 1, 0, 1),
('snusdosa', 'Snusdosa', 10, 0, 1),
('snus', 'Snus', 24, 0, 1);
