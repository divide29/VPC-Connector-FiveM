---******************************************************
--- Local Variables                                   ***
---******************************************************

--- The Config object
local Config = require 'config.shared'

--- The MySQL query function
local SqlQuery = MySQL.query

---******************************************************
--- Local Functions                                   ***
---******************************************************

--- Ensures that the required database schema exists.
local function EnsureSchema()
  SqlQuery([[CREATE TABLE IF NOT EXISTS `vpcLS` (
      `playerId` varchar(80) COLLATE utf8mb4_bin NOT NULL,
      `coordsx` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
      `coordsy` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
      `NET` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
      PRIMARY KEY (`playerId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;]])

  SqlQuery([[CREATE TABLE IF NOT EXISTS `vpc_invoice` (
      `id` int NOT NULL,
      `computerid` int NOT NULL,
      `computername` varchar(30) COLLATE utf8mb4_bin NOT NULL,
      `identifier` varchar(80) COLLATE utf8mb4_bin NOT NULL,
      `net` varchar(8) COLLATE utf8mb4_bin NOT NULL,
      `reason` TEXT(500) COLLATE utf8mb4_bin NOT NULL,
      `ammount` int NOT NULL,
      `maturity` DATE NOT NULL,
      `status` varchar(18) COLLATE utf8mb4_bin NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;]])

  SqlQuery([[ALTER TABLE `owned_vehicles` ADD `vpcname` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL;]])
end

---******************************************************
--- Event Handlers                                    ***
--- *****************************************************

--- Initialize the database schema when MySQL is ready
MySQL.ready(function()
  EnsureSchema()
end)
