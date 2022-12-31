-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 31, 2022 at 06:37 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `extreme_racer`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `transfer_p1_to_p2` (IN `transfer_amount` INT)   BEGIN
DECLARE player1_coin_pre INT;
DECLARE player2_coin_pre INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
SELECT player1_coin,player2_coin INTO player1_coin_pre, player2_coin_pre FROM total_coin;

  START TRANSACTION ;

  IF player1_coin_pre < transfer_amount THEN
      ROLLBACK;
  ELSE
    UPDATE total_coin set player1_coin = player1_coin_pre - transfer_amount; 
    UPDATE total_coin set player2_coin = player2_coin_pre + transfer_amount;
  END IF;

  COMMIT ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `transfer_p2_to_p1` (IN `transfer_amount` INT)   BEGIN
DECLARE player1_coin_pre INT;
DECLARE player2_coin_pre INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
SELECT player1_coin,player2_coin INTO player1_coin_pre, player2_coin_pre FROM total_coin;

  START TRANSACTION ;
    IF player2_coin_pre < transfer_amount THEN
    ROLLBACK;
    ELSE
      UPDATE total_coin set player2_coin = player2_coin_pre - transfer_amount; 
    UPDATE total_coin set player1_coin = player1_coin_pre + transfer_amount;
    END IF;

  COMMIT ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWinner` (IN `player1_coins` INT, IN `player2_coins` INT)   BEGIN
	DECLARE player1_win_prev INT;
    DECLARE player2_win_prev INT;
    DECLARE player1_winner float;
    DECLARE player2_winner float;
	SELECT player1_win into player1_win_prev FROM total_win;
    SELECT player2_win into player2_win_prev FROM total_win;
    
    SET player1_winner = player1_win_prev+1;
     
    SET player2_winner = player2_win_prev+1;

  	IF player1_coins > player2_coins THEN UPDATE total_win set player1_win = player1_winner;
    ELSEIF player1_coins < player2_coins THEN UPDATE total_win set player2_win = player2_winner;
    	
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `top_scorer` (`player1_coin_given` INT, `player2_coin_given` INT) RETURNS VARCHAR(10) CHARSET utf8mb4  BEGIN
DECLARE player1_total INT;
DECLARE player2_total INT;
SELECT player1_coin INTO player1_total FROM total_coin;
SELECT player2_coin INTO player2_total FROM total_coin;
    IF player1_total > player2_total then 
    	UPDATE top_player SET player_name = 'Player 1';
    	RETURN 'Player 1';
    ELSE
    	UPDATE top_player SET player_name = 'Player 2';
        RETURN 'Player 2';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cars_position`
--

CREATE TABLE `cars_position` (
  `car_name` varchar(20) NOT NULL,
  `x_axis` int(11) NOT NULL,
  `y_axis` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cars_position`
--

INSERT INTO `cars_position` (`car_name`, `x_axis`, `y_axis`) VALUES
('car_1', 1260, 227),
('car_2', 380, 340);

-- --------------------------------------------------------

--
-- Table structure for table `coins_earned`
--

CREATE TABLE `coins_earned` (
  `player1_coins` int(11) NOT NULL,
  `player2_coins` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coins_earned`
--

INSERT INTO `coins_earned` (`player1_coins`, `player2_coins`) VALUES
(0, 1);

--
-- Triggers `coins_earned`
--
DELIMITER $$
CREATE TRIGGER `after_temp_coin` AFTER UPDATE ON `coins_earned` FOR EACH ROW BEGIN
	DECLARE player1_coin_pre INT;
    DECLARE player1_coins_earned INT;
    DECLARE player2_coin_pre INT;
    DECLARE player2_coins_earned INT;
    DECLARE winner VARCHAR(20);
	SELECT player1_coin into player1_coin_pre from total_coin;
    SELECT player1_coins into player1_coins_earned from coins_earned;
    SELECT player2_coin into player2_coin_pre from total_coin;
    SELECT player2_coins into player2_coins_earned from coins_earned;
    UPDATE total_coin SET player1_coin=player1_coin_pre+(player1_coins_earned/2), player2_coin=player2_coin_pre+(player2_coins_earned/2);
    CALL updateWinner(player1_coins_earned, player2_coins_earned);
    SELECT top_scorer(player1_coins_earned, player2_coins_earned) INTO winner;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `top_player`
--

CREATE TABLE `top_player` (
  `player_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `top_player`
--

INSERT INTO `top_player` (`player_name`) VALUES
('Player 2');

-- --------------------------------------------------------

--
-- Table structure for table `total_coin`
--

CREATE TABLE `total_coin` (
  `player1_coin` int(11) NOT NULL,
  `player2_coin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `total_coin`
--

INSERT INTO `total_coin` (`player1_coin`, `player2_coin`) VALUES
(17, 221);

-- --------------------------------------------------------

--
-- Table structure for table `total_win`
--

CREATE TABLE `total_win` (
  `player1_win` float NOT NULL,
  `player2_win` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `total_win`
--

INSERT INTO `total_win` (`player1_win`, `player2_win`) VALUES
(32, 40);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
