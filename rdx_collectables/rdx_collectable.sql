--
-- Table structure for table `user_collectables`
--
CREATE TABLE `user_collectables` (
    `identifier` varchar(50) NOT NULL,
    `cards` text NOT NULL,
    `coins` text NOT NULL,
    `jewelery` text NOT NULL,
    `eggs` text NOT NULL,
    `flowers` text NOT NULL,
    `arrowheads` text NOT NULL,
    `bottles` text NOT NULL
);

--
-- Indexes for table `user_collectables`
--
ALTER TABLE `user_collectables`
ADD PRIMARY KEY (`identifier`);