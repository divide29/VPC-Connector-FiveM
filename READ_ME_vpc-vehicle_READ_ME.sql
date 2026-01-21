ALTER TABLE `owned_vehicles` ADD `vpcname` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL;


--HINWEIS
--Wenn ihr bereits das Feld ID in eurer DB habt, muss diese Zeile NICHT importiert werden!
--Solltet Ihr dies benötigen, kommentiert die Zeile bitte ein! (die zwei "-" vor ALTER TABLE entfernen)

--NOTE
--If you already have the ID field in your DB, this row does NOT need to be imported!
--Should you need this, please comment the line! (remove the two "-" in front of ALTER TABLE)


--  ALTER TABLE `owned_vehicles` ADD COLUMN `id` INT AUTO_INCREMENT, ADD KEY (id);
