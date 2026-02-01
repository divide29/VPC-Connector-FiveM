

CREATE TABLE `vpcLS` (
	`playerId` varchar(80) COLLATE utf8mb4_bin NOT NULL,
	`coordsx` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
	`coordsy` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
	`NET` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,

	PRIMARY KEY (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;