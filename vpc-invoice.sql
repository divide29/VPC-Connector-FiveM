

CREATE TABLE `vpc_invoice` (
	`id` int COLLATE utf8mb4_bin NOT NULL,
	`computerid` int(30) COLLATE utf8mb4_bin NOT NULL,
	`computername` varchar(30) COLLATE utf8mb4_bin NOT NULL,
	`identifier` varchar(80) COLLATE utf8mb4_bin NOT NULL,
	`net` varchar(8) COLLATE utf8mb4_bin NOT NULL,
	`reason` TEXT(500) COLLATE utf8mb4_bin NOT NULL,
	`ammount` int(18) COLLATE utf8mb4_bin NOT NULL,
	`maturity` DATE COLLATE utf8mb4_bin NOT NULL,
	`status` varchar(18) COLLATE utf8mb4_bin NOT NULL,

	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;