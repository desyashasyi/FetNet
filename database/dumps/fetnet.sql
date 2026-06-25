/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.8-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: fetnet
-- ------------------------------------------------------
-- Server version	11.8.8-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `bems_clients`
--

DROP TABLE IF EXISTS `bems_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bems_clients` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `expirity` varchar(255) DEFAULT NULL,
  `remain` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bems_clients_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bems_clients`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `bems_clients` WRITE;
/*!40000 ALTER TABLE `bems_clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `bems_clients` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `bems_profiles`
--

DROP TABLE IF EXISTS `bems_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bems_profiles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `contact_person` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bems_profiles_client_id_foreign` (`client_id`),
  CONSTRAINT `bems_profiles_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `bems_clients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bems_profiles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `bems_profiles` WRITE;
/*!40000 ALTER TABLE `bems_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `bems_profiles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
INSERT INTO `failed_jobs` VALUES
(1,'71eaea7d-a5b9-4962-8f5a-dda31d58b400','redis','default','{\"uuid\":\"71eaea7d-a5b9-4962-8f5a-dda31d58b400\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/subjects\\/subjects_6a2d6620c475c.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781360160,\"id\":\"71eaea7d-a5b9-4962-8f5a-dda31d58b400\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781360160.8856\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SubjectsImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#17 /var/www/app/Jobs/FetNet/SubjectsImportJob.php(29): App\\Events\\FetNet\\SubjectsImportEvent::dispatch(\'success\', \'Import done: 16...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SubjectsImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SubjectsImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-13 14:16:02'),
(2,'9e2d30d9-f47d-401d-a327-1e39261baa55','redis','default','{\"uuid\":\"9e2d30d9-f47d-401d-a327-1e39261baa55\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/teachers\\/teachers_6a2d666171156.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781360225,\"id\":\"9e2d30d9-f47d-401d-a327-1e39261baa55\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781360225.4692\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'TeachersImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#17 /var/www/app/Jobs/FetNet/TeachersImportJob.php(54): App\\Events\\FetNet\\TeachersImportEvent::dispatch(\'success\', \'Import done \\xE2\\x80\\x94...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\TeachersImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\TeachersImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-13 14:17:06'),
(3,'e008d300-fd60-429d-b40b-afcbc1a2a7f4','redis','default','{\"uuid\":\"e008d300-fd60-429d-b40b-afcbc1a2a7f4\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/teachers\\/teachers_6a2d667bcaf05.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781360251,\"id\":\"e008d300-fd60-429d-b40b-afcbc1a2a7f4\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781360251.8357\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'TeachersImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#17 /var/www/app/Jobs/FetNet/TeachersImportJob.php(54): App\\Events\\FetNet\\TeachersImportEvent::dispatch(\'success\', \'Import done \\xE2\\x80\\x94...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\TeachersImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\TeachersImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-13 14:17:32'),
(4,'82778d15-646b-4273-acf8-c6365c2a9794','redis','default','{\"uuid\":\"82778d15-646b-4273-acf8-c6365c2a9794\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/teachers\\/teachers_6a2d6c739d85b.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781361779,\"id\":\"82778d15-646b-4273-acf8-c6365c2a9794\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781361779.656\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'TeachersImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#17 /var/www/app/Jobs/FetNet/TeachersImportJob.php(54): App\\Events\\FetNet\\TeachersImportEvent::dispatch(\'success\', \'Import done \\xE2\\x80\\x94...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\TeachersImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\TeachersImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-13 14:43:00'),
(5,'5b9f794c-5fa4-4b40-adb9-d7bdf70bf0f4','redis','default','{\"uuid\":\"5b9f794c-5fa4-4b40-adb9-d7bdf70bf0f4\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/subjects\\/subjects_6a2d77b324961.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781364659,\"id\":\"5b9f794c-5fa4-4b40-adb9-d7bdf70bf0f4\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781364659.1576\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SubjectsImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#17 /var/www/app/Jobs/FetNet/SubjectsImportJob.php(29): App\\Events\\FetNet\\SubjectsImportEvent::dispatch(\'success\', \'Import done: 85...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SubjectsImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SubjectsImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-13 15:31:01'),
(6,'1a94c9c5-72d5-4d4e-a717-fde55d047ef6','redis','default','{\"uuid\":\"1a94c9c5-72d5-4d4e-a717-fde55d047ef6\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/subjects\\/subjects_6a2d7aed3541c.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781365485,\"id\":\"1a94c9c5-72d5-4d4e-a717-fde55d047ef6\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781365485.2247\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <!DOCTYPE html>\n<html lang=\"en\">\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\n        <title>Not Found</title>\n\n        <style>\n            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}code{font-family:monospace,monospace;font-size:1em}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}code{font-family:Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-gray-400{--border-opacity:1;border-color:#cbd5e0;border-color:rgba(203,213,224,var(--border-opacity))}.border-t{border-top-width:1px}.border-r{border-right-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-xl{max-width:36rem}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-4{padding-left:1rem;padding-right:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.uppercase{text-transform:uppercase}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.tracking-wider{letter-spacing:.05em}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@-webkit-keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@keyframes spin{0%{transform:rotate(0deg)}to{transform:rotate(1turn)}}@-webkit-keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@keyframes ping{0%{transform:scale(1);opacity:1}75%,to{transform:scale(2);opacity:0}}@-webkit-keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@keyframes pulse{0%,to{opacity:1}50%{opacity:.5}}@-webkit-keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@keyframes bounce{0%,to{transform:translateY(-25%);-webkit-animation-timing-function:cubic-bezier(.8,0,1,1);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:translateY(0);-webkit-animation-timing-function:cubic-bezier(0,0,.2,1);animation-timing-function:cubic-bezier(0,0,.2,1)}}@media (min-width:640px){.sm\\:rounded-lg{border-radius:.5rem}.sm\\:block{display:block}.sm\\:items-center{align-items:center}.sm\\:justify-start{justify-content:flex-start}.sm\\:justify-between{justify-content:space-between}.sm\\:h-20{height:5rem}.sm\\:ml-0{margin-left:0}.sm\\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\\:pt-0{padding-top:0}.sm\\:text-left{text-align:left}.sm\\:text-right{text-align:right}}@media (min-width:768px){.md\\:border-t-0{border-top-width:0}.md\\:border-l{border-left-width:1px}.md\\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\\:text-gray-300 { --text-opacity: 1; color: #e2e8f0; color: rgba(226,232,240,var(--text-opacity)) }}\n        </style>\n\n        <style>\n            body {\n                font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\";\n            }\n        </style>\n    </head>\n    <body class=\"antialiased\">\n        <div class=\"relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0\" role=\"main\">\n            <div class=\"max-w-xl mx-auto sm:px-6 lg:px-8\">\n                <div class=\"flex items-center pt-8 sm:justify-start sm:pt-0\">\n                    <h1 class=\"px-4 text-lg dark:text-gray-300 text-gray-700 border-r border-gray-400 tracking-wider\">\n                        404                    </h1>\n\n                    <div class=\"ml-4 text-lg dark:text-gray-300 text-gray-700 uppercase tracking-wider\">\n                        Not Found                    </div>\n                </div>\n            </div>\n        </div>\n    </body>\n</html>\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SubjectsImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#17 /var/www/app/Jobs/FetNet/SubjectsImportJob.php(29): App\\Events\\FetNet\\SubjectsImportEvent::dispatch(\'success\', \'Import done: 85...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SubjectsImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SubjectsImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable,defau...\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable,defau...\')\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#44 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#47 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#52 {main}','2026-06-13 15:44:46'),
(7,'5be245cd-9b14-4b7e-90d7-8d476bc24b2f','redis','default','{\"uuid\":\"5be245cd-9b14-4b7e-90d7-8d476bc24b2f\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\TeachersImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/teachers\\/teachers_6a323f03c622f.xlsx\\\";s:9:\\\"programId\\\";i:1;}\",\"batchId\":null},\"createdAt\":1781677827,\"id\":\"5be245cd-9b14-4b7e-90d7-8d476bc24b2f\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781677827.8367\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'TeachersImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\TeachersImportEvent))\n#17 /var/www/app/Jobs/FetNet/TeachersImportJob.php(54): App\\Events\\FetNet\\TeachersImportEvent::dispatch(\'success\', \'Import done \\xE2\\x80\\x94...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\TeachersImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\TeachersImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\TeachersImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable,defau...\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable,defau...\')\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#44 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#47 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#52 {main}','2026-06-17 06:30:28'),
(8,'64e6d990-a807-40f2-9289-c5d5c13da846','redis','default','{\"uuid\":\"64e6d990-a807-40f2-9289-c5d5c13da846\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":600,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"command\":\"O:29:\\\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\\\":3:{s:8:\\\"clientId\\\";i:1;s:10:\\\"semesterId\\\";i:1;s:6:\\\"userId\\\";i:2;}\",\"batchId\":null},\"createdAt\":1781828934,\"id\":\"64e6d990-a807-40f2-9289-c5d5c13da846\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781828934.7182\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'FetCompiledEven...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/PendingBroadcast.php(73): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(231): Illuminate\\Broadcasting\\PendingBroadcast->__destruct()\n#17 /var/www/app/Jobs/FetNet/CompileFetJob.php(66): broadcast(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\CompileFetJob->handle(Object(App\\Services\\FetNet\\FetXmlBuilder))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\CompileFetJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\CompileFetJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 00:28:56'),
(9,'1bcb4b00-b955-4b3d-a0ce-97fd2e77be2f','redis','default','{\"uuid\":\"1bcb4b00-b955-4b3d-a0ce-97fd2e77be2f\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/subjects\\/subjects_6a34963e8491e.xlsx\\\";s:9:\\\"programId\\\";i:3;}\",\"batchId\":null},\"createdAt\":1781831230,\"id\":\"1bcb4b00-b955-4b3d-a0ce-97fd2e77be2f\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781831230.5492\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SubjectsImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#17 /var/www/app/Jobs/FetNet/SubjectsImportJob.php(29): App\\Events\\FetNet\\SubjectsImportEvent::dispatch(\'success\', \'Import done: 24...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SubjectsImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SubjectsImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 01:07:10'),
(10,'3d86b961-8d01-4716-b024-19d8dd499172','redis','default','{\"uuid\":\"3d86b961-8d01-4716-b024-19d8dd499172\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":600,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"command\":\"O:29:\\\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\\\":3:{s:8:\\\"clientId\\\";i:1;s:10:\\\"semesterId\\\";i:1;s:6:\\\"userId\\\";i:2;}\",\"batchId\":null},\"createdAt\":1781844131,\"id\":\"3d86b961-8d01-4716-b024-19d8dd499172\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781844131.8415\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'FetCompiledEven...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/PendingBroadcast.php(73): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(231): Illuminate\\Broadcasting\\PendingBroadcast->__destruct()\n#17 /var/www/app/Jobs/FetNet/CompileFetJob.php(66): broadcast(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\CompileFetJob->handle(Object(App\\Services\\FetNet\\FetXmlBuilder))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\CompileFetJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\CompileFetJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable,defau...\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable,defau...\')\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#44 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#47 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#52 {main}','2026-06-19 04:42:12'),
(11,'ab8948f9-c8e4-490e-9b9c-9c4348bb55df','redis','default','{\"uuid\":\"ab8948f9-c8e4-490e-9b9c-9c4348bb55df\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":600,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\",\"command\":\"O:29:\\\"App\\\\Jobs\\\\FetNet\\\\CompileFetJob\\\":3:{s:8:\\\"clientId\\\";i:1;s:10:\\\"semesterId\\\";i:1;s:6:\\\"userId\\\";i:2;}\",\"batchId\":null},\"createdAt\":1781844393,\"id\":\"ab8948f9-c8e4-490e-9b9c-9c4348bb55df\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781844393.8483\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'FetCompiledEven...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/PendingBroadcast.php(73): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(231): Illuminate\\Broadcasting\\PendingBroadcast->__destruct()\n#17 /var/www/app/Jobs/FetNet/CompileFetJob.php(66): broadcast(Object(App\\Events\\FetNet\\FetCompiledEvent))\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\CompileFetJob->handle(Object(App\\Services\\FetNet\\FetXmlBuilder))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\CompileFetJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\CompileFetJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\CompileFetJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable,defau...\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable,defau...\')\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#44 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#47 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#52 {main}','2026-06-19 04:46:34'),
(12,'82f4fd69-8139-4de3-951b-3d72e2263fc4','redis','timetable','{\"uuid\":\"82f4fd69-8139-4de3-951b-3d72e2263fc4\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":0,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:3;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"batchId\":null},\"createdAt\":1781844397,\"id\":\"82f4fd69-8139-4de3-951b-3d72e2263fc4\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781844397.7456\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SolverLogEvent\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SolverLogEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SolverLogEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/PendingBroadcast.php(73): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SolverLogEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(231): Illuminate\\Broadcasting\\PendingBroadcast->__destruct()\n#17 /var/www/app/Jobs/FetNet/SolveTimetableJob.php(88): broadcast(Object(App\\Events\\FetNet\\SolverLogEvent))\n#18 /var/www/app/Jobs/FetNet/SolveTimetableJob.php(99): App\\Jobs\\FetNet\\SolveTimetableJob->{closure:App\\Jobs\\FetNet\\SolveTimetableJob::handle():84}(true)\n#19 /var/www/app/Jobs/FetNet/SolveTimetableJob.php(109): App\\Jobs\\FetNet\\SolveTimetableJob->{closure:App\\Jobs\\FetNet\\SolveTimetableJob::handle():93}(\'Opened file ver...\')\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SolveTimetableJob->handle()\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SolveTimetableJob))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SolveTimetableJob))\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SolveTimetableJob), false)\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SolveTimetableJob))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SolveTimetableJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SolveTimetableJob))\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#40 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#47 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#48 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#49 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#53 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#54 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#55 {main}','2026-06-19 04:46:38'),
(13,'fb4fd348-8a5d-4755-a6c0-a639b0207e62','redis','default','{\"uuid\":\"fb4fd348-8a5d-4755-a6c0-a639b0207e62\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:59;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886917,\"id\":\"fb4fd348-8a5d-4755-a6c0-a639b0207e62\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886917.3355\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(59, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:35:17'),
(14,'453beddf-a3a3-4d6a-bc4b-60746c4a3c72','redis','default','{\"uuid\":\"453beddf-a3a3-4d6a-bc4b-60746c4a3c72\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:60;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886925,\"id\":\"453beddf-a3a3-4d6a-bc4b-60746c4a3c72\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886925.4876\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(60, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:35:25'),
(15,'4a100100-c9bc-4358-afa9-9b94a980ae72','redis','default','{\"uuid\":\"4a100100-c9bc-4358-afa9-9b94a980ae72\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:61;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886933,\"id\":\"4a100100-c9bc-4358-afa9-9b94a980ae72\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886933.3905\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(61, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:35:33'),
(16,'ae491f70-f684-460a-9037-39de05d9a07f','redis','default','{\"uuid\":\"ae491f70-f684-460a-9037-39de05d9a07f\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:62;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886942,\"id\":\"ae491f70-f684-460a-9037-39de05d9a07f\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886942.3717\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(62, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:35:42'),
(17,'4c2aed9c-5f90-4561-9d56-c3e7cc93a861','redis','default','{\"uuid\":\"4c2aed9c-5f90-4561-9d56-c3e7cc93a861\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:63;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886952,\"id\":\"4c2aed9c-5f90-4561-9d56-c3e7cc93a861\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886952.9117\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(63, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:35:52'),
(18,'c7453d79-f3a6-4ec7-a7fe-ec1f93944ff8','redis','default','{\"uuid\":\"c7453d79-f3a6-4ec7-a7fe-ec1f93944ff8\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:64;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781886967,\"id\":\"c7453d79-f3a6-4ec7-a7fe-ec1f93944ff8\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781886967.8799\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(64, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:36:07'),
(19,'c5c6ec04-fad0-4c2a-9c0c-03b5f9bf9007','redis','default','{\"uuid\":\"c5c6ec04-fad0-4c2a-9c0c-03b5f9bf9007\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:65;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887033,\"id\":\"c5c6ec04-fad0-4c2a-9c0c-03b5f9bf9007\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887033.883\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(65, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:13'),
(20,'06fcedfd-c0ef-4cac-83a4-df0e75d625d7','redis','default','{\"uuid\":\"06fcedfd-c0ef-4cac-83a4-df0e75d625d7\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:66;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887040,\"id\":\"06fcedfd-c0ef-4cac-83a4-df0e75d625d7\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887040.0239\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(66, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:20'),
(21,'76190707-754c-44d4-bee8-89c315da2bc9','redis','default','{\"uuid\":\"76190707-754c-44d4-bee8-89c315da2bc9\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:67;s:8:\\\"spaceIds\\\";a:8:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:16;}}\",\"batchId\":null},\"createdAt\":1781887045,\"id\":\"76190707-754c-44d4-bee8-89c315da2bc9\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887045.0841\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(67, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:25'),
(22,'8b707f52-abcd-4cd9-bb65-f28db0a48a85','redis','default','{\"uuid\":\"8b707f52-abcd-4cd9-bb65-f28db0a48a85\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:68;s:8:\\\"spaceIds\\\";a:8:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:16;}}\",\"batchId\":null},\"createdAt\":1781887050,\"id\":\"8b707f52-abcd-4cd9-bb65-f28db0a48a85\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887050.9307\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(68, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:31'),
(23,'a396c0ea-3eae-4579-b62b-62354231129d','redis','default','{\"uuid\":\"a396c0ea-3eae-4579-b62b-62354231129d\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:69;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887056,\"id\":\"a396c0ea-3eae-4579-b62b-62354231129d\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887056.5734\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(69, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:36'),
(24,'f253c6bc-775b-49e3-8cf6-0d82653e4ea5','redis','default','{\"uuid\":\"f253c6bc-775b-49e3-8cf6-0d82653e4ea5\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:70;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887062,\"id\":\"f253c6bc-775b-49e3-8cf6-0d82653e4ea5\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887062.4397\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(70, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:42'),
(25,'46030b26-e963-4f90-816e-faa7a9e24f66','redis','default','{\"uuid\":\"46030b26-e963-4f90-816e-faa7a9e24f66\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:71;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887074,\"id\":\"46030b26-e963-4f90-816e-faa7a9e24f66\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887074.8064\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(71, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:37:54'),
(26,'67bdc96b-0b3e-4f72-91da-3a00ad47a0bc','redis','default','{\"uuid\":\"67bdc96b-0b3e-4f72-91da-3a00ad47a0bc\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:72;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887086,\"id\":\"67bdc96b-0b3e-4f72-91da-3a00ad47a0bc\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887086.3851\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(72, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:06'),
(27,'ad8d4527-f484-4adb-9d6a-f2df01888695','redis','default','{\"uuid\":\"ad8d4527-f484-4adb-9d6a-f2df01888695\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:73;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887092,\"id\":\"ad8d4527-f484-4adb-9d6a-f2df01888695\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887092.3803\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(73, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:12'),
(28,'c831006f-8af5-4c7e-b376-014e7acbd688','redis','default','{\"uuid\":\"c831006f-8af5-4c7e-b376-014e7acbd688\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:74;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887098,\"id\":\"c831006f-8af5-4c7e-b376-014e7acbd688\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887098.5838\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(74, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:18'),
(29,'89770412-de80-48c6-91dc-e293c5f54add','redis','default','{\"uuid\":\"89770412-de80-48c6-91dc-e293c5f54add\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:75;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887110,\"id\":\"89770412-de80-48c6-91dc-e293c5f54add\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887110.4185\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(75, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:30'),
(30,'e4b1e8cd-f895-4072-9793-f5d1c8badf21','redis','default','{\"uuid\":\"e4b1e8cd-f895-4072-9793-f5d1c8badf21\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:76;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887120,\"id\":\"e4b1e8cd-f895-4072-9793-f5d1c8badf21\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887120.6935\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(76, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:40'),
(31,'bfcb6d6a-cd8e-4f84-aefa-ff14a1ab6aec','redis','default','{\"uuid\":\"bfcb6d6a-cd8e-4f84-aefa-ff14a1ab6aec\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:77;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887132,\"id\":\"bfcb6d6a-cd8e-4f84-aefa-ff14a1ab6aec\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887132.4576\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(77, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:52'),
(32,'92cdae10-bdb4-47e6-aa6e-044a5ceef7e4','redis','default','{\"uuid\":\"92cdae10-bdb4-47e6-aa6e-044a5ceef7e4\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:78;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887138,\"id\":\"92cdae10-bdb4-47e6-aa6e-044a5ceef7e4\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887138.3373\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(78, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:38:58'),
(33,'dfb6bcb5-cb46-4eca-bff4-0484f2ed644a','redis','default','{\"uuid\":\"dfb6bcb5-cb46-4eca-bff4-0484f2ed644a\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:79;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887147,\"id\":\"dfb6bcb5-cb46-4eca-bff4-0484f2ed644a\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887147.3745\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(79, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:39:07'),
(34,'5366e719-6986-44f4-95e3-03648eac98f1','redis','default','{\"uuid\":\"5366e719-6986-44f4-95e3-03648eac98f1\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:80;s:8:\\\"spaceIds\\\";a:8:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:16;}}\",\"batchId\":null},\"createdAt\":1781887152,\"id\":\"5366e719-6986-44f4-95e3-03648eac98f1\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887152.3056\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(80, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:39:12'),
(35,'dd96f997-e60b-43e9-ae64-eab068d6100a','redis','default','{\"uuid\":\"dd96f997-e60b-43e9-ae64-eab068d6100a\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:81;s:8:\\\"spaceIds\\\";a:8:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:16;}}\",\"batchId\":null},\"createdAt\":1781887159,\"id\":\"dd96f997-e60b-43e9-ae64-eab068d6100a\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887159.5513\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(81, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:39:19'),
(36,'7d0aa893-968b-4706-b39d-49c4f1fce2fb','redis','default','{\"uuid\":\"7d0aa893-968b-4706-b39d-49c4f1fce2fb\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:82;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887166,\"id\":\"7d0aa893-968b-4706-b39d-49c4f1fce2fb\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887166.5849\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(82, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:39:26'),
(37,'a0c3f0a9-d1c5-437e-82cc-dde8a671c66b','redis','default','{\"uuid\":\"a0c3f0a9-d1c5-437e-82cc-dde8a671c66b\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:84;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781887192,\"id\":\"a0c3f0a9-d1c5-437e-82cc-dde8a671c66b\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887192.1791\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(84, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:39:52'),
(38,'f9725637-c7d7-4229-9a5a-eb72171ad419','redis','default','{\"uuid\":\"f9725637-c7d7-4229-9a5a-eb72171ad419\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:85;s:8:\\\"spaceIds\\\";a:8:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:16;}}\",\"batchId\":null},\"createdAt\":1781887200,\"id\":\"f9725637-c7d7-4229-9a5a-eb72171ad419\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887200.7241\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(85, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:40:00'),
(39,'fec5dd5c-3b74-4568-9e26-5a1b6da3e664','redis','default','{\"uuid\":\"fec5dd5c-3b74-4568-9e26-5a1b6da3e664\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:85;}\",\"batchId\":null},\"createdAt\":1781887204,\"id\":\"fec5dd5c-3b74-4568-9e26-5a1b6da3e664\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781887204.206\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(85, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 16:40:04'),
(40,'70c2f9fe-a9df-40e6-b372-4c5da85440d7','redis','default','{\"uuid\":\"70c2f9fe-a9df-40e6-b372-4c5da85440d7\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:67;}\",\"batchId\":null},\"createdAt\":1781888604,\"id\":\"70c2f9fe-a9df-40e6-b372-4c5da85440d7\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888604.1581\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(67, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:03:25'),
(41,'e853faa6-fc44-4915-82be-190c5efa14f5','redis','default','{\"uuid\":\"e853faa6-fc44-4915-82be-190c5efa14f5\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:68;}\",\"batchId\":null},\"createdAt\":1781888616,\"id\":\"e853faa6-fc44-4915-82be-190c5efa14f5\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888616.9235\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(68, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:03:37'),
(42,'a23e31b8-9026-4f6a-9e09-a08ee37d8f25','redis','default','{\"uuid\":\"a23e31b8-9026-4f6a-9e09-a08ee37d8f25\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:80;}\",\"batchId\":null},\"createdAt\":1781888702,\"id\":\"a23e31b8-9026-4f6a-9e09-a08ee37d8f25\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888702.4277\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(80, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:05:02'),
(43,'a0452fc5-865f-4517-afbc-cbbcdccf19ac','redis','default','{\"uuid\":\"a0452fc5-865f-4517-afbc-cbbcdccf19ac\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:80;}\",\"batchId\":null},\"createdAt\":1781888774,\"id\":\"a0452fc5-865f-4517-afbc-cbbcdccf19ac\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888774.3871\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(80, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:06:14'),
(44,'0c591393-867f-407d-9c3e-f43607ee13db','redis','default','{\"uuid\":\"0c591393-867f-407d-9c3e-f43607ee13db\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\",\"command\":\"O:46:\\\"App\\\\Jobs\\\\FetNet\\\\RemoveAllSpacesFromActivityJob\\\":1:{s:10:\\\"activityId\\\";i:81;}\",\"batchId\":null},\"createdAt\":1781888788,\"id\":\"0c591393-867f-407d-9c3e-f43607ee13db\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888788.0064\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/RemoveAllSpacesFromActivityJob.php(30): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(81, \'success\', \'All spaces remo...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\RemoveAllSpacesFromActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable,defau...\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable,defau...\')\n#38 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#44 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#45 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#47 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#52 {main}','2026-06-19 17:06:28'),
(45,'90e84af0-4d17-4c9c-bcc8-957a02352035','redis','default','{\"uuid\":\"90e84af0-4d17-4c9c-bcc8-957a02352035\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:19;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781888931,\"id\":\"90e84af0-4d17-4c9c-bcc8-957a02352035\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888931.104\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(19, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:08:51'),
(46,'e1138ad6-1c99-4b55-bad5-52ecf9e88622','redis','default','{\"uuid\":\"e1138ad6-1c99-4b55-bad5-52ecf9e88622\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":60,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\",\"command\":\"O:41:\\\"App\\\\Jobs\\\\FetNet\\\\AssignSpacesToActivityJob\\\":2:{s:10:\\\"activityId\\\";i:17;s:8:\\\"spaceIds\\\";a:8:{i:0;i:8;i:1;i:9;i:2;i:10;i:3;i:11;i:4;i:12;i:5;i:13;i:6;i:14;i:7;i:15;}}\",\"batchId\":null},\"createdAt\":1781888938,\"id\":\"e1138ad6-1c99-4b55-bad5-52ecf9e88622\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781888938.8998\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'ActivitySpacesU...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\ActivitySpacesUpdatedEvent))\n#17 /var/www/app/Jobs/FetNet/AssignSpacesToActivityJob.php(33): App\\Events\\FetNet\\ActivitySpacesUpdatedEvent::dispatch(17, \'success\', \'8 space(s) assi...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\AssignSpacesToActivityJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\AssignSpacesToActivityJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-19 17:08:58'),
(47,'99298506-9fd3-400c-ae80-70ae78c87903','redis','default','{\"uuid\":\"99298506-9fd3-400c-ae80-70ae78c87903\",\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":1,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\",\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SubjectsImportJob\\\":2:{s:8:\\\"filePath\\\";s:65:\\\"\\/var\\/www\\/storage\\/app\\/imports\\/subjects\\/subjects_6a360b89c4589.xlsx\\\";s:9:\\\"programId\\\";i:2;}\",\"batchId\":null},\"createdAt\":1781926793,\"id\":\"99298506-9fd3-400c-ae80-70ae78c87903\",\"attempts\":0,\"delay\":null,\"type\":\"job\",\"tags\":[],\"silenced\":false,\"pushedAt\":\"1781926793.8118\"}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n. in /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/Broadcasters/PusherBroadcaster.php:171\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastEvent.php(100): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'SubjectsImportE...\', Array)\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(185): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Broadcasting/BroadcastManager.php(189): Illuminate\\Broadcasting\\BroadcastManager->{closure:Illuminate\\Broadcasting\\BroadcastManager::queue():184}()\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(391): Illuminate\\Broadcasting\\BroadcastManager->queue(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(313): Illuminate\\Events\\Dispatcher->broadcastEvent(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#14 /var/www/vendor/laravel/framework/src/Illuminate/Events/Dispatcher.php(299): Illuminate\\Events\\Dispatcher->invokeListeners(\'App\\\\Events\\\\FetN...\', Array, false)\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/helpers.php(505): Illuminate\\Events\\Dispatcher->dispatch(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Events/Dispatchable.php(15): event(Object(App\\Events\\FetNet\\SubjectsImportEvent))\n#17 /var/www/app/Jobs/FetNet/SubjectsImportJob.php(36): App\\Events\\FetNet\\SubjectsImportEvent::dispatch(\'success\', \'Import done: 77...\')\n#18 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): App\\Jobs\\FetNet\\SubjectsImportJob->handle()\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#21 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#22 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#23 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#24 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Bus\\Dispatcher->{closure:Illuminate\\Bus\\Dispatcher::dispatchNow():126}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#26 /var/www/vendor/laravel/framework/src/Illuminate/Bus/Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#27 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(136): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\FetNet\\SubjectsImportJob), false)\n#28 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->{closure:Illuminate\\Queue\\CallQueuedHandler::dispatchThroughMiddleware():129}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->{closure:Illuminate\\Pipeline\\Pipeline::prepareDestination():178}(Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#30 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(129): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#31 /var/www/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(App\\Jobs\\FetNet\\SubjectsImportJob))\n#32 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#33 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(485): Illuminate\\Queue\\Jobs\\Job->fire()\n#34 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#35 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#36 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#38 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#39 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#40 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#41 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#45 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#53 {main}','2026-06-20 03:39:54'),
(48,'23d240ac-e43c-4bf6-a012-6af58aa0a17c','redis','timetable','{\"data\":{\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:75;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"batchId\":null},\"maxTries\":1,\"createdAt\":1782291438,\"failOnTimeout\":false,\"attempts\":1,\"uuid\":\"23d240ac-e43c-4bf6-a012-6af58aa0a17c\",\"timeout\":0,\"tags\":{},\"id\":\"23d240ac-e43c-4bf6-a012-6af58aa0a17c\",\"maxExceptions\":null,\"pushedAt\":\"1782291438.8368\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"type\":\"job\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times. in /var/www/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(862): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(573): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(474): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 1)\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#7 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#14 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#16 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#22 {main}','2026-06-24 08:58:54'),
(49,'d3828ed1-63fa-4336-928b-a05ce103da00','redis','timetable','{\"data\":{\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:76;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"batchId\":null},\"maxTries\":1,\"createdAt\":1782291899,\"failOnTimeout\":false,\"attempts\":1,\"uuid\":\"d3828ed1-63fa-4336-928b-a05ce103da00\",\"timeout\":0,\"tags\":{},\"id\":\"d3828ed1-63fa-4336-928b-a05ce103da00\",\"maxExceptions\":null,\"pushedAt\":\"1782291899.6756\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"type\":\"job\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times. in /var/www/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(862): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(573): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(474): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 1)\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#7 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#14 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#16 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#22 {main}','2026-06-24 09:06:32'),
(50,'8717d154-8f15-48f2-92b6-6d7d32f9b72b','redis','timetable','{\"data\":{\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:77;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"batchId\":null},\"maxTries\":1,\"createdAt\":1782335798,\"failOnTimeout\":false,\"attempts\":1,\"uuid\":\"8717d154-8f15-48f2-92b6-6d7d32f9b72b\",\"timeout\":0,\"tags\":{},\"id\":\"8717d154-8f15-48f2-92b6-6d7d32f9b72b\",\"maxExceptions\":null,\"pushedAt\":\"1782335798.5674\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"type\":\"job\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times. in /var/www/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(862): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(573): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(474): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 1)\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#7 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#14 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#16 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#22 {main}','2026-06-24 21:18:09'),
(51,'e13a8fc0-e376-439c-aa2b-da4359d9c746','redis','timetable','{\"data\":{\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:91;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"batchId\":null},\"maxTries\":1,\"createdAt\":1782337417,\"failOnTimeout\":false,\"attempts\":1,\"uuid\":\"e13a8fc0-e376-439c-aa2b-da4359d9c746\",\"timeout\":0,\"tags\":{},\"id\":\"e13a8fc0-e376-439c-aa2b-da4359d9c746\",\"maxExceptions\":null,\"pushedAt\":\"1782337417.3341\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"type\":\"job\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times. in /var/www/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(862): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(573): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(474): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 1)\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#7 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#14 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#16 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#22 {main}','2026-06-24 21:45:13'),
(52,'f7aa9d03-a87f-441f-8416-2c09179c4146','redis','timetable','{\"data\":{\"command\":\"O:33:\\\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\\\":3:{s:9:\\\"compileId\\\";i:110;s:6:\\\"userId\\\";i:2;s:5:\\\"queue\\\";s:9:\\\"timetable\\\";}\",\"commandName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\",\"batchId\":null},\"maxTries\":1,\"createdAt\":1782357175,\"failOnTimeout\":false,\"attempts\":1,\"uuid\":\"f7aa9d03-a87f-441f-8416-2c09179c4146\",\"timeout\":0,\"tags\":{},\"id\":\"f7aa9d03-a87f-441f-8416-2c09179c4146\",\"maxExceptions\":null,\"pushedAt\":\"1782357175.0454\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"type\":\"job\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"displayName\":\"App\\\\Jobs\\\\FetNet\\\\SolveTimetableJob\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times. in /var/www/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(862): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(573): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(474): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 1)\n#3 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(435): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(201): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'redis\', \'timetable\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'timetable\')\n#7 /var/www/vendor/laravel/horizon/src/Console/WorkCommand.php(52): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Laravel\\Horizon\\Console\\WorkCommand->handle()\n#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::{closure:Illuminate\\Container\\BoundMethod::call():35}()\n#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#13 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#14 /var/www/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#16 /var/www/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Laravel\\Horizon\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#22 {main}','2026-06-25 03:14:32');
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_academic_year`
--

DROP TABLE IF EXISTS `fetnet_academic_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_academic_year` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `year_start` smallint(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_academic_year_client_id_year_start_unique` (`client_id`,`year_start`),
  CONSTRAINT `fetnet_academic_year_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_academic_year`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_academic_year` WRITE;
/*!40000 ALTER TABLE `fetnet_academic_year` DISABLE KEYS */;
INSERT INTO `fetnet_academic_year` VALUES
(1,1,2026,0,'2026-06-12 06:14:40','2026-06-12 06:14:40');
/*!40000 ALTER TABLE `fetnet_academic_year` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity`
--

DROP TABLE IF EXISTS `fetnet_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `planning_id` bigint(20) unsigned DEFAULT NULL,
  `type_id` bigint(20) unsigned DEFAULT NULL,
  `duration` tinyint(4) NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_activity_program_id_foreign` (`program_id`),
  KEY `fetnet_activity_type_id_foreign` (`type_id`),
  KEY `fetnet_activity_planning_id_foreign` (`planning_id`),
  CONSTRAINT `fetnet_activity_planning_id_foreign` FOREIGN KEY (`planning_id`) REFERENCES `fetnet_activity_planning` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `fetnet_activity_type` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity` WRITE;
/*!40000 ALTER TABLE `fetnet_activity` DISABLE KEYS */;
INSERT INTO `fetnet_activity` VALUES
(1,1,1,1,3,1,'2026-06-13 14:59:11','2026-06-13 14:50:05','2026-06-13 14:59:11'),
(2,1,1,1,3,1,'2026-06-13 14:59:11','2026-06-13 14:51:18','2026-06-13 14:59:11'),
(3,1,3,1,3,1,NULL,'2026-06-13 14:53:34','2026-06-21 05:54:23'),
(4,1,3,1,3,1,NULL,'2026-06-13 14:53:49','2026-06-13 15:54:20'),
(5,1,10,1,3,1,NULL,'2026-06-13 14:56:49','2026-06-13 15:54:31'),
(6,1,10,1,3,1,NULL,'2026-06-13 14:57:32','2026-06-21 05:54:33'),
(7,1,4,1,3,1,NULL,'2026-06-13 14:58:21','2026-06-13 15:54:49'),
(8,1,4,1,3,1,NULL,'2026-06-13 14:58:35','2026-06-13 15:54:49'),
(9,1,11,1,3,1,NULL,'2026-06-13 14:59:26','2026-06-13 15:55:07'),
(10,1,11,1,3,1,NULL,'2026-06-13 14:59:38','2026-06-13 15:55:07'),
(11,1,5,1,3,1,NULL,'2026-06-13 15:00:04','2026-06-13 15:56:17'),
(12,1,5,1,3,1,NULL,'2026-06-13 15:00:24','2026-06-13 15:56:17'),
(13,1,81,1,3,1,'2026-06-19 06:07:55','2026-06-13 16:04:52','2026-06-19 06:07:55'),
(14,1,81,1,3,1,'2026-06-14 04:32:53','2026-06-13 16:05:05','2026-06-14 04:32:53'),
(15,1,84,2,2,1,'2026-06-19 06:21:28','2026-06-13 16:05:22','2026-06-19 06:21:28'),
(16,1,84,2,2,1,'2026-06-14 04:31:50','2026-06-13 16:05:37','2026-06-14 04:31:50'),
(17,1,31,1,3,1,'2026-06-22 23:38:33','2026-06-13 16:40:03','2026-06-22 23:38:33'),
(18,1,82,1,3,1,'2026-06-19 06:09:57','2026-06-14 01:46:31','2026-06-19 06:09:57'),
(19,1,22,1,2,1,NULL,'2026-06-14 04:33:54','2026-06-14 04:33:54'),
(20,1,20,1,3,1,NULL,'2026-06-14 04:34:22','2026-06-14 04:34:22'),
(21,1,81,1,3,1,'2026-06-19 06:08:11','2026-06-14 04:37:04','2026-06-19 06:08:11'),
(22,1,84,1,2,1,'2026-06-19 06:21:35','2026-06-14 04:38:54','2026-06-19 06:21:35'),
(23,1,82,1,3,1,'2026-06-19 06:10:08','2026-06-14 04:39:35','2026-06-19 06:10:08'),
(24,1,22,1,2,1,NULL,'2026-06-14 09:43:21','2026-06-14 09:43:21'),
(25,1,20,1,3,1,NULL,'2026-06-14 09:43:52','2026-06-14 09:43:52'),
(26,1,59,1,2,1,NULL,'2026-06-14 09:44:19','2026-06-14 09:44:19'),
(27,1,59,1,2,1,NULL,'2026-06-14 09:44:49','2026-06-14 09:44:49'),
(28,1,21,2,2,1,NULL,'2026-06-14 09:45:11','2026-06-19 11:49:26'),
(29,1,21,2,2,1,NULL,'2026-06-14 09:45:34','2026-06-19 11:49:42'),
(30,1,60,1,3,1,'2026-06-22 00:21:44','2026-06-14 09:47:18','2026-06-22 00:21:44'),
(31,1,85,2,2,1,'2026-06-22 00:07:58','2026-06-14 09:47:40','2026-06-22 00:07:58'),
(32,1,26,1,2,1,NULL,'2026-06-14 09:48:30','2026-06-14 09:48:30'),
(33,1,32,1,2,1,NULL,'2026-06-14 09:48:54','2026-06-14 09:48:54'),
(34,1,61,1,2,1,NULL,'2026-06-14 09:49:17','2026-06-14 09:49:17'),
(35,1,63,1,3,1,NULL,'2026-06-14 09:49:38','2026-06-14 09:49:38'),
(36,1,62,1,3,1,NULL,'2026-06-14 09:49:54','2026-06-14 09:49:54'),
(37,1,33,1,2,1,NULL,'2026-06-17 01:57:49','2026-06-17 01:57:49'),
(38,1,35,1,2,1,NULL,'2026-06-17 06:52:51','2026-06-17 06:52:51'),
(39,1,34,1,2,1,NULL,'2026-06-19 03:03:27','2026-06-19 03:03:27'),
(40,1,36,1,2,1,NULL,'2026-06-19 03:04:55','2026-06-19 03:04:55'),
(41,1,37,1,2,1,NULL,'2026-06-19 03:06:02','2026-06-19 03:06:02'),
(42,1,38,1,3,1,NULL,'2026-06-19 03:06:49','2026-06-19 03:06:49'),
(43,1,39,1,2,1,NULL,'2026-06-19 03:07:22','2026-06-19 03:07:22'),
(44,1,40,1,2,1,NULL,'2026-06-19 03:11:25','2026-06-19 03:11:25'),
(45,1,41,NULL,3,1,NULL,'2026-06-19 03:13:05','2026-06-19 03:13:05'),
(46,1,85,2,2,1,'2026-06-22 00:08:03','2026-06-19 05:55:11','2026-06-22 00:08:03'),
(47,1,15,1,3,1,NULL,'2026-06-19 06:16:24','2026-06-19 06:16:24'),
(48,1,15,1,3,1,NULL,'2026-06-19 06:16:49','2026-06-19 06:16:49'),
(49,3,86,1,4,1,NULL,'2026-06-19 07:41:22','2026-06-19 07:41:22'),
(50,3,86,1,4,1,NULL,'2026-06-19 07:41:50','2026-06-19 07:41:50'),
(51,1,84,2,2,1,'2026-06-21 23:22:02','2026-06-19 08:32:14','2026-06-21 23:22:02'),
(52,1,84,2,2,1,'2026-06-21 23:22:10','2026-06-19 08:32:57','2026-06-21 23:22:10'),
(53,1,61,2,2,1,NULL,'2026-06-19 11:51:27','2026-06-19 11:51:27'),
(54,1,42,1,2,1,NULL,'2026-06-19 13:18:22','2026-06-19 13:18:22'),
(55,1,54,1,2,1,NULL,'2026-06-19 13:19:33','2026-06-19 13:19:33'),
(56,1,56,1,2,1,NULL,'2026-06-19 13:20:05','2026-06-19 13:20:05'),
(57,1,57,1,2,1,'2026-06-21 04:43:55','2026-06-19 13:20:25','2026-06-21 04:43:55'),
(58,1,45,1,2,1,NULL,'2026-06-19 13:21:58','2026-06-19 13:21:58'),
(59,3,89,1,3,1,NULL,'2026-06-19 13:41:58','2026-06-19 13:41:58'),
(60,3,89,1,3,1,NULL,'2026-06-19 13:42:17','2026-06-19 13:42:17'),
(61,3,87,1,4,1,NULL,'2026-06-19 13:42:42','2026-06-19 13:42:42'),
(62,3,87,1,4,1,NULL,'2026-06-19 13:42:59','2026-06-19 13:42:59'),
(63,3,88,1,3,1,NULL,'2026-06-19 13:43:34','2026-06-19 13:43:34'),
(64,3,88,1,3,1,NULL,'2026-06-19 13:43:48','2026-06-19 13:43:48'),
(65,3,90,1,3,1,NULL,'2026-06-19 13:50:16','2026-06-19 13:50:16'),
(66,3,90,1,3,1,NULL,'2026-06-19 13:50:34','2026-06-19 13:50:34'),
(67,3,91,2,4,1,NULL,'2026-06-19 13:51:02','2026-06-19 13:51:02'),
(68,3,91,2,4,1,NULL,'2026-06-19 13:51:17','2026-06-19 13:51:17'),
(69,3,92,1,3,1,NULL,'2026-06-19 13:52:05','2026-06-19 13:52:05'),
(70,3,92,1,3,1,NULL,'2026-06-19 13:52:20','2026-06-19 13:52:20'),
(71,3,93,1,3,1,NULL,'2026-06-19 14:00:25','2026-06-19 14:00:25'),
(72,3,93,1,3,1,NULL,'2026-06-19 14:00:46','2026-06-19 14:00:46'),
(73,3,94,1,3,1,NULL,'2026-06-19 14:03:42','2026-06-19 14:03:42'),
(74,3,94,1,3,1,NULL,'2026-06-19 14:04:05','2026-06-19 14:04:05'),
(75,3,95,1,3,1,NULL,'2026-06-19 14:47:45','2026-06-19 14:47:45'),
(76,3,98,1,4,1,NULL,'2026-06-19 14:48:09','2026-06-19 14:48:09'),
(77,3,99,1,3,1,NULL,'2026-06-19 14:48:31','2026-06-19 14:48:31'),
(78,3,100,1,3,1,NULL,'2026-06-19 14:48:57','2026-06-19 14:48:57'),
(79,3,97,1,4,1,NULL,'2026-06-19 14:49:17','2026-06-19 14:49:17'),
(80,3,96,2,4,1,NULL,'2026-06-19 14:49:34','2026-06-19 14:49:34'),
(81,3,96,2,4,1,'2026-06-23 00:07:29','2026-06-19 14:51:38','2026-06-23 00:07:29'),
(82,3,101,1,3,1,NULL,'2026-06-19 14:52:26','2026-06-19 14:52:26'),
(83,3,102,2,2,1,NULL,'2026-06-19 14:52:45','2026-06-19 14:52:45'),
(84,3,103,1,2,1,NULL,'2026-06-19 14:53:03','2026-06-19 14:53:03'),
(85,3,105,2,3,1,NULL,'2026-06-19 14:53:48','2026-06-19 14:53:48'),
(86,2,106,2,3,1,NULL,'2026-06-20 04:21:21','2026-06-20 04:21:21'),
(87,2,106,2,3,1,NULL,'2026-06-20 04:25:40','2026-06-20 04:25:40'),
(88,2,107,1,3,1,NULL,'2026-06-20 11:45:10','2026-06-20 11:45:10'),
(89,2,107,1,3,1,NULL,'2026-06-20 11:45:32','2026-06-20 11:45:32'),
(90,2,119,1,3,1,NULL,'2026-06-21 04:34:23','2026-06-21 04:34:23'),
(91,2,119,1,3,1,NULL,'2026-06-21 04:34:54','2026-06-21 04:34:54'),
(92,2,123,1,3,1,NULL,'2026-06-21 04:35:46','2026-06-21 04:35:46'),
(93,2,123,1,3,1,NULL,'2026-06-21 04:36:13','2026-06-21 04:36:13'),
(94,1,49,1,2,1,NULL,'2026-06-21 16:41:10','2026-06-21 16:41:10'),
(95,1,16,1,3,1,NULL,'2026-06-21 23:43:19','2026-06-21 23:43:19'),
(96,1,16,1,3,1,NULL,'2026-06-21 23:43:52','2026-06-21 23:43:52'),
(97,1,25,1,2,1,NULL,'2026-06-22 00:11:55','2026-06-22 00:11:55'),
(98,1,171,1,2,1,NULL,'2026-06-22 00:32:18','2026-06-22 00:32:18'),
(99,2,109,1,2,1,NULL,'2026-06-22 00:34:38','2026-06-22 00:34:38'),
(100,2,109,1,2,1,NULL,'2026-06-22 00:42:17','2026-06-22 00:42:17'),
(101,2,151,1,2,1,NULL,'2026-06-22 07:41:13','2026-06-22 07:41:13'),
(102,4,172,1,4,1,NULL,'2026-06-22 08:13:12','2026-06-22 08:13:12'),
(103,4,172,1,4,1,NULL,'2026-06-22 08:13:30','2026-06-22 08:13:30'),
(104,4,173,1,4,1,NULL,'2026-06-22 08:14:39','2026-06-22 08:14:39'),
(105,4,173,1,4,1,NULL,'2026-06-22 23:08:03','2026-06-22 23:08:03'),
(106,4,174,1,4,1,NULL,'2026-06-22 23:08:51','2026-06-22 23:08:51'),
(107,4,174,1,4,1,NULL,'2026-06-22 23:09:12','2026-06-22 23:09:12'),
(108,4,175,1,4,1,NULL,'2026-06-22 23:09:39','2026-06-22 23:09:39'),
(109,4,175,1,4,1,NULL,'2026-06-22 23:10:00','2026-06-22 23:10:00'),
(110,4,176,1,3,1,NULL,'2026-06-22 23:10:58','2026-06-22 23:10:58'),
(111,4,176,1,3,1,NULL,'2026-06-22 23:11:17','2026-06-22 23:11:17'),
(112,4,177,1,3,1,NULL,'2026-06-22 23:12:22','2026-06-22 23:12:22'),
(113,4,177,1,3,1,NULL,'2026-06-22 23:20:13','2026-06-22 23:20:13'),
(114,4,178,1,4,1,NULL,'2026-06-22 23:21:35','2026-06-22 23:21:35'),
(115,4,178,1,4,1,NULL,'2026-06-22 23:22:04','2026-06-22 23:22:04'),
(116,4,179,1,3,1,NULL,'2026-06-22 23:22:33','2026-06-22 23:22:33'),
(117,4,179,1,3,1,NULL,'2026-06-22 23:22:51','2026-06-22 23:22:51'),
(118,4,180,1,3,1,NULL,'2026-06-22 23:23:24','2026-06-22 23:23:24'),
(119,4,180,1,3,1,NULL,'2026-06-22 23:24:10','2026-06-22 23:24:10'),
(120,4,181,1,3,1,NULL,'2026-06-22 23:24:46','2026-06-22 23:24:46'),
(121,4,181,1,3,1,NULL,'2026-06-22 23:25:16','2026-06-22 23:25:16'),
(122,4,182,1,3,1,NULL,'2026-06-22 23:25:48','2026-06-22 23:25:48'),
(123,4,182,1,3,1,NULL,'2026-06-22 23:26:05','2026-06-22 23:26:05'),
(124,4,183,1,4,1,NULL,'2026-06-22 23:26:45','2026-06-22 23:26:45'),
(125,4,184,1,3,1,NULL,'2026-06-22 23:27:06','2026-06-22 23:27:06'),
(126,4,185,1,3,1,NULL,'2026-06-22 23:30:51','2026-06-22 23:30:51'),
(127,4,186,1,3,1,NULL,'2026-06-22 23:31:24','2026-06-22 23:31:24'),
(128,4,187,1,4,1,NULL,'2026-06-22 23:31:59','2026-06-22 23:31:59'),
(129,1,31,1,3,1,NULL,'2026-06-22 23:39:07','2026-06-22 23:39:07'),
(130,2,108,1,2,1,NULL,'2026-06-22 23:41:40','2026-06-22 23:41:40'),
(131,2,108,1,2,1,NULL,'2026-06-22 23:42:04','2026-06-22 23:42:04'),
(132,2,111,1,3,1,NULL,'2026-06-22 23:42:27','2026-06-22 23:42:27'),
(133,2,111,1,3,1,NULL,'2026-06-22 23:42:47','2026-06-22 23:42:47'),
(134,2,120,1,2,1,NULL,'2026-06-22 23:43:38','2026-06-22 23:43:38'),
(135,2,120,1,2,1,NULL,'2026-06-22 23:44:51','2026-06-22 23:44:51'),
(136,2,141,1,3,1,NULL,'2026-06-22 23:45:35','2026-06-22 23:45:35'),
(137,2,143,1,2,1,NULL,'2026-06-22 23:46:04','2026-06-22 23:46:04'),
(138,2,145,1,2,1,NULL,'2026-06-22 23:46:27','2026-06-22 23:46:27'),
(139,3,188,2,4,1,NULL,'2026-06-23 00:06:37','2026-06-23 00:19:44'),
(140,2,110,1,3,1,NULL,'2026-06-23 00:16:33','2026-06-23 00:16:33'),
(141,3,104,1,3,1,NULL,'2026-06-23 00:18:20','2026-06-23 00:18:20'),
(142,2,110,1,3,1,NULL,'2026-06-23 00:35:36','2026-06-23 00:35:36'),
(143,2,122,1,3,1,NULL,'2026-06-23 00:36:28','2026-06-23 00:36:28'),
(144,2,122,1,3,1,NULL,'2026-06-23 00:36:54','2026-06-23 00:36:54'),
(145,2,121,1,2,1,NULL,'2026-06-23 02:26:27','2026-06-23 02:26:27'),
(146,1,47,1,2,1,NULL,'2026-06-23 03:22:34','2026-06-23 03:22:34'),
(147,2,118,1,3,1,'2026-06-25 00:44:54','2026-06-23 03:39:40','2026-06-25 00:44:54'),
(148,2,118,1,3,1,'2026-06-25 00:44:54','2026-06-23 03:40:47','2026-06-25 00:44:54'),
(149,2,142,1,2,1,NULL,'2026-06-23 03:43:11','2026-06-23 03:43:11'),
(150,2,142,1,2,1,'2026-06-24 06:24:24','2026-06-23 03:43:58','2026-06-24 06:24:24'),
(151,2,140,2,3,1,NULL,'2026-06-23 04:19:04','2026-06-23 04:19:04'),
(152,2,144,1,3,1,NULL,'2026-06-23 07:36:36','2026-06-23 07:36:36'),
(153,1,48,1,3,1,NULL,'2026-06-23 23:47:04','2026-06-23 23:47:04'),
(154,1,50,1,3,1,'2026-06-24 05:00:53','2026-06-23 23:47:33','2026-06-24 05:00:53'),
(155,1,46,1,3,1,NULL,'2026-06-24 03:46:59','2026-06-24 03:46:59'),
(156,1,58,1,2,1,NULL,'2026-06-24 04:14:40','2026-06-24 04:14:40'),
(157,2,150,1,3,1,NULL,'2026-06-24 05:29:09','2026-06-24 05:29:09'),
(158,2,121,1,2,1,NULL,'2026-06-24 06:18:17','2026-06-24 06:18:17'),
(159,2,146,1,2,1,NULL,'2026-06-24 06:34:48','2026-06-24 06:34:48'),
(160,2,147,1,3,1,NULL,'2026-06-24 06:39:06','2026-06-24 06:39:06'),
(161,2,149,2,2,1,NULL,'2026-06-24 06:53:54','2026-06-24 06:53:54'),
(162,2,148,2,2,1,NULL,'2026-06-24 06:56:10','2026-06-24 06:56:10'),
(163,2,152,1,2,1,NULL,'2026-06-24 06:56:56','2026-06-24 06:56:56'),
(164,2,163,1,4,1,'2026-06-24 08:56:25','2026-06-24 08:20:49','2026-06-24 08:56:25'),
(165,2,167,1,3,1,NULL,'2026-06-24 08:21:48','2026-06-24 08:21:48'),
(166,2,166,1,2,1,NULL,'2026-06-24 08:22:15','2026-06-24 08:22:15'),
(167,2,169,1,2,1,NULL,'2026-06-24 08:23:03','2026-06-24 08:23:03'),
(168,2,170,1,2,1,NULL,'2026-06-24 08:23:29','2026-06-24 08:23:29'),
(169,2,168,1,2,1,NULL,'2026-06-24 08:48:33','2026-06-24 08:48:33');
/*!40000 ALTER TABLE `fetnet_activity` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_planning`
--

DROP TABLE IF EXISTS `fetnet_activity_planning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_planning` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint(20) unsigned NOT NULL,
  `program_id` bigint(20) unsigned NOT NULL,
  `semester_id` bigint(20) unsigned NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fap_subject_program_semester_unique` (`subject_id`,`program_id`,`semester_id`),
  KEY `fetnet_activity_planning_program_id_foreign` (`program_id`),
  KEY `fetnet_activity_planning_semester_id_foreign` (`semester_id`),
  CONSTRAINT `fetnet_activity_planning_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_planning_semester_id_foreign` FOREIGN KEY (`semester_id`) REFERENCES `fetnet_semester` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_planning_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `fetnet_subject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_planning`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_planning` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_planning` DISABLE KEYS */;
INSERT INTO `fetnet_activity_planning` VALUES
(1,1,1,1,'2026-06-13 14:59:11','2026-06-13 14:48:57','2026-06-13 14:59:11'),
(2,2,1,1,'2026-06-13 14:53:05','2026-06-13 14:48:57','2026-06-13 14:53:05'),
(3,3,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 15:54:20'),
(4,4,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 15:54:49'),
(5,5,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 15:56:17'),
(6,6,1,1,'2026-06-13 15:01:00','2026-06-13 14:48:57','2026-06-13 15:01:00'),
(7,7,1,1,'2026-06-13 15:31:37','2026-06-13 14:48:57','2026-06-13 15:31:37'),
(8,8,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(9,9,1,1,'2026-06-13 15:02:17','2026-06-13 14:48:57','2026-06-13 15:02:17'),
(10,12,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 15:54:31'),
(11,13,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 15:55:07'),
(12,19,1,1,'2026-06-13 15:24:43','2026-06-13 14:48:57','2026-06-13 15:24:43'),
(13,20,1,1,'2026-06-13 15:32:21','2026-06-13 14:48:57','2026-06-13 15:32:21'),
(14,21,1,1,'2026-06-13 15:26:33','2026-06-13 14:48:57','2026-06-13 15:26:33'),
(15,22,1,1,NULL,'2026-06-13 14:48:57','2026-06-19 06:11:15'),
(16,23,1,1,NULL,'2026-06-13 14:48:57','2026-06-21 23:41:11'),
(17,24,1,1,'2026-06-13 15:28:23','2026-06-13 14:48:57','2026-06-13 15:28:23'),
(18,25,1,1,'2026-06-13 15:32:36','2026-06-13 14:48:57','2026-06-13 15:32:36'),
(19,28,1,1,'2026-06-13 15:26:50','2026-06-13 14:48:57','2026-06-13 15:26:50'),
(20,29,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:10:19'),
(21,33,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:20:51'),
(22,35,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:10:02'),
(23,36,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(24,37,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(25,38,1,1,NULL,'2026-06-13 14:48:57','2026-06-22 00:10:50'),
(26,39,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:27'),
(27,40,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(28,41,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(29,42,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(30,43,1,1,'2026-06-13 15:44:32','2026-06-13 14:48:57','2026-06-13 15:44:32'),
(31,47,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:21'),
(32,48,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:29'),
(33,62,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:27'),
(34,63,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:29'),
(35,64,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:31'),
(36,65,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:32'),
(37,66,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:34'),
(38,67,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:35'),
(39,68,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:36'),
(40,69,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:37'),
(41,70,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:39'),
(42,71,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:40'),
(43,72,1,1,'2026-06-23 03:11:28','2026-06-13 14:48:57','2026-06-23 03:11:28'),
(44,73,1,1,NULL,'2026-06-13 14:48:57','2026-06-24 02:47:53'),
(45,74,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:45'),
(46,75,1,1,NULL,'2026-06-13 14:48:57','2026-06-24 02:47:59'),
(47,76,1,1,NULL,'2026-06-13 14:48:57','2026-06-22 00:47:26'),
(48,77,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:48'),
(49,78,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:49'),
(50,79,1,1,'2026-06-24 05:01:37','2026-06-13 14:48:57','2026-06-24 05:01:37'),
(51,80,1,1,'2026-06-23 03:12:41','2026-06-13 14:48:57','2026-06-23 03:12:41'),
(52,81,1,1,'2026-06-23 03:23:08','2026-06-13 14:48:57','2026-06-23 03:23:08'),
(53,82,1,1,'2026-06-23 03:24:25','2026-06-13 14:48:57','2026-06-23 03:24:25'),
(54,83,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:50:58'),
(55,84,1,1,'2026-06-23 03:24:55','2026-06-13 14:48:57','2026-06-23 03:24:55'),
(56,85,1,1,NULL,'2026-06-13 14:48:57','2026-06-17 01:51:00'),
(57,86,1,1,'2026-06-21 04:44:16','2026-06-13 14:48:57','2026-06-21 04:44:16'),
(58,87,1,1,NULL,'2026-06-13 14:48:57','2026-06-24 04:10:12'),
(59,99,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:19:57'),
(60,108,1,1,'2026-06-22 00:21:58','2026-06-13 14:48:57','2026-06-22 00:21:58'),
(61,109,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:32'),
(62,110,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:34'),
(63,111,1,1,NULL,'2026-06-13 14:48:57','2026-06-13 16:21:36'),
(64,116,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(65,117,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(66,123,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(67,124,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(68,125,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(69,126,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(70,127,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(71,133,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(72,134,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(73,135,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(74,141,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(75,142,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(76,143,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(77,144,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(78,145,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(79,146,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(80,147,1,1,'2026-06-13 15:44:33','2026-06-13 14:48:57','2026-06-13 15:44:33'),
(81,95,1,1,'2026-06-19 06:10:48','2026-06-13 15:23:32','2026-06-19 06:10:48'),
(82,98,1,1,'2026-06-19 06:10:51','2026-06-13 15:23:42','2026-06-19 06:10:51'),
(83,94,1,1,'2026-06-13 15:44:33','2026-06-13 15:23:47','2026-06-13 15:44:33'),
(84,96,1,1,'2026-06-21 23:26:26','2026-06-13 16:00:11','2026-06-21 23:26:26'),
(85,104,1,1,'2026-06-22 00:08:13','2026-06-13 16:21:15','2026-06-22 00:08:13'),
(86,178,3,1,NULL,'2026-06-19 07:40:26','2026-06-19 07:40:26'),
(87,180,3,1,NULL,'2026-06-19 07:40:27','2026-06-19 07:40:27'),
(88,179,3,1,NULL,'2026-06-19 07:40:29','2026-06-19 07:40:29'),
(89,177,3,1,NULL,'2026-06-19 07:40:31','2026-06-19 07:40:31'),
(90,173,3,1,NULL,'2026-06-19 13:45:34','2026-06-19 13:45:34'),
(91,175,3,1,NULL,'2026-06-19 13:45:40','2026-06-19 13:45:40'),
(92,174,3,1,NULL,'2026-06-19 13:45:55','2026-06-19 13:45:55'),
(93,176,3,1,NULL,'2026-06-19 13:59:53','2026-06-19 13:59:53'),
(94,172,3,1,NULL,'2026-06-19 14:03:17','2026-06-19 14:03:17'),
(95,171,3,1,NULL,'2026-06-19 14:08:45','2026-06-19 14:08:45'),
(96,166,3,1,NULL,'2026-06-19 14:09:00','2026-06-19 14:09:00'),
(97,167,3,1,NULL,'2026-06-19 14:09:11','2026-06-19 14:09:11'),
(98,168,3,1,NULL,'2026-06-19 14:09:19','2026-06-19 14:09:19'),
(99,170,3,1,NULL,'2026-06-19 14:09:25','2026-06-19 14:09:25'),
(100,169,3,1,NULL,'2026-06-19 14:09:26','2026-06-19 14:09:26'),
(101,158,3,1,NULL,'2026-06-19 14:51:53','2026-06-19 14:51:53'),
(102,162,3,1,NULL,'2026-06-19 14:51:54','2026-06-19 14:51:54'),
(103,163,3,1,NULL,'2026-06-19 14:51:55','2026-06-19 14:51:55'),
(104,164,3,1,NULL,'2026-06-19 14:51:56','2026-06-19 14:51:56'),
(105,165,3,1,NULL,'2026-06-19 14:51:57','2026-06-19 14:51:57'),
(106,198,2,1,NULL,'2026-06-20 03:53:52','2026-06-20 03:53:52'),
(107,196,2,1,NULL,'2026-06-20 03:53:54','2026-06-20 03:53:54'),
(108,197,2,1,NULL,'2026-06-20 03:53:56','2026-06-20 03:53:56'),
(109,199,2,1,NULL,'2026-06-20 03:53:57','2026-06-20 03:53:57'),
(110,200,2,1,NULL,'2026-06-20 03:53:58','2026-06-20 03:53:58'),
(111,195,2,1,NULL,'2026-06-20 03:54:02','2026-06-20 03:54:02'),
(112,201,2,1,'2026-06-20 03:55:49','2026-06-20 03:54:03','2026-06-20 03:55:49'),
(113,202,2,1,'2026-06-20 03:55:50','2026-06-20 03:54:05','2026-06-20 03:55:50'),
(114,203,2,1,'2026-06-20 03:55:51','2026-06-20 03:54:09','2026-06-20 03:55:51'),
(115,204,2,1,'2026-06-20 03:55:51','2026-06-20 03:54:10','2026-06-20 03:55:51'),
(116,190,2,1,'2026-06-20 03:55:52','2026-06-20 03:54:12','2026-06-20 03:55:52'),
(117,183,2,1,'2026-06-20 03:54:14','2026-06-20 03:54:13','2026-06-20 03:54:14'),
(118,257,2,1,'2026-06-25 00:44:54','2026-06-20 03:54:26','2026-06-25 00:44:54'),
(119,205,2,1,NULL,'2026-06-20 03:54:28','2026-06-20 03:54:28'),
(120,206,2,1,NULL,'2026-06-20 03:54:29','2026-06-20 03:54:29'),
(121,208,2,1,NULL,'2026-06-20 03:54:33','2026-06-20 03:54:33'),
(122,207,2,1,NULL,'2026-06-20 03:54:34','2026-06-20 03:54:34'),
(123,191,2,1,NULL,'2026-06-20 03:54:36','2026-06-20 03:54:36'),
(124,186,2,1,'2026-06-20 03:57:11','2026-06-20 03:54:37','2026-06-20 03:57:11'),
(125,192,2,1,'2026-06-20 03:56:04','2026-06-20 03:54:41','2026-06-20 03:56:04'),
(126,193,2,1,'2026-06-20 03:56:05','2026-06-20 03:54:44','2026-06-20 03:56:05'),
(127,221,2,1,'2026-06-20 03:56:06','2026-06-20 03:54:45','2026-06-20 03:56:06'),
(128,209,2,1,'2026-06-20 03:56:06','2026-06-20 03:54:46','2026-06-20 03:56:06'),
(129,210,2,1,'2026-06-20 03:56:07','2026-06-20 03:54:47','2026-06-20 03:56:07'),
(130,211,2,1,'2026-06-20 03:56:07','2026-06-20 03:54:51','2026-06-20 03:56:07'),
(131,222,2,1,'2026-06-20 03:56:08','2026-06-20 03:54:52','2026-06-20 03:56:08'),
(132,224,2,1,'2026-06-20 03:56:09','2026-06-20 03:54:57','2026-06-20 03:56:09'),
(133,240,2,1,'2026-06-20 03:56:10','2026-06-20 03:54:59','2026-06-20 03:56:10'),
(134,241,2,1,'2026-06-20 03:56:11','2026-06-20 03:55:00','2026-06-20 03:56:11'),
(135,242,2,1,'2026-06-20 03:56:15','2026-06-20 03:55:01','2026-06-20 03:56:15'),
(136,239,2,1,'2026-06-20 03:56:15','2026-06-20 03:55:02','2026-06-20 03:56:15'),
(137,223,2,1,'2026-06-20 03:56:16','2026-06-20 03:55:03','2026-06-20 03:56:16'),
(138,188,2,1,'2026-06-20 03:56:17','2026-06-20 03:55:04','2026-06-20 03:56:17'),
(139,212,2,1,'2026-06-22 07:20:06','2026-06-20 03:55:06','2026-06-22 07:20:06'),
(140,246,2,1,NULL,'2026-06-20 03:55:12','2026-06-20 03:55:12'),
(141,194,2,1,NULL,'2026-06-20 03:55:13','2026-06-20 03:55:13'),
(142,213,2,1,NULL,'2026-06-20 03:55:14','2026-06-20 03:55:14'),
(143,214,2,1,NULL,'2026-06-20 03:55:15','2026-06-20 03:55:15'),
(144,226,2,1,NULL,'2026-06-20 03:55:16','2026-06-20 03:55:16'),
(145,229,2,1,NULL,'2026-06-20 03:55:17','2026-06-20 03:55:17'),
(146,225,2,1,NULL,'2026-06-20 03:55:18','2026-06-20 03:55:18'),
(147,228,2,1,NULL,'2026-06-20 03:55:20','2026-06-20 03:55:20'),
(148,227,2,1,NULL,'2026-06-20 03:55:20','2026-06-20 03:55:20'),
(149,243,2,1,NULL,'2026-06-20 03:55:21','2026-06-20 03:55:21'),
(150,245,2,1,NULL,'2026-06-20 03:55:24','2026-06-20 03:55:24'),
(151,247,2,1,NULL,'2026-06-20 03:55:25','2026-06-20 03:55:25'),
(152,244,2,1,NULL,'2026-06-20 03:55:25','2026-06-20 03:55:25'),
(153,232,2,1,'2026-06-20 03:56:35','2026-06-20 03:55:26','2026-06-20 03:56:35'),
(154,215,2,1,'2026-06-20 03:56:33','2026-06-20 03:55:27','2026-06-20 03:56:33'),
(155,216,2,1,'2026-06-20 03:56:33','2026-06-20 03:55:28','2026-06-20 03:56:33'),
(156,217,2,1,'2026-06-20 03:56:32','2026-06-20 03:55:29','2026-06-20 03:56:32'),
(157,233,2,1,'2026-06-20 03:56:31','2026-06-20 03:55:30','2026-06-20 03:56:31'),
(158,181,2,1,'2026-06-20 03:56:41','2026-06-20 03:56:19','2026-06-20 03:56:41'),
(159,182,2,1,'2026-06-20 03:56:41','2026-06-20 03:56:19','2026-06-20 03:56:41'),
(160,185,2,1,'2026-06-20 03:57:09','2026-06-20 03:56:19','2026-06-20 03:57:09'),
(161,187,2,1,'2026-06-20 03:57:17','2026-06-20 03:56:19','2026-06-20 03:57:17'),
(162,189,2,1,'2026-06-20 03:57:15','2026-06-20 03:56:19','2026-06-20 03:57:15'),
(163,218,2,1,'2026-06-24 08:56:25','2026-06-20 03:56:19','2026-06-24 08:56:25'),
(164,235,2,1,'2026-06-24 08:14:52','2026-06-20 03:56:19','2026-06-24 08:14:52'),
(165,236,2,1,'2026-06-24 08:15:02','2026-06-20 03:56:19','2026-06-24 08:15:02'),
(166,237,2,1,NULL,'2026-06-20 03:56:19','2026-06-24 06:51:57'),
(167,238,2,1,NULL,'2026-06-20 03:56:19','2026-06-24 06:51:51'),
(168,253,2,1,NULL,'2026-06-20 03:56:19','2026-06-24 06:51:52'),
(169,254,2,1,NULL,'2026-06-20 03:56:19','2026-06-24 06:52:02'),
(170,255,2,1,NULL,'2026-06-20 03:56:19','2026-06-24 06:52:04'),
(171,113,1,1,NULL,'2026-06-22 00:31:34','2026-06-22 00:31:34'),
(172,260,4,1,NULL,'2026-06-22 08:10:55','2026-06-22 08:10:55'),
(173,258,4,1,NULL,'2026-06-22 08:10:59','2026-06-22 08:10:59'),
(174,259,4,1,NULL,'2026-06-22 08:11:03','2026-06-22 08:11:03'),
(175,261,4,1,NULL,'2026-06-22 08:11:03','2026-06-22 08:11:03'),
(176,263,4,1,NULL,'2026-06-22 08:11:05','2026-06-22 08:11:05'),
(177,268,4,1,NULL,'2026-06-22 08:11:07','2026-06-22 08:11:07'),
(178,264,4,1,NULL,'2026-06-22 08:11:08','2026-06-22 08:11:08'),
(179,266,4,1,NULL,'2026-06-22 08:11:09','2026-06-22 08:11:09'),
(180,267,4,1,NULL,'2026-06-22 08:11:10','2026-06-22 08:11:10'),
(181,265,4,1,NULL,'2026-06-22 08:11:12','2026-06-22 08:11:12'),
(182,262,4,1,NULL,'2026-06-22 08:11:15','2026-06-22 08:11:15'),
(183,270,4,1,NULL,'2026-06-22 08:11:16','2026-06-22 08:11:16'),
(184,269,4,1,NULL,'2026-06-22 08:11:18','2026-06-22 08:11:18'),
(185,273,4,1,NULL,'2026-06-22 08:11:19','2026-06-22 08:11:19'),
(186,271,4,1,NULL,'2026-06-22 08:11:20','2026-06-22 08:11:20'),
(187,272,4,1,NULL,'2026-06-22 08:11:21','2026-06-22 08:11:21'),
(188,274,3,1,NULL,'2026-06-23 00:05:14','2026-06-23 00:05:14');
/*!40000 ALTER TABLE `fetnet_activity_planning` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_space`
--

DROP TABLE IF EXISTS `fetnet_activity_space`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_space` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) unsigned NOT NULL,
  `space_id` bigint(20) unsigned NOT NULL,
  `assigned_by` varchar(255) NOT NULL DEFAULT 'client',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_activity_space_activity_id_space_id_unique` (`activity_id`,`space_id`),
  KEY `fetnet_activity_space_space_id_foreign` (`space_id`),
  CONSTRAINT `fetnet_activity_space_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_space_space_id_foreign` FOREIGN KEY (`space_id`) REFERENCES `fetnet_space` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_space`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_space` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_space` DISABLE KEYS */;
INSERT INTO `fetnet_activity_space` VALUES
(2,29,1,'client',NULL,NULL),
(4,3,8,'client',NULL,NULL),
(5,3,9,'client',NULL,NULL),
(6,3,10,'client',NULL,NULL),
(7,3,11,'client',NULL,NULL),
(12,4,8,'client',NULL,NULL),
(13,4,9,'client',NULL,NULL),
(14,4,10,'client',NULL,NULL),
(15,4,11,'client',NULL,NULL),
(20,7,8,'client',NULL,NULL),
(21,7,9,'client',NULL,NULL),
(22,7,10,'client',NULL,NULL),
(23,7,11,'client',NULL,NULL),
(24,7,12,'client',NULL,NULL),
(25,7,13,'client',NULL,NULL),
(26,7,14,'client',NULL,NULL),
(27,7,15,'client',NULL,NULL),
(28,8,8,'client',NULL,NULL),
(29,8,9,'client',NULL,NULL),
(30,8,10,'client',NULL,NULL),
(31,8,11,'client',NULL,NULL),
(32,8,12,'client',NULL,NULL),
(33,8,13,'client',NULL,NULL),
(34,8,14,'client',NULL,NULL),
(35,8,15,'client',NULL,NULL),
(36,11,8,'client',NULL,NULL),
(37,11,9,'client',NULL,NULL),
(38,11,10,'client',NULL,NULL),
(39,11,11,'client',NULL,NULL),
(40,11,12,'client',NULL,NULL),
(41,11,13,'client',NULL,NULL),
(42,11,14,'client',NULL,NULL),
(43,11,15,'client',NULL,NULL),
(44,12,8,'client',NULL,NULL),
(45,12,9,'client',NULL,NULL),
(46,12,10,'client',NULL,NULL),
(47,12,11,'client',NULL,NULL),
(48,12,12,'client',NULL,NULL),
(49,12,13,'client',NULL,NULL),
(50,12,14,'client',NULL,NULL),
(51,12,15,'client',NULL,NULL),
(52,5,8,'client',NULL,NULL),
(53,5,9,'client',NULL,NULL),
(54,5,10,'client',NULL,NULL),
(55,5,11,'client',NULL,NULL),
(56,5,12,'client',NULL,NULL),
(57,5,13,'client',NULL,NULL),
(58,5,14,'client',NULL,NULL),
(59,5,15,'client',NULL,NULL),
(60,6,8,'client',NULL,NULL),
(61,6,9,'client',NULL,NULL),
(62,6,10,'client',NULL,NULL),
(63,6,11,'client',NULL,NULL),
(64,6,12,'client',NULL,NULL),
(65,6,13,'client',NULL,NULL),
(66,6,14,'client',NULL,NULL),
(67,6,15,'client',NULL,NULL),
(84,47,8,'client',NULL,NULL),
(85,47,9,'client',NULL,NULL),
(86,47,10,'client',NULL,NULL),
(87,47,11,'client',NULL,NULL),
(88,47,12,'client',NULL,NULL),
(89,47,13,'client',NULL,NULL),
(90,47,14,'client',NULL,NULL),
(91,47,15,'client',NULL,NULL),
(92,48,8,'client',NULL,NULL),
(93,48,9,'client',NULL,NULL),
(94,48,10,'client',NULL,NULL),
(95,48,11,'client',NULL,NULL),
(96,48,12,'client',NULL,NULL),
(97,48,13,'client',NULL,NULL),
(98,48,14,'client',NULL,NULL),
(99,48,15,'client',NULL,NULL),
(100,20,8,'client',NULL,NULL),
(101,20,9,'client',NULL,NULL),
(102,20,10,'client',NULL,NULL),
(103,20,11,'client',NULL,NULL),
(104,20,12,'client',NULL,NULL),
(105,20,13,'client',NULL,NULL),
(106,20,14,'client',NULL,NULL),
(107,20,15,'client',NULL,NULL),
(108,24,8,'client',NULL,NULL),
(109,24,9,'client',NULL,NULL),
(110,24,10,'client',NULL,NULL),
(111,24,11,'client',NULL,NULL),
(116,25,8,'client',NULL,NULL),
(117,25,9,'client',NULL,NULL),
(118,25,10,'client',NULL,NULL),
(119,25,11,'client',NULL,NULL),
(120,25,12,'client',NULL,NULL),
(121,25,13,'client',NULL,NULL),
(122,25,14,'client',NULL,NULL),
(123,25,15,'client',NULL,NULL),
(124,26,8,'client',NULL,NULL),
(125,26,9,'client',NULL,NULL),
(126,26,10,'client',NULL,NULL),
(127,26,11,'client',NULL,NULL),
(132,27,8,'client',NULL,NULL),
(133,27,9,'client',NULL,NULL),
(134,27,10,'client',NULL,NULL),
(135,27,11,'client',NULL,NULL),
(148,28,1,'client',NULL,NULL),
(157,32,8,'client',NULL,NULL),
(158,32,9,'client',NULL,NULL),
(159,32,10,'client',NULL,NULL),
(160,32,11,'client',NULL,NULL),
(161,32,12,'client',NULL,NULL),
(162,32,13,'client',NULL,NULL),
(163,32,14,'client',NULL,NULL),
(164,32,15,'client',NULL,NULL),
(165,33,8,'client',NULL,NULL),
(166,33,9,'client',NULL,NULL),
(167,33,10,'client',NULL,NULL),
(168,33,11,'client',NULL,NULL),
(169,33,12,'client',NULL,NULL),
(170,33,13,'client',NULL,NULL),
(171,33,14,'client',NULL,NULL),
(172,33,15,'client',NULL,NULL),
(173,34,4,'client',NULL,NULL),
(174,35,16,'client',NULL,NULL),
(175,36,8,'client',NULL,NULL),
(176,36,9,'client',NULL,NULL),
(177,36,10,'client',NULL,NULL),
(178,36,11,'client',NULL,NULL),
(179,36,12,'client',NULL,NULL),
(180,36,13,'client',NULL,NULL),
(181,36,14,'client',NULL,NULL),
(182,36,15,'client',NULL,NULL),
(183,37,8,'client',NULL,NULL),
(184,37,9,'client',NULL,NULL),
(185,37,10,'client',NULL,NULL),
(186,37,11,'client',NULL,NULL),
(187,37,12,'client',NULL,NULL),
(188,37,13,'client',NULL,NULL),
(189,37,14,'client',NULL,NULL),
(190,37,15,'client',NULL,NULL),
(191,38,8,'client',NULL,NULL),
(192,38,9,'client',NULL,NULL),
(193,38,10,'client',NULL,NULL),
(194,38,11,'client',NULL,NULL),
(195,38,12,'client',NULL,NULL),
(196,38,13,'client',NULL,NULL),
(197,38,14,'client',NULL,NULL),
(198,38,15,'client',NULL,NULL),
(199,39,8,'client',NULL,NULL),
(200,39,9,'client',NULL,NULL),
(201,39,10,'client',NULL,NULL),
(202,39,11,'client',NULL,NULL),
(203,39,12,'client',NULL,NULL),
(204,39,13,'client',NULL,NULL),
(205,39,14,'client',NULL,NULL),
(206,39,15,'client',NULL,NULL),
(207,40,8,'client',NULL,NULL),
(208,40,9,'client',NULL,NULL),
(209,40,10,'client',NULL,NULL),
(210,40,11,'client',NULL,NULL),
(211,40,12,'client',NULL,NULL),
(212,40,13,'client',NULL,NULL),
(213,40,14,'client',NULL,NULL),
(214,40,15,'client',NULL,NULL),
(215,41,8,'client',NULL,NULL),
(216,41,9,'client',NULL,NULL),
(217,41,10,'client',NULL,NULL),
(218,41,11,'client',NULL,NULL),
(219,41,12,'client',NULL,NULL),
(220,41,13,'client',NULL,NULL),
(221,41,14,'client',NULL,NULL),
(222,41,15,'client',NULL,NULL),
(223,42,8,'client',NULL,NULL),
(224,42,9,'client',NULL,NULL),
(225,42,10,'client',NULL,NULL),
(226,42,11,'client',NULL,NULL),
(227,42,12,'client',NULL,NULL),
(228,42,13,'client',NULL,NULL),
(229,42,14,'client',NULL,NULL),
(230,42,15,'client',NULL,NULL),
(231,43,8,'client',NULL,NULL),
(232,43,9,'client',NULL,NULL),
(233,43,10,'client',NULL,NULL),
(234,43,11,'client',NULL,NULL),
(235,43,12,'client',NULL,NULL),
(236,43,13,'client',NULL,NULL),
(237,43,14,'client',NULL,NULL),
(238,43,15,'client',NULL,NULL),
(239,44,8,'client',NULL,NULL),
(240,44,9,'client',NULL,NULL),
(241,44,10,'client',NULL,NULL),
(242,44,11,'client',NULL,NULL),
(243,44,12,'client',NULL,NULL),
(244,44,13,'client',NULL,NULL),
(245,44,14,'client',NULL,NULL),
(246,44,15,'client',NULL,NULL),
(266,45,9,'client',NULL,NULL),
(267,45,10,'client',NULL,NULL),
(268,45,11,'client',NULL,NULL),
(277,49,12,'client',NULL,NULL),
(278,49,13,'client',NULL,NULL),
(279,49,14,'client',NULL,NULL),
(280,49,15,'client',NULL,NULL),
(285,50,12,'client',NULL,NULL),
(286,50,13,'client',NULL,NULL),
(287,50,14,'client',NULL,NULL),
(288,50,15,'client',NULL,NULL),
(291,53,4,'client',NULL,NULL),
(292,54,8,'client',NULL,NULL),
(293,54,9,'client',NULL,NULL),
(294,54,10,'client',NULL,NULL),
(295,54,11,'client',NULL,NULL),
(296,54,12,'client',NULL,NULL),
(297,54,13,'client',NULL,NULL),
(298,54,14,'client',NULL,NULL),
(299,54,15,'client',NULL,NULL),
(300,55,8,'client',NULL,NULL),
(301,55,9,'client',NULL,NULL),
(302,55,10,'client',NULL,NULL),
(303,55,11,'client',NULL,NULL),
(304,55,12,'client',NULL,NULL),
(305,55,13,'client',NULL,NULL),
(306,55,14,'client',NULL,NULL),
(307,55,15,'client',NULL,NULL),
(308,56,8,'client',NULL,NULL),
(309,56,9,'client',NULL,NULL),
(310,56,10,'client',NULL,NULL),
(311,56,11,'client',NULL,NULL),
(312,56,12,'client',NULL,NULL),
(313,56,13,'client',NULL,NULL),
(314,56,14,'client',NULL,NULL),
(315,56,15,'client',NULL,NULL),
(324,58,8,'client',NULL,NULL),
(325,58,9,'client',NULL,NULL),
(326,58,10,'client',NULL,NULL),
(327,58,11,'client',NULL,NULL),
(328,58,12,'client',NULL,NULL),
(329,58,13,'client',NULL,NULL),
(330,58,14,'client',NULL,NULL),
(331,58,15,'client',NULL,NULL),
(336,59,12,'client',NULL,NULL),
(337,59,13,'client',NULL,NULL),
(338,59,14,'client',NULL,NULL),
(339,59,15,'client',NULL,NULL),
(340,60,8,'client',NULL,NULL),
(341,60,9,'client',NULL,NULL),
(342,60,10,'client',NULL,NULL),
(343,60,11,'client',NULL,NULL),
(344,60,12,'client',NULL,NULL),
(345,60,13,'client',NULL,NULL),
(346,60,14,'client',NULL,NULL),
(347,60,15,'client',NULL,NULL),
(352,61,12,'client',NULL,NULL),
(353,61,13,'client',NULL,NULL),
(354,61,14,'client',NULL,NULL),
(355,61,15,'client',NULL,NULL),
(360,62,12,'client',NULL,NULL),
(361,62,13,'client',NULL,NULL),
(362,62,14,'client',NULL,NULL),
(363,62,15,'client',NULL,NULL),
(368,63,12,'client',NULL,NULL),
(369,63,13,'client',NULL,NULL),
(370,63,14,'client',NULL,NULL),
(371,63,15,'client',NULL,NULL),
(376,64,12,'client',NULL,NULL),
(377,64,13,'client',NULL,NULL),
(378,64,14,'client',NULL,NULL),
(379,64,15,'client',NULL,NULL),
(380,65,8,'client',NULL,NULL),
(381,65,9,'client',NULL,NULL),
(382,65,10,'client',NULL,NULL),
(383,65,11,'client',NULL,NULL),
(384,65,12,'client',NULL,NULL),
(385,65,13,'client',NULL,NULL),
(386,65,14,'client',NULL,NULL),
(387,65,15,'client',NULL,NULL),
(388,66,8,'client',NULL,NULL),
(389,66,9,'client',NULL,NULL),
(390,66,10,'client',NULL,NULL),
(391,66,11,'client',NULL,NULL),
(392,66,12,'client',NULL,NULL),
(393,66,13,'client',NULL,NULL),
(394,66,14,'client',NULL,NULL),
(395,66,15,'client',NULL,NULL),
(416,69,12,'client',NULL,NULL),
(417,69,13,'client',NULL,NULL),
(418,69,14,'client',NULL,NULL),
(419,69,15,'client',NULL,NULL),
(424,70,12,'client',NULL,NULL),
(425,70,13,'client',NULL,NULL),
(426,70,14,'client',NULL,NULL),
(427,70,15,'client',NULL,NULL),
(432,71,12,'client',NULL,NULL),
(433,71,13,'client',NULL,NULL),
(434,71,14,'client',NULL,NULL),
(435,71,15,'client',NULL,NULL),
(440,72,12,'client',NULL,NULL),
(441,72,13,'client',NULL,NULL),
(442,72,14,'client',NULL,NULL),
(443,72,15,'client',NULL,NULL),
(448,73,12,'client',NULL,NULL),
(449,73,13,'client',NULL,NULL),
(450,73,14,'client',NULL,NULL),
(451,73,15,'client',NULL,NULL),
(456,74,12,'client',NULL,NULL),
(457,74,13,'client',NULL,NULL),
(458,74,14,'client',NULL,NULL),
(459,74,15,'client',NULL,NULL),
(464,75,12,'client',NULL,NULL),
(465,75,13,'client',NULL,NULL),
(466,75,14,'client',NULL,NULL),
(467,75,15,'client',NULL,NULL),
(472,76,12,'client',NULL,NULL),
(473,76,13,'client',NULL,NULL),
(474,76,14,'client',NULL,NULL),
(475,76,15,'client',NULL,NULL),
(480,77,12,'client',NULL,NULL),
(481,77,13,'client',NULL,NULL),
(482,77,14,'client',NULL,NULL),
(483,77,15,'client',NULL,NULL),
(488,78,12,'client',NULL,NULL),
(489,78,13,'client',NULL,NULL),
(490,78,14,'client',NULL,NULL),
(491,78,15,'client',NULL,NULL),
(496,79,12,'client',NULL,NULL),
(497,79,13,'client',NULL,NULL),
(498,79,14,'client',NULL,NULL),
(499,79,15,'client',NULL,NULL),
(520,82,12,'client',NULL,NULL),
(521,82,13,'client',NULL,NULL),
(522,82,14,'client',NULL,NULL),
(523,82,15,'client',NULL,NULL),
(524,83,2,'client',NULL,NULL),
(529,84,12,'client',NULL,NULL),
(530,84,13,'client',NULL,NULL),
(531,84,14,'client',NULL,NULL),
(532,84,15,'client',NULL,NULL),
(541,85,2,'client',NULL,NULL),
(542,85,3,'client',NULL,NULL),
(543,67,2,'client',NULL,NULL),
(544,67,3,'client',NULL,NULL),
(545,68,2,'client',NULL,NULL),
(546,68,3,'client',NULL,NULL),
(549,80,17,'client',NULL,NULL),
(551,19,8,'client',NULL,NULL),
(552,19,9,'client',NULL,NULL),
(553,19,10,'client',NULL,NULL),
(554,19,11,'client',NULL,NULL),
(567,90,10,'client',NULL,NULL),
(568,90,11,'client',NULL,NULL),
(569,90,8,'client',NULL,NULL),
(570,90,9,'client',NULL,NULL),
(571,92,10,'client',NULL,NULL),
(572,92,8,'client',NULL,NULL),
(573,92,9,'client',NULL,NULL),
(574,92,11,'client',NULL,NULL),
(575,92,12,'client',NULL,NULL),
(576,92,13,'client',NULL,NULL),
(577,92,14,'client',NULL,NULL),
(578,92,15,'client',NULL,NULL),
(579,93,8,'client',NULL,NULL),
(580,93,9,'client',NULL,NULL),
(581,93,10,'client',NULL,NULL),
(582,93,11,'client',NULL,NULL),
(583,93,12,'client',NULL,NULL),
(584,93,13,'client',NULL,NULL),
(585,93,14,'client',NULL,NULL),
(586,93,15,'client',NULL,NULL),
(587,94,8,'client',NULL,NULL),
(588,94,9,'client',NULL,NULL),
(589,94,10,'client',NULL,NULL),
(590,94,11,'client',NULL,NULL),
(591,94,12,'client',NULL,NULL),
(592,94,13,'client',NULL,NULL),
(593,94,14,'client',NULL,NULL),
(594,94,15,'client',NULL,NULL),
(596,10,16,'client',NULL,NULL),
(597,45,8,'client',NULL,NULL),
(598,86,18,'client',NULL,NULL),
(599,87,18,'client',NULL,NULL),
(600,88,10,'client',NULL,NULL),
(601,88,11,'client',NULL,NULL),
(602,88,8,'client',NULL,NULL),
(603,88,9,'client',NULL,NULL),
(604,89,10,'client',NULL,NULL),
(605,89,11,'client',NULL,NULL),
(606,89,8,'client',NULL,NULL),
(607,89,9,'client',NULL,NULL),
(608,91,8,'client',NULL,NULL),
(609,91,9,'client',NULL,NULL),
(610,91,10,'client',NULL,NULL),
(611,91,11,'client',NULL,NULL),
(612,91,12,'client',NULL,NULL),
(613,91,13,'client',NULL,NULL),
(614,91,14,'client',NULL,NULL),
(615,91,15,'client',NULL,NULL),
(616,130,18,'client',NULL,NULL),
(617,131,18,'client',NULL,NULL),
(618,99,16,'client',NULL,NULL),
(619,100,16,'client',NULL,NULL),
(620,140,10,'client',NULL,NULL),
(621,140,11,'client',NULL,NULL),
(622,140,8,'client',NULL,NULL),
(623,140,9,'client',NULL,NULL),
(624,140,12,'client',NULL,NULL),
(625,140,13,'client',NULL,NULL),
(626,140,14,'client',NULL,NULL),
(627,140,15,'client',NULL,NULL),
(628,142,8,'client',NULL,NULL),
(629,142,9,'client',NULL,NULL),
(630,142,10,'client',NULL,NULL),
(631,142,11,'client',NULL,NULL),
(632,142,12,'client',NULL,NULL),
(633,142,13,'client',NULL,NULL),
(634,142,14,'client',NULL,NULL),
(635,142,15,'client',NULL,NULL),
(636,102,12,'client',NULL,NULL),
(637,102,13,'client',NULL,NULL),
(638,102,14,'client',NULL,NULL),
(639,102,15,'client',NULL,NULL),
(640,103,12,'client',NULL,NULL),
(641,103,13,'client',NULL,NULL),
(642,103,14,'client',NULL,NULL),
(643,103,15,'client',NULL,NULL),
(644,104,12,'client',NULL,NULL),
(645,104,13,'client',NULL,NULL),
(646,104,14,'client',NULL,NULL),
(647,104,15,'client',NULL,NULL),
(648,105,12,'client',NULL,NULL),
(649,105,13,'client',NULL,NULL),
(650,105,14,'client',NULL,NULL),
(651,105,15,'client',NULL,NULL),
(652,106,12,'client',NULL,NULL),
(653,106,13,'client',NULL,NULL),
(654,106,14,'client',NULL,NULL),
(655,106,15,'client',NULL,NULL),
(656,107,12,'client',NULL,NULL),
(657,107,13,'client',NULL,NULL),
(658,107,14,'client',NULL,NULL),
(659,107,15,'client',NULL,NULL),
(660,108,12,'client',NULL,NULL),
(661,108,13,'client',NULL,NULL),
(662,108,14,'client',NULL,NULL),
(663,108,15,'client',NULL,NULL),
(664,109,12,'client',NULL,NULL),
(665,109,13,'client',NULL,NULL),
(666,109,14,'client',NULL,NULL),
(667,109,15,'client',NULL,NULL),
(668,132,8,'client',NULL,NULL),
(669,132,9,'client',NULL,NULL),
(670,132,10,'client',NULL,NULL),
(671,132,11,'client',NULL,NULL),
(672,132,12,'client',NULL,NULL),
(673,132,13,'client',NULL,NULL),
(674,132,14,'client',NULL,NULL),
(675,132,15,'client',NULL,NULL),
(676,133,8,'client',NULL,NULL),
(677,133,9,'client',NULL,NULL),
(678,133,10,'client',NULL,NULL),
(679,133,11,'client',NULL,NULL),
(680,133,12,'client',NULL,NULL),
(681,133,13,'client',NULL,NULL),
(682,133,14,'client',NULL,NULL),
(683,133,15,'client',NULL,NULL),
(684,129,8,'client',NULL,NULL),
(685,129,9,'client',NULL,NULL),
(686,129,10,'client',NULL,NULL),
(687,129,11,'client',NULL,NULL),
(688,129,12,'client',NULL,NULL),
(689,129,13,'client',NULL,NULL),
(690,129,14,'client',NULL,NULL),
(691,129,15,'client',NULL,NULL),
(692,146,8,'client',NULL,NULL),
(693,146,9,'client',NULL,NULL),
(694,146,10,'client',NULL,NULL),
(695,146,11,'client',NULL,NULL),
(696,146,12,'client',NULL,NULL),
(697,146,13,'client',NULL,NULL),
(698,146,14,'client',NULL,NULL),
(699,146,15,'client',NULL,NULL),
(700,95,8,'client',NULL,NULL),
(701,95,9,'client',NULL,NULL),
(702,95,10,'client',NULL,NULL),
(703,95,11,'client',NULL,NULL),
(704,95,12,'client',NULL,NULL),
(705,95,13,'client',NULL,NULL),
(706,95,14,'client',NULL,NULL),
(707,95,15,'client',NULL,NULL),
(708,96,8,'client',NULL,NULL),
(709,96,9,'client',NULL,NULL),
(710,96,10,'client',NULL,NULL),
(711,96,11,'client',NULL,NULL),
(712,96,12,'client',NULL,NULL),
(713,96,13,'client',NULL,NULL),
(714,96,14,'client',NULL,NULL),
(715,96,15,'client',NULL,NULL),
(716,97,18,'client',NULL,NULL),
(717,98,8,'client',NULL,NULL),
(718,98,9,'client',NULL,NULL),
(719,98,10,'client',NULL,NULL),
(720,98,11,'client',NULL,NULL),
(721,98,12,'client',NULL,NULL),
(722,98,13,'client',NULL,NULL),
(723,98,14,'client',NULL,NULL),
(724,98,15,'client',NULL,NULL),
(743,134,10,'client',NULL,NULL),
(744,134,11,'client',NULL,NULL),
(745,134,8,'client',NULL,NULL),
(746,134,9,'client',NULL,NULL),
(747,135,10,'client',NULL,NULL),
(748,135,11,'client',NULL,NULL),
(749,135,8,'client',NULL,NULL),
(750,135,9,'client',NULL,NULL),
(751,145,10,'client',NULL,NULL),
(752,145,11,'client',NULL,NULL),
(753,145,8,'client',NULL,NULL),
(754,145,9,'client',NULL,NULL),
(755,110,12,'client',NULL,NULL),
(756,110,13,'client',NULL,NULL),
(757,110,14,'client',NULL,NULL),
(758,110,15,'client',NULL,NULL),
(759,111,12,'client',NULL,NULL),
(760,111,13,'client',NULL,NULL),
(761,111,14,'client',NULL,NULL),
(762,111,15,'client',NULL,NULL),
(763,112,12,'client',NULL,NULL),
(764,112,13,'client',NULL,NULL),
(765,112,14,'client',NULL,NULL),
(766,112,15,'client',NULL,NULL),
(767,143,8,'client',NULL,NULL),
(768,143,9,'client',NULL,NULL),
(769,143,10,'client',NULL,NULL),
(770,143,11,'client',NULL,NULL),
(771,143,12,'client',NULL,NULL),
(772,143,13,'client',NULL,NULL),
(773,143,14,'client',NULL,NULL),
(774,143,15,'client',NULL,NULL),
(775,141,12,'client',NULL,NULL),
(776,141,13,'client',NULL,NULL),
(777,141,14,'client',NULL,NULL),
(778,141,15,'client',NULL,NULL),
(779,139,17,'client',NULL,NULL),
(780,113,12,'client',NULL,NULL),
(781,113,13,'client',NULL,NULL),
(782,113,14,'client',NULL,NULL),
(783,113,15,'client',NULL,NULL),
(784,114,12,'client',NULL,NULL),
(785,114,13,'client',NULL,NULL),
(786,114,14,'client',NULL,NULL),
(787,114,15,'client',NULL,NULL),
(788,115,12,'client',NULL,NULL),
(789,115,13,'client',NULL,NULL),
(790,115,14,'client',NULL,NULL),
(791,115,15,'client',NULL,NULL),
(792,116,12,'client',NULL,NULL),
(793,116,13,'client',NULL,NULL),
(794,116,14,'client',NULL,NULL),
(795,116,15,'client',NULL,NULL),
(796,117,12,'client',NULL,NULL),
(797,117,13,'client',NULL,NULL),
(798,117,14,'client',NULL,NULL),
(799,117,15,'client',NULL,NULL),
(800,144,8,'client',NULL,NULL),
(801,144,9,'client',NULL,NULL),
(802,144,10,'client',NULL,NULL),
(803,144,11,'client',NULL,NULL),
(804,144,12,'client',NULL,NULL),
(805,144,13,'client',NULL,NULL),
(806,144,14,'client',NULL,NULL),
(807,144,15,'client',NULL,NULL),
(808,151,6,'client',NULL,NULL),
(809,151,7,'client',NULL,NULL),
(810,136,8,'client',NULL,NULL),
(811,136,9,'client',NULL,NULL),
(812,136,10,'client',NULL,NULL),
(813,136,11,'client',NULL,NULL),
(814,136,12,'client',NULL,NULL),
(815,136,13,'client',NULL,NULL),
(816,136,14,'client',NULL,NULL),
(817,136,15,'client',NULL,NULL),
(818,149,8,'client',NULL,NULL),
(819,149,9,'client',NULL,NULL),
(820,149,10,'client',NULL,NULL),
(821,149,11,'client',NULL,NULL),
(822,149,12,'client',NULL,NULL),
(823,149,13,'client',NULL,NULL),
(824,149,14,'client',NULL,NULL),
(825,149,15,'client',NULL,NULL),
(834,137,8,'client',NULL,NULL),
(835,137,9,'client',NULL,NULL),
(836,137,10,'client',NULL,NULL),
(837,137,11,'client',NULL,NULL),
(838,137,12,'client',NULL,NULL),
(839,137,13,'client',NULL,NULL),
(840,137,14,'client',NULL,NULL),
(841,137,15,'client',NULL,NULL),
(850,152,4,'client',NULL,NULL),
(851,138,8,'client',NULL,NULL),
(852,138,9,'client',NULL,NULL),
(853,138,10,'client',NULL,NULL),
(854,138,11,'client',NULL,NULL),
(855,138,12,'client',NULL,NULL),
(856,138,13,'client',NULL,NULL),
(857,138,14,'client',NULL,NULL),
(858,138,15,'client',NULL,NULL),
(859,101,8,'client',NULL,NULL),
(860,101,9,'client',NULL,NULL),
(861,101,10,'client',NULL,NULL),
(862,101,11,'client',NULL,NULL),
(863,101,12,'client',NULL,NULL),
(864,101,13,'client',NULL,NULL),
(865,101,14,'client',NULL,NULL),
(866,101,15,'client',NULL,NULL),
(867,118,12,'client',NULL,NULL),
(868,118,13,'client',NULL,NULL),
(869,118,14,'client',NULL,NULL),
(870,118,15,'client',NULL,NULL),
(871,119,12,'client',NULL,NULL),
(872,119,13,'client',NULL,NULL),
(873,119,14,'client',NULL,NULL),
(874,119,15,'client',NULL,NULL),
(875,120,12,'client',NULL,NULL),
(876,120,13,'client',NULL,NULL),
(877,120,14,'client',NULL,NULL),
(878,120,15,'client',NULL,NULL),
(879,121,12,'client',NULL,NULL),
(880,121,13,'client',NULL,NULL),
(881,121,14,'client',NULL,NULL),
(882,121,15,'client',NULL,NULL),
(883,122,12,'client',NULL,NULL),
(884,122,13,'client',NULL,NULL),
(885,122,14,'client',NULL,NULL),
(886,122,15,'client',NULL,NULL),
(887,123,12,'client',NULL,NULL),
(888,123,13,'client',NULL,NULL),
(889,123,14,'client',NULL,NULL),
(890,123,15,'client',NULL,NULL),
(891,124,12,'client',NULL,NULL),
(892,124,13,'client',NULL,NULL),
(893,124,14,'client',NULL,NULL),
(894,124,15,'client',NULL,NULL),
(895,125,12,'client',NULL,NULL),
(896,125,13,'client',NULL,NULL),
(897,125,14,'client',NULL,NULL),
(898,125,15,'client',NULL,NULL),
(899,126,12,'client',NULL,NULL),
(900,126,13,'client',NULL,NULL),
(901,126,14,'client',NULL,NULL),
(902,126,15,'client',NULL,NULL),
(903,127,12,'client',NULL,NULL),
(904,127,13,'client',NULL,NULL),
(905,127,14,'client',NULL,NULL),
(906,127,15,'client',NULL,NULL),
(907,128,12,'client',NULL,NULL),
(908,128,13,'client',NULL,NULL),
(909,128,14,'client',NULL,NULL),
(910,128,15,'client',NULL,NULL),
(911,155,8,'client',NULL,NULL),
(912,155,9,'client',NULL,NULL),
(913,155,10,'client',NULL,NULL),
(914,155,11,'client',NULL,NULL),
(915,155,12,'client',NULL,NULL),
(916,155,13,'client',NULL,NULL),
(917,155,14,'client',NULL,NULL),
(918,155,15,'client',NULL,NULL),
(919,153,10,'client',NULL,NULL),
(920,153,11,'client',NULL,NULL),
(921,153,14,'client',NULL,NULL),
(922,153,15,'client',NULL,NULL),
(923,156,8,'client',NULL,NULL),
(924,156,9,'client',NULL,NULL),
(925,156,10,'client',NULL,NULL),
(926,156,11,'client',NULL,NULL),
(927,156,12,'client',NULL,NULL),
(928,156,13,'client',NULL,NULL),
(929,156,14,'client',NULL,NULL),
(930,156,15,'client',NULL,NULL),
(931,158,8,'client',NULL,NULL),
(932,158,9,'client',NULL,NULL),
(933,158,10,'client',NULL,NULL),
(934,158,11,'client',NULL,NULL),
(935,158,12,'client',NULL,NULL),
(936,158,13,'client',NULL,NULL),
(937,158,14,'client',NULL,NULL),
(938,158,15,'client',NULL,NULL),
(939,159,8,'client',NULL,NULL),
(940,159,9,'client',NULL,NULL),
(941,159,10,'client',NULL,NULL),
(942,159,11,'client',NULL,NULL),
(943,159,12,'client',NULL,NULL),
(944,159,13,'client',NULL,NULL),
(945,159,14,'client',NULL,NULL),
(946,159,15,'client',NULL,NULL),
(947,160,8,'client',NULL,NULL),
(948,160,9,'client',NULL,NULL),
(949,160,10,'client',NULL,NULL),
(950,160,11,'client',NULL,NULL),
(951,160,12,'client',NULL,NULL),
(952,160,13,'client',NULL,NULL),
(953,160,14,'client',NULL,NULL),
(954,160,15,'client',NULL,NULL),
(955,162,1,'client',NULL,NULL),
(956,161,6,'client',NULL,NULL),
(957,161,7,'client',NULL,NULL),
(958,157,8,'client',NULL,NULL),
(959,157,9,'client',NULL,NULL),
(960,157,10,'client',NULL,NULL),
(961,157,11,'client',NULL,NULL),
(962,157,12,'client',NULL,NULL),
(963,157,13,'client',NULL,NULL),
(964,157,14,'client',NULL,NULL),
(965,157,15,'client',NULL,NULL),
(966,163,8,'client',NULL,NULL),
(967,163,9,'client',NULL,NULL),
(968,163,10,'client',NULL,NULL),
(969,163,11,'client',NULL,NULL),
(970,163,12,'client',NULL,NULL),
(971,163,13,'client',NULL,NULL),
(972,163,14,'client',NULL,NULL),
(973,163,15,'client',NULL,NULL),
(974,165,8,'client',NULL,NULL),
(975,165,9,'client',NULL,NULL),
(976,165,10,'client',NULL,NULL),
(977,165,11,'client',NULL,NULL),
(978,165,12,'client',NULL,NULL),
(979,165,13,'client',NULL,NULL),
(980,165,14,'client',NULL,NULL),
(981,165,15,'client',NULL,NULL),
(982,169,8,'client',NULL,NULL),
(983,169,9,'client',NULL,NULL),
(984,169,10,'client',NULL,NULL),
(985,169,11,'client',NULL,NULL),
(986,169,12,'client',NULL,NULL),
(987,169,13,'client',NULL,NULL),
(988,169,14,'client',NULL,NULL),
(989,169,15,'client',NULL,NULL),
(990,166,8,'client',NULL,NULL),
(991,166,9,'client',NULL,NULL),
(992,166,10,'client',NULL,NULL),
(993,166,11,'client',NULL,NULL),
(994,166,12,'client',NULL,NULL),
(995,166,13,'client',NULL,NULL),
(996,166,14,'client',NULL,NULL),
(997,166,15,'client',NULL,NULL),
(998,167,8,'client',NULL,NULL),
(999,167,9,'client',NULL,NULL),
(1000,167,10,'client',NULL,NULL),
(1001,167,11,'client',NULL,NULL),
(1002,167,12,'client',NULL,NULL),
(1003,167,13,'client',NULL,NULL),
(1004,167,14,'client',NULL,NULL),
(1005,167,15,'client',NULL,NULL),
(1006,168,8,'client',NULL,NULL),
(1007,168,9,'client',NULL,NULL),
(1008,168,10,'client',NULL,NULL),
(1009,168,11,'client',NULL,NULL),
(1010,168,12,'client',NULL,NULL),
(1011,168,13,'client',NULL,NULL),
(1012,168,14,'client',NULL,NULL),
(1013,168,15,'client',NULL,NULL),
(1014,49,8,'client',NULL,NULL),
(1015,49,9,'client',NULL,NULL),
(1016,49,10,'client',NULL,NULL),
(1017,49,11,'client',NULL,NULL),
(1018,50,8,'client',NULL,NULL),
(1019,50,9,'client',NULL,NULL),
(1020,50,10,'client',NULL,NULL),
(1021,50,11,'client',NULL,NULL),
(1022,61,8,'client',NULL,NULL),
(1023,61,9,'client',NULL,NULL),
(1024,61,10,'client',NULL,NULL),
(1025,61,11,'client',NULL,NULL),
(1026,62,8,'client',NULL,NULL),
(1027,62,9,'client',NULL,NULL),
(1028,62,10,'client',NULL,NULL),
(1029,62,11,'client',NULL,NULL),
(1030,63,8,'client',NULL,NULL),
(1031,63,9,'client',NULL,NULL),
(1032,63,10,'client',NULL,NULL),
(1033,63,11,'client',NULL,NULL),
(1042,9,16,'client',NULL,NULL),
(1043,69,8,'client',NULL,NULL),
(1044,69,9,'client',NULL,NULL),
(1045,69,10,'client',NULL,NULL),
(1046,69,11,'client',NULL,NULL),
(1047,70,8,'client',NULL,NULL),
(1048,70,9,'client',NULL,NULL),
(1049,70,10,'client',NULL,NULL),
(1050,70,11,'client',NULL,NULL),
(1051,71,8,'client',NULL,NULL),
(1052,71,9,'client',NULL,NULL),
(1053,71,10,'client',NULL,NULL),
(1054,71,11,'client',NULL,NULL),
(1055,72,8,'client',NULL,NULL),
(1056,72,9,'client',NULL,NULL),
(1057,72,10,'client',NULL,NULL),
(1058,72,11,'client',NULL,NULL),
(1059,73,8,'client',NULL,NULL),
(1060,73,9,'client',NULL,NULL),
(1061,73,10,'client',NULL,NULL),
(1062,73,11,'client',NULL,NULL),
(1063,74,8,'client',NULL,NULL),
(1064,74,9,'client',NULL,NULL),
(1065,74,10,'client',NULL,NULL),
(1066,74,11,'client',NULL,NULL),
(1067,75,8,'client',NULL,NULL),
(1068,75,9,'client',NULL,NULL),
(1069,75,10,'client',NULL,NULL),
(1070,75,11,'client',NULL,NULL),
(1071,76,8,'client',NULL,NULL),
(1072,76,9,'client',NULL,NULL),
(1073,76,10,'client',NULL,NULL),
(1074,76,11,'client',NULL,NULL),
(1075,77,8,'client',NULL,NULL),
(1076,77,9,'client',NULL,NULL),
(1077,77,10,'client',NULL,NULL),
(1078,77,11,'client',NULL,NULL),
(1079,78,8,'client',NULL,NULL),
(1080,78,9,'client',NULL,NULL),
(1081,78,10,'client',NULL,NULL),
(1082,78,11,'client',NULL,NULL),
(1083,79,8,'client',NULL,NULL),
(1084,79,9,'client',NULL,NULL),
(1085,79,10,'client',NULL,NULL),
(1086,79,11,'client',NULL,NULL),
(1087,82,8,'client',NULL,NULL),
(1088,82,9,'client',NULL,NULL),
(1089,82,10,'client',NULL,NULL),
(1090,82,11,'client',NULL,NULL),
(1091,84,8,'client',NULL,NULL),
(1092,84,9,'client',NULL,NULL),
(1093,84,10,'client',NULL,NULL),
(1094,84,11,'client',NULL,NULL),
(1095,141,8,'client',NULL,NULL),
(1096,141,9,'client',NULL,NULL),
(1097,141,10,'client',NULL,NULL),
(1098,141,11,'client',NULL,NULL),
(1099,85,1,'client',NULL,NULL),
(1100,85,4,'client',NULL,NULL),
(1101,85,5,'client',NULL,NULL),
(1102,85,6,'client',NULL,NULL),
(1103,85,7,'client',NULL,NULL),
(1104,85,16,'client',NULL,NULL),
(1105,85,17,'client',NULL,NULL),
(1106,85,18,'client',NULL,NULL),
(1107,102,8,'client',NULL,NULL),
(1108,102,9,'client',NULL,NULL),
(1109,102,10,'client',NULL,NULL),
(1110,102,11,'client',NULL,NULL),
(1111,103,8,'client',NULL,NULL),
(1112,103,9,'client',NULL,NULL),
(1113,103,10,'client',NULL,NULL),
(1114,103,11,'client',NULL,NULL),
(1115,104,8,'client',NULL,NULL),
(1116,104,9,'client',NULL,NULL),
(1117,104,10,'client',NULL,NULL),
(1118,104,11,'client',NULL,NULL),
(1119,105,8,'client',NULL,NULL),
(1120,105,9,'client',NULL,NULL),
(1121,105,10,'client',NULL,NULL),
(1122,105,11,'client',NULL,NULL),
(1123,106,8,'client',NULL,NULL),
(1124,106,9,'client',NULL,NULL),
(1125,106,10,'client',NULL,NULL),
(1126,106,11,'client',NULL,NULL),
(1127,107,8,'client',NULL,NULL),
(1128,107,9,'client',NULL,NULL),
(1129,107,10,'client',NULL,NULL),
(1130,107,11,'client',NULL,NULL),
(1131,108,8,'client',NULL,NULL),
(1132,108,9,'client',NULL,NULL),
(1133,108,10,'client',NULL,NULL),
(1134,108,11,'client',NULL,NULL),
(1135,109,8,'client',NULL,NULL),
(1136,109,9,'client',NULL,NULL),
(1137,109,10,'client',NULL,NULL),
(1138,109,11,'client',NULL,NULL),
(1139,110,8,'client',NULL,NULL),
(1140,110,9,'client',NULL,NULL),
(1141,110,10,'client',NULL,NULL),
(1142,110,11,'client',NULL,NULL),
(1143,111,8,'client',NULL,NULL),
(1144,111,9,'client',NULL,NULL),
(1145,111,10,'client',NULL,NULL),
(1146,111,11,'client',NULL,NULL),
(1147,112,8,'client',NULL,NULL),
(1148,112,9,'client',NULL,NULL),
(1149,112,10,'client',NULL,NULL),
(1150,112,11,'client',NULL,NULL),
(1151,113,8,'client',NULL,NULL),
(1152,113,9,'client',NULL,NULL),
(1153,113,10,'client',NULL,NULL),
(1154,113,11,'client',NULL,NULL),
(1155,114,8,'client',NULL,NULL),
(1156,114,9,'client',NULL,NULL),
(1157,114,10,'client',NULL,NULL),
(1158,114,11,'client',NULL,NULL),
(1159,115,8,'client',NULL,NULL),
(1160,115,9,'client',NULL,NULL),
(1161,115,10,'client',NULL,NULL),
(1162,115,11,'client',NULL,NULL),
(1163,116,8,'client',NULL,NULL),
(1164,116,9,'client',NULL,NULL),
(1165,116,10,'client',NULL,NULL),
(1166,116,11,'client',NULL,NULL),
(1167,117,8,'client',NULL,NULL),
(1168,117,9,'client',NULL,NULL),
(1169,117,10,'client',NULL,NULL),
(1170,117,11,'client',NULL,NULL),
(1171,118,8,'client',NULL,NULL),
(1172,118,9,'client',NULL,NULL),
(1173,118,10,'client',NULL,NULL),
(1174,118,11,'client',NULL,NULL),
(1175,119,8,'client',NULL,NULL),
(1176,119,9,'client',NULL,NULL),
(1177,119,10,'client',NULL,NULL),
(1178,119,11,'client',NULL,NULL),
(1179,120,8,'client',NULL,NULL),
(1180,120,9,'client',NULL,NULL),
(1181,120,10,'client',NULL,NULL),
(1182,120,11,'client',NULL,NULL),
(1183,121,8,'client',NULL,NULL),
(1184,121,9,'client',NULL,NULL),
(1185,121,10,'client',NULL,NULL),
(1186,121,11,'client',NULL,NULL),
(1187,122,8,'client',NULL,NULL),
(1188,122,9,'client',NULL,NULL),
(1189,122,10,'client',NULL,NULL),
(1190,122,11,'client',NULL,NULL),
(1191,123,8,'client',NULL,NULL),
(1192,123,9,'client',NULL,NULL),
(1193,123,10,'client',NULL,NULL),
(1194,123,11,'client',NULL,NULL),
(1195,124,8,'client',NULL,NULL),
(1196,124,9,'client',NULL,NULL),
(1197,124,10,'client',NULL,NULL),
(1198,124,11,'client',NULL,NULL),
(1199,125,8,'client',NULL,NULL),
(1200,125,9,'client',NULL,NULL),
(1201,125,10,'client',NULL,NULL),
(1202,125,11,'client',NULL,NULL),
(1203,126,8,'client',NULL,NULL),
(1204,126,9,'client',NULL,NULL),
(1205,126,10,'client',NULL,NULL),
(1206,126,11,'client',NULL,NULL),
(1207,127,8,'client',NULL,NULL),
(1208,127,9,'client',NULL,NULL),
(1209,127,10,'client',NULL,NULL),
(1210,127,11,'client',NULL,NULL),
(1211,128,8,'client',NULL,NULL),
(1212,128,9,'client',NULL,NULL),
(1213,128,10,'client',NULL,NULL),
(1214,128,11,'client',NULL,NULL);
/*!40000 ALTER TABLE `fetnet_activity_space` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_student`
--

DROP TABLE IF EXISTS `fetnet_activity_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_student` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_activity_student_activity_id_foreign` (`activity_id`),
  KEY `fetnet_activity_student_student_id_foreign` (`student_id`),
  CONSTRAINT `fetnet_activity_student_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_student_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `fetnet_student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_student`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_student` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_student` DISABLE KEYS */;
INSERT INTO `fetnet_activity_student` VALUES
(14,4,3,NULL,NULL),
(15,5,2,NULL,NULL),
(16,6,3,NULL,NULL),
(17,7,2,NULL,NULL),
(18,8,3,NULL,NULL),
(19,9,2,NULL,NULL),
(20,10,3,NULL,NULL),
(21,11,2,NULL,NULL),
(22,12,3,NULL,NULL),
(36,19,5,NULL,NULL),
(38,20,5,NULL,NULL),
(43,24,6,NULL,NULL),
(44,25,6,NULL,NULL),
(45,26,5,NULL,NULL),
(46,27,6,NULL,NULL),
(47,28,5,NULL,NULL),
(48,29,6,NULL,NULL),
(59,34,11,NULL,NULL),
(67,38,13,NULL,NULL),
(68,38,15,NULL,NULL),
(69,39,14,NULL,NULL),
(70,40,14,NULL,NULL),
(71,40,16,NULL,NULL),
(72,39,16,NULL,NULL),
(73,41,13,NULL,NULL),
(74,41,15,NULL,NULL),
(75,42,14,NULL,NULL),
(76,42,16,NULL,NULL),
(77,43,13,NULL,NULL),
(78,43,15,NULL,NULL),
(79,44,14,NULL,NULL),
(80,44,16,NULL,NULL),
(81,45,14,NULL,NULL),
(82,45,16,NULL,NULL),
(84,47,5,NULL,NULL),
(85,48,6,NULL,NULL),
(86,49,23,NULL,NULL),
(87,50,24,NULL,NULL),
(91,53,12,NULL,NULL),
(92,54,13,NULL,NULL),
(93,54,15,NULL,NULL),
(94,55,16,NULL,NULL),
(95,55,14,NULL,NULL),
(96,56,15,NULL,NULL),
(97,56,13,NULL,NULL),
(100,58,14,NULL,NULL),
(101,58,16,NULL,NULL),
(102,59,23,NULL,NULL),
(103,60,24,NULL,NULL),
(104,61,23,NULL,NULL),
(105,62,24,NULL,NULL),
(106,63,23,NULL,NULL),
(107,64,24,NULL,NULL),
(108,65,21,NULL,NULL),
(109,66,22,NULL,NULL),
(110,67,21,NULL,NULL),
(111,68,22,NULL,NULL),
(112,69,21,NULL,NULL),
(113,70,22,NULL,NULL),
(114,71,21,NULL,NULL),
(115,72,22,NULL,NULL),
(116,73,21,NULL,NULL),
(117,74,22,NULL,NULL),
(118,75,25,NULL,NULL),
(119,76,25,NULL,NULL),
(120,77,25,NULL,NULL),
(121,78,25,NULL,NULL),
(122,79,25,NULL,NULL),
(123,80,25,NULL,NULL),
(125,82,26,NULL,NULL),
(126,83,26,NULL,NULL),
(127,84,26,NULL,NULL),
(128,85,26,NULL,NULL),
(129,86,28,NULL,NULL),
(130,87,29,NULL,NULL),
(135,32,7,NULL,NULL),
(136,33,7,NULL,NULL),
(137,36,7,NULL,NULL),
(138,35,7,NULL,NULL),
(139,88,28,NULL,NULL),
(140,89,29,NULL,NULL),
(141,90,31,NULL,NULL),
(142,91,32,NULL,NULL),
(143,92,31,NULL,NULL),
(144,93,32,NULL,NULL),
(145,94,14,NULL,NULL),
(146,94,16,NULL,NULL),
(147,37,13,NULL,NULL),
(148,37,15,NULL,NULL),
(149,95,5,NULL,NULL),
(150,96,6,NULL,NULL),
(151,97,7,NULL,NULL),
(152,98,7,NULL,NULL),
(153,99,28,NULL,NULL),
(154,100,29,NULL,NULL),
(155,101,37,NULL,NULL),
(156,102,57,NULL,NULL),
(157,103,58,NULL,NULL),
(158,104,57,NULL,NULL),
(159,105,58,NULL,NULL),
(160,106,57,NULL,NULL),
(161,107,58,NULL,NULL),
(162,108,57,NULL,NULL),
(163,109,58,NULL,NULL),
(164,110,59,NULL,NULL),
(165,111,60,NULL,NULL),
(166,112,59,NULL,NULL),
(168,113,60,NULL,NULL),
(169,114,59,NULL,NULL),
(170,115,60,NULL,NULL),
(171,116,59,NULL,NULL),
(172,117,60,NULL,NULL),
(174,119,60,NULL,NULL),
(175,120,59,NULL,NULL),
(176,121,60,NULL,NULL),
(177,122,59,NULL,NULL),
(178,123,60,NULL,NULL),
(179,124,56,NULL,NULL),
(180,125,56,NULL,NULL),
(181,126,56,NULL,NULL),
(182,127,56,NULL,NULL),
(183,128,56,NULL,NULL),
(186,129,7,NULL,NULL),
(187,130,28,NULL,NULL),
(188,131,29,NULL,NULL),
(189,132,28,NULL,NULL),
(190,133,29,NULL,NULL),
(191,134,31,NULL,NULL),
(192,135,32,NULL,NULL),
(193,136,37,NULL,NULL),
(194,137,37,NULL,NULL),
(195,138,37,NULL,NULL),
(196,139,26,NULL,NULL),
(197,140,28,NULL,NULL),
(198,141,26,NULL,NULL),
(199,142,29,NULL,NULL),
(200,143,31,NULL,NULL),
(201,144,32,NULL,NULL),
(203,146,14,NULL,NULL),
(204,146,16,NULL,NULL),
(205,118,59,NULL,NULL),
(212,152,37,NULL,NULL),
(213,3,2,NULL,NULL),
(214,153,13,NULL,NULL),
(215,153,15,NULL,NULL),
(218,155,13,NULL,NULL),
(219,155,15,NULL,NULL),
(220,156,14,NULL,NULL),
(221,156,16,NULL,NULL),
(225,158,32,NULL,NULL),
(226,149,37,NULL,NULL),
(227,151,62,NULL,NULL),
(228,159,41,NULL,NULL),
(229,157,62,NULL,NULL),
(230,160,41,NULL,NULL),
(231,145,32,NULL,NULL),
(232,161,62,NULL,NULL),
(233,162,39,NULL,NULL),
(234,163,62,NULL,NULL),
(236,165,43,NULL,NULL),
(237,166,42,NULL,NULL),
(238,167,61,NULL,NULL),
(239,168,61,NULL,NULL),
(240,169,61,NULL,NULL);
/*!40000 ALTER TABLE `fetnet_activity_student` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_tag`
--

DROP TABLE IF EXISTS `fetnet_activity_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_activity_tag_program_id_name_unique` (`program_id`,`name`),
  CONSTRAINT `fetnet_activity_tag_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_tag` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_activity_tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_tag_map`
--

DROP TABLE IF EXISTS `fetnet_activity_tag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_tag_map` (
  `activity_id` bigint(20) unsigned NOT NULL,
  `tag_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`activity_id`,`tag_id`),
  KEY `fetnet_activity_tag_map_tag_id_foreign` (`tag_id`),
  CONSTRAINT `fetnet_activity_tag_map_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_tag_map_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `fetnet_activity_tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_tag_map`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_tag_map` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_tag_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_activity_tag_map` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_teacher`
--

DROP TABLE IF EXISTS `fetnet_activity_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_teacher` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) unsigned NOT NULL,
  `teacher_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_activity_teacher_activity_id_foreign` (`activity_id`),
  KEY `fetnet_activity_teacher_teacher_id_foreign` (`teacher_id`),
  CONSTRAINT `fetnet_activity_teacher_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_activity_teacher_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `fetnet_teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_teacher`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_teacher` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_teacher` DISABLE KEYS */;
INSERT INTO `fetnet_activity_teacher` VALUES
(15,4,2,NULL,NULL),
(17,6,6,NULL,NULL),
(18,7,6,NULL,NULL),
(19,8,6,NULL,NULL),
(20,9,1,NULL,NULL),
(21,10,1,NULL,NULL),
(34,20,10,NULL,NULL),
(38,24,3,NULL,NULL),
(39,25,10,NULL,NULL),
(40,26,3,NULL,NULL),
(41,27,3,NULL,NULL),
(42,28,3,NULL,NULL),
(43,29,3,NULL,NULL),
(46,32,11,NULL,NULL),
(48,34,5,NULL,NULL),
(54,5,6,NULL,NULL),
(55,37,9,NULL,NULL),
(57,39,7,NULL,NULL),
(58,40,7,NULL,NULL),
(59,41,9,NULL,NULL),
(60,42,10,NULL,NULL),
(61,43,4,NULL,NULL),
(64,11,5,NULL,NULL),
(65,12,5,NULL,NULL),
(71,49,24,NULL,NULL),
(72,50,24,NULL,NULL),
(73,28,31,NULL,NULL),
(74,29,31,NULL,NULL),
(77,53,5,NULL,NULL),
(79,55,13,NULL,NULL),
(83,59,20,NULL,NULL),
(84,60,19,NULL,NULL),
(85,61,25,NULL,NULL),
(86,62,25,NULL,NULL),
(87,63,19,NULL,NULL),
(88,64,19,NULL,NULL),
(89,65,24,NULL,NULL),
(90,66,20,NULL,NULL),
(91,67,22,NULL,NULL),
(92,68,22,NULL,NULL),
(93,69,25,NULL,NULL),
(94,70,26,NULL,NULL),
(95,71,7,NULL,NULL),
(96,72,7,NULL,NULL),
(97,71,22,NULL,NULL),
(98,72,22,NULL,NULL),
(99,73,19,NULL,NULL),
(100,74,19,NULL,NULL),
(101,75,27,NULL,NULL),
(102,76,20,NULL,NULL),
(103,77,20,NULL,NULL),
(104,78,29,NULL,NULL),
(105,79,30,NULL,NULL),
(106,80,29,NULL,NULL),
(108,82,22,NULL,NULL),
(109,83,29,NULL,NULL),
(110,84,20,NULL,NULL),
(112,86,8,NULL,NULL),
(113,87,8,NULL,NULL),
(117,90,10,NULL,NULL),
(118,91,10,NULL,NULL),
(119,92,28,NULL,NULL),
(120,93,28,NULL,NULL),
(121,94,10,NULL,NULL),
(124,97,1,NULL,NULL),
(125,98,13,NULL,NULL),
(126,99,1,NULL,NULL),
(127,100,1,NULL,NULL),
(128,58,12,NULL,NULL),
(129,101,2,NULL,NULL),
(130,102,32,NULL,NULL),
(131,103,32,NULL,NULL),
(132,104,18,NULL,NULL),
(133,105,33,NULL,NULL),
(134,106,33,NULL,NULL),
(135,107,33,NULL,NULL),
(136,108,16,NULL,NULL),
(137,109,16,NULL,NULL),
(138,110,33,NULL,NULL),
(139,111,33,NULL,NULL),
(140,112,4,NULL,NULL),
(141,113,4,NULL,NULL),
(142,114,11,NULL,NULL),
(143,115,11,NULL,NULL),
(144,116,12,NULL,NULL),
(145,117,12,NULL,NULL),
(147,118,18,NULL,NULL),
(148,119,18,NULL,NULL),
(149,120,18,NULL,NULL),
(150,121,18,NULL,NULL),
(151,122,11,NULL,NULL),
(152,123,11,NULL,NULL),
(153,124,18,NULL,NULL),
(154,125,1,NULL,NULL),
(155,126,18,NULL,NULL),
(156,127,16,NULL,NULL),
(157,128,4,NULL,NULL),
(159,129,4,NULL,NULL),
(160,130,30,NULL,NULL),
(161,131,30,NULL,NULL),
(162,132,8,NULL,NULL),
(163,133,8,NULL,NULL),
(164,134,3,NULL,NULL),
(165,135,3,NULL,NULL),
(166,136,8,NULL,NULL),
(167,137,17,NULL,NULL),
(168,138,29,NULL,NULL),
(171,139,29,NULL,NULL),
(172,139,7,NULL,NULL),
(175,140,26,NULL,NULL),
(176,141,19,NULL,NULL),
(177,142,26,NULL,NULL),
(178,143,17,NULL,NULL),
(179,144,17,NULL,NULL),
(181,146,12,NULL,NULL),
(182,54,4,NULL,NULL),
(183,129,15,NULL,NULL),
(188,47,20,NULL,NULL),
(189,48,11,NULL,NULL),
(190,34,15,NULL,NULL),
(195,53,15,NULL,NULL),
(199,5,15,NULL,NULL),
(200,6,15,NULL,NULL),
(201,54,15,NULL,NULL),
(205,56,2,NULL,NULL),
(206,33,24,NULL,NULL),
(207,152,9,NULL,NULL),
(208,3,2,NULL,NULL),
(210,85,24,NULL,NULL),
(211,153,3,NULL,NULL),
(213,155,5,NULL,NULL),
(214,104,34,NULL,NULL),
(215,105,34,NULL,NULL),
(216,122,34,NULL,NULL),
(217,123,34,NULL,NULL),
(218,125,34,NULL,NULL),
(220,156,16,NULL,NULL),
(221,156,31,NULL,NULL),
(222,95,2,NULL,NULL),
(223,96,2,NULL,NULL),
(224,96,15,NULL,NULL),
(225,45,12,NULL,NULL),
(226,45,31,NULL,NULL),
(227,38,5,NULL,NULL),
(228,44,7,NULL,NULL),
(229,44,17,NULL,NULL),
(230,36,12,NULL,NULL),
(231,75,22,NULL,NULL),
(232,88,6,NULL,NULL),
(233,88,27,NULL,NULL),
(234,89,6,NULL,NULL),
(235,89,27,NULL,NULL),
(236,149,8,NULL,NULL),
(237,149,27,NULL,NULL),
(240,35,5,NULL,NULL),
(241,19,6,NULL,NULL),
(242,157,11,NULL,NULL),
(245,159,9,NULL,NULL),
(246,160,9,NULL,NULL),
(247,161,17,NULL,NULL),
(248,162,8,NULL,NULL),
(249,163,10,NULL,NULL),
(251,165,9,NULL,NULL),
(252,166,29,NULL,NULL),
(253,167,7,NULL,NULL),
(254,168,12,NULL,NULL),
(255,169,17,NULL,NULL),
(258,39,31,NULL,NULL),
(259,40,31,NULL,NULL),
(261,145,30,NULL,NULL),
(263,158,30,NULL,NULL),
(264,145,17,NULL,NULL),
(265,158,17,NULL,NULL),
(266,151,7,NULL,NULL),
(267,95,31,NULL,NULL);
/*!40000 ALTER TABLE `fetnet_activity_teacher` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_activity_type`
--

DROP TABLE IF EXISTS `fetnet_activity_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_activity_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_activity_type`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_activity_type` WRITE;
/*!40000 ALTER TABLE `fetnet_activity_type` DISABLE KEYS */;
INSERT INTO `fetnet_activity_type` VALUES
(1,'Theory','2026-06-12 06:01:16','2026-06-12 06:01:16'),
(2,'Laboratory','2026-06-12 06:01:16','2026-06-12 06:01:16'),
(3,'Studio','2026-06-12 06:01:16','2026-06-12 06:01:16');
/*!40000 ALTER TABLE `fetnet_activity_type` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_building`
--

DROP TABLE IF EXISTS `fetnet_building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_building` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_building_client_id_foreign` (`client_id`),
  CONSTRAINT `fetnet_building_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_building`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_building` WRITE;
/*!40000 ALTER TABLE `fetnet_building` DISABLE KEYS */;
INSERT INTO `fetnet_building` VALUES
(1,1,'Gedung A FPTI','FPTI A','2026-06-21 17:11:46','2026-06-21 17:11:46'),
(2,1,'Gedung B FPTI','FPTI B','2026-06-21 17:11:59','2026-06-21 17:11:59'),
(3,1,'Gedung C FPTI','FPTI C','2026-06-21 17:12:21','2026-06-21 17:12:21'),
(4,1,'Gedung D FPTI','FPTI D','2026-06-21 17:13:16','2026-06-21 17:13:16');
/*!40000 ALTER TABLE `fetnet_building` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_client`
--

DROP TABLE IF EXISTS `fetnet_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_client` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `university_id` bigint(20) unsigned DEFAULT NULL,
  `faculty_id` bigint(20) unsigned DEFAULT NULL,
  `client_level_id` bigint(20) unsigned DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_client_user_id_foreign` (`user_id`),
  KEY `fetnet_client_university_id_foreign` (`university_id`),
  KEY `fetnet_client_faculty_id_foreign` (`faculty_id`),
  KEY `fetnet_client_client_level_id_foreign` (`client_level_id`),
  CONSTRAINT `fetnet_client_client_level_id_foreign` FOREIGN KEY (`client_level_id`) REFERENCES `fetnet_client_level` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_client_faculty_id_foreign` FOREIGN KEY (`faculty_id`) REFERENCES `institution_faculty` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_client_university_id_foreign` FOREIGN KEY (`university_id`) REFERENCES `institution_university` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_client_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_client`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_client` WRITE;
/*!40000 ALTER TABLE `fetnet_client` DISABLE KEYS */;
INSERT INTO `fetnet_client` VALUES
(1,2,1,1,1,'Fakultas Teknik Elektro','2026-06-12 06:09:20','2026-06-12 06:09:20');
/*!40000 ALTER TABLE `fetnet_client` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_client_config`
--

DROP TABLE IF EXISTS `fetnet_client_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_client_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned DEFAULT NULL,
  `number_of_days` int(11) NOT NULL DEFAULT 0,
  `number_of_hours` int(11) NOT NULL DEFAULT 0,
  `start_time` time NOT NULL DEFAULT '07:00:00',
  `slot_duration` smallint(6) NOT NULL DEFAULT 50,
  `break_start` time NOT NULL DEFAULT '12:00:00',
  `break_end` time NOT NULL DEFAULT '13:00:00',
  `no_break` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_client_config_client_id_foreign` (`client_id`),
  CONSTRAINT `fetnet_client_config_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_client_config`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_client_config` WRITE;
/*!40000 ALTER TABLE `fetnet_client_config` DISABLE KEYS */;
INSERT INTO `fetnet_client_config` VALUES
(1,1,5,12,'07:00:00',50,'12:00:00','13:00:00',0,'2026-06-12 06:09:20','2026-06-12 06:15:26');
/*!40000 ALTER TABLE `fetnet_client_config` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_client_level`
--

DROP TABLE IF EXISTS `fetnet_client_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_client_level` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_client_level`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_client_level` WRITE;
/*!40000 ALTER TABLE `fetnet_client_level` DISABLE KEYS */;
INSERT INTO `fetnet_client_level` VALUES
(1,'CLU','Cluster','2026-06-12 06:01:23','2026-06-12 06:01:23'),
(2,'FAK','Fakultas','2026-06-12 06:01:23','2026-06-12 06:01:23'),
(3,'PRG','Program Studi','2026-06-12 06:01:23','2026-06-12 06:01:23');
/*!40000 ALTER TABLE `fetnet_client_level` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_cluster`
--

DROP TABLE IF EXISTS `fetnet_cluster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_cluster` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned DEFAULT NULL,
  `cluster_base_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_cluster_program_id_foreign` (`program_id`),
  KEY `fetnet_cluster_cluster_base_id_foreign` (`cluster_base_id`),
  CONSTRAINT `fetnet_cluster_cluster_base_id_foreign` FOREIGN KEY (`cluster_base_id`) REFERENCES `fetnet_cluster_base` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_cluster_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_cluster`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_cluster` WRITE;
/*!40000 ALTER TABLE `fetnet_cluster` DISABLE KEYS */;
INSERT INTO `fetnet_cluster` VALUES
(1,1,1,'2026-06-12 06:09:59','2026-06-12 06:09:59'),
(2,2,1,'2026-06-12 06:11:09','2026-06-12 06:11:09'),
(3,3,1,'2026-06-12 06:11:49','2026-06-12 06:11:49'),
(4,4,1,'2026-06-12 06:13:01','2026-06-12 06:13:01');
/*!40000 ALTER TABLE `fetnet_cluster` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_cluster_base`
--

DROP TABLE IF EXISTS `fetnet_cluster_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_cluster_base` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `name_eng` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_cluster_base_client_id_foreign` (`client_id`),
  CONSTRAINT `fetnet_cluster_base_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_cluster_base`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_cluster_base` WRITE;
/*!40000 ALTER TABLE `fetnet_cluster_base` DISABLE KEYS */;
INSERT INTO `fetnet_cluster_base` VALUES
(1,1,'FTE','Fakultas Teknik Elektro',NULL,'2026-06-12 06:09:20','2026-06-12 06:09:20');
/*!40000 ALTER TABLE `fetnet_cluster_base` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_curriculum_year`
--

DROP TABLE IF EXISTS `fetnet_curriculum_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_curriculum_year` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `year` varchar(20) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_curriculum_year_program_id_year_unique` (`program_id`,`year`),
  CONSTRAINT `fetnet_curriculum_year_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_curriculum_year`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_curriculum_year` WRITE;
/*!40000 ALTER TABLE `fetnet_curriculum_year` DISABLE KEYS */;
INSERT INTO `fetnet_curriculum_year` VALUES
(1,1,'2023',NULL,'2026-06-13 15:31:00','2026-06-13 15:31:00'),
(2,1,'2018',NULL,'2026-06-14 22:45:28','2026-06-14 22:45:28'),
(3,3,'2020',NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(4,3,'2018',NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(5,3,'2024',NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(6,2,'2023',NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(7,4,'2023',NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(8,2,'2024',NULL,'2026-06-24 06:47:52','2026-06-24 06:47:52');
/*!40000 ALTER TABLE `fetnet_curriculum_year` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_fet_compile`
--

DROP TABLE IF EXISTS `fetnet_fet_compile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_fet_compile` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `semester_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `size_bytes` bigint(20) unsigned DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `message` text DEFAULT NULL,
  `duration_ms` int(10) unsigned DEFAULT NULL,
  `solver_status` varchar(255) DEFAULT NULL,
  `solver_output_dir` varchar(255) DEFAULT NULL,
  `solver_result_path` varchar(255) DEFAULT NULL,
  `solver_started_at` timestamp NULL DEFAULT NULL,
  `solver_finished_at` timestamp NULL DEFAULT NULL,
  `solver_pid` int(10) unsigned DEFAULT NULL,
  `solver_message` text DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `published_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_fet_compile_semester_id_foreign` (`semester_id`),
  KEY `fetnet_fet_compile_user_id_foreign` (`user_id`),
  KEY `fetnet_fet_compile_published_by_foreign` (`published_by`),
  KEY `fetnet_fet_compile_client_id_semester_id_index` (`client_id`,`semester_id`),
  KEY `fetnet_fet_compile_status_index` (`status`),
  KEY `fetnet_fet_compile_solver_status_index` (`solver_status`),
  KEY `fet_compile_publish_lookup` (`client_id`,`semester_id`,`published_at`),
  CONSTRAINT `fetnet_fet_compile_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_fet_compile_published_by_foreign` FOREIGN KEY (`published_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_fet_compile_semester_id_foreign` FOREIGN KEY (`semester_id`) REFERENCES `fetnet_semester` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_fet_compile_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_fet_compile`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_fet_compile` WRITE;
/*!40000 ALTER TABLE `fetnet_fet_compile` DISABLE KEYS */;
INSERT INTO `fetnet_fet_compile` VALUES
(1,1,1,2,NULL,99319,'failed','Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n.',292,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-19 00:28:56','2026-06-25 03:40:44'),
(2,1,1,2,NULL,116558,'failed','Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n.',276,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-19 04:42:12','2026-06-25 03:40:44'),
(3,1,1,NULL,NULL,116558,'success','Compile completed.',271,'failed','fet-solve/3',NULL,'2026-06-19 04:46:38','2026-06-19 04:46:38',NULL,'Worker crash: Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n.',NULL,NULL,'2026-06-19 04:46:30','2026-06-25 03:40:44'),
(4,1,1,2,NULL,116558,'failed','Pusher error: <html>\r\n<head><title>502 Bad Gateway</title></head>\r\n<body>\r\n<center><h1>502 Bad Gateway</h1></center>\r\n<hr><center>nginx/1.31.1</center>\r\n</body>\r\n</html>\r\n.',235,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-19 04:46:34','2026-06-25 03:40:44'),
(5,1,1,NULL,NULL,116558,'success','Compile completed.',251,'success','fet-solve/5',NULL,'2026-06-19 05:45:51','2026-06-19 05:45:52',NULL,'Solver finished.',NULL,NULL,'2026-06-19 04:48:00','2026-06-25 03:40:44'),
(6,1,1,2,NULL,131207,'success','Compile completed.',186,'success','fet-solve/6',NULL,'2026-06-19 05:59:51','2026-06-19 05:59:52',NULL,'Solver finished.',NULL,NULL,'2026-06-19 05:59:39','2026-06-25 03:40:44'),
(7,1,1,2,NULL,128224,'success','Compile completed.',384,'success','fet-solve/7',NULL,'2026-06-19 07:34:17','2026-06-19 07:34:18',NULL,'Solver finished.',NULL,NULL,'2026-06-19 07:34:08','2026-06-25 03:40:44'),
(8,1,1,2,NULL,131975,'success','Compile completed.',314,'success','fet-solve/8',NULL,'2026-06-19 07:57:52','2026-06-19 07:57:53',NULL,'Solver finished.',NULL,NULL,'2026-06-19 07:57:49','2026-06-25 03:40:44'),
(9,1,1,2,NULL,157486,'success','Compile completed.',354,'failed','fet-solve/9',NULL,'2026-06-19 12:47:23','2026-06-19 12:47:23',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-19 12:09:09','2026-06-25 03:40:44'),
(10,1,1,2,NULL,156722,'success','Compile completed.',296,'failed','fet-solve/10',NULL,'2026-06-19 12:47:42','2026-06-19 12:47:43',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-19 12:47:37','2026-06-25 03:40:44'),
(11,1,1,2,NULL,154378,'success','Compile completed.',279,'success','fet-solve/11',NULL,'2026-06-19 12:48:51','2026-06-19 12:48:51',NULL,'Solver finished.',NULL,NULL,'2026-06-19 12:48:44','2026-06-25 03:40:44'),
(12,1,1,2,NULL,147578,'success','Compile completed.',261,'success','fet-solve/12',NULL,'2026-06-19 12:49:46','2026-06-19 12:49:46',NULL,'Solver finished.',NULL,NULL,'2026-06-19 12:49:39','2026-06-25 03:40:44'),
(13,1,1,2,NULL,147960,'success','Compile completed.',281,'success','fet-solve/13',NULL,'2026-06-19 13:14:25','2026-06-19 13:14:26',NULL,'Solver finished.',NULL,NULL,'2026-06-19 13:14:19','2026-06-25 03:40:44'),
(14,1,1,2,NULL,152976,'success','Compile completed.',263,'success','fet-solve/14',NULL,'2026-06-19 13:25:28','2026-06-19 13:25:28',NULL,'Solver finished.',NULL,NULL,'2026-06-19 13:25:22','2026-06-25 03:40:44'),
(15,1,1,2,NULL,176495,'success','Compile completed.',501,'success','fet-solve/15',NULL,'2026-06-19 16:41:03','2026-06-19 16:41:04',NULL,'Solver finished.',NULL,NULL,'2026-06-19 16:40:43','2026-06-25 03:40:44'),
(16,1,1,2,NULL,178131,'success','Compile completed.',344,'success','fet-solve/16',NULL,'2026-06-19 17:10:19','2026-06-19 17:10:20',NULL,'Solver finished.',NULL,NULL,'2026-06-19 17:09:15','2026-06-25 03:40:44'),
(17,1,1,2,NULL,177787,'success','Compile completed.',560,'success','fet-solve/17',NULL,'2026-06-19 17:21:37','2026-06-19 17:21:37',NULL,'Solver finished.',NULL,NULL,'2026-06-19 17:21:02','2026-06-25 03:40:44'),
(18,1,1,2,NULL,227070,'success','Compile completed.',572,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-20 04:49:07','2026-06-25 03:40:44'),
(19,1,1,2,NULL,227070,'success','Compile completed.',357,'success','fet-solve/19',NULL,'2026-06-20 04:49:17','2026-06-20 04:49:17',NULL,'Solver finished.',NULL,NULL,'2026-06-20 04:49:12','2026-06-25 03:40:44'),
(20,1,1,2,NULL,279450,'success','Compile completed.',431,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-20 16:29:18','2026-06-25 03:40:44'),
(21,1,1,2,NULL,279450,'success','Compile completed.',514,'failed','fet-solve/21',NULL,'2026-06-20 16:33:07','2026-06-20 16:33:07',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:31:38','2026-06-25 03:40:44'),
(22,1,1,2,NULL,278304,'success','Compile completed.',501,'failed','fet-solve/22',NULL,'2026-06-20 16:36:45','2026-06-20 16:36:45',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:36:41','2026-06-25 03:40:44'),
(23,1,1,2,NULL,277540,'success','Compile completed.',507,'failed','fet-solve/23',NULL,'2026-06-20 16:37:45','2026-06-20 16:37:45',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:37:38','2026-06-25 03:40:44'),
(24,1,1,2,NULL,275630,'success','Compile completed.',632,'failed','fet-solve/24',NULL,'2026-06-20 16:40:38','2026-06-20 16:40:39',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:40:33','2026-06-25 03:40:44'),
(25,1,1,2,NULL,274302,'success','Compile completed.',454,'failed','fet-solve/25',NULL,'2026-06-20 16:41:58','2026-06-20 16:41:59',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:41:55','2026-06-25 03:40:44'),
(26,1,1,2,NULL,274208,'success','Compile completed.',735,'failed','fet-solve/26',NULL,'2026-06-20 16:43:27','2026-06-20 16:43:28',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:42:58','2026-06-25 03:40:44'),
(27,1,1,2,NULL,273174,'success','Compile completed.',466,'failed','fet-solve/27',NULL,'2026-06-20 16:54:13','2026-06-20 16:54:14',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-20 16:54:09','2026-06-25 03:40:44'),
(28,1,1,2,NULL,264890,'success','Compile completed.',498,'success','fet-solve/28',NULL,'2026-06-20 17:16:07','2026-06-20 17:16:08',NULL,'Solver finished.',NULL,NULL,'2026-06-20 17:03:05','2026-06-25 03:40:44'),
(29,1,1,2,NULL,265278,'success','Compile completed.',512,'success','fet-solve/29',NULL,'2026-06-20 17:19:52','2026-06-20 17:19:53',NULL,'Solver finished.',NULL,NULL,'2026-06-20 17:19:48','2026-06-25 03:40:44'),
(30,1,1,2,NULL,265278,'success','Compile completed.',484,'success','fet-solve/30',NULL,'2026-06-20 17:36:59','2026-06-20 17:37:00',NULL,'Solver finished.',NULL,NULL,'2026-06-20 17:36:09','2026-06-25 03:40:44'),
(31,1,1,2,NULL,265278,'success','Compile completed.',484,'success','fet-solve/31',NULL,'2026-06-20 17:46:19','2026-06-20 17:46:20',NULL,'Solver finished.',NULL,NULL,'2026-06-20 17:46:14','2026-06-25 03:40:44'),
(32,1,1,2,NULL,265278,'success','Compile completed.',812,'success','fet-solve/32',NULL,'2026-06-20 17:53:13','2026-06-20 17:53:15',NULL,'Solver finished.',NULL,NULL,'2026-06-20 17:53:10','2026-06-25 03:40:44'),
(33,1,1,2,NULL,265284,'success','Compile completed.',677,'success','fet-solve/33',NULL,'2026-06-20 18:03:01','2026-06-20 18:03:03',NULL,'Solver finished.',NULL,NULL,'2026-06-20 18:02:59','2026-06-25 03:40:44'),
(34,1,1,2,NULL,265157,'success','Compile completed.',490,'success','fet-solve/34',NULL,'2026-06-21 17:02:52','2026-06-21 17:02:53',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:02:45','2026-06-25 03:40:44'),
(35,1,1,2,NULL,265721,'success','Compile completed.',455,'success','fet-solve/35',NULL,'2026-06-21 17:04:26','2026-06-21 17:04:27',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:04:23','2026-06-25 03:40:44'),
(36,1,1,2,NULL,267431,'success','Compile completed.',470,'success','fet-solve/36',NULL,'2026-06-21 17:05:24','2026-06-21 17:05:25',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:05:20','2026-06-25 03:40:44'),
(37,1,1,2,NULL,270669,'success','Compile completed.',425,'success','fet-solve/37',NULL,'2026-06-21 17:08:23','2026-06-21 17:08:24',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:08:20','2026-06-25 03:40:44'),
(38,1,1,2,NULL,270669,'success','Compile completed.',427,'success','fet-solve/38',NULL,'2026-06-21 17:09:42','2026-06-21 17:09:43',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:09:38','2026-06-25 03:40:44'),
(39,1,1,2,NULL,271701,'success','Compile completed.',428,'success','fet-solve/39',NULL,'2026-06-21 17:18:32','2026-06-21 17:18:33',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:18:26','2026-06-25 03:40:44'),
(40,1,1,2,NULL,271701,'success','Compile completed.',412,'success','fet-solve/40',NULL,'2026-06-21 17:21:10','2026-06-21 17:21:11',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:21:07','2026-06-25 03:40:44'),
(41,1,1,2,NULL,275072,'success','Compile completed.',543,'success','fet-solve/41',NULL,'2026-06-21 17:26:43','2026-06-21 17:26:44',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:26:40','2026-06-25 03:40:44'),
(42,1,1,2,NULL,275710,'success','Compile completed.',384,'success','fet-solve/42',NULL,'2026-06-21 17:28:00','2026-06-21 17:28:01',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:27:57','2026-06-25 03:40:44'),
(43,1,1,2,NULL,275710,'success','Compile completed.',411,'success','fet-solve/43',NULL,'2026-06-21 17:31:30','2026-06-21 17:31:31',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:31:27','2026-06-25 03:40:44'),
(44,1,1,2,NULL,275710,'success','Compile completed.',565,'success','fet-solve/44',NULL,'2026-06-21 17:36:04','2026-06-21 17:36:05',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:36:01','2026-06-25 03:40:44'),
(45,1,1,2,NULL,275710,'success','Compile completed.',422,'success','fet-solve/45',NULL,'2026-06-21 17:47:38','2026-06-21 17:47:40',NULL,'Solver finished.',NULL,NULL,'2026-06-21 17:47:33','2026-06-25 03:40:44'),
(46,1,1,2,NULL,313960,'success','Compile completed.',714,'failed','fet-solve/46',NULL,'2026-06-23 07:54:45','2026-06-23 07:54:46',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 07:54:40','2026-06-25 03:40:44'),
(47,1,1,2,NULL,313960,'success','Compile completed.',477,'failed','fet-solve/47',NULL,'2026-06-23 07:55:23','2026-06-23 07:55:23',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 07:55:14','2026-06-25 03:40:44'),
(48,1,1,2,NULL,314403,'success','Compile completed.',604,'failed','fet-solve/48',NULL,'2026-06-23 08:03:46','2026-06-23 08:03:46',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:03:40','2026-06-25 03:40:44'),
(49,1,1,2,NULL,314403,'success','Compile completed.',668,'failed','fet-solve/49',NULL,'2026-06-23 08:04:08','2026-06-23 08:04:09',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:04:02','2026-06-25 03:40:44'),
(50,1,1,2,NULL,315291,'success','Compile completed.',531,'failed','fet-solve/50',NULL,'2026-06-23 08:15:33','2026-06-23 08:15:34',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:15:26','2026-06-25 03:40:44'),
(51,1,1,2,NULL,315938,'success','Compile completed.',582,'failed','fet-solve/51',NULL,'2026-06-23 08:18:23','2026-06-23 08:18:23',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:18:18','2026-06-25 03:40:44'),
(52,1,1,2,NULL,315911,'success','Compile completed.',748,'failed','fet-solve/52',NULL,'2026-06-23 08:21:43','2026-06-23 08:21:43',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:21:40','2026-06-25 03:40:44'),
(53,1,1,2,NULL,315911,'success','Compile completed.',510,'failed','fet-solve/53',NULL,'2026-06-23 08:22:13','2026-06-23 08:22:14',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:22:09','2026-06-25 03:40:44'),
(54,1,1,NULL,NULL,318354,'success','Compile completed.',592,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 08:25:20','2026-06-25 03:40:44'),
(55,1,1,NULL,NULL,318442,'success','Compile completed.',593,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 08:25:27','2026-06-25 03:40:44'),
(56,1,1,NULL,NULL,318886,'success','Compile completed.',807,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 08:25:51','2026-06-25 03:40:44'),
(57,1,1,2,NULL,318858,'success','Compile completed.',665,'failed','fet-solve/57',NULL,'2026-06-23 08:27:00','2026-06-23 08:27:00',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:26:52','2026-06-25 03:40:44'),
(58,1,1,2,NULL,318859,'success','Compile completed.',528,'failed','fet-solve/58',NULL,'2026-06-23 08:28:26','2026-06-23 08:28:26',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:28:22','2026-06-25 03:40:44'),
(59,1,1,NULL,NULL,318886,'success','Compile completed.',570,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 08:29:54','2026-06-25 03:40:44'),
(60,1,1,2,NULL,318886,'success','Compile completed.',615,'failed','fet-solve/60',NULL,'2026-06-23 08:30:34','2026-06-23 08:30:34',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:30:30','2026-06-25 03:40:44'),
(61,1,1,2,NULL,319906,'success','Compile completed.',626,'failed','fet-solve/61',NULL,'2026-06-23 08:38:09','2026-06-23 08:38:10',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:38:06','2026-06-25 03:40:44'),
(62,1,1,2,NULL,324907,'success','Compile completed.',753,'failed','fet-solve/62',NULL,'2026-06-23 08:45:16','2026-06-23 08:45:16',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:45:12','2026-06-25 03:40:44'),
(63,1,1,2,NULL,324907,'success','Compile completed.',917,'failed','fet-solve/63',NULL,'2026-06-23 08:51:37','2026-06-23 08:51:37',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:51:30','2026-06-25 03:40:44'),
(64,1,1,2,NULL,324929,'success','Compile completed.',755,'failed','fet-solve/64',NULL,'2026-06-23 08:54:12','2026-06-23 08:54:12',NULL,'Solver exited with code 1',NULL,NULL,'2026-06-23 08:54:08','2026-06-25 03:40:44'),
(65,1,1,2,NULL,324297,'success','Compile completed.',597,'success','fet-solve/65',NULL,'2026-06-23 08:58:33','2026-06-23 08:58:34',NULL,'Solver finished.',NULL,NULL,'2026-06-23 08:58:30','2026-06-25 03:40:44'),
(66,1,1,2,NULL,NULL,'failed','Compile dibatalkan: 12 aktivitas memiliki data tidak lengkap:\n  • ER597 — SEMINAR TEKNIK OTOMASI INDUSTRI DAN ROBOTIKA (id=85): belum ada dosen\n  • ET224 — SENSOR DAN AKTUATOR (id=118): belum ada ruangan\n  • ET224 — SENSOR DAN AKTUATOR (id=119): belum ada ruangan\n  • ET225 — RANGKAIAN LISTRIK DAN ELEKTRONIK 2 (id=120): belum ada ruangan\n  • ET225 — RANGKAIAN LISTRIK DAN ELEKTRONIK 2 (id=121): belum ada ruangan\n  • ET226 — FISIKA GELOMBANG DAN MEKANIKA FLUIDA (id=122): belum ada ruangan\n  • ET226 — FISIKA GELOMBANG DAN MEKANIKA FLUIDA (id=123): belum ada ruangan\n  • ET233 — TEKNOLOGI ENERGI HIDRO DAN BAYU (id=124): belum ada ruangan\n  • ET308 — ILMU MATERIAL TET (id=125): belum ada ruangan\n  • ET310 — ELEKTRONIKA DAYA (id=126): belum ada ruangan\n  • ET319 — SISTEM PENYIMPANAN ENERGI (id=127): belum ada ruangan\n  • ET602 — SCADA DAN INTERNET OF THINGS (id=128): belum ada ruangan',309,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 09:04:13','2026-06-25 03:40:44'),
(67,1,1,2,NULL,NULL,'failed','Compile dibatalkan: 12 aktivitas memiliki data tidak lengkap:\n  • ER597 — SEMINAR TEKNIK OTOMASI INDUSTRI DAN ROBOTIKA (id=85): belum ada dosen\n  • ET224 — SENSOR DAN AKTUATOR (id=118): belum ada ruangan\n  • ET224 — SENSOR DAN AKTUATOR (id=119): belum ada ruangan\n  • ET225 — RANGKAIAN LISTRIK DAN ELEKTRONIK 2 (id=120): belum ada ruangan\n  • ET225 — RANGKAIAN LISTRIK DAN ELEKTRONIK 2 (id=121): belum ada ruangan\n  • ET226 — FISIKA GELOMBANG DAN MEKANIKA FLUIDA (id=122): belum ada ruangan\n  • ET226 — FISIKA GELOMBANG DAN MEKANIKA FLUIDA (id=123): belum ada ruangan\n  • ET233 — TEKNOLOGI ENERGI HIDRO DAN BAYU (id=124): belum ada ruangan\n  • ET308 — ILMU MATERIAL TET (id=125): belum ada ruangan\n  • ET310 — ELEKTRONIKA DAYA (id=126): belum ada ruangan\n  • ET319 — SISTEM PENYIMPANAN ENERGI (id=127): belum ada ruangan\n  • ET602 — SCADA DAN INTERNET OF THINGS (id=128): belum ada ruangan',298,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 09:04:29','2026-06-25 03:40:44'),
(68,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":12,\"items\":[{\"id\":85,\"code\":\"ER597\",\"name\":\"SEMINAR TEKNIK OTOMASI INDUSTRI DAN ROBOTIKA\",\"issues\":[\"Dosen belum diisi\"]},{\"id\":118,\"code\":\"ET224\",\"name\":\"SENSOR DAN AKTUATOR\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":119,\"code\":\"ET224\",\"name\":\"SENSOR DAN AKTUATOR\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":120,\"code\":\"ET225\",\"name\":\"RANGKAIAN LISTRIK DAN ELEKTRONIK 2\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":121,\"code\":\"ET225\",\"name\":\"RANGKAIAN LISTRIK DAN ELEKTRONIK 2\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":122,\"code\":\"ET226\",\"name\":\"FISIKA GELOMBANG DAN MEKANIKA FLUIDA\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":123,\"code\":\"ET226\",\"name\":\"FISIKA GELOMBANG DAN MEKANIKA FLUIDA\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":124,\"code\":\"ET233\",\"name\":\"TEKNOLOGI ENERGI HIDRO DAN BAYU\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":125,\"code\":\"ET308\",\"name\":\"ILMU MATERIAL TET\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":126,\"code\":\"ET310\",\"name\":\"ELEKTRONIKA DAYA\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":127,\"code\":\"ET319\",\"name\":\"SISTEM PENYIMPANAN ENERGI\",\"issues\":[\"Ruangan belum diisi\"]},{\"id\":128,\"code\":\"ET602\",\"name\":\"SCADA DAN INTERNET OF THINGS\",\"issues\":[\"Ruangan belum diisi\"]}]}',291,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 09:07:49','2026-06-25 03:40:44'),
(69,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":12,\"items\":[{\"id\":85,\"code\":\"ER597\",\"name\":\"SEMINAR TEKNIK OTOMASI INDUSTRI DAN ROBOTIKA\",\"issues\":[\"No teacher assigned\"]},{\"id\":118,\"code\":\"ET224\",\"name\":\"SENSOR DAN AKTUATOR\",\"issues\":[\"No room assigned\"]},{\"id\":119,\"code\":\"ET224\",\"name\":\"SENSOR DAN AKTUATOR\",\"issues\":[\"No room assigned\"]},{\"id\":120,\"code\":\"ET225\",\"name\":\"RANGKAIAN LISTRIK DAN ELEKTRONIK 2\",\"issues\":[\"No room assigned\"]},{\"id\":121,\"code\":\"ET225\",\"name\":\"RANGKAIAN LISTRIK DAN ELEKTRONIK 2\",\"issues\":[\"No room assigned\"]},{\"id\":122,\"code\":\"ET226\",\"name\":\"FISIKA GELOMBANG DAN MEKANIKA FLUIDA\",\"issues\":[\"No room assigned\"]},{\"id\":123,\"code\":\"ET226\",\"name\":\"FISIKA GELOMBANG DAN MEKANIKA FLUIDA\",\"issues\":[\"No room assigned\"]},{\"id\":124,\"code\":\"ET233\",\"name\":\"TEKNOLOGI ENERGI HIDRO DAN BAYU\",\"issues\":[\"No room assigned\"]},{\"id\":125,\"code\":\"ET308\",\"name\":\"ILMU MATERIAL TET\",\"issues\":[\"No room assigned\"]},{\"id\":126,\"code\":\"ET310\",\"name\":\"ELEKTRONIKA DAYA\",\"issues\":[\"No room assigned\"]},{\"id\":127,\"code\":\"ET319\",\"name\":\"SISTEM PENYIMPANAN ENERGI\",\"issues\":[\"No room assigned\"]},{\"id\":128,\"code\":\"ET602\",\"name\":\"SCADA DAN INTERNET OF THINGS\",\"issues\":[\"No room assigned\"]}]}',296,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 14:06:00','2026-06-25 03:40:44'),
(70,1,1,2,NULL,329846,'success','Compile completed.',634,'success','fet-solve/70',NULL,'2026-06-23 22:19:46','2026-06-23 22:19:48',NULL,'Solver finished.',NULL,NULL,'2026-06-23 22:19:42','2026-06-25 03:40:44'),
(71,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":2,\"items\":[{\"id\":153,\"code\":\"EE515\",\"name\":\"PENGOLAHAN SINYAL DAN APLIKASINYA (P)\",\"issues\":[\"No room assigned\"]},{\"id\":154,\"code\":\"EE519\",\"name\":\"JARINGAN AKSES NIRKABEL (P)\",\"issues\":[\"No room assigned\"]}]}',398,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 03:45:52','2026-06-25 03:40:44'),
(72,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":10,\"items\":[{\"id\":153,\"code\":\"EE515\",\"name\":\"PENGOLAHAN SINYAL DAN APLIKASINYA (P)\",\"issues\":[\"No room assigned\"]},{\"id\":155,\"code\":\"EE511\",\"name\":\"SISTEM KOMUNIKASI SATELIT DAN TERESTRIAL (P)\",\"issues\":[\"No room assigned\"]},{\"id\":156,\"code\":\"EE539\",\"name\":\"SCADA DAN MANAJEMEN ENERGI (P)\",\"issues\":[\"No room assigned\"]},{\"id\":157,\"code\":\"EL533\",\"name\":\"MESIN LISTRIK  AC\",\"issues\":[\"No room assigned\"]},{\"id\":158,\"code\":\"EL313\",\"name\":\"SISTEM TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":159,\"code\":\"EL523\",\"name\":\"JARINGAN TELEKOMUNIKASI\",\"issues\":[\"No room assigned\"]},{\"id\":160,\"code\":\"EL525\",\"name\":\"SISTEM ANTENA\",\"issues\":[\"No room assigned\"]},{\"id\":161,\"code\":\"EL532\",\"name\":\"PRAKTIKUM TEKNIK TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":162,\"code\":\"EL527\",\"name\":\"PRAKTIKUM SENSOR DAN SISTEM MIKROPROSESOR\",\"issues\":[\"No room assigned\"]},{\"id\":163,\"code\":\"EL537\",\"name\":\"SISTEM PEMBANGKIT TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]}]}',329,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 08:20:22','2026-06-25 03:40:44'),
(73,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":14,\"items\":[{\"id\":153,\"code\":\"EE515\",\"name\":\"PENGOLAHAN SINYAL DAN APLIKASINYA (P)\",\"issues\":[\"No room assigned\"]},{\"id\":155,\"code\":\"EE511\",\"name\":\"SISTEM KOMUNIKASI SATELIT DAN TERESTRIAL (P)\",\"issues\":[\"No room assigned\"]},{\"id\":156,\"code\":\"EE539\",\"name\":\"SCADA DAN MANAJEMEN ENERGI (P)\",\"issues\":[\"No room assigned\"]},{\"id\":157,\"code\":\"EL533\",\"name\":\"MESIN LISTRIK  AC\",\"issues\":[\"No room assigned\"]},{\"id\":158,\"code\":\"EL313\",\"name\":\"SISTEM TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":159,\"code\":\"EL523\",\"name\":\"JARINGAN TELEKOMUNIKASI\",\"issues\":[\"No room assigned\"]},{\"id\":160,\"code\":\"EL525\",\"name\":\"SISTEM ANTENA\",\"issues\":[\"No room assigned\"]},{\"id\":161,\"code\":\"EL532\",\"name\":\"PRAKTIKUM TEKNIK TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":162,\"code\":\"EL527\",\"name\":\"PRAKTIKUM SENSOR DAN SISTEM MIKROPROSESOR\",\"issues\":[\"No room assigned\"]},{\"id\":163,\"code\":\"EL537\",\"name\":\"SISTEM PEMBANGKIT TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":165,\"code\":\"EL348\",\"name\":\"REKAYASA TRAFIK TELEKOMUNIKASI\",\"issues\":[\"No room assigned\"]},{\"id\":166,\"code\":\"EL722\",\"name\":\"VISI KOMPUTER\",\"issues\":[\"No room assigned\"]},{\"id\":167,\"code\":\"EL731\",\"name\":\"PENGGUNAAN DAN PENGATURAN MOTOR\",\"issues\":[\"No room assigned\"]},{\"id\":168,\"code\":\"EL732\",\"name\":\"KELISTRIKAN OTOMOTIF\",\"issues\":[\"No room assigned\"]}]}',317,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 08:23:50','2026-06-25 03:40:44'),
(74,1,1,2,NULL,NULL,'failed','{\"type\":\"incomplete_activities\",\"count\":14,\"items\":[{\"id\":153,\"code\":\"EE515\",\"name\":\"PENGOLAHAN SINYAL DAN APLIKASINYA (P)\",\"issues\":[\"No room assigned\"]},{\"id\":155,\"code\":\"EE511\",\"name\":\"SISTEM KOMUNIKASI SATELIT DAN TERESTRIAL (P)\",\"issues\":[\"No room assigned\"]},{\"id\":156,\"code\":\"EE539\",\"name\":\"SCADA DAN MANAJEMEN ENERGI (P)\",\"issues\":[\"No room assigned\"]},{\"id\":157,\"code\":\"EL533\",\"name\":\"MESIN LISTRIK  AC\",\"issues\":[\"No room assigned\"]},{\"id\":158,\"code\":\"EL313\",\"name\":\"SISTEM TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":159,\"code\":\"EL523\",\"name\":\"JARINGAN TELEKOMUNIKASI\",\"issues\":[\"No room assigned\"]},{\"id\":160,\"code\":\"EL525\",\"name\":\"SISTEM ANTENA\",\"issues\":[\"No room assigned\"]},{\"id\":161,\"code\":\"EL532\",\"name\":\"PRAKTIKUM TEKNIK TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":162,\"code\":\"EL527\",\"name\":\"PRAKTIKUM SENSOR DAN SISTEM MIKROPROSESOR\",\"issues\":[\"No room assigned\"]},{\"id\":163,\"code\":\"EL537\",\"name\":\"SISTEM PEMBANGKIT TENAGA LISTRIK\",\"issues\":[\"No room assigned\"]},{\"id\":165,\"code\":\"EL348\",\"name\":\"REKAYASA TRAFIK TELEKOMUNIKASI\",\"issues\":[\"No room assigned\"]},{\"id\":166,\"code\":\"EL722\",\"name\":\"VISI KOMPUTER\",\"issues\":[\"No room assigned\"]},{\"id\":167,\"code\":\"EL731\",\"name\":\"PENGGUNAAN DAN PENGATURAN MOTOR\",\"issues\":[\"No room assigned\"]},{\"id\":168,\"code\":\"EL732\",\"name\":\"KELISTRIKAN OTOMOTIF\",\"issues\":[\"No room assigned\"]}]}',299,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 08:24:06','2026-06-25 03:40:44'),
(75,1,1,2,NULL,355540,'success','Compile completed.',588,'failed','fet-solve/75',NULL,'2026-06-24 08:57:18','2026-06-24 08:58:54',NULL,'Worker crash: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times.',NULL,NULL,'2026-06-24 08:57:12','2026-06-25 03:40:44'),
(76,1,1,2,NULL,352434,'success','Compile completed.',1353,'running','fet-solve/76',NULL,'2026-06-24 14:41:13','2026-06-24 09:06:32',11437,NULL,NULL,NULL,'2026-06-24 09:04:51','2026-06-25 03:40:44'),
(77,1,1,2,NULL,352434,'success','Compile completed.',638,'failed','fet-solve/77',NULL,'2026-06-24 21:16:38','2026-06-24 21:18:09',NULL,'Worker crash: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times.',NULL,NULL,'2026-06-24 21:16:33','2026-06-25 03:40:44'),
(78,1,1,2,NULL,352434,'success','Compile completed.',906,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:18:59','2026-06-25 03:40:44'),
(79,1,1,2,NULL,352434,'success','Compile completed.',1034,'stopped','fet-solve/79',NULL,'2026-06-24 21:24:12','2026-06-24 21:24:47',NULL,'Solver stopped by user.',NULL,NULL,'2026-06-24 21:24:08','2026-06-25 03:40:44'),
(80,1,1,2,NULL,352434,'success','Compile completed.',978,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:24:58','2026-06-25 03:40:44'),
(81,1,1,2,NULL,352434,'success','Compile completed.',1173,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:25:41','2026-06-25 03:40:44'),
(82,1,1,NULL,NULL,352406,'success','Compile completed.',1201,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:27:06','2026-06-25 03:40:44'),
(83,1,1,2,NULL,352434,'success','Compile completed.',1334,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:28:01','2026-06-25 03:40:44'),
(84,1,1,NULL,NULL,352406,'success','Compile completed.',947,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:31:18','2026-06-25 03:40:44'),
(85,1,1,2,NULL,352434,'success','Compile completed.',986,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:31:39','2026-06-25 03:40:44'),
(86,1,1,NULL,NULL,352406,'success','Compile completed.',758,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:34:05','2026-06-25 03:40:44'),
(87,1,1,2,NULL,352434,'success','Compile completed.',661,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:35:32','2026-06-25 03:40:44'),
(88,1,1,NULL,NULL,352406,'success','Compile completed.',1052,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:37:59','2026-06-25 03:40:44'),
(89,1,1,NULL,NULL,352406,'success','Compile completed.',1009,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:38:19','2026-06-25 03:40:44'),
(90,1,1,2,NULL,352406,'success','Compile completed.',1257,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:39:05','2026-06-25 03:40:44'),
(91,1,1,2,NULL,348434,'success','Compile completed.',1731,'failed','fet-solve/91',NULL,'2026-06-24 21:43:37','2026-06-24 21:45:13',NULL,'Worker crash: App\\Jobs\\FetNet\\SolveTimetableJob has been attempted too many times.',NULL,NULL,'2026-06-24 21:43:32','2026-06-25 03:40:44'),
(92,1,1,2,NULL,356630,'success','Compile completed.',2997,'stopped','fet-solve/92',NULL,'2026-06-24 22:48:36','2026-06-24 22:52:32',NULL,'Solver stopped by user.',NULL,NULL,'2026-06-24 22:48:29','2026-06-25 03:40:44'),
(93,1,1,2,NULL,356630,'success','Compile completed.',2779,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 22:52:48','2026-06-25 03:40:44'),
(94,1,1,2,NULL,355678,'success','Compile completed.',7575,'success','fet-solve/94',NULL,'2026-06-24 22:55:14','2026-06-24 22:55:18',NULL,'Solver finished.',NULL,NULL,'2026-06-24 22:54:57','2026-06-25 03:40:44'),
(95,1,1,2,NULL,356154,'success','Compile completed.',2384,'success','fet-solve/95',NULL,'2026-06-24 22:56:07','2026-06-24 22:56:09',NULL,'Solver finished.',NULL,NULL,'2026-06-24 22:55:46','2026-06-25 03:40:44'),
(96,1,1,2,NULL,358804,'success','Compile completed.',2644,'success','fet-solve/96',NULL,'2026-06-24 23:09:28','2026-06-24 23:09:32',NULL,'Solver finished.',NULL,NULL,'2026-06-24 23:09:21','2026-06-25 03:40:44'),
(97,1,1,2,NULL,358856,'success','Compile completed.',2693,'success','fet-solve/97',NULL,'2026-06-25 00:25:49','2026-06-25 00:25:53',NULL,'Solver finished.',NULL,NULL,'2026-06-25 00:25:39','2026-06-25 03:40:44'),
(98,1,1,2,NULL,358908,'success','Compile completed.',2953,'success','fet-solve/98',NULL,'2026-06-25 00:40:46','2026-06-25 00:40:53',NULL,'Solver finished.',NULL,NULL,'2026-06-25 00:40:34','2026-06-25 03:40:44'),
(99,1,1,2,NULL,357067,'success','Compile completed.',2679,'success','fet-solve/99',NULL,'2026-06-25 00:49:31','2026-06-25 00:49:36',NULL,'Solver finished.',NULL,NULL,'2026-06-25 00:49:23','2026-06-25 03:40:44'),
(100,1,1,2,NULL,357067,'success','Compile completed.',2176,'success','fet-solve/100',NULL,'2026-06-25 00:55:21','2026-06-25 00:55:46',NULL,'Solver finished.','2026-06-25 00:56:01',2,'2026-06-25 00:55:14','2026-06-25 03:40:44'),
(101,1,1,2,NULL,357067,'success','Compile completed.',4607,'success','fet-solve/101',NULL,'2026-06-25 02:41:22','2026-06-25 02:41:28',NULL,'Solver finished.',NULL,NULL,'2026-06-25 02:41:09','2026-06-25 03:40:44'),
(102,1,1,2,NULL,357067,'success','Compile completed.',2401,'success','fet-solve/102',NULL,'2026-06-25 02:52:43','2026-06-25 02:52:53',NULL,'Solver finished.',NULL,NULL,'2026-06-25 02:52:36','2026-06-25 03:40:44'),
(103,1,1,NULL,NULL,357730,'success','Compile completed.',1717,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-25 02:56:47','2026-06-25 03:40:44'),
(104,1,1,2,NULL,357067,'success','Compile completed.',1558,'success','fet-solve/104',NULL,'2026-06-25 02:57:35','2026-06-25 02:57:41',NULL,'Solver finished.',NULL,NULL,'2026-06-25 02:57:30','2026-06-25 03:40:44'),
(105,1,1,2,NULL,357067,'success','Compile completed.',1711,'success','fet-solve/105',NULL,'2026-06-25 02:59:14','2026-06-25 02:59:17',NULL,'Solver finished.',NULL,NULL,'2026-06-25 02:59:08','2026-06-25 03:40:44'),
(106,1,1,NULL,NULL,411821,'success','Compile completed.',1404,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-25 03:06:19','2026-06-25 03:40:44'),
(107,1,1,2,NULL,357067,'success','Compile completed.',1982,'success','fet-solve/107',NULL,'2026-06-25 03:08:49','2026-06-25 03:09:02',NULL,'Solver finished.',NULL,NULL,'2026-06-25 03:08:43','2026-06-25 03:40:44'),
(108,1,1,2,NULL,357067,'success','Compile completed.',1734,'success','fet-solve/108',NULL,'2026-06-25 03:10:12','2026-06-25 03:10:16',NULL,'Solver finished.',NULL,NULL,'2026-06-25 03:10:07','2026-06-25 03:40:44'),
(109,1,1,NULL,NULL,411821,'success','Compile completed.',2322,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-25 03:12:30','2026-06-25 03:40:44'),
(110,1,1,2,NULL,411821,'success','Compile completed.',2269,'success','fet-solve/110',NULL,'2026-06-25 03:12:55','2026-06-25 03:22:09',NULL,'Solver finished.',NULL,NULL,'2026-06-25 03:12:48','2026-06-25 03:40:44'),
(111,1,1,2,NULL,394947,'success','Compile completed.',1388,'success','fet-solve/111',NULL,'2026-06-25 03:37:51','2026-06-25 03:37:53',NULL,'Solver finished.',NULL,NULL,'2026-06-25 03:37:47','2026-06-25 03:40:44'),
(112,1,1,2,'fet/1/sem1.fet',394947,'success','Compile completed.',1409,'success','fet-solve/112','fet-solve/112/timetables/sem1/sem1_data_and_timetable.fet','2026-06-25 03:40:51','2026-06-25 03:40:53',NULL,'Solver finished.',NULL,NULL,'2026-06-25 03:40:47','2026-06-25 03:40:53');
/*!40000 ALTER TABLE `fetnet_fet_compile` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_semester`
--

DROP TABLE IF EXISTS `fetnet_semester`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_semester` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned DEFAULT NULL,
  `academic_year_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `start_month` tinyint(3) unsigned DEFAULT NULL,
  `end_month` tinyint(3) unsigned DEFAULT NULL,
  `lecture_start` date DEFAULT NULL,
  `lecture_end` date DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `semester` tinyint(4) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_semester_client_id_foreign` (`client_id`),
  KEY `fetnet_semester_academic_year_id_foreign` (`academic_year_id`),
  CONSTRAINT `fetnet_semester_academic_year_id_foreign` FOREIGN KEY (`academic_year_id`) REFERENCES `fetnet_academic_year` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_semester_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_semester`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_semester` WRITE;
/*!40000 ALTER TABLE `fetnet_semester` DISABLE KEYS */;
INSERT INTO `fetnet_semester` VALUES
(1,1,1,'Ganjil 2026/2027',9,1,'2026-08-17','2026-12-18',2026,1,0,'2026-06-12 06:14:40','2026-06-12 06:14:40');
/*!40000 ALTER TABLE `fetnet_semester` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_space`
--

DROP TABLE IF EXISTS `fetnet_space`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_space` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `type_id` bigint(20) unsigned DEFAULT NULL,
  `building_id` bigint(20) unsigned DEFAULT NULL,
  `faculty_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `floor` varchar(255) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_space_client_id_foreign` (`client_id`),
  KEY `fetnet_space_type_id_foreign` (`type_id`),
  KEY `fetnet_space_building_id_foreign` (`building_id`),
  KEY `fetnet_space_client_name_idx` (`client_id`,`name`),
  CONSTRAINT `fetnet_space_building_id_foreign` FOREIGN KEY (`building_id`) REFERENCES `fetnet_building` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_space_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_space_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `fetnet_space_type` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_space`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_space` WRITE;
/*!40000 ALTER TABLE `fetnet_space` DISABLE KEYS */;
INSERT INTO `fetnet_space` VALUES
(1,1,2,1,1,'Lab Elektronika Industri','L-Elind','5',40,NULL,'2026-06-19 02:37:14','2026-06-21 17:12:42'),
(2,1,2,4,1,'Lab PTOIR A','L-PTOIR-A','7',40,NULL,'2026-06-19 02:38:57','2026-06-21 17:13:39'),
(3,1,2,4,1,'Lab PTOIR B','L-PTOIR-B','7',40,NULL,'2026-06-19 02:39:33','2026-06-21 17:13:53'),
(4,1,2,1,1,'Lab Telekomunikasi','L-Telkom','7',40,NULL,'2026-06-19 02:40:31','2026-06-21 17:14:28'),
(5,1,2,1,1,'Lab Elektronika Dasar','L-Eldas','5',40,NULL,'2026-06-19 02:40:59','2026-06-21 17:12:31'),
(6,1,2,3,1,'Lab Teknik Tenaga Elektrik 1','L-TTE-1','3',40,NULL,'2026-06-19 02:42:11','2026-06-21 17:14:01'),
(7,1,2,3,1,'Lab Teknik Tenaga Elektrik 2','L-TTE-2','3',40,NULL,'2026-06-19 02:42:58','2026-06-21 17:14:11'),
(8,1,1,4,1,'Ruang Kuliah TE 1','R-TE-1','5',40,NULL,'2026-06-19 02:43:41','2026-06-21 17:15:14'),
(9,1,1,4,1,'Ruang Kuliah TE 2','R-TE-2','5',40,NULL,'2026-06-19 02:44:22','2026-06-21 17:15:22'),
(10,1,1,1,1,'Ruang Kuliah PTE 1','R-PTE-1','4',40,NULL,'2026-06-19 02:45:15','2026-06-21 17:14:37'),
(11,1,1,1,1,'Ruang Kuliah PTE 2','R-PTE-2','4',40,NULL,'2026-06-19 02:45:40','2026-06-21 17:14:45'),
(12,1,1,4,1,'Ruang Kuliah PTOIR 1','R-PTOIR-1','5',40,NULL,'2026-06-19 02:46:13','2026-06-21 17:14:57'),
(13,1,1,4,1,'Ruang Kuliah PTOIR 2','R-PTOIR-2','5',40,NULL,'2026-06-19 02:47:29','2026-06-21 17:15:05'),
(14,1,1,4,1,'Ruang Kuliah TET 1','R-TET-1','4',40,NULL,'2026-06-19 02:48:31','2026-06-21 17:15:31'),
(15,1,1,4,1,'Ruang Kuliah TET 2','R-TET-2','4',40,NULL,'2026-06-19 02:49:20','2026-06-21 17:15:39'),
(16,1,2,4,1,'Lab Material Gedung D','Lab-Material','5',40,NULL,'2026-06-19 11:55:55','2026-06-21 17:13:20'),
(17,1,2,4,1,'Lab Micro Teaching','L-Micro-Teach','5',40,NULL,'2026-06-19 17:05:51','2026-06-21 17:13:30'),
(18,1,2,1,1,'Lab Komputer D','L-Komp-D','4',40,NULL,'2026-06-21 17:01:05','2026-06-21 17:12:54');
/*!40000 ALTER TABLE `fetnet_space` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_space_claim`
--

DROP TABLE IF EXISTS `fetnet_space_claim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_space_claim` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `space_id` bigint(20) unsigned NOT NULL,
  `program_id` bigint(20) unsigned NOT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `note` varchar(255) DEFAULT NULL,
  `responded_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_space_claim_space_id_program_id_unique` (`space_id`,`program_id`),
  KEY `fetnet_space_claim_program_id_foreign` (`program_id`),
  CONSTRAINT `fetnet_space_claim_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_space_claim_space_id_foreign` FOREIGN KEY (`space_id`) REFERENCES `fetnet_space` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_space_claim`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_space_claim` WRITE;
/*!40000 ALTER TABLE `fetnet_space_claim` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_space_claim` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_space_type`
--

DROP TABLE IF EXISTS `fetnet_space_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_space_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `is_theory` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_space_type`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_space_type` WRITE;
/*!40000 ALTER TABLE `fetnet_space_type` DISABLE KEYS */;
INSERT INTO `fetnet_space_type` VALUES
(1,'Classroom','CLS',1,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(2,'Laboratory','LAB',0,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(3,'Studio','STD',0,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(4,'Auditorium','AUD',1,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(5,'Seminar Room','SEM',1,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(6,'Workshop','WRK',0,'2026-06-12 06:01:20','2026-06-12 06:01:20'),
(7,'Office','OFC',0,'2026-06-12 06:01:20','2026-06-12 06:01:20');
/*!40000 ALTER TABLE `fetnet_space_type` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_specialization`
--

DROP TABLE IF EXISTS `fetnet_specialization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_specialization` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `code` varchar(10) NOT NULL,
  `abbrev` varchar(10) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_specialization_program_id_foreign` (`program_id`),
  CONSTRAINT `fetnet_specialization_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_specialization`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_specialization` WRITE;
/*!40000 ALTER TABLE `fetnet_specialization` DISABLE KEYS */;
INSERT INTO `fetnet_specialization` VALUES
(1,1,'TEL',NULL,'TELKOM',NULL,'2026-06-13 15:31:01','2026-06-13 15:31:01'),
(2,1,'TE',NULL,'TENAGA ELEKTRIK',NULL,'2026-06-13 15:31:01','2026-06-13 15:31:01'),
(3,1,'EK',NULL,'ELEKTRONIKA DAN KOMPUTER',NULL,'2026-06-13 15:31:01','2026-06-13 15:31:01'),
(4,3,'POW',NULL,'POWER',NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(5,2,'TEL',NULL,'Telekomunikasi',NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(6,2,'TE',NULL,'Tenaga Elektrik',NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(7,2,'POW',NULL,'POWER',NULL,'2026-06-24 06:47:52','2026-06-24 06:47:52');
/*!40000 ALTER TABLE `fetnet_specialization` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_student`
--

DROP TABLE IF EXISTS `fetnet_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_student` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `batch` varchar(10) DEFAULT NULL,
  `number_of_student` smallint(6) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_student_program_id_foreign` (`program_id`),
  KEY `fetnet_student_parent_id_foreign` (`parent_id`),
  CONSTRAINT `fetnet_student_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `fetnet_student` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_student_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_student`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_student` WRITE;
/*!40000 ALTER TABLE `fetnet_student` DISABLE KEYS */;
INSERT INTO `fetnet_student` VALUES
(1,1,NULL,'TE-2026','2026',80,NULL,'2026-06-13 14:43:53','2026-06-20 04:41:55'),
(2,1,1,'TE01-1',NULL,40,NULL,'2026-06-13 14:44:14','2026-06-13 14:44:28'),
(3,1,1,'TE02-1',NULL,40,NULL,'2026-06-13 14:44:38','2026-06-13 14:44:38'),
(4,1,NULL,'TE-2025','2025',80,NULL,'2026-06-13 14:44:55','2026-06-20 04:41:46'),
(5,1,4,'TE01-3',NULL,40,NULL,'2026-06-13 14:45:06','2026-06-13 14:45:06'),
(6,1,4,'TE02-3',NULL,40,NULL,'2026-06-13 14:45:19','2026-06-13 14:45:19'),
(7,1,NULL,'TE-2024','2024',40,NULL,'2026-06-13 14:45:36','2026-06-21 17:26:08'),
(8,1,NULL,'TE-2023','2023',70,NULL,'2026-06-13 14:46:33','2026-06-19 13:15:59'),
(9,1,8,'TE01-7',NULL,35,NULL,'2026-06-13 14:46:55','2026-06-13 14:46:55'),
(10,1,8,'TE02-7',NULL,35,NULL,'2026-06-13 14:47:07','2026-06-13 14:47:07'),
(11,1,7,'TE01-5',NULL,20,NULL,'2026-06-13 23:58:20','2026-06-21 17:26:20'),
(12,1,7,'TE02-5',NULL,20,NULL,'2026-06-13 23:58:32','2026-06-21 17:26:27'),
(13,1,9,'TE01-TK-7',NULL,17,NULL,'2026-06-17 06:51:18','2026-06-21 17:20:55'),
(14,1,9,'TE01-TTE-7',NULL,18,NULL,'2026-06-17 06:51:34','2026-06-17 06:51:34'),
(15,1,10,'TE02-TK-7',NULL,17,NULL,'2026-06-17 06:51:59','2026-06-21 17:20:45'),
(16,1,10,'TE02-TTE-7',NULL,18,NULL,'2026-06-17 06:52:14','2026-06-17 06:52:14'),
(17,3,NULL,'2026','2026',80,NULL,'2026-06-19 07:37:44','2026-06-19 07:37:44'),
(18,3,NULL,'2025','2025',80,NULL,'2026-06-19 07:37:57','2026-06-19 07:37:57'),
(19,3,NULL,'2024','2024',40,NULL,'2026-06-19 07:38:11','2026-06-19 07:38:11'),
(20,3,NULL,'2023','2023',40,NULL,'2026-06-19 07:38:23','2026-06-19 07:38:23'),
(21,3,18,'PTOIR-3A',NULL,40,NULL,'2026-06-19 07:38:49','2026-06-19 07:39:14'),
(22,3,18,'PTOIR-3B',NULL,40,NULL,'2026-06-19 07:39:27','2026-06-19 07:39:27'),
(23,3,17,'PTOIR-1A',NULL,40,NULL,'2026-06-19 07:39:39','2026-06-19 07:39:39'),
(24,3,17,'PTOIR-1B',NULL,40,NULL,'2026-06-19 07:39:54','2026-06-19 07:39:54'),
(25,3,19,'PTOIR-5',NULL,40,NULL,'2026-06-19 14:46:56','2026-06-19 14:46:56'),
(26,3,20,'PTOIR-7',NULL,40,NULL,'2026-06-19 14:47:15','2026-06-19 14:47:15'),
(27,2,NULL,'PTE-2026','2026',80,NULL,'2026-06-20 03:42:19','2026-06-20 03:42:19'),
(28,2,27,'PTEA-1',NULL,40,NULL,'2026-06-20 03:42:47','2026-06-20 03:43:06'),
(29,2,27,'PTEB-1',NULL,40,NULL,'2026-06-20 03:42:58','2026-06-20 03:42:58'),
(30,2,NULL,'PTE-2025','2025',80,NULL,'2026-06-20 03:43:19','2026-06-20 03:43:19'),
(31,2,30,'PTEA-3',NULL,40,NULL,'2026-06-20 03:43:33','2026-06-20 03:43:33'),
(32,2,30,'PTEB-3',NULL,40,NULL,'2026-06-20 03:43:47','2026-06-20 03:43:47'),
(33,2,31,'PTEA-TK-3',NULL,10,NULL,'2026-06-20 03:44:11','2026-06-21 17:19:41'),
(34,2,31,'PTEA-TTE-3',NULL,30,NULL,'2026-06-20 03:44:44','2026-06-21 17:19:49'),
(35,2,32,'PTEB-TK-3',NULL,10,NULL,'2026-06-20 03:44:59','2026-06-21 17:19:59'),
(36,2,32,'PTEB-TTE-3',NULL,30,NULL,'2026-06-20 03:45:35','2026-06-21 17:20:06'),
(37,2,NULL,'PTE-2024','2024',40,NULL,'2026-06-20 03:46:25','2026-06-23 08:55:44'),
(38,2,NULL,'PTE-2023','2023',40,NULL,'2026-06-20 03:46:48','2026-06-20 03:46:48'),
(39,2,37,'PTE-EI-5',NULL,5,NULL,'2026-06-20 03:47:03','2026-06-24 06:32:24'),
(40,2,39,'PTEA-TTE-5',NULL,40,'2026-06-20 03:49:02','2026-06-20 03:48:51','2026-06-20 03:49:02'),
(41,2,37,'PTE-TK--5',NULL,2,NULL,'2026-06-20 03:49:42','2026-06-24 06:32:16'),
(42,2,38,'PTE-EI-7',NULL,5,NULL,'2026-06-20 03:50:15','2026-06-24 06:29:16'),
(43,2,38,'PTE-TK-7',NULL,2,NULL,'2026-06-20 03:50:33','2026-06-24 06:28:47'),
(44,2,39,'PTEA-TK-5',NULL,2,'2026-06-24 06:30:10','2026-06-22 07:24:29','2026-06-24 06:30:10'),
(45,2,39,'PTEA-TTE-5',NULL,18,'2026-06-24 06:30:18','2026-06-22 07:26:37','2026-06-24 06:30:18'),
(46,2,41,'PTEB-TK-5',NULL,2,'2026-06-24 06:30:25','2026-06-22 07:26:49','2026-06-24 06:30:25'),
(47,2,41,'PTEB-TTE-5',NULL,18,'2026-06-24 06:30:32','2026-06-22 07:27:13','2026-06-24 06:30:32'),
(48,2,43,'PTEA-TK-7',NULL,2,'2026-06-24 06:27:31','2026-06-22 07:27:44','2026-06-24 06:27:31'),
(49,2,43,'PTEA-EI-7',NULL,5,'2026-06-24 06:28:01','2026-06-22 07:28:00','2026-06-24 06:28:01'),
(50,2,43,'PTEA-TTE-7',NULL,13,'2026-06-24 06:30:01','2026-06-22 07:28:24','2026-06-24 06:30:01'),
(51,2,42,'PTEB-TK-7',NULL,2,'2026-06-24 06:27:36','2026-06-22 07:29:19','2026-06-24 06:27:36'),
(52,2,42,'PTEB-EI-7',NULL,5,'2026-06-24 06:29:47','2026-06-22 07:29:32','2026-06-24 06:29:47'),
(53,2,42,'PTEB-TTE-7',NULL,13,'2026-06-24 06:29:54','2026-06-22 07:29:47','2026-06-24 06:29:54'),
(54,4,NULL,'TET-2026','2026',80,NULL,'2026-06-22 08:08:49','2026-06-22 08:08:49'),
(55,4,NULL,'TET-2025','2025',80,NULL,'2026-06-22 08:09:03','2026-06-22 08:09:03'),
(56,4,NULL,'TET-2024','2024',40,NULL,'2026-06-22 08:09:21','2026-06-22 08:09:21'),
(57,4,54,'TET-1A',NULL,40,NULL,'2026-06-22 08:09:43','2026-06-22 08:09:43'),
(58,4,54,'TET-1B',NULL,40,NULL,'2026-06-22 08:09:55','2026-06-22 08:09:55'),
(59,4,55,'TET-3A',NULL,40,NULL,'2026-06-22 08:10:12','2026-06-22 08:10:12'),
(60,4,55,'TET-3B',NULL,40,NULL,'2026-06-22 08:10:26','2026-06-22 08:10:26'),
(61,2,38,'PTE-TTE-7',NULL,13,NULL,'2026-06-24 06:29:36','2026-06-24 06:29:36'),
(62,2,37,'PTE-TTE-5',NULL,13,NULL,'2026-06-24 06:32:39','2026-06-24 06:32:39');
/*!40000 ALTER TABLE `fetnet_student` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_student_constraint`
--

DROP TABLE IF EXISTS `fetnet_student_constraint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_student_constraint` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned DEFAULT NULL,
  `constraint_type` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  `weight` decimal(5,2) NOT NULL DEFAULT 100.00,
  `tag_id` bigint(20) unsigned DEFAULT NULL,
  `tag2_id` bigint(20) unsigned DEFAULT NULL,
  `interval_start` tinyint(4) DEFAULT NULL,
  `interval_end` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_student_constraint_program_id_foreign` (`program_id`),
  KEY `fetnet_student_constraint_student_id_foreign` (`student_id`),
  KEY `fetnet_student_constraint_tag_id_foreign` (`tag_id`),
  KEY `fetnet_student_constraint_tag2_id_foreign` (`tag2_id`),
  CONSTRAINT `fetnet_student_constraint_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_student_constraint_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `fetnet_student` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_student_constraint_tag2_id_foreign` FOREIGN KEY (`tag2_id`) REFERENCES `fetnet_activity_tag` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_student_constraint_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `fetnet_activity_tag` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_student_constraint`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_student_constraint` WRITE;
/*!40000 ALTER TABLE `fetnet_student_constraint` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_student_constraint` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_sub_activity`
--

DROP TABLE IF EXISTS `fetnet_sub_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_sub_activity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) unsigned NOT NULL,
  `duration` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `order` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_sub_activity_activity_id_foreign` (`activity_id`),
  CONSTRAINT `fetnet_sub_activity_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_sub_activity`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_sub_activity` WRITE;
/*!40000 ALTER TABLE `fetnet_sub_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_sub_activity` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_subject`
--

DROP TABLE IF EXISTS `fetnet_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_subject` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `curriculum_year_id` bigint(20) unsigned DEFAULT NULL,
  `specialization_id` bigint(20) unsigned DEFAULT NULL,
  `type_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `credit` tinyint(4) NOT NULL DEFAULT 2,
  `semester` tinyint(4) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_subject_program_id_foreign` (`program_id`),
  KEY `fetnet_subject_curriculum_year_id_foreign` (`curriculum_year_id`),
  KEY `fetnet_subject_specialization_id_foreign` (`specialization_id`),
  KEY `fetnet_subject_type_id_foreign` (`type_id`),
  CONSTRAINT `fetnet_subject_curriculum_year_id_foreign` FOREIGN KEY (`curriculum_year_id`) REFERENCES `fetnet_curriculum_year` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_subject_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_subject_specialization_id_foreign` FOREIGN KEY (`specialization_id`) REFERENCES `fetnet_specialization` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_subject_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `fetnet_subject_type` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_subject`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_subject` WRITE;
/*!40000 ALTER TABLE `fetnet_subject` DISABLE KEYS */;
INSERT INTO `fetnet_subject` VALUES
(1,1,NULL,NULL,NULL,'EE101','FISIKA DASAR I',3,1,'2026-06-13 15:31:18','2026-06-13 14:16:01','2026-06-13 15:31:18'),
(2,1,NULL,NULL,NULL,'EE103','KOMPUTER DAN PEMROGRAMAN',3,1,'2026-06-13 15:31:22','2026-06-13 14:16:01','2026-06-13 15:31:22'),
(3,1,1,NULL,NULL,'EE105','ALGORITMA DAN PEMROGRAMAN',3,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(4,1,1,NULL,NULL,'EE107','KALKULUS I',3,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(5,1,1,NULL,NULL,'EE109','ALJABAR LINEAR',3,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(6,1,NULL,NULL,NULL,'EE111','BAHASA INGGRIS',2,1,'2026-06-13 15:31:28','2026-06-13 14:16:01','2026-06-13 15:31:28'),
(7,1,NULL,NULL,NULL,'KU10X','PENDIDIKAN AGAMA',2,1,'2026-06-13 15:31:37','2026-06-13 14:16:01','2026-06-13 15:31:37'),
(8,1,1,NULL,NULL,'KU110','PENDIDIKAN PANCASILA',2,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(9,1,NULL,NULL,NULL,'TK301','MATEMATIKA DASAR',2,1,'2026-06-13 15:31:42','2026-06-13 14:16:01','2026-06-13 15:31:42'),
(10,1,NULL,NULL,NULL,'EE102','FISIKA DASAR II',3,2,'2026-06-13 15:31:46','2026-06-13 14:16:01','2026-06-13 15:31:46'),
(11,1,NULL,NULL,NULL,'EE104','MATEMATIKA TEKNIK I',3,2,'2026-06-13 15:31:51','2026-06-13 14:16:01','2026-06-13 15:31:51'),
(12,1,1,NULL,NULL,'EE106','MATEMATIKA DISKRIT',3,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(13,1,1,NULL,NULL,'EE108','FISIKA I',3,1,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(14,1,NULL,NULL,NULL,'HU300','PENGANTAR PENDIDIKAN',2,2,'2026-06-13 15:31:58','2026-06-13 14:16:01','2026-06-13 15:31:58'),
(15,1,1,NULL,NULL,'KU105','PENDIDIKAN KEWARGANEGARAAN',2,2,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(16,1,1,NULL,NULL,'KU106','PENDIDIKAN BAHASA INDONESIA',2,2,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(17,1,1,NULL,NULL,'KU108','OLAH RAGA DAN KEBUGARAN*',2,3,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(18,1,1,NULL,NULL,'KU119','APRESIASI SENI*',2,3,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(19,1,NULL,NULL,NULL,'EE201','MATEMATIKA TEKNIK II',3,3,'2026-06-13 15:32:03','2026-06-13 14:16:01','2026-06-13 15:32:03'),
(20,1,NULL,NULL,NULL,'EE203','ELEKTRONIKA',3,3,'2026-06-13 15:32:21','2026-06-13 14:16:01','2026-06-13 15:32:21'),
(21,1,NULL,NULL,NULL,'EE204','TEKNIK DIGITAL',2,3,'2026-06-13 15:32:15','2026-06-13 14:16:01','2026-06-13 15:32:15'),
(22,1,1,NULL,NULL,'EE207','PROBABILITAS DAN STATISTIKA',3,2,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(23,1,1,NULL,NULL,'EE209','SISTEM DIGITAL',3,2,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(24,1,NULL,NULL,NULL,'EE211','MEDAN ELEKTROMAGNETIK I',3,3,'2026-06-13 15:32:28','2026-06-13 14:16:01','2026-06-13 15:32:28'),
(25,1,NULL,NULL,NULL,'EE213','PRAKTIKUM PENGUKURAN LISTRIK DAN ELEKTRONIKA',2,3,'2026-06-13 15:32:36','2026-06-13 14:16:01','2026-06-13 15:32:36'),
(26,1,NULL,NULL,NULL,'EE202','MATERIAL ELEKTROTEKNIK',2,4,'2026-06-13 15:32:44','2026-06-13 14:16:01','2026-06-13 15:32:44'),
(27,1,NULL,NULL,NULL,'EE205','EKONOMI TEKNIK',2,4,'2026-06-13 15:32:49','2026-06-13 14:16:01','2026-06-13 15:32:49'),
(28,1,1,NULL,NULL,'EE206','FISIKA III',2,4,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(29,1,1,NULL,NULL,'EE210','RANGKAIAN LISTRIK II',3,3,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(30,1,NULL,NULL,NULL,'EE212','MEDAN ELEKTROMAGNETIK II',3,4,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(31,1,NULL,NULL,NULL,'EE214','ARSITEKTUR SISTEM DAN JARINGAN KOMPUTER',2,4,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(32,1,NULL,NULL,NULL,'EE216','SISTEM KENDALI',2,4,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(33,1,1,NULL,NULL,'EE218','PRAKTIKUM ELEKTRONIKA',2,3,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(34,1,NULL,NULL,NULL,'EE301','SISTEM MIKROPROSESOR',2,4,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(35,1,1,NULL,NULL,'EE208','PENGOLAHAN SINYAL WAKTU KONTINU',2,3,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(36,1,NULL,NULL,NULL,'EE303','TEKNIK INSTALASI LISTRIK',2,5,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(37,1,NULL,NULL,NULL,'EE305','DESAIN SISTEM DIGITAL',2,5,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(38,1,1,NULL,NULL,'EE307','MATERIAL TEKNIK ELEKTRO',2,6,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(39,1,1,NULL,NULL,'EE309','MESIN AC',2,5,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(40,1,NULL,NULL,NULL,'EE311','METODOLOGI PENELITIAN',2,5,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(41,1,NULL,NULL,NULL,'EE313','PRAKTIKUM SISTEM DIGITAL DAN MIKROPROSESOR',2,5,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(42,1,NULL,NULL,NULL,'KU30X','SEMINAR PENDIDIKAN AGAMA',2,5,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(43,1,1,NULL,NULL,'TK302','KAJIAN TEKNOLOGI VOKASI DAN INDUSTRI',3,7,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(44,1,NULL,NULL,NULL,'EE302','MESIN LISTRIK',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(45,1,NULL,NULL,NULL,'EE304','SISTEM KOMUNIKASI DIGITAL',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(46,1,NULL,NULL,NULL,'EE306','SISTEM DISTRIBUSI TENAGA LISTRIK',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(47,1,1,NULL,NULL,'EE308','JARINGAN KOMPUTER DAN KOMUNIKASI',3,5,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(48,1,1,NULL,NULL,'EE310','SISTEM KENDALI',2,5,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(49,1,NULL,NULL,NULL,'EE312','REKAYASA TRAFIK TELEKOMUNIKASI',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(50,1,NULL,NULL,NULL,'EE314','PERENCANAAN INSTALASI LISTRIK',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(51,1,NULL,NULL,NULL,'EE316','ELEKTRONIKA TELEKOMUNIKASI',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(52,1,NULL,NULL,NULL,'EE318','PRAKTIKUM TEKNIK TENAGA LISTRIK',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(53,1,NULL,NULL,NULL,'EE320','PRAKTIKUM TEKNIK TELEKOMUNIKASI',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(54,1,1,NULL,NULL,'EE402','SKRIPSI',6,8,NULL,'2026-06-13 14:16:01','2026-06-13 15:44:45'),
(55,1,NULL,NULL,NULL,'EE404','KOMUNIKASI DATA (P)',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(56,1,NULL,NULL,NULL,'EE406','ANALISIS SISTEM TENAGA LISTRIK (P)',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(57,1,NULL,NULL,NULL,'EE408','ELEKTRONIKA FREKUENSI RADIO (P)',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(58,1,NULL,NULL,NULL,'EE410','KUALITAS DAYA LISTRIK (P)',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(59,1,NULL,NULL,NULL,'EE412','PERANGKAT LUNAK TELEKOMUNIKASI (P)',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(60,1,NULL,NULL,NULL,'EE414','KEANDALAN SISTEM TENAGA LISTRIK (P)',3,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(61,1,NULL,NULL,NULL,'EE416','TEORI INFORMASI (P)',2,6,'2026-06-13 15:44:32','2026-06-13 14:16:01','2026-06-13 15:44:32'),
(62,1,2,3,NULL,'EE401','PENGOLAHAN SINYAL DIGITAL',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:08'),
(63,1,2,2,NULL,'EE403','PENGGUNAAN DAN PENGATURAN MOTOR LISTRIK',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:08'),
(64,1,2,3,NULL,'EE405','DEVAIS SISTEM KOMUNIKASI',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:08'),
(65,1,2,2,NULL,'EE407','PROTEKSI SISTEM TENAGA LISTRIK',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:08'),
(66,1,2,3,NULL,'EE409','SISTEM KOMUNIKASI OPTIK',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(67,1,2,2,NULL,'EE411','SISTEM PEMBANGKIT TENAGA LISTRIK',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(68,1,2,3,NULL,'EE413','SISTEM KOMUNIKASI BERGERAK DAN NIRKABEL',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(69,1,2,2,NULL,'EE415','SISTEM TRANSMISI TENAGA LISTRIK',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(70,1,2,2,2,'EE501','OTOMASI INDUSTRI (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(71,1,2,3,2,'EE503','KEAMANAN JARINGAN TELEKOMUNIKASI (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(72,1,2,2,2,'EE505','PROTEKSI RELAI (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(73,1,2,3,2,'EE507','SISTEM RADAR (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(74,1,2,2,2,'EE509','ENERGI TERBARUKAN (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(75,1,2,3,2,'EE511','SISTEM KOMUNIKASI SATELIT DAN TERESTRIAL (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(76,1,2,2,2,'EE513','EKONOMI ENERGI (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(77,1,2,3,2,'EE515','PENGOLAHAN SINYAL DAN APLIKASINYA (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(78,1,2,2,2,'EE517','PENGGUNAAN KOMPUTER DALAM SISTEM TENAGA LISTRIK (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(79,1,2,3,2,'EE519','JARINGAN AKSES NIRKABEL (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(80,1,2,2,2,'EE521','ELEKTRONIKA DAYA LANJUT (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(81,1,2,3,2,'EE523','SISTEM TELEMETRI (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(82,1,2,2,2,'EE525','SISTEM TRANSPORTASI LISTRIK (P)',3,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(83,1,2,2,2,'EE527','SISTEM CERDAS (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(84,1,2,3,2,'EE531','TOPIK KHUSUS WLAN (P)',2,7,NULL,'2026-06-13 14:16:01','2026-06-17 01:49:09'),
(85,1,2,3,2,'EE535','VISI KOMPUTER (P)',2,7,NULL,'2026-06-13 14:16:02','2026-06-17 01:49:09'),
(86,1,2,3,2,'EE537','SISTEM TERTANAM (P)',2,7,NULL,'2026-06-13 14:16:02','2026-06-17 01:49:09'),
(87,1,2,2,2,'EE539','SCADA DAN MANAJEMEN ENERGI (P)',2,7,NULL,'2026-06-13 14:16:02','2026-06-17 01:49:09'),
(88,1,2,NULL,NULL,'EE592','PRAKTIK KERJA',4,8,'2026-06-17 01:42:25','2026-06-13 14:16:02','2026-06-17 01:42:25'),
(89,1,2,NULL,NULL,'EE594','KAPITA SELEKTA',2,8,'2026-06-17 01:42:36','2026-06-13 14:16:02','2026-06-17 01:42:36'),
(90,1,2,NULL,NULL,'EE596','SKRIPSI',6,8,'2026-06-17 01:42:36','2026-06-13 14:16:02','2026-06-17 01:42:36'),
(91,1,2,NULL,NULL,'EE598','UJIAN SIDANG',0,8,'2026-06-17 01:42:36','2026-06-13 14:16:02','2026-06-17 01:42:36'),
(92,1,2,NULL,NULL,'PT502','PROYEK KONSULTANSI',4,8,'2026-06-17 01:33:36','2026-06-13 14:16:02','2026-06-17 01:33:36'),
(93,1,1,NULL,NULL,'EE117','KALKULUS II',3,2,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(94,1,1,NULL,NULL,'EE118','FISIKA II',3,2,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(95,1,1,NULL,NULL,'EE119','VARIABEL KOMPLEKS',3,3,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(96,1,1,NULL,NULL,'EE120','PRAKTIKUM FISIKA',2,3,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(97,1,1,NULL,NULL,'EE121','RANGKAIAN LISTRIK I',3,2,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(98,1,1,NULL,NULL,'EE122','PERSAMAAN DIFERENSIAL',3,3,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(99,1,1,NULL,NULL,'EE217','ELEKTRONIKA',2,3,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(100,1,1,NULL,NULL,'PT400','BAHASA INGGRIS',3,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(101,1,1,NULL,NULL,'EE220','PENGOLAHAN SINYAL WAKTU DISKRIT',3,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(102,1,1,NULL,NULL,'EE221','ELEKTROMAGNETIKA I',3,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(103,1,1,NULL,NULL,'EE222','SISTEM MIKROPROSESOR',3,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(104,1,1,NULL,NULL,'EE223','PRAKTIKUM SISTEM DIGITAL DAN MIKROPROSESOR',2,5,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(105,1,1,NULL,NULL,'EE224','MESIN DC',2,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(106,1,1,NULL,NULL,'EE336','INSTRUMENTASI  DAN PENGUKURAN',2,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(107,1,1,NULL,NULL,'EE358','KEBERLANJUTAN, KESEHATAN, DAN KESELAMATAN KERJA',2,4,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(108,1,1,NULL,NULL,'EE219','SISTEM KOMUNIKASI',3,5,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(109,1,1,NULL,NULL,'EE337','PRAKTIKUM PENGOLAHAN SINYAL',2,5,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(110,1,1,NULL,NULL,'EE338','SISTEM TENAGA LISTRIK',3,5,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(111,1,1,NULL,NULL,'EE339','ELEKTROMAGNETIKA II',3,5,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(112,1,1,NULL,NULL,'EE340','DESAIN PROYEK TEKNIK ELEKTRO I',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(113,1,1,NULL,NULL,'EE422','SISTEM CERDAS',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(114,1,1,NULL,NULL,'EE341','METODOLOGI PENELITIAN',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(115,1,1,NULL,NULL,'EE335','SISTEM TERTANAM',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(116,1,1,NULL,NULL,'EE423','PRAKTIK INDUSTRI',4,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(117,1,1,2,NULL,'EE430','SCADA DAN INDUSTRIAL INTERNET OF THINGS',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(118,1,1,1,NULL,'EE342','PERANGKAT LUNAK TELEKOMUNIKASI',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(119,1,1,1,NULL,'EE343','SISTEM ANTENA',3,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(120,1,1,1,NULL,'EE344','SISTEM KOMUNIKASI NIRKABEL',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(121,1,1,1,NULL,'EE345','PRAKTIKUM TELEKOMUNIKASI',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(122,1,1,1,NULL,'EE346','ELEKTRONIKA DAN DEVAIS TELEKOMUNIKASI',3,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(123,1,1,1,NULL,'EE424','SISTEM RADAR',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(124,1,1,1,NULL,'EE425','SISTEM KOMUNIKASI OPTIK',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(125,1,1,1,NULL,'EE426','TEORI INFORMASI',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(126,1,1,1,NULL,'EE427','PENGOLAHAN CITRA DIGITAL',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(127,1,1,1,NULL,'EE428','SOFTWARE DEFINED RADIO',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(128,1,1,2,NULL,'EE347','SISTEM TRANSMISI DAN DISTRIBUSI TENAGA LISTRIK',3,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(129,1,1,2,NULL,'EE348','ELEKTRONIKA DAYA',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(130,1,1,2,NULL,'EE349','PERENCANAAN INSTALASI LISTRIK',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(131,1,1,2,NULL,'EE350','SISTEM PEMBANGKIT TENAGA LISTRIK',3,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(132,1,1,2,NULL,'EE351','PRAKTIKUM MESIN LISTRIK',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(133,1,1,2,NULL,'EE429','OTOMASI INDUSTRI',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(134,1,1,2,NULL,'EE431','TEKNIK TEGANGAN TINGGI',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(135,1,1,2,NULL,'EE432','KEANDALAN SISTEM TENAGA LISTRIK',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(136,1,1,3,NULL,'EE433','APLIKASI KOMPUTER DALAM SISTEM TENAGA LISTRIK',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(137,1,1,3,NULL,'EE352','APLIKASI BERBASIS PLATFORM',3,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(138,1,1,3,NULL,'EE353','ELEKTRONIKA DAYA',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(139,1,1,3,NULL,'EE354','OTOMASI INDUSTRI',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(140,1,1,3,NULL,'EE355','PRAKTIKUM OTOMASI INDUSTRI',2,6,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:45'),
(141,1,NULL,NULL,NULL,'EE356','MACHINE LEARNING',2,7,'2026-06-13 15:44:33','2026-06-13 14:16:02','2026-06-13 15:44:33'),
(142,1,1,3,NULL,'EE434','MACHINE LEARNING',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:46'),
(143,1,1,3,NULL,'EE435','ROBOTIKA',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:46'),
(144,1,1,3,NULL,'EE436','DESAIN VLSI',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:46'),
(145,1,NULL,NULL,NULL,'EE437','TEKNOLOGI KENDARAAN LISTRIK',2,7,'2026-06-13 15:44:33','2026-06-13 14:16:02','2026-06-13 15:44:33'),
(146,1,1,3,NULL,'EE438','VISI KOMPUTER',2,7,NULL,'2026-06-13 14:16:02','2026-06-13 15:44:46'),
(147,1,NULL,NULL,NULL,'EE357','TECHNOPREUNERSHIP',3,7,'2026-06-13 15:44:33','2026-06-13 14:16:02','2026-06-13 15:44:33'),
(148,1,1,NULL,NULL,'KU100','PENDIDIKAN AGAMA',2,1,NULL,'2026-06-13 15:31:00','2026-06-13 15:44:45'),
(149,1,1,NULL,NULL,'KU300','SEMINAR PENDIDIKAN AGAMA',2,3,NULL,'2026-06-13 15:31:00','2026-06-13 15:44:45'),
(150,1,1,NULL,NULL,'EE440','DESAIN PROYEK TEKNIK ELEKTRO II',3,6,NULL,'2026-06-13 15:31:00','2026-06-13 15:44:45'),
(151,1,1,3,NULL,'EE328','ARSITEKTUR KOMPUTER',3,6,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(152,1,1,3,NULL,'EE331','PEMROGRAMAN BERORIENTASI OBYEK',2,7,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(153,1,1,NULL,1,'KM448','Strategi Pengembangan Diri',4,8,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(154,1,1,NULL,1,'KM451','Total Quality Management',4,8,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(155,1,1,NULL,1,'KM444','Manajemen Projek dan Networking',4,8,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(156,1,1,NULL,1,'KM443','Literasi Ekonomi Digital',4,8,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(157,1,1,NULL,1,'KM449','Studi Independen Tematik',4,8,NULL,'2026-06-13 15:31:01','2026-06-13 15:44:46'),
(158,3,4,NULL,3,'ER362','EVALUASI PEMBELAJARAN TOIR',3,7,NULL,'2026-06-17 08:26:20','2026-06-19 01:07:10'),
(159,3,3,4,3,'ELC301','Electrical Machines I',3,3,'2026-06-19 07:36:57','2026-06-19 01:07:10','2026-06-19 07:36:57'),
(160,3,3,4,3,'ELC302','Electrical Machines II',3,4,'2026-06-19 13:30:59','2026-06-19 01:07:10','2026-06-19 13:30:59'),
(161,3,3,NULL,3,'ELC401','Power Systems Analysis',3,5,'2026-06-19 13:48:43','2026-06-19 01:07:10','2026-06-19 13:48:43'),
(162,3,4,NULL,3,'ER470','PRAKTIKUM OTOMASI INDUSTRI & ROBOTIKA',2,7,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(163,3,4,NULL,3,'ER473','METODE PENELITIAN',2,7,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(164,3,4,NULL,3,'ER561','DESAIN SISTEM ROBOT CERDAS',3,7,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(165,3,4,NULL,3,'ER597','SEMINAR TEKNIK OTOMASI INDUSTRI DAN ROBOTIKA',3,7,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(166,3,5,NULL,3,'PT501','PEMBELAJARAN MICRO',4,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(167,3,5,NULL,3,'ER461','Pengaturan Motor Listrik',4,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(168,3,5,NULL,3,'ER350','Sensor dan Aktuator',4,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(169,3,5,NULL,3,'ER454','Sistem Mikroprosesor dan IoT',3,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(170,3,5,NULL,3,'ER361','Probabilitas dan Statistik',3,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(171,3,5,NULL,3,'DK306','Strategi Pembelajaran',3,5,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(172,3,5,NULL,3,'TK301','KAJIAN PENDIDIKAN VOKASIONAL, TEKNOLOGI, DAN INDUSTRI',3,3,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(173,3,5,NULL,3,'ER230','Rangkaian Listrik 2',3,3,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(174,3,5,NULL,3,'ER344','Medan Elektromagnetik',3,3,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(175,3,5,NULL,3,'ER237','Praktikum Bengkel dan Dasar Elektro',4,3,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(176,3,5,NULL,3,'PT503','KEWIRAUSAHAAN',3,3,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(177,3,5,NULL,3,'PT400','Keterampilan Berbahasa Inggris',3,1,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(178,3,5,NULL,3,'ER115','Kalkulus',4,1,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(179,3,5,NULL,3,'ER210','Computer Aided Design (Gambar Teknik)',3,1,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(180,3,5,NULL,3,'ER116','Fisika',4,1,NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(181,2,6,NULL,NULL,'KU100','PENDIDIKAN AGAMA',2,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(182,2,6,NULL,NULL,'KU110','PENDIDIKAN PANCASILA',2,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(183,2,6,NULL,NULL,'KU105','PENDIDIKAN KEWARGANEGARAAN',2,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(184,2,6,NULL,NULL,'KU106','PENDIDIKAN BAHASA INDONESIA',2,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(185,2,6,NULL,NULL,'KU300','SEMINAR PENDIDIKAN AGAMA',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(186,2,6,NULL,NULL,'KU108','OLAH RAGA DAN KEBUGARAN*',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(187,2,6,NULL,NULL,'DK300','LANDASAN PENDIDIKAN',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(188,2,6,NULL,NULL,'TK302','KAJIAN TEKNOLOGI VOKASI DAN INDUSTRI',3,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(189,2,6,NULL,NULL,'DK301','PSIKOLOGI PENDIDIKAN DAN BIMBINGAN',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(190,2,6,NULL,NULL,'EL372','PERENCANAAN PEMBELAJARAN BIDANG STUDI **)',3,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(191,2,6,NULL,NULL,'EL370','STRATEGI PEMBELAJARAN BIDANG STUDI **)',3,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(192,2,6,NULL,NULL,'DK303','KURIKULUM DAN PEMBELAJARAN',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(193,2,6,NULL,NULL,'DK304','PENGELOLAAN KELAS',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(194,2,6,NULL,NULL,'EL371','LITERASI TIK DAN MEDIA PEMBELAJARAN **)',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(195,2,6,NULL,NULL,'PT400','KETERAMPILAN BAHASA INGGRIS',3,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(196,2,6,NULL,NULL,'EL115','FISIKA 1',3,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(197,2,6,NULL,NULL,'EL116','GAMBAR TEKNIK ELEKTRO',2,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(198,2,6,NULL,NULL,'EL114','DASAR KOMPUTER DAN PEMROGRAMAN (S/W dan H/W)',3,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(199,2,6,NULL,NULL,'EL117','MATERIAL ELEKTROTEKNIK',2,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(200,2,6,NULL,NULL,'EL123','MATEMATIKA DASAR',3,1,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(201,2,6,NULL,NULL,'EL211','FISIKA 2',3,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(202,2,6,NULL,NULL,'EL212','PRAKTIKUM DASAR DAN KESELAMATAN KERJA',2,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(203,2,6,NULL,NULL,'EL213','MATEMATIKA TEKNIK I',3,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(204,2,6,NULL,NULL,'EL238','RANGKAIAN LISTRIK I (Rangkaian DC dan Dasar AC)',3,2,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(205,2,6,NULL,NULL,'EL311','RANGKAIAN LISTRIK II',3,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(206,2,6,NULL,NULL,'EL312','ELEKTRONIKA DASAR',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(207,2,6,NULL,NULL,'EL314','MATEMATIKA TEKNIK II',3,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(208,2,6,NULL,NULL,'EL313','SISTEM TENAGA LISTRIK',2,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(209,2,6,NULL,NULL,'EL411','SISTEM DIGITAL',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(210,2,6,NULL,NULL,'EL412','SINYAL SISTEM',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(211,2,6,NULL,NULL,'EL415','ELEKTROMAGNETIKA',3,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(212,2,6,NULL,NULL,'EL251','SISTEM MIKROPROSESOR (2/1)',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(213,2,6,NULL,NULL,'EL511','PROBABILITAS DAN STATISTIK',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(214,2,6,NULL,NULL,'EL512','SISTEM KENDALI',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(215,2,6,NULL,NULL,'EL611','OTOMASI INDUSTRI',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(216,2,6,NULL,NULL,'EL612','PRAKTIKUM OTOMASI INDUSTRI',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(217,2,6,NULL,NULL,'EL613','METODE PENELITIAN',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(218,2,8,7,4,'EL272','PRAKTIK INDUSTRI DAN SEMINAR (PI DAN STE) (2 laporan)',4,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(219,2,6,NULL,NULL,'KA591','SKRIPSI',6,8,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(220,2,6,NULL,NULL,'EL599','SIDANG YUDISIUM',0,8,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(221,2,6,5,NULL,'EL347','SISTEM TELEKOMUNIKASI',4,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(222,2,6,5,NULL,'EL421','SISTEM KOMUNIKASI ANALOG',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(223,2,6,5,NULL,'EL455','ELEKTRONIKA DAN DEVAIS',3,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(224,2,6,5,NULL,'EL424','PRAKTIKUM  SISTEM KOMUNIKASI DAN ELEKTRONIKA TELEKOMUNIKASI',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(225,2,6,5,NULL,'EL523','JARINGAN TELEKOMUNIKASI',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(226,2,6,5,NULL,'EL521','SISTEM KOMUNIKASI DIGITAL',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(227,2,6,5,NULL,'EL527','PRAKTIKUM SENSOR DAN SISTEM MIKROPROSESOR',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(228,2,6,5,NULL,'EL525','SISTEM ANTENA',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(229,2,6,5,NULL,'EL522','SENSOR DAN TRANSDUSER',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(230,2,6,5,NULL,'EL626','PENGOLAHAN SINYAL DIGITAL',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(231,2,6,5,NULL,'EL625','PRAKTIKUM ANTENA DAN SISTEM RADAR',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(232,2,6,5,NULL,'EL465','SISTEM KOMUNIKASI SERAT OPTIK',3,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(233,2,6,5,NULL,'EL621','SISTEM KOMUNIKASI NIRKABEL',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(234,2,6,5,NULL,'EL624','PRAKTIKUM SISTEM KOMUNIKASI  DAN ANTENA',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(235,2,8,7,4,'EL723','SISTEM TERTANAM DAN IOT',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(236,2,8,7,4,'EL721','SISTEM CERDAS',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(237,2,8,7,4,'EL722','VISI KOMPUTER',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(238,2,8,7,4,'EL348','REKAYASA TRAFIK TELEKOMUNIKASI',3,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(239,2,6,6,NULL,'EL437','PRAKTIKUM PENGUKURAN LISTRIK',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(240,2,6,6,NULL,'EL432','METODA PENGUKURAN LISTRIK',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(241,2,6,6,NULL,'EL433','MESIN LISTRIK  DC',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(242,2,6,6,NULL,'EL435','ELEKTRONIKA DAYA',2,4,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(243,2,6,6,NULL,'EL532','PRAKTIKUM TEKNIK TENAGA LISTRIK',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(244,2,6,6,NULL,'EL537','SISTEM PEMBANGKIT TENAGA LISTRIK',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(245,2,6,6,NULL,'EL533','MESIN LISTRIK  AC',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(246,2,6,6,NULL,'EL358','PERENCANAAN INSTALASI LISTRIK',3,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(247,2,6,6,NULL,'EL534','SISTEM TERTANAM DAN INDUSTRIAL IoT',2,5,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(248,2,6,6,NULL,'EL636','SISTEM TRANSMISI DAN DISTRIBUSI',3,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(249,2,6,6,NULL,'EL631','PROTEKSI SISTEM TENAGA LISTRIK',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(250,2,6,6,NULL,'EL635','PRAKTIKUM PENGGUNAAN KOMPUTER DALAM SISTEM TENAGA LISTRIK',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(251,2,6,6,NULL,'EL633','PRAKTIKUM INSTALASI LISTRIK',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(252,2,6,6,NULL,'EL637','ANALISIS SISTEM TENAGA LISTRIK',2,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(253,2,8,7,4,'EL632','TEKNIK TEGANGAN TINGGI',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(254,2,8,7,4,'EL731','PENGGUNAAN DAN PENGATURAN MOTOR',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(255,2,8,7,4,'EL732','KELISTRIKAN OTOMOTIF',2,7,NULL,'2026-06-20 03:39:54','2026-06-24 06:47:52'),
(256,2,6,NULL,NULL,'PT401','Mikroteaching',4,6,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(257,2,6,NULL,NULL,'EL271','Kewirausahaan',3,3,NULL,'2026-06-20 03:39:54','2026-06-20 03:39:54'),
(258,4,7,NULL,NULL,'ET114','FISIKA DASAR I',4,1,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(259,4,7,NULL,NULL,'ET301','MATEMATIKA DASAR I',4,1,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(260,4,7,NULL,NULL,'ET113','KIMIA DASAR',4,1,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(261,4,7,NULL,NULL,'PT400','KETERAMPILAN BERBAHASA INGGRIS',4,1,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(262,4,7,NULL,NULL,'ET226','FISIKA GELOMBANG DAN MEKANIKA FLUIDA',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(263,4,7,NULL,NULL,'ET210','MATEMATIKA TEKNIK',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(264,4,7,NULL,NULL,'ET222','DASAR KONVERSI DAN ET',4,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(265,4,7,NULL,NULL,'ET225','RANGKAIAN LISTRIK DAN ELEKTRONIK 2',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(266,4,7,NULL,NULL,'ET223','SISTEM TENAGA LISTRIK',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(267,4,7,NULL,NULL,'ET224','SENSOR DAN AKTUATOR',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(268,4,7,NULL,NULL,'ET221','ALGORITMA, DATA, DAN PEMROGRAMAN',3,3,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(269,4,7,NULL,NULL,'ET308','ILMU MATERIAL TET',3,5,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(270,4,7,NULL,NULL,'ET233','TEKNOLOGI ENERGI HIDRO DAN BAYU',4,5,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(271,4,7,NULL,NULL,'ET319','SISTEM PENYIMPANAN ENERGI',3,5,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(272,4,7,NULL,NULL,'ET602','SCADA DAN INTERNET OF THINGS',4,5,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(273,4,7,NULL,NULL,'ET310','ELEKTRONIKA DAYA',3,5,NULL,'2026-06-22 08:07:15','2026-06-22 08:07:15'),
(274,3,4,NULL,NULL,'PT501_','Microteaching',4,7,NULL,'2026-06-23 00:04:14','2026-06-23 00:04:31');
/*!40000 ALTER TABLE `fetnet_subject` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_subject_type`
--

DROP TABLE IF EXISTS `fetnet_subject_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_subject_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_subject_type_program_id_foreign` (`program_id`),
  CONSTRAINT `fetnet_subject_type_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_subject_type`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_subject_type` WRITE;
/*!40000 ALTER TABLE `fetnet_subject_type` DISABLE KEYS */;
INSERT INTO `fetnet_subject_type` VALUES
(1,1,'MBK','MBKM',NULL,'2026-06-13 15:31:01','2026-06-13 15:31:01'),
(2,1,'PIL','PIL',NULL,'2026-06-17 01:49:09','2026-06-17 01:49:09'),
(3,3,'MK','MK',NULL,'2026-06-19 01:07:10','2026-06-19 01:07:10'),
(4,2,'MK','MK',NULL,'2026-06-24 06:47:52','2026-06-24 06:47:52');
/*!40000 ALTER TABLE `fetnet_subject_type` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_teacher`
--

DROP TABLE IF EXISTS `fetnet_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_teacher` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `code` varchar(10) DEFAULT NULL,
  `univ_code` char(4) DEFAULT NULL,
  `employee_id` varchar(20) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `civil_grade` varchar(50) DEFAULT NULL,
  `front_title` varchar(15) DEFAULT NULL,
  `rear_title` varchar(30) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_teacher_program_id_foreign` (`program_id`),
  CONSTRAINT `fetnet_teacher_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_teacher`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_teacher` WRITE;
/*!40000 ALTER TABLE `fetnet_teacher` DISABLE KEYS */;
INSERT INTO `fetnet_teacher` VALUES
(1,1,'BMY','1846','196301091994022000','Guru Besar','Pembina Utama/IVE','Prof. Dr.','M.Si.','Budi Mulyanti',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(2,1,'DDW','2934','197608272009121000','Lektor','Penata/IIIC',NULL,'Ph.D.','Didin Wahyudin',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(3,1,'INK','2338','197709082003121000','Lektor Kepala','Pembina Tk. I/IVB',NULL,'Ph.D.','Iwan Kustiawan',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(4,4,'AHS','2410','197208262005011000','Lektor Kepala','Penata Tk.1/IIID','Dr.','M.T.','Agus Heri Setya Budi',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-17 06:26:12'),
(5,1,'TMH','2745','198204282009121000','Lektor','Penata Tk.1/IIID',NULL,'Ph.D.','Tommi Hariyadi',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(6,1,'AIP','2355','197004162005011000','Lektor','Penata Tk.1/IIID','Dr.','MT.','Aip Saripudin',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(7,2,'MMS','2203','197201192001121000','Lektor','Penata Tk.1/IIID','Dr.','M.T.','Maman Somantri',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(8,2,'SSE','2202','197311222001122000','Lektor','Penata/IIIC',NULL,'Ph.D.','Siscka Elvyanti',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(9,2,'ARJ','2108','196406071995122000','Lektor Kepala','Penata Tk.1/IIID',NULL,'M.T.','Arjuni Budi Pantjawati',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(10,2,'TSM','1748','196410071991011000','Lektor Kepala','Pembina Utama Muda/IVC','Dr.','M.T.','Tasma Sucita',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-13 14:43:00'),
(11,4,'WAS','2107','197008081997021000','Lektor','Penata Tk.1/IIID',NULL,'M.T.','Wasimudin Surya Saputra',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-17 06:26:39'),
(12,4,'YDM','1766','196307271993021000','Lektor Kepala','Pembina Utama Muda/IVC','Dr.','M.T.','Yadi Mulyadi',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-17 06:31:47'),
(13,1,'AGF','2055','197211131999031000','Guru Besar','Pembina Utama/IVE','Prof. Dr.','S.Pd., M.Si.','Ade Gafar Abdullah',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-17 06:26:01'),
(14,1,'DLH','2409','196106041986031000','Lektor','Penata Tk.1/IIID','Dr.','M.T.','Dadang Lukman Hakim',NULL,NULL,'2026-06-19 08:28:14','2026-06-13 14:43:00','2026-06-19 08:28:14'),
(15,1,'DES','3586','198812022024062000','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','R. Deasy Mandasari',NULL,NULL,NULL,'2026-06-13 14:43:00','2026-06-14 10:02:25'),
(16,4,'UHR',NULL,'920241019930321101','Lektor','Penata/IIIC',NULL,'Ph.D.','Umar Hanif Ramadhani',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(17,2,'YKN',NULL,'199512172024061002','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Abdu Yakan Rosyadi',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(18,4,'MLE',NULL,'920241019970918101','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Mugni Labib Edhiputra',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(19,3,'IPO','3580','199303142024061001','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.Pd.','Ibnu Hartopo',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(20,3,'REP','3186','920200419881019101','Lektor','Penata/IIIC',NULL,'Ph.D.','Roer Eka Pawinanto',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(21,3,'MAR','3178','920200419921028101','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Muhammad Adli Rizqullah',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(22,3,'RPR','3172','920200419910418101','Lektor','Penata /IIIC',NULL,'M.T.','Resa Pramudita',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 08:19:04'),
(23,3,'NFA','3179','920200419930905101','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Nurul Fahmi Arief',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(24,3,'STA','3183','920200419960203201','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Silmi Aththairah Al Zamzami',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(25,3,'MAQ','3204','920200419890407201','Asisten Ahli','Penata Muda Tk.1/IIIB',NULL,'M.T.','Mariya Al Qibthiya',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(26,2,'JKR','0767','195912311985031022','Guru Besar','Pembina Utama/IVC','Prof. Dr.','M.Sc.','Jaja Kustija',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(27,2,'WWP','1848','196710261994031001','Lektor','Penata Tk.1/IIID','Drs.','M.Si.','Wawan Purnama',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(28,2,'MKH','0535','195311101980021001','Guru Besar','Pembina Utama/IVE','Prof. Dr.','M.Pd.','Mukhidin',NULL,NULL,NULL,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(29,3,'ERH','2407','197605272001121002','Lektor','Penata Tk.1/IIID','Dr.','M.T.','Erik Haritman',NULL,NULL,NULL,'2026-06-17 06:33:41','2026-06-17 06:33:41'),
(30,2,'ELM','1751','196404171992021001','Lektor Kepala','Pembina Tk. I/IVB','Dr.','M.Si.','Elih Mulyana',NULL,NULL,NULL,'2026-06-17 06:35:14','2026-06-17 06:35:14'),
(31,1,'GAP','0000','1234567890','Magang','-',NULL,'M.T.','Galang Adira Prayoga','galang@upi.edu','-',NULL,'2026-06-19 08:03:25','2026-06-19 08:07:23'),
(32,4,'ASH',NULL,'1111111111111111','Lektor Kepala','Pembina IVA','Dr.','M.T.','Agus Solehudin','ash@upi.edu','089639978111',NULL,'2026-06-22 08:12:35','2026-06-22 08:12:35'),
(33,4,'ALP','9999','198108239891717171','Asisten Ahli','III/B',NULL,'M.T','Ayu Laksmi Padmadewi','alp@upi.edu','08936978119',NULL,'2026-06-22 23:07:35','2026-06-22 23:07:35'),
(34,1,'NNH',NULL,NULL,NULL,NULL,NULL,'M.T.','Novianto Nur Hidayat','novi@upi.edu','00000000000000',NULL,'2026-06-24 03:51:59','2026-06-24 03:51:59');
/*!40000 ALTER TABLE `fetnet_teacher` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_teacher_constraint`
--

DROP TABLE IF EXISTS `fetnet_teacher_constraint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_teacher_constraint` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `program_id` bigint(20) unsigned NOT NULL,
  `teacher_id` bigint(20) unsigned DEFAULT NULL,
  `constraint_type` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  `weight` decimal(5,2) NOT NULL DEFAULT 100.00,
  `tag_id` bigint(20) unsigned DEFAULT NULL,
  `tag2_id` bigint(20) unsigned DEFAULT NULL,
  `interval_start` tinyint(4) DEFAULT NULL,
  `interval_end` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fetnet_teacher_constraint_tag_id_foreign` (`tag_id`),
  KEY `fetnet_teacher_constraint_tag2_id_foreign` (`tag2_id`),
  KEY `ftc_program_id_index` (`program_id`),
  KEY `ftc_teacher_id_index` (`teacher_id`),
  CONSTRAINT `fetnet_teacher_constraint_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_teacher_constraint_tag2_id_foreign` FOREIGN KEY (`tag2_id`) REFERENCES `fetnet_activity_tag` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_teacher_constraint_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `fetnet_activity_tag` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_teacher_constraint_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `fetnet_teacher` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_teacher_constraint`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_teacher_constraint` WRITE;
/*!40000 ALTER TABLE `fetnet_teacher_constraint` DISABLE KEYS */;
INSERT INTO `fetnet_teacher_constraint` VALUES
(1,1,13,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-14 09:54:14','2026-06-25 03:21:34'),
(2,1,4,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-14 09:54:38','2026-06-25 03:21:51'),
(3,1,6,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-14 15:21:11','2026-06-25 03:22:44'),
(4,1,12,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-14 15:21:35','2026-06-25 03:14:47'),
(5,1,11,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-14 23:20:06','2026-06-14 23:20:06'),
(6,1,10,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-19 12:47:15','2026-06-19 12:49:33'),
(7,1,25,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:25:38','2026-06-20 16:25:38'),
(8,1,15,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:36:33','2026-06-20 18:04:51'),
(9,1,29,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:37:31','2026-06-20 16:41:50'),
(10,1,3,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:39:38','2026-06-20 16:39:38'),
(11,1,18,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:40:04','2026-06-20 16:40:04'),
(12,1,22,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:41:12','2026-06-25 03:29:58'),
(13,1,2,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-20 16:42:49','2026-06-20 16:42:49'),
(14,2,10,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:04:14','2026-06-21 17:04:14'),
(15,2,29,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:05:14','2026-06-21 17:05:14'),
(16,2,3,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:07:19','2026-06-21 17:07:19'),
(17,2,18,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:07:34','2026-06-21 17:07:34'),
(18,2,20,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:07:52','2026-06-21 17:07:52'),
(19,2,2,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-21 17:08:11','2026-06-21 17:08:11'),
(20,1,34,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 08:53:12','2026-06-24 08:53:12'),
(21,1,31,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 08:56:09','2026-06-24 08:56:09'),
(22,2,7,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 09:02:42','2026-06-24 21:43:21'),
(23,2,6,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 21:42:06','2026-06-24 23:08:08'),
(24,2,33,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 21:42:45','2026-06-24 21:42:45'),
(25,2,12,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-24 22:54:48','2026-06-24 22:55:39'),
(26,1,27,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-25 03:15:07','2026-06-25 03:15:07'),
(27,1,8,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-25 03:15:35','2026-06-25 03:15:35'),
(28,1,9,'not_available',0,100.00,NULL,NULL,NULL,NULL,'2026-06-25 03:22:25','2026-06-25 03:22:25');
/*!40000 ALTER TABLE `fetnet_teacher_constraint` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_teacher_guest`
--

DROP TABLE IF EXISTS `fetnet_teacher_guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_teacher_guest` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` bigint(20) unsigned NOT NULL,
  `program_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_teacher_guest_teacher_id_program_id_unique` (`teacher_id`,`program_id`),
  KEY `fetnet_teacher_guest_program_id_foreign` (`program_id`),
  CONSTRAINT `fetnet_teacher_guest_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_teacher_guest_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `fetnet_teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_teacher_guest`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_teacher_guest` WRITE;
/*!40000 ALTER TABLE `fetnet_teacher_guest` DISABLE KEYS */;
INSERT INTO `fetnet_teacher_guest` VALUES
(1,4,2,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(2,11,2,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(3,13,2,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(4,14,2,'2026-06-17 06:30:28','2026-06-17 06:30:28'),
(5,15,2,'2026-06-17 06:30:28','2026-06-17 06:30:28');
/*!40000 ALTER TABLE `fetnet_teacher_guest` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_time_constraint_activity`
--

DROP TABLE IF EXISTS `fetnet_time_constraint_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_time_constraint_activity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint(20) unsigned NOT NULL,
  `day` tinyint(4) NOT NULL,
  `hour` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_time_constraint_activity_activity_id_day_hour_unique` (`activity_id`,`day`,`hour`),
  CONSTRAINT `fetnet_time_constraint_activity_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_time_constraint_activity`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_time_constraint_activity` WRITE;
/*!40000 ALTER TABLE `fetnet_time_constraint_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `fetnet_time_constraint_activity` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_time_constraint_student`
--

DROP TABLE IF EXISTS `fetnet_time_constraint_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_time_constraint_student` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `day` tinyint(4) NOT NULL,
  `hour` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_time_constraint_student_student_id_day_hour_unique` (`student_id`,`day`,`hour`),
  CONSTRAINT `fetnet_time_constraint_student_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `fetnet_student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_time_constraint_student`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_time_constraint_student` WRITE;
/*!40000 ALTER TABLE `fetnet_time_constraint_student` DISABLE KEYS */;
INSERT INTO `fetnet_time_constraint_student` VALUES
(1,21,3,1,'2026-06-19 07:44:21','2026-06-19 07:44:21'),
(3,21,3,2,'2026-06-19 07:44:53','2026-06-19 07:44:53');
/*!40000 ALTER TABLE `fetnet_time_constraint_student` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_time_constraint_teacher`
--

DROP TABLE IF EXISTS `fetnet_time_constraint_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_time_constraint_teacher` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` bigint(20) unsigned NOT NULL,
  `day` tinyint(4) NOT NULL,
  `hour` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fetnet_time_constraint_teacher_teacher_id_day_hour_unique` (`teacher_id`,`day`,`hour`),
  CONSTRAINT `fetnet_time_constraint_teacher_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `fetnet_teacher` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1020 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_time_constraint_teacher`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_time_constraint_teacher` WRITE;
/*!40000 ALTER TABLE `fetnet_time_constraint_teacher` DISABLE KEYS */;
INSERT INTO `fetnet_time_constraint_teacher` VALUES
(19,13,5,7,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(20,13,5,8,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(21,13,5,9,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(22,13,5,10,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(23,13,5,11,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(24,13,5,12,'2026-06-14 09:53:57','2026-06-14 09:53:57'),
(40,4,5,6,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(41,4,5,7,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(42,4,5,8,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(43,4,5,9,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(44,4,5,10,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(45,4,5,11,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(46,4,5,12,'2026-06-14 09:54:29','2026-06-14 09:54:29'),
(47,4,1,12,'2026-06-14 09:54:33','2026-06-14 09:54:33'),
(48,4,2,12,'2026-06-14 09:54:33','2026-06-14 09:54:33'),
(49,4,3,12,'2026-06-14 09:54:33','2026-06-14 09:54:33'),
(50,4,4,12,'2026-06-14 09:54:33','2026-06-14 09:54:33'),
(51,4,1,11,'2026-06-14 09:54:34','2026-06-14 09:54:34'),
(52,4,2,11,'2026-06-14 09:54:34','2026-06-14 09:54:34'),
(53,4,3,11,'2026-06-14 09:54:34','2026-06-14 09:54:34'),
(54,4,4,11,'2026-06-14 09:54:34','2026-06-14 09:54:34'),
(81,12,5,7,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(82,12,5,8,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(83,12,5,9,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(84,12,5,10,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(85,12,5,11,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(86,12,5,12,'2026-06-14 15:21:21','2026-06-14 15:21:21'),
(87,12,1,7,'2026-06-14 15:21:25','2026-06-14 15:21:25'),
(88,12,2,7,'2026-06-14 15:21:25','2026-06-14 15:21:25'),
(89,12,3,7,'2026-06-14 15:21:25','2026-06-14 15:21:25'),
(90,12,4,7,'2026-06-14 15:21:25','2026-06-14 15:21:25'),
(91,12,1,8,'2026-06-14 15:21:26','2026-06-14 15:21:26'),
(92,12,2,8,'2026-06-14 15:21:26','2026-06-14 15:21:26'),
(93,12,3,8,'2026-06-14 15:21:26','2026-06-14 15:21:26'),
(94,12,4,8,'2026-06-14 15:21:26','2026-06-14 15:21:26'),
(95,12,1,9,'2026-06-14 15:21:28','2026-06-14 15:21:28'),
(96,12,2,9,'2026-06-14 15:21:28','2026-06-14 15:21:28'),
(97,12,3,9,'2026-06-14 15:21:28','2026-06-14 15:21:28'),
(98,12,4,9,'2026-06-14 15:21:28','2026-06-14 15:21:28'),
(99,12,1,10,'2026-06-14 15:21:29','2026-06-14 15:21:29'),
(100,12,2,10,'2026-06-14 15:21:29','2026-06-14 15:21:29'),
(101,12,3,10,'2026-06-14 15:21:29','2026-06-14 15:21:29'),
(102,12,4,10,'2026-06-14 15:21:29','2026-06-14 15:21:29'),
(103,12,1,11,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(104,12,2,11,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(105,12,3,11,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(106,12,4,11,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(107,12,1,12,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(108,12,2,12,'2026-06-14 15:21:31','2026-06-14 15:21:31'),
(109,12,3,12,'2026-06-14 15:21:32','2026-06-14 15:21:32'),
(110,12,4,12,'2026-06-14 15:21:32','2026-06-14 15:21:32'),
(117,11,5,7,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(118,11,5,8,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(119,11,5,9,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(120,11,5,10,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(121,11,5,11,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(122,11,5,12,'2026-06-14 23:19:55','2026-06-14 23:19:55'),
(123,11,1,11,'2026-06-14 23:19:58','2026-06-14 23:19:58'),
(124,11,2,11,'2026-06-14 23:19:58','2026-06-14 23:19:58'),
(125,11,3,11,'2026-06-14 23:19:58','2026-06-14 23:19:58'),
(126,11,4,11,'2026-06-14 23:19:58','2026-06-14 23:19:58'),
(127,11,1,12,'2026-06-14 23:20:00','2026-06-14 23:20:00'),
(128,11,2,12,'2026-06-14 23:20:00','2026-06-14 23:20:00'),
(129,11,3,12,'2026-06-14 23:20:00','2026-06-14 23:20:00'),
(130,11,4,12,'2026-06-14 23:20:00','2026-06-14 23:20:00'),
(131,11,1,10,'2026-06-14 23:20:02','2026-06-14 23:20:02'),
(132,11,2,10,'2026-06-14 23:20:02','2026-06-14 23:20:02'),
(133,11,3,10,'2026-06-14 23:20:02','2026-06-14 23:20:02'),
(134,11,4,10,'2026-06-14 23:20:03','2026-06-14 23:20:03'),
(141,9,5,7,'2026-06-14 23:20:20','2026-06-14 23:20:20'),
(142,9,5,8,'2026-06-14 23:20:20','2026-06-14 23:20:20'),
(143,9,5,9,'2026-06-14 23:20:20','2026-06-14 23:20:20'),
(145,9,5,11,'2026-06-14 23:20:20','2026-06-14 23:20:20'),
(146,9,5,12,'2026-06-14 23:20:20','2026-06-14 23:20:20'),
(147,9,1,12,'2026-06-14 23:20:22','2026-06-14 23:20:22'),
(148,9,2,12,'2026-06-14 23:20:22','2026-06-14 23:20:22'),
(149,9,3,12,'2026-06-14 23:20:22','2026-06-14 23:20:22'),
(150,9,4,12,'2026-06-14 23:20:22','2026-06-14 23:20:22'),
(151,9,1,11,'2026-06-14 23:20:23','2026-06-14 23:20:23'),
(152,9,2,11,'2026-06-14 23:20:23','2026-06-14 23:20:23'),
(153,9,3,11,'2026-06-14 23:20:23','2026-06-14 23:20:23'),
(154,9,4,11,'2026-06-14 23:20:23','2026-06-14 23:20:23'),
(165,1,5,7,'2026-06-14 23:20:30','2026-06-14 23:20:30'),
(166,1,5,8,'2026-06-14 23:20:30','2026-06-14 23:20:30'),
(167,1,5,9,'2026-06-14 23:20:30','2026-06-14 23:20:30'),
(169,1,5,11,'2026-06-14 23:20:30','2026-06-14 23:20:30'),
(170,1,5,12,'2026-06-14 23:20:30','2026-06-14 23:20:30'),
(171,1,1,12,'2026-06-14 23:20:32','2026-06-14 23:20:32'),
(172,1,2,12,'2026-06-14 23:20:32','2026-06-14 23:20:32'),
(173,1,3,12,'2026-06-14 23:20:32','2026-06-14 23:20:32'),
(174,1,4,12,'2026-06-14 23:20:32','2026-06-14 23:20:32'),
(175,1,1,11,'2026-06-14 23:20:34','2026-06-14 23:20:34'),
(176,1,2,11,'2026-06-14 23:20:34','2026-06-14 23:20:34'),
(177,1,3,11,'2026-06-14 23:20:34','2026-06-14 23:20:34'),
(178,1,4,11,'2026-06-14 23:20:34','2026-06-14 23:20:34'),
(219,27,5,7,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(220,27,5,8,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(221,27,5,9,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(222,27,5,10,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(223,27,5,11,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(224,27,5,12,'2026-06-19 08:26:45','2026-06-19 08:26:45'),
(225,27,1,12,'2026-06-19 08:26:50','2026-06-19 08:26:50'),
(226,27,2,12,'2026-06-19 08:26:50','2026-06-19 08:26:50'),
(227,27,3,12,'2026-06-19 08:26:50','2026-06-19 08:26:50'),
(228,27,4,12,'2026-06-19 08:26:50','2026-06-19 08:26:50'),
(229,27,1,11,'2026-06-19 08:27:10','2026-06-19 08:27:10'),
(230,27,2,11,'2026-06-19 08:27:10','2026-06-19 08:27:10'),
(231,27,3,11,'2026-06-19 08:27:10','2026-06-19 08:27:10'),
(232,27,4,11,'2026-06-19 08:27:10','2026-06-19 08:27:10'),
(237,14,5,1,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(238,14,5,2,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(239,14,5,3,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(240,14,5,4,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(241,14,5,5,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(242,14,5,6,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(243,14,5,7,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(244,14,5,8,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(245,14,5,9,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(246,14,5,10,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(247,14,5,11,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(248,14,5,12,'2026-06-19 08:27:52','2026-06-19 08:27:52'),
(266,10,1,1,'2026-06-19 12:49:14','2026-06-19 12:49:14'),
(267,10,1,2,'2026-06-19 12:49:17','2026-06-19 12:49:17'),
(268,10,1,3,'2026-06-19 12:49:17','2026-06-19 12:49:17'),
(269,10,1,4,'2026-06-19 12:49:17','2026-06-19 12:49:17'),
(270,10,1,5,'2026-06-19 12:49:20','2026-06-19 12:49:20'),
(271,10,1,6,'2026-06-19 12:49:20','2026-06-19 12:49:20'),
(272,10,5,7,'2026-06-19 12:49:22','2026-06-19 12:49:22'),
(273,10,5,8,'2026-06-19 12:49:22','2026-06-19 12:49:22'),
(274,10,5,11,'2026-06-19 12:49:25','2026-06-19 12:49:25'),
(275,10,5,9,'2026-06-19 12:49:27','2026-06-19 12:49:27'),
(276,10,5,10,'2026-06-19 12:49:29','2026-06-19 12:49:29'),
(277,10,5,12,'2026-06-19 12:49:31','2026-06-19 12:49:31'),
(278,10,1,12,'2026-06-19 13:14:06','2026-06-19 13:14:06'),
(279,10,2,12,'2026-06-19 13:14:06','2026-06-19 13:14:06'),
(280,10,3,12,'2026-06-19 13:14:06','2026-06-19 13:14:06'),
(281,10,4,12,'2026-06-19 13:14:06','2026-06-19 13:14:06'),
(288,5,5,7,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(289,5,5,8,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(290,5,5,9,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(291,5,5,10,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(292,5,5,11,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(293,5,5,12,'2026-06-20 16:20:54','2026-06-20 16:20:54'),
(294,5,1,12,'2026-06-20 16:20:58','2026-06-20 16:20:58'),
(295,5,2,12,'2026-06-20 16:20:58','2026-06-20 16:20:58'),
(296,5,3,12,'2026-06-20 16:20:58','2026-06-20 16:20:58'),
(297,5,4,12,'2026-06-20 16:20:58','2026-06-20 16:20:58'),
(298,5,1,11,'2026-06-20 16:21:01','2026-06-20 16:21:01'),
(299,5,2,11,'2026-06-20 16:21:01','2026-06-20 16:21:01'),
(300,5,3,11,'2026-06-20 16:21:01','2026-06-20 16:21:01'),
(301,5,4,11,'2026-06-20 16:21:01','2026-06-20 16:21:01'),
(308,17,5,7,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(309,17,5,8,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(310,17,5,9,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(311,17,5,10,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(312,17,5,11,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(313,17,5,12,'2026-06-20 16:21:09','2026-06-20 16:21:09'),
(314,17,1,12,'2026-06-20 16:21:12','2026-06-20 16:21:12'),
(315,17,2,12,'2026-06-20 16:21:12','2026-06-20 16:21:12'),
(316,17,3,12,'2026-06-20 16:21:12','2026-06-20 16:21:12'),
(317,17,4,12,'2026-06-20 16:21:12','2026-06-20 16:21:12'),
(318,17,1,11,'2026-06-20 16:21:13','2026-06-20 16:21:13'),
(319,17,2,11,'2026-06-20 16:21:13','2026-06-20 16:21:13'),
(320,17,3,11,'2026-06-20 16:21:13','2026-06-20 16:21:13'),
(321,17,4,11,'2026-06-20 16:21:13','2026-06-20 16:21:13'),
(322,13,1,12,'2026-06-20 16:21:19','2026-06-20 16:21:19'),
(323,13,2,12,'2026-06-20 16:21:19','2026-06-20 16:21:19'),
(324,13,3,12,'2026-06-20 16:21:19','2026-06-20 16:21:19'),
(325,13,4,12,'2026-06-20 16:21:19','2026-06-20 16:21:19'),
(326,13,1,11,'2026-06-20 16:21:21','2026-06-20 16:21:21'),
(327,13,2,11,'2026-06-20 16:21:21','2026-06-20 16:21:21'),
(328,13,3,11,'2026-06-20 16:21:21','2026-06-20 16:21:21'),
(329,13,4,11,'2026-06-20 16:21:21','2026-06-20 16:21:21'),
(334,9,5,10,'2026-06-20 16:22:02','2026-06-20 16:22:02'),
(335,1,5,10,'2026-06-20 16:22:11','2026-06-20 16:22:11'),
(336,2,1,1,'2026-06-20 16:22:17','2026-06-20 16:22:17'),
(337,2,2,1,'2026-06-20 16:22:17','2026-06-20 16:22:17'),
(338,2,3,1,'2026-06-20 16:22:17','2026-06-20 16:22:17'),
(339,2,4,1,'2026-06-20 16:22:17','2026-06-20 16:22:17'),
(340,2,5,1,'2026-06-20 16:22:17','2026-06-20 16:22:17'),
(341,2,5,2,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(342,2,5,3,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(343,2,5,4,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(344,2,5,5,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(345,2,5,6,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(346,2,5,7,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(347,2,5,8,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(348,2,5,9,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(349,2,5,10,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(350,2,5,11,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(351,2,5,12,'2026-06-20 16:22:19','2026-06-20 16:22:19'),
(353,2,2,2,'2026-06-20 16:22:22','2026-06-20 16:22:22'),
(354,2,3,2,'2026-06-20 16:22:22','2026-06-20 16:22:22'),
(355,2,4,2,'2026-06-20 16:22:22','2026-06-20 16:22:22'),
(356,2,1,12,'2026-06-20 16:22:25','2026-06-20 16:22:25'),
(357,2,2,12,'2026-06-20 16:22:25','2026-06-20 16:22:25'),
(358,2,3,12,'2026-06-20 16:22:25','2026-06-20 16:22:25'),
(359,2,4,12,'2026-06-20 16:22:25','2026-06-20 16:22:25'),
(360,2,1,11,'2026-06-20 16:22:27','2026-06-20 16:22:27'),
(361,2,2,11,'2026-06-20 16:22:27','2026-06-20 16:22:27'),
(362,2,3,11,'2026-06-20 16:22:27','2026-06-20 16:22:27'),
(363,2,4,11,'2026-06-20 16:22:27','2026-06-20 16:22:27'),
(364,2,1,10,'2026-06-20 16:22:30','2026-06-20 16:22:30'),
(365,2,2,10,'2026-06-20 16:22:30','2026-06-20 16:22:30'),
(366,2,3,10,'2026-06-20 16:22:30','2026-06-20 16:22:30'),
(367,2,4,10,'2026-06-20 16:22:30','2026-06-20 16:22:30'),
(374,30,5,7,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(375,30,5,8,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(376,30,5,9,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(377,30,5,10,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(378,30,5,11,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(379,30,5,12,'2026-06-20 16:22:36','2026-06-20 16:22:36'),
(380,30,1,12,'2026-06-20 16:22:38','2026-06-20 16:22:38'),
(381,30,2,12,'2026-06-20 16:22:38','2026-06-20 16:22:38'),
(382,30,3,12,'2026-06-20 16:22:38','2026-06-20 16:22:38'),
(383,30,4,12,'2026-06-20 16:22:38','2026-06-20 16:22:38'),
(384,30,1,11,'2026-06-20 16:22:40','2026-06-20 16:22:40'),
(385,30,2,11,'2026-06-20 16:22:40','2026-06-20 16:22:40'),
(386,30,3,11,'2026-06-20 16:22:40','2026-06-20 16:22:40'),
(387,30,4,11,'2026-06-20 16:22:40','2026-06-20 16:22:40'),
(394,29,5,7,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(395,29,5,8,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(396,29,5,9,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(397,29,5,10,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(398,29,5,11,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(399,29,5,12,'2026-06-20 16:22:46','2026-06-20 16:22:46'),
(400,29,1,12,'2026-06-20 16:22:48','2026-06-20 16:22:48'),
(401,29,2,12,'2026-06-20 16:22:48','2026-06-20 16:22:48'),
(402,29,3,12,'2026-06-20 16:22:48','2026-06-20 16:22:48'),
(403,29,4,12,'2026-06-20 16:22:48','2026-06-20 16:22:48'),
(418,31,5,7,'2026-06-20 16:22:57','2026-06-20 16:22:57'),
(420,31,5,9,'2026-06-20 16:22:57','2026-06-20 16:22:57'),
(421,31,5,10,'2026-06-20 16:22:57','2026-06-20 16:22:57'),
(422,31,5,11,'2026-06-20 16:22:57','2026-06-20 16:22:57'),
(423,31,5,12,'2026-06-20 16:22:57','2026-06-20 16:22:57'),
(424,31,1,12,'2026-06-20 16:23:00','2026-06-20 16:23:00'),
(425,31,2,12,'2026-06-20 16:23:00','2026-06-20 16:23:00'),
(426,31,3,12,'2026-06-20 16:23:00','2026-06-20 16:23:00'),
(427,31,4,12,'2026-06-20 16:23:00','2026-06-20 16:23:00'),
(428,31,1,11,'2026-06-20 16:23:02','2026-06-20 16:23:02'),
(429,31,2,11,'2026-06-20 16:23:02','2026-06-20 16:23:02'),
(430,31,3,11,'2026-06-20 16:23:02','2026-06-20 16:23:02'),
(431,31,4,11,'2026-06-20 16:23:02','2026-06-20 16:23:02'),
(444,31,5,8,'2026-06-20 16:23:11','2026-06-20 16:23:11'),
(451,19,5,7,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(452,19,5,8,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(453,19,5,9,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(454,19,5,10,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(455,19,5,11,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(456,19,5,12,'2026-06-20 16:23:26','2026-06-20 16:23:26'),
(457,19,1,12,'2026-06-20 16:23:28','2026-06-20 16:23:28'),
(458,19,2,12,'2026-06-20 16:23:28','2026-06-20 16:23:28'),
(459,19,3,12,'2026-06-20 16:23:28','2026-06-20 16:23:28'),
(460,19,4,12,'2026-06-20 16:23:28','2026-06-20 16:23:28'),
(461,19,1,11,'2026-06-20 16:23:30','2026-06-20 16:23:30'),
(462,19,2,11,'2026-06-20 16:23:30','2026-06-20 16:23:30'),
(463,19,3,11,'2026-06-20 16:23:30','2026-06-20 16:23:30'),
(464,19,4,11,'2026-06-20 16:23:30','2026-06-20 16:23:30'),
(471,3,5,7,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(472,3,5,8,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(473,3,5,9,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(474,3,5,10,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(475,3,5,11,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(476,3,5,12,'2026-06-20 16:23:37','2026-06-20 16:23:37'),
(477,3,1,12,'2026-06-20 16:23:38','2026-06-20 16:23:38'),
(478,3,2,12,'2026-06-20 16:23:38','2026-06-20 16:23:38'),
(479,3,3,12,'2026-06-20 16:23:39','2026-06-20 16:23:39'),
(480,3,4,12,'2026-06-20 16:23:39','2026-06-20 16:23:39'),
(491,26,5,7,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(492,26,5,8,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(493,26,5,9,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(494,26,5,10,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(495,26,5,11,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(496,26,5,12,'2026-06-20 16:23:45','2026-06-20 16:23:45'),
(505,26,1,11,'2026-06-20 16:23:54','2026-06-20 16:23:54'),
(506,26,2,11,'2026-06-20 16:23:54','2026-06-20 16:23:54'),
(507,26,3,11,'2026-06-20 16:23:54','2026-06-20 16:23:54'),
(508,26,4,11,'2026-06-20 16:23:54','2026-06-20 16:23:54'),
(510,26,1,12,'2026-06-20 16:24:00','2026-06-20 16:24:00'),
(511,26,2,12,'2026-06-20 16:24:00','2026-06-20 16:24:00'),
(512,26,3,12,'2026-06-20 16:24:00','2026-06-20 16:24:00'),
(513,26,4,12,'2026-06-20 16:24:00','2026-06-20 16:24:00'),
(540,25,5,7,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(541,25,5,8,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(542,25,5,9,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(543,25,5,10,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(544,25,5,11,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(545,25,5,12,'2026-06-20 16:24:25','2026-06-20 16:24:25'),
(546,25,1,12,'2026-06-20 16:24:27','2026-06-20 16:24:27'),
(547,25,2,12,'2026-06-20 16:24:27','2026-06-20 16:24:27'),
(548,25,3,12,'2026-06-20 16:24:27','2026-06-20 16:24:27'),
(549,25,4,12,'2026-06-20 16:24:27','2026-06-20 16:24:27'),
(550,25,1,11,'2026-06-20 16:24:29','2026-06-20 16:24:29'),
(551,25,2,11,'2026-06-20 16:24:29','2026-06-20 16:24:29'),
(552,25,3,11,'2026-06-20 16:24:29','2026-06-20 16:24:29'),
(553,25,4,11,'2026-06-20 16:24:29','2026-06-20 16:24:29'),
(566,18,1,12,'2026-06-20 16:26:10','2026-06-20 16:26:10'),
(567,18,2,12,'2026-06-20 16:26:10','2026-06-20 16:26:10'),
(568,18,3,12,'2026-06-20 16:26:10','2026-06-20 16:26:10'),
(569,18,4,12,'2026-06-20 16:26:10','2026-06-20 16:26:10'),
(584,28,5,7,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(585,28,5,8,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(586,28,5,9,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(587,28,5,10,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(588,28,5,11,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(589,28,5,12,'2026-06-20 16:26:37','2026-06-20 16:26:37'),
(590,28,1,12,'2026-06-20 16:26:39','2026-06-20 16:26:39'),
(591,28,2,12,'2026-06-20 16:26:39','2026-06-20 16:26:39'),
(592,28,3,12,'2026-06-20 16:26:39','2026-06-20 16:26:39'),
(593,28,4,12,'2026-06-20 16:26:39','2026-06-20 16:26:39'),
(594,28,1,11,'2026-06-20 16:26:41','2026-06-20 16:26:41'),
(595,28,2,11,'2026-06-20 16:26:41','2026-06-20 16:26:41'),
(596,28,3,11,'2026-06-20 16:26:41','2026-06-20 16:26:41'),
(597,28,4,11,'2026-06-20 16:26:41','2026-06-20 16:26:41'),
(602,23,5,1,'2026-06-20 16:26:51','2026-06-20 16:26:51'),
(603,23,5,2,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(604,23,5,3,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(605,23,5,4,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(606,23,5,5,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(607,23,5,6,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(608,23,5,7,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(609,23,5,8,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(610,23,5,9,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(611,23,5,10,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(612,23,5,11,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(613,23,5,12,'2026-06-20 16:26:53','2026-06-20 16:26:53'),
(614,23,1,12,'2026-06-20 16:26:55','2026-06-20 16:26:55'),
(615,23,2,12,'2026-06-20 16:26:55','2026-06-20 16:26:55'),
(616,23,3,12,'2026-06-20 16:26:55','2026-06-20 16:26:55'),
(617,23,4,12,'2026-06-20 16:26:55','2026-06-20 16:26:55'),
(618,23,1,11,'2026-06-20 16:26:56','2026-06-20 16:26:56'),
(619,23,2,11,'2026-06-20 16:26:56','2026-06-20 16:26:56'),
(620,23,3,11,'2026-06-20 16:26:56','2026-06-20 16:26:56'),
(621,23,4,11,'2026-06-20 16:26:56','2026-06-20 16:26:56'),
(622,23,1,10,'2026-06-20 16:26:57','2026-06-20 16:26:57'),
(623,23,2,10,'2026-06-20 16:26:57','2026-06-20 16:26:57'),
(624,23,3,10,'2026-06-20 16:26:57','2026-06-20 16:26:57'),
(625,23,4,10,'2026-06-20 16:26:57','2026-06-20 16:26:57'),
(626,21,5,1,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(627,21,5,2,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(628,21,5,3,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(629,21,5,4,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(630,21,5,5,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(631,21,5,6,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(632,21,5,7,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(633,21,5,8,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(634,21,5,9,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(635,21,5,10,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(636,21,5,11,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(637,21,5,12,'2026-06-20 16:27:14','2026-06-20 16:27:14'),
(638,21,1,12,'2026-06-20 16:27:16','2026-06-20 16:27:16'),
(639,21,2,12,'2026-06-20 16:27:16','2026-06-20 16:27:16'),
(640,21,3,12,'2026-06-20 16:27:16','2026-06-20 16:27:16'),
(641,21,4,12,'2026-06-20 16:27:16','2026-06-20 16:27:16'),
(642,21,1,11,'2026-06-20 16:27:17','2026-06-20 16:27:17'),
(643,21,2,11,'2026-06-20 16:27:17','2026-06-20 16:27:17'),
(644,21,3,11,'2026-06-20 16:27:17','2026-06-20 16:27:17'),
(645,21,4,11,'2026-06-20 16:27:17','2026-06-20 16:27:17'),
(646,21,1,10,'2026-06-20 16:27:18','2026-06-20 16:27:18'),
(647,21,2,10,'2026-06-20 16:27:18','2026-06-20 16:27:18'),
(648,21,3,10,'2026-06-20 16:27:18','2026-06-20 16:27:18'),
(649,21,4,10,'2026-06-20 16:27:18','2026-06-20 16:27:18'),
(656,15,5,7,'2026-06-20 16:27:28','2026-06-20 16:27:28'),
(657,15,5,8,'2026-06-20 16:27:28','2026-06-20 16:27:28'),
(658,15,5,9,'2026-06-20 16:27:28','2026-06-20 16:27:28'),
(660,15,5,11,'2026-06-20 16:27:28','2026-06-20 16:27:28'),
(661,15,5,12,'2026-06-20 16:27:28','2026-06-20 16:27:28'),
(662,15,1,12,'2026-06-20 16:27:30','2026-06-20 16:27:30'),
(663,15,2,12,'2026-06-20 16:27:30','2026-06-20 16:27:30'),
(664,15,3,12,'2026-06-20 16:27:30','2026-06-20 16:27:30'),
(665,15,4,12,'2026-06-20 16:27:30','2026-06-20 16:27:30'),
(680,22,5,7,'2026-06-20 16:27:44','2026-06-20 16:27:44'),
(681,22,5,8,'2026-06-20 16:27:44','2026-06-20 16:27:44'),
(682,22,5,9,'2026-06-20 16:27:44','2026-06-20 16:27:44'),
(685,22,5,12,'2026-06-20 16:27:44','2026-06-20 16:27:44'),
(686,22,1,12,'2026-06-20 16:27:48','2026-06-20 16:27:48'),
(687,22,2,12,'2026-06-20 16:27:48','2026-06-20 16:27:48'),
(688,22,3,12,'2026-06-20 16:27:48','2026-06-20 16:27:48'),
(689,22,4,12,'2026-06-20 16:27:48','2026-06-20 16:27:48'),
(704,20,5,7,'2026-06-20 16:28:05','2026-06-20 16:28:05'),
(705,20,5,8,'2026-06-20 16:28:05','2026-06-20 16:28:05'),
(706,20,5,9,'2026-06-20 16:28:05','2026-06-20 16:28:05'),
(709,20,5,12,'2026-06-20 16:28:05','2026-06-20 16:28:05'),
(710,20,1,12,'2026-06-20 16:28:09','2026-06-20 16:28:09'),
(711,20,2,12,'2026-06-20 16:28:09','2026-06-20 16:28:09'),
(712,20,3,12,'2026-06-20 16:28:09','2026-06-20 16:28:09'),
(713,20,4,12,'2026-06-20 16:28:09','2026-06-20 16:28:09'),
(728,24,5,7,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(729,24,5,8,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(730,24,5,9,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(731,24,5,10,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(732,24,5,11,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(733,24,5,12,'2026-06-20 16:28:30','2026-06-20 16:28:30'),
(734,24,1,12,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(735,24,2,12,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(736,24,3,12,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(737,24,4,12,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(738,24,1,11,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(739,24,2,11,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(740,24,3,11,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(741,24,4,11,'2026-06-20 16:28:32','2026-06-20 16:28:32'),
(742,24,1,10,'2026-06-20 16:28:34','2026-06-20 16:28:34'),
(743,24,2,10,'2026-06-20 16:28:34','2026-06-20 16:28:34'),
(744,24,3,10,'2026-06-20 16:28:34','2026-06-20 16:28:34'),
(745,24,4,10,'2026-06-20 16:28:34','2026-06-20 16:28:34'),
(752,8,5,7,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(753,8,5,8,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(754,8,5,9,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(755,8,5,10,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(756,8,5,11,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(757,8,5,12,'2026-06-20 16:28:43','2026-06-20 16:28:43'),
(758,8,1,12,'2026-06-20 16:28:45','2026-06-20 16:28:45'),
(759,8,2,12,'2026-06-20 16:28:45','2026-06-20 16:28:45'),
(760,8,3,12,'2026-06-20 16:28:45','2026-06-20 16:28:45'),
(761,8,4,12,'2026-06-20 16:28:45','2026-06-20 16:28:45'),
(762,8,1,11,'2026-06-20 16:28:47','2026-06-20 16:28:47'),
(763,8,2,11,'2026-06-20 16:28:47','2026-06-20 16:28:47'),
(764,8,3,11,'2026-06-20 16:28:47','2026-06-20 16:28:47'),
(765,8,4,11,'2026-06-20 16:28:47','2026-06-20 16:28:47'),
(766,8,1,10,'2026-06-20 16:28:49','2026-06-20 16:28:49'),
(767,8,2,10,'2026-06-20 16:28:49','2026-06-20 16:28:49'),
(768,8,3,10,'2026-06-20 16:28:49','2026-06-20 16:28:49'),
(769,8,4,10,'2026-06-20 16:28:49','2026-06-20 16:28:49'),
(776,16,5,7,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(777,16,5,8,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(778,16,5,9,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(779,16,5,10,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(780,16,5,11,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(781,16,5,12,'2026-06-20 16:28:57','2026-06-20 16:28:57'),
(782,16,1,12,'2026-06-20 16:28:59','2026-06-20 16:28:59'),
(783,16,2,12,'2026-06-20 16:28:59','2026-06-20 16:28:59'),
(784,16,3,12,'2026-06-20 16:28:59','2026-06-20 16:28:59'),
(785,16,4,12,'2026-06-20 16:28:59','2026-06-20 16:28:59'),
(786,16,1,11,'2026-06-20 16:29:00','2026-06-20 16:29:00'),
(787,16,2,11,'2026-06-20 16:29:00','2026-06-20 16:29:00'),
(788,16,3,11,'2026-06-20 16:29:00','2026-06-20 16:29:00'),
(789,16,4,11,'2026-06-20 16:29:00','2026-06-20 16:29:00'),
(790,16,1,10,'2026-06-20 16:29:03','2026-06-20 16:29:03'),
(791,16,2,10,'2026-06-20 16:29:03','2026-06-20 16:29:03'),
(792,16,3,10,'2026-06-20 16:29:03','2026-06-20 16:29:03'),
(793,16,4,10,'2026-06-20 16:29:03','2026-06-20 16:29:03'),
(794,15,5,10,'2026-06-20 16:36:27','2026-06-20 16:36:27'),
(795,20,5,10,'2026-06-20 16:40:24','2026-06-20 16:40:24'),
(796,20,5,11,'2026-06-20 16:40:25','2026-06-20 16:40:25'),
(797,22,5,10,'2026-06-20 16:41:08','2026-06-20 16:41:08'),
(798,22,5,11,'2026-06-20 16:41:08','2026-06-20 16:41:08'),
(816,15,1,11,'2026-06-21 17:05:01','2026-06-21 17:05:01'),
(817,15,2,11,'2026-06-21 17:05:01','2026-06-21 17:05:01'),
(818,15,3,11,'2026-06-21 17:05:01','2026-06-21 17:05:01'),
(819,15,4,11,'2026-06-21 17:05:01','2026-06-21 17:05:01'),
(826,29,1,11,'2026-06-21 17:05:10','2026-06-21 17:05:10'),
(827,29,2,11,'2026-06-21 17:05:10','2026-06-21 17:05:10'),
(828,29,3,11,'2026-06-21 17:05:10','2026-06-21 17:05:10'),
(829,29,4,11,'2026-06-21 17:05:10','2026-06-21 17:05:10'),
(839,22,1,11,'2026-06-21 17:06:57','2026-06-21 17:06:57'),
(840,22,2,11,'2026-06-21 17:06:57','2026-06-21 17:06:57'),
(841,22,3,11,'2026-06-21 17:06:57','2026-06-21 17:06:57'),
(842,22,4,11,'2026-06-21 17:06:57','2026-06-21 17:06:57'),
(843,3,1,11,'2026-06-21 17:07:15','2026-06-21 17:07:15'),
(844,3,2,11,'2026-06-21 17:07:15','2026-06-21 17:07:15'),
(845,3,3,11,'2026-06-21 17:07:15','2026-06-21 17:07:15'),
(846,3,4,11,'2026-06-21 17:07:15','2026-06-21 17:07:15'),
(851,18,1,11,'2026-06-21 17:07:31','2026-06-21 17:07:31'),
(852,18,2,11,'2026-06-21 17:07:31','2026-06-21 17:07:31'),
(853,18,3,11,'2026-06-21 17:07:31','2026-06-21 17:07:31'),
(854,18,4,11,'2026-06-21 17:07:31','2026-06-21 17:07:31'),
(859,20,1,11,'2026-06-21 17:07:48','2026-06-21 17:07:48'),
(860,20,2,11,'2026-06-21 17:07:48','2026-06-21 17:07:48'),
(861,20,3,11,'2026-06-21 17:07:48','2026-06-21 17:07:48'),
(862,20,4,11,'2026-06-21 17:07:48','2026-06-21 17:07:48'),
(867,2,1,2,'2026-06-21 17:08:08','2026-06-21 17:08:08'),
(869,6,3,1,'2026-06-24 08:52:00','2026-06-24 08:52:00'),
(870,6,3,2,'2026-06-24 08:52:02','2026-06-24 08:52:02'),
(871,6,4,1,'2026-06-24 08:52:03','2026-06-24 08:52:03'),
(872,6,4,2,'2026-06-24 08:52:04','2026-06-24 08:52:04'),
(873,6,4,3,'2026-06-24 08:52:06','2026-06-24 08:52:06'),
(874,6,3,3,'2026-06-24 08:52:06','2026-06-24 08:52:06'),
(875,6,3,4,'2026-06-24 08:52:07','2026-06-24 08:52:07'),
(876,6,4,4,'2026-06-24 08:52:09','2026-06-24 08:52:09'),
(877,6,4,5,'2026-06-24 08:52:09','2026-06-24 08:52:09'),
(878,6,3,5,'2026-06-24 08:52:10','2026-06-24 08:52:10'),
(879,6,3,6,'2026-06-24 08:52:11','2026-06-24 08:52:11'),
(880,6,4,6,'2026-06-24 08:52:11','2026-06-24 08:52:11'),
(911,32,5,7,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(912,32,5,8,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(913,32,5,9,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(914,32,5,10,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(915,32,5,11,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(916,32,5,12,'2026-06-24 08:52:38','2026-06-24 08:52:38'),
(917,32,1,11,'2026-06-24 08:52:41','2026-06-24 08:52:41'),
(918,32,2,11,'2026-06-24 08:52:41','2026-06-24 08:52:41'),
(919,32,3,11,'2026-06-24 08:52:41','2026-06-24 08:52:41'),
(920,32,4,11,'2026-06-24 08:52:41','2026-06-24 08:52:41'),
(921,32,1,12,'2026-06-24 08:52:43','2026-06-24 08:52:43'),
(922,32,2,12,'2026-06-24 08:52:43','2026-06-24 08:52:43'),
(923,32,3,12,'2026-06-24 08:52:43','2026-06-24 08:52:43'),
(924,32,4,12,'2026-06-24 08:52:43','2026-06-24 08:52:43'),
(931,34,5,7,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(932,34,5,8,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(933,34,5,9,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(934,34,5,10,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(935,34,5,11,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(936,34,5,12,'2026-06-24 08:53:07','2026-06-24 08:53:07'),
(937,34,1,12,'2026-06-24 08:53:09','2026-06-24 08:53:09'),
(938,34,2,12,'2026-06-24 08:53:09','2026-06-24 08:53:09'),
(939,34,3,12,'2026-06-24 08:53:09','2026-06-24 08:53:09'),
(940,34,4,12,'2026-06-24 08:53:09','2026-06-24 08:53:09'),
(941,34,1,11,'2026-06-24 08:53:10','2026-06-24 08:53:10'),
(942,34,2,11,'2026-06-24 08:53:10','2026-06-24 08:53:10'),
(943,34,3,11,'2026-06-24 08:53:10','2026-06-24 08:53:10'),
(944,34,4,11,'2026-06-24 08:53:10','2026-06-24 08:53:10'),
(957,13,1,10,'2026-06-24 08:56:34','2026-06-24 08:56:34'),
(958,13,2,10,'2026-06-24 08:56:34','2026-06-24 08:56:34'),
(959,13,3,10,'2026-06-24 08:56:34','2026-06-24 08:56:34'),
(960,13,4,10,'2026-06-24 08:56:34','2026-06-24 08:56:34'),
(971,18,5,11,'2026-06-24 09:04:19','2026-06-24 09:04:19'),
(972,18,5,12,'2026-06-24 09:04:33','2026-06-24 09:04:33'),
(976,33,1,12,'2026-06-24 21:42:41','2026-06-24 21:42:41'),
(977,33,2,12,'2026-06-24 21:42:41','2026-06-24 21:42:41'),
(978,33,3,12,'2026-06-24 21:42:41','2026-06-24 21:42:41'),
(979,33,4,12,'2026-06-24 21:42:41','2026-06-24 21:42:41'),
(980,33,5,12,'2026-06-24 21:42:41','2026-06-24 21:42:41'),
(981,33,1,11,'2026-06-24 21:42:43','2026-06-24 21:42:43'),
(982,33,2,11,'2026-06-24 21:42:43','2026-06-24 21:42:43'),
(983,33,3,11,'2026-06-24 21:42:43','2026-06-24 21:42:43'),
(984,33,4,11,'2026-06-24 21:42:43','2026-06-24 21:42:43'),
(985,33,5,11,'2026-06-24 21:42:43','2026-06-24 21:42:43'),
(991,6,1,12,'2026-06-24 23:08:01','2026-06-24 23:08:01'),
(992,6,2,12,'2026-06-24 23:08:01','2026-06-24 23:08:01'),
(993,6,3,12,'2026-06-24 23:08:01','2026-06-24 23:08:01'),
(994,6,4,12,'2026-06-24 23:08:01','2026-06-24 23:08:01'),
(995,6,5,12,'2026-06-24 23:08:01','2026-06-24 23:08:01'),
(996,6,1,11,'2026-06-24 23:08:04','2026-06-24 23:08:04'),
(997,6,2,11,'2026-06-24 23:08:04','2026-06-24 23:08:04'),
(998,6,3,11,'2026-06-24 23:08:04','2026-06-24 23:08:04'),
(999,6,4,11,'2026-06-24 23:08:04','2026-06-24 23:08:04'),
(1000,6,5,11,'2026-06-24 23:08:04','2026-06-24 23:08:04'),
(1006,7,1,12,'2026-06-24 23:09:01','2026-06-24 23:09:01'),
(1007,7,2,12,'2026-06-24 23:09:01','2026-06-24 23:09:01'),
(1008,7,3,12,'2026-06-24 23:09:01','2026-06-24 23:09:01'),
(1009,7,4,12,'2026-06-24 23:09:01','2026-06-24 23:09:01'),
(1010,7,5,12,'2026-06-24 23:09:01','2026-06-24 23:09:01'),
(1011,7,1,11,'2026-06-24 23:09:03','2026-06-24 23:09:03'),
(1012,7,2,11,'2026-06-24 23:09:03','2026-06-24 23:09:03'),
(1013,7,3,11,'2026-06-24 23:09:03','2026-06-24 23:09:03'),
(1014,7,4,11,'2026-06-24 23:09:03','2026-06-24 23:09:03'),
(1015,7,5,11,'2026-06-24 23:09:03','2026-06-24 23:09:03'),
(1016,7,5,9,'2026-06-25 03:28:42','2026-06-25 03:28:42'),
(1017,7,5,10,'2026-06-25 03:28:43','2026-06-25 03:28:43'),
(1018,7,5,8,'2026-06-25 03:28:46','2026-06-25 03:28:46'),
(1019,7,5,7,'2026-06-25 03:28:48','2026-06-25 03:28:48');
/*!40000 ALTER TABLE `fetnet_time_constraint_teacher` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `fetnet_timetable_slot`
--

DROP TABLE IF EXISTS `fetnet_timetable_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fetnet_timetable_slot` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `semester_id` bigint(20) unsigned NOT NULL,
  `activity_id` bigint(20) unsigned NOT NULL,
  `day_index` smallint(5) unsigned DEFAULT NULL,
  `hour_index` smallint(5) unsigned DEFAULT NULL,
  `duration` smallint(5) unsigned NOT NULL DEFAULT 1,
  `room_id` bigint(20) unsigned DEFAULT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT 1,
  `weight_percent` tinyint(3) unsigned NOT NULL DEFAULT 100,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tt_slot_uniq` (`client_id`,`semester_id`,`activity_id`),
  KEY `fetnet_timetable_slot_semester_id_foreign` (`semester_id`),
  KEY `fetnet_timetable_slot_activity_id_foreign` (`activity_id`),
  KEY `fetnet_timetable_slot_room_id_foreign` (`room_id`),
  KEY `tt_slot_lookup` (`client_id`,`semester_id`,`locked`),
  CONSTRAINT `fetnet_timetable_slot_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `fetnet_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_timetable_slot_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fetnet_timetable_slot_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `fetnet_space` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fetnet_timetable_slot_semester_id_foreign` FOREIGN KEY (`semester_id`) REFERENCES `fetnet_semester` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fetnet_timetable_slot`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `fetnet_timetable_slot` WRITE;
/*!40000 ALTER TABLE `fetnet_timetable_slot` DISABLE KEYS */;
INSERT INTO `fetnet_timetable_slot` VALUES
(84,1,1,3,4,3,3,9,1,100,'2026-06-20 17:03:12','2026-06-25 03:42:16'),
(85,1,1,4,3,4,3,9,1,100,'2026-06-20 17:03:12','2026-06-25 03:42:16'),
(86,1,1,5,2,2,3,10,1,100,'2026-06-20 17:03:12','2026-06-25 03:42:16'),
(87,1,1,6,1,1,3,14,1,100,'2026-06-20 17:03:12','2026-06-25 03:42:16'),
(88,1,1,7,5,8,3,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(89,1,1,8,5,1,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(90,1,1,9,3,4,3,16,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(91,1,1,10,4,1,3,16,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(92,1,1,11,1,4,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(93,1,1,12,3,1,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(94,1,1,17,4,8,3,8,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(95,1,1,19,1,5,2,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(96,1,1,20,3,7,3,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(97,1,1,24,4,5,2,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(98,1,1,25,2,7,3,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(99,1,1,26,3,1,2,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(100,1,1,27,3,5,2,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(101,1,1,28,4,7,2,1,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(102,1,1,29,5,4,2,1,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(103,1,1,30,2,8,3,13,0,100,'2026-06-20 17:03:13','2026-06-21 17:36:04'),
(104,1,1,31,2,1,2,4,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(105,1,1,32,4,1,2,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(106,1,1,33,3,1,2,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(107,1,1,34,4,7,2,4,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(108,1,1,35,3,7,3,16,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(109,1,1,36,5,4,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(110,1,1,37,3,1,2,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(111,1,1,38,5,1,2,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(112,1,1,39,4,5,2,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(113,1,1,40,4,9,2,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(114,1,1,41,2,5,2,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(115,1,1,42,3,3,3,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(116,1,1,43,1,1,2,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(117,1,1,44,1,7,2,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(118,1,1,45,5,1,3,9,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(119,1,1,46,1,9,2,1,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(120,1,1,47,5,1,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(121,1,1,48,1,7,3,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(122,1,1,49,2,3,4,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(123,1,1,50,5,3,4,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(124,1,1,51,3,2,2,16,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(125,1,1,52,3,5,2,16,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(126,1,1,53,1,9,2,4,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(127,1,1,54,4,3,2,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(128,1,1,55,4,1,2,9,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(129,1,1,56,4,7,2,13,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(130,1,1,57,3,4,2,8,0,100,'2026-06-20 17:03:13','2026-06-20 18:03:02'),
(131,1,1,58,3,1,2,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:16'),
(132,1,1,59,3,4,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(133,1,1,60,1,7,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(134,1,1,61,1,1,4,9,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(135,1,1,62,4,7,4,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(136,1,1,63,2,7,3,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(137,1,1,64,1,4,3,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(138,1,1,65,3,4,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(139,1,1,66,4,2,3,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(140,1,1,67,2,7,4,2,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(141,1,1,68,4,7,4,3,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(142,1,1,69,4,4,3,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(143,1,1,70,5,1,3,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(144,1,1,71,1,1,3,15,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(145,1,1,72,2,1,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(146,1,1,73,4,1,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(147,1,1,74,3,7,3,14,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(148,1,1,75,3,3,3,12,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(149,1,1,76,3,7,4,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(150,1,1,77,1,8,3,10,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(151,1,1,78,4,7,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(152,1,1,79,1,3,4,8,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(153,1,1,80,2,7,4,17,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(154,1,1,81,2,6,4,17,0,100,'2026-06-20 17:03:13','2026-06-21 17:47:39'),
(155,1,1,82,2,4,3,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(156,1,1,83,3,3,2,2,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(157,1,1,84,2,1,2,11,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(158,1,1,85,4,4,3,4,1,100,'2026-06-20 17:03:13','2026-06-25 03:42:07'),
(159,1,1,86,2,7,3,18,0,100,'2026-06-20 17:03:13','2026-06-25 03:40:53'),
(160,1,1,87,5,2,3,18,0,100,'2026-06-20 17:03:13','2026-06-25 03:40:53'),
(161,1,1,88,5,4,3,11,0,100,'2026-06-20 17:03:13','2026-06-25 03:40:53'),
(162,1,1,89,3,7,3,8,0,100,'2026-06-20 17:03:13','2026-06-25 03:40:53'),
(163,1,1,90,4,7,3,10,0,100,'2026-06-21 17:02:53','2026-06-25 03:40:53'),
(164,1,1,91,1,9,3,15,0,100,'2026-06-21 17:02:53','2026-06-25 03:40:53'),
(165,1,1,92,2,8,3,12,0,100,'2026-06-21 17:02:53','2026-06-25 03:40:53'),
(166,1,1,93,3,1,3,9,0,100,'2026-06-21 17:02:53','2026-06-25 03:40:53'),
(167,1,1,94,2,5,2,10,1,100,'2026-06-21 17:02:53','2026-06-25 03:42:16'),
(168,1,1,95,2,4,3,14,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(169,1,1,96,3,7,3,12,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(170,1,1,97,1,4,2,18,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(171,1,1,98,5,1,2,15,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(172,1,1,99,2,5,2,16,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(173,1,1,100,4,5,2,16,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(174,1,1,101,1,5,2,9,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(175,1,1,102,4,7,4,15,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(176,1,1,103,5,3,4,15,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(177,1,1,104,1,7,4,9,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(178,1,1,105,1,1,4,11,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(179,1,1,106,5,7,4,13,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(180,1,1,107,1,7,4,11,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(181,1,1,108,4,1,4,14,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(182,1,1,109,2,3,4,8,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(183,1,1,110,2,1,3,12,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(184,1,1,111,3,8,3,10,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(185,1,1,112,1,7,3,8,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(186,1,1,113,1,4,3,12,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(187,1,1,114,1,3,4,13,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(188,1,1,115,5,3,4,10,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(189,1,1,116,4,3,3,10,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(190,1,1,117,3,3,3,8,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(191,1,1,118,3,7,3,9,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(192,1,1,119,2,7,3,13,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(193,1,1,120,5,8,3,11,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(194,1,1,121,4,7,3,8,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(195,1,1,122,2,7,3,11,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(196,1,1,123,4,4,3,11,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(197,1,1,124,2,3,4,9,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(198,1,1,125,4,7,3,14,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(199,1,1,126,4,1,3,13,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(200,1,1,127,5,3,3,13,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(201,1,1,128,3,1,4,15,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:25'),
(202,1,1,129,2,7,3,14,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(203,1,1,130,1,1,2,18,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(204,1,1,131,1,8,2,18,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(205,1,1,132,1,4,3,10,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(206,1,1,133,4,1,3,12,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(207,1,1,134,3,3,2,10,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(208,1,1,135,2,1,2,9,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(209,1,1,136,1,7,3,13,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(210,1,1,137,5,1,2,13,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(211,1,1,138,4,5,2,15,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(212,1,1,139,3,7,4,17,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:07'),
(213,1,1,140,3,7,3,13,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(214,1,1,141,1,1,3,12,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:07'),
(215,1,1,142,3,1,3,14,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(216,1,1,143,5,4,3,9,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(217,1,1,144,2,7,3,9,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(218,1,1,145,4,1,2,8,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(219,1,1,146,1,1,2,8,1,100,'2026-06-23 08:58:34','2026-06-25 03:42:16'),
(220,1,1,147,5,5,3,8,0,100,'2026-06-23 08:58:34','2026-06-25 00:40:52'),
(221,1,1,148,5,8,3,15,0,100,'2026-06-23 08:58:34','2026-06-25 00:40:52'),
(222,1,1,149,2,1,2,13,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(223,1,1,150,2,1,2,9,0,100,'2026-06-23 08:58:34','2026-06-23 22:19:48'),
(224,1,1,151,3,2,3,6,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(225,1,1,152,5,4,3,4,0,100,'2026-06-23 08:58:34','2026-06-25 03:40:53'),
(226,1,1,153,2,7,3,15,1,100,'2026-06-24 22:55:18','2026-06-25 03:42:16'),
(227,1,1,155,5,4,3,12,1,100,'2026-06-24 22:55:18','2026-06-25 03:42:16'),
(228,1,1,156,2,1,2,8,1,100,'2026-06-24 22:55:18','2026-06-25 03:42:16'),
(229,1,1,157,2,4,3,12,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(230,1,1,158,3,5,2,15,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(231,1,1,159,4,9,2,9,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(232,1,1,160,1,1,3,10,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(233,1,1,161,4,3,2,6,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(234,1,1,162,2,5,2,1,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(235,1,1,163,2,10,2,15,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(236,1,1,165,4,4,3,13,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(237,1,1,166,5,1,2,8,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(238,1,1,167,4,7,2,9,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(239,1,1,168,2,3,2,13,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53'),
(240,1,1,169,2,1,2,15,0,100,'2026-06-24 22:55:18','2026-06-25 03:40:53');
/*!40000 ALTER TABLE `fetnet_timetable_slot` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `institution_faculty`
--

DROP TABLE IF EXISTS `institution_faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution_faculty` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `name_eng` varchar(100) DEFAULT NULL,
  `university_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `institution_faculty_university_id_foreign` (`university_id`),
  CONSTRAINT `institution_faculty_university_id_foreign` FOREIGN KEY (`university_id`) REFERENCES `institution_university` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institution_faculty`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `institution_faculty` WRITE;
/*!40000 ALTER TABLE `institution_faculty` DISABLE KEYS */;
INSERT INTO `institution_faculty` VALUES
(1,'FPTI','Fakultas Pendidikan Teknik dan Industri','Fakultas Pendidikan Teknik dan Industri',1,'2026-06-12 06:08:19','2026-06-12 06:08:19');
/*!40000 ALTER TABLE `institution_faculty` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `institution_program`
--

DROP TABLE IF EXISTS `institution_program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution_program` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  `abbrev` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `institution_program_client_id_foreign` (`client_id`),
  KEY `institution_program_user_id_foreign` (`user_id`),
  CONSTRAINT `institution_program_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE SET NULL,
  CONSTRAINT `institution_program_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institution_program`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `institution_program` WRITE;
/*!40000 ALTER TABLE `institution_program` DISABLE KEYS */;
INSERT INTO `institution_program` VALUES
(1,1,3,'E505','TE','Teknik Elektro',NULL,'2026-06-12 06:09:59','2026-06-12 06:09:59'),
(2,1,4,'E045','PTE','Pendidkan Teknik Elektro',NULL,'2026-06-12 06:11:09','2026-06-12 06:11:09'),
(3,1,5,'E515','PTOIR','Pendidikan Teknik Otomasi dan Robotika',NULL,'2026-06-12 06:11:49','2026-06-12 06:11:49'),
(4,1,6,'E187','TET','Teknik Energi Terbarukan',NULL,'2026-06-12 06:13:01','2026-06-12 06:13:01');
/*!40000 ALTER TABLE `institution_program` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `institution_university`
--

DROP TABLE IF EXISTS `institution_university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution_university` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `name_eng` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institution_university`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `institution_university` WRITE;
/*!40000 ALTER TABLE `institution_university` DISABLE KEYS */;
INSERT INTO `institution_university` VALUES
(1,'UPI','Universitas Pendidikan Indonesia','Universitas Pendidikan Indonesia','2026-06-12 06:07:50','2026-06-12 06:07:50');
/*!40000 ALTER TABLE `institution_university` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2026_01_18_142244_create_permission_tables',1),
(5,'2026_02_26_044203_table_client',1),
(6,'2026_03_05_035710_create_table_bems_profiles',1),
(7,'2026_03_22_000001_create_institution_university_table',1),
(8,'2026_03_22_000002_create_institution_faculty_table',1),
(9,'2026_03_22_000003_create_fetnet_client_level_table',1),
(10,'2026_03_22_000004_create_fetnet_client_table',1),
(11,'2026_03_22_000005_create_fetnet_cluster_base_table',1),
(12,'2026_03_22_000006_create_fetnet_client_config_table',1),
(13,'2026_03_22_000007_create_institution_program_table',1),
(14,'2026_03_22_000008_create_fetnet_cluster_table',1),
(15,'2026_03_22_000009_create_fetnet_academic_year_table',1),
(16,'2026_03_22_000010_create_fetnet_semester_table',1),
(17,'2026_03_25_000010_create_fetnet_specialization_table',1),
(18,'2026_03_25_000011_create_fetnet_subject_type_table',1),
(19,'2026_03_25_000011a_create_fetnet_curriculum_year_table',1),
(20,'2026_03_25_000012_create_fetnet_subject_table',1),
(21,'2026_03_25_000013_create_fetnet_teacher_table',1),
(22,'2026_03_25_000014_create_fetnet_student_table',1),
(23,'2026_03_25_000015_create_fetnet_activity_type_table',1),
(24,'2026_03_25_000016_create_fetnet_activity_table',1),
(25,'2026_03_25_000017_create_fetnet_activity_teacher_table',1),
(26,'2026_03_25_000018_create_fetnet_activity_student_table',1),
(27,'2026_03_25_070818_create_fetnet_sub_activity_table',1),
(28,'2026_03_25_091000_create_fetnet_teacher_guest_table',1),
(29,'2026_03_25_100000_create_fetnet_time_constraint_teacher_table',1),
(30,'2026_03_25_101a00_create_fetnet_activity_tag_table',1),
(31,'2026_03_25_102000_create_fetnet_teacher_constraint_table',1),
(32,'2026_03_25_104000_create_fetnet_activity_tag_map_table',1),
(33,'2026_03_25_220000_create_fetnet_activity_planning',1),
(34,'2026_03_27_100000_create_fetnet_student_constraint_tables',1),
(35,'2026_03_27_101000_create_fetnet_activity_time_constraint_table',1),
(36,'2026_03_27_200000_create_fetnet_building_table',1),
(37,'2026_03_27_210000_create_fetnet_space_type_table',1),
(38,'2026_03_27_210001_create_fetnet_space_table',1),
(39,'2026_03_27_220000_create_fetnet_space_claim_table',1),
(40,'2026_03_28_100000_create_fetnet_activity_space_table',1),
(41,'2026_03_29_000001_add_relations_to_users_table',1),
(42,'2026_05_15_110000_create_fetnet_fet_compile_table',1),
(43,'2026_05_17_140000_create_fetnet_timetable_slot_table',1),
(44,'2026_06_19_222754_add_indexes_to_fetnet_space_table',2),
(45,'2026_06_21_002450_add_duration_to_fetnet_timetable_slot_table',3);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES
(1,'App\\Models\\User',1),
(2,'App\\Models\\User',2),
(3,'App\\Models\\User',3),
(3,'App\\Models\\User',4),
(3,'App\\Models\\User',5),
(3,'App\\Models\\User',6);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'super-admin','web','2026-06-12 06:01:23','2026-06-12 06:01:23'),
(2,'client','web','2026-06-12 06:01:23','2026-06-12 06:01:23'),
(3,'program','web','2026-06-12 06:01:23','2026-06-12 06:01:23'),
(4,'operator','web','2026-06-12 06:01:23','2026-06-12 06:01:23');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('61d2Ha49zq1TwCPHA1QNoMEX7BAVtHkkg3FRWsNW',2,'10.89.1.6','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','ZXlKcGRpSTZJbkpSVFhSb2N5OTJZVWR3TkVaUmVWWkdXVWQwUVZFOVBTSXNJblpoYkhWbElqb2lPSEF2ZGtJell6Vk5OVU5PU1ZWUlRrbzJZMFYzTWpBMmVGZ3lSMjVVYlZJMGFVbDFRek5USzJwNlN5OTBNMFpwWVhKaFFtRjJTbEpaYnpaQk9HaFNRUzlwYkUxaFNsUnZWbWQyTkZvd1UzRjVXaXQwU2tsNWNHSnFUVmxaVlV0VGN6VklTMDlNWkdoTmJXdDRLMlpJYzJjM2JHTXZWbTFhU210eVlYRTBhVnBtTHpCbVZGVkdNa0p3WkRsWFdHWjFMMjAwYXpWbGVHcGxiWFZoTTNWWFVuZDBlR3d3TnpkRFV6TnBUMEUyTDJKM00wZHlNM28yV0d3MU5DdHVhVGRUUTJ4Uk9VZHJaazg1YzI1RFdIbEliekZMTTBwVmVHSjVibll2VHpsSFJpODNSbGN6VTJGME0yaERTalJHVUU5bmVHaFBNVXBIYUhFeFprMXhVMWRGVDB4cFN6RkllWEZUU3poUE5UVkJNRU5CVVhaWGJqQm9XSFZJTld4NU1VSnNOa0pQUW1sV1VGSjJSVEpIY1M5TlVreFlhbGcyVTI1ckwxcDBaa3huVDNCVU9UVnlLemNyUlZSdmFYaGxaVmwwY0VOT2FHSTVkMWRqUVdKbFFucHVNV2gwVUVvNVNWTm1ka3hJU1ZKTVJGUklRMVpSU2s5SU0yeHlSMWN2YTB4b1JHcG5TbTlSZFRJMmNWRkJkVUZXTVRGbWRsRlpSVXA0VmpKVkwwRnVaazFaZG1kdVozSlpZbkZKYm5kNmNGQkpVRE4wWTFsbFVXMU5WMWhGY0haM1pVUm5jRVZNZUhGSFprSkJkM0p5YTI5U1p5OUJRbmxRYkc0M1QzSjVOM3BKY0Rkc1ZXcEplVGxxWVcxdFJYcFdORGhNVFhKUVVUUlRZbWhJYUhBemVFbG9PVXBUUVdnM1RFWlpTMGcwU2xWelFuVmpVRUZKT0ZRNVZsSm9ZbXRZVkU5M1pXNUdVVU5aYVRKeVJUVkhjSGhSYkRCT1kyd3lMMEp2Um1sWWVHVTViRkExZGpOb1dERnhaWE5HT0ZkT2N6VTFkM3BzUldWS2FFMDFjbFZXU2pObFlWSjBMMnRpTkZSNWRUaHhTVFZvY0Zkc1FWbExSalZpVld4RVExUkVTbkZyZVUxdVdtOVhVU3N3YWtGb1dVaFJja3Q2TWxkV09VUXZaVlJ3ZGt4eFUxaGFla2d3SzBoS2RWbFdiR05wU0N0S1JDdEdhbkJaT0dWRlExUXhZalFpTENKdFlXTWlPaUl6TlRWaE16SXpPR1EzTkdNMll6RmhNVEEwTkRSaE1EUTNaVE16TldOa1lqRTJOV0ZtTURNNU5HUTFZalV6WVRJNVl6bGxaR1V4WTJFMVpXWmhOVEZsSWl3aWRHRm5Jam9pSW4wPQ==',1782358946),
('uzDMw0SXholfQe7eNZBXtISaUG53GO19EAVispu2',5,'10.89.1.6','Mozilla/5.0 (X11; Linux x86_64; rv:152.0) Gecko/20100101 Firefox/152.0','ZXlKcGRpSTZJbTQwU2tKd1RVTjFhbmR1ZEZwUVNIWXZRVnBSVEVFOVBTSXNJblpoYkhWbElqb2liM00xUms1UVNFRlJiVE14VW1RemJGSTViazVIVVVFM0sxUjRXazlwU0dWUlZrMDJhQ3M0YWtZM1ozVjNkVk50ZGtkSU9VTkZLMkk0TWtKV1NUQnJLMFZpTWtjeVYzbzJhRGw1VFhGb09XZ3ZkblJHYTI1SVdHRnNLMWg0U2tSbU5ITm1WR1ZSWlU1blZqUTNlazFUUzJSR1JDOUxWRFY1YkdacmVXeFZiVWhFVEdWaGFHbERWRFYzTWxGVVZtVlZhVEZsYzFwdmFHMXVMMVJrUWtsT2MyRkVXR1Z1WjNGV2VXbEJhUzlYY2t4SU5YSnBXV2xpUjJKTE0yeHBaMEpHZERaNVJFSk9TVFEwVUhoeU0yUXlZV05CY1RaT1pXazBiRXQxTTBSdVRqRkdRbmhEZGxsSGRUZFFMMnR4VW13MWQzRjZUQ3RvYkRSaVltUnhiRnBUT1RCYVRFTmpaRVJpZUhCb2VucHdZbVJ4UzNoSmMzbGpNbGtyU2tzMU9DdE9hM2N6SzB0RFJUVmhPVWRDTDIxWkwyNHdlbXhNUVN0YVUzVmpOV1JNTmpGVEsyNXBVR0ZEWWsxdlMyZDRZakpOV25GSmJIVldhbE5wUkVkU1ZtMXJOMFJtV0hWNlMxRkpNazU1Vlc1MVJXdHZjWGNyVERSdGRqaFZRbEJZUVhCdmIxQklkbWhHVFdwVmRWTlhTRzFqYTA1elZUY3dVa3cwVlZSRVRESlpjVkptTjFGcFNsSnFURE56UldWbFNETk9hMGR5Y21KcFYwcHNjWHB0WTFGWFJXTXpWV0pIY0ZaNk5EWlVhVlJ0VGpsdlUyOURVRFpoVm1ReFpqQklhalpRT0hod1VqSlBiVlJITlRoTFVEaHdhV2w2UkV0alZsWmFTbWhKYW05RFJFTTJkME52UWs1bWFqSndhbWxCYTBvek9HZGpTMUJCUFQwaUxDSnRZV01pT2lKak1UUTJPRFkyTkdFMlpHTXpPRE00T1dOak16WTRPVGM1WVRWbVlqQTJNVE01TkdRMU5qYzRNalpsWTJJeFl6VmpPVFV4WmpJeVpEWTBNRFl6TVRRMUlpd2lkR0ZuSWpvaUluMD0=',1782358803);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `sso` varchar(255) DEFAULT NULL,
  `client_id` bigint(20) unsigned DEFAULT NULL,
  `program_id` bigint(20) unsigned DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_sso_unique` (`sso`),
  KEY `users_client_id_foreign` (`client_id`),
  KEY `users_program_id_foreign` (`program_id`),
  CONSTRAINT `users_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `fetnet_client` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_program_id_foreign` FOREIGN KEY (`program_id`) REFERENCES `institution_program` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Dedi Wahyudi','deewahyu@upi.edu',NULL,'$2y$12$MdF9/QQuNKAVGk.Ha5PRI.o/r44nuvuSF0KChWrf5wusUla/jaRIC','197608272009121001',NULL,NULL,NULL,'2026-06-12 06:01:24','2026-06-12 06:01:24'),
(2,'fte','fte@upi.edu',NULL,'$2y$12$wlXbC6bOzgHXvTAp2dZr3.bvi6yLno2z4.8fAY5B6JksNKKtU9d5y',NULL,1,NULL,NULL,'2026-06-12 06:09:20','2026-06-12 06:09:20'),
(3,'TE','te@upi.edu',NULL,'$2y$12$tIjaM4KwjPW.BXUK23PoaeDf1WVo/EVhnYUI/xbcEcfFrChAe6DKK',NULL,NULL,NULL,NULL,'2026-06-12 06:09:59','2026-06-12 06:09:59'),
(4,'PTE','pte@upi.edu',NULL,'$2y$12$jheXwcqBcgaENhSZmfDReusy1GTZGoT8ipPB63xQZDbRWbsPSL3ra',NULL,NULL,NULL,NULL,'2026-06-12 06:11:09','2026-06-12 06:11:09'),
(5,'PTOIR','ptoir@upi.edu',NULL,'$2y$12$iamAnISHH58/cg90y.wurugV4Dtzey5CYWc/GjdwUEDT9VK7j8fqy',NULL,NULL,NULL,NULL,'2026-06-12 06:11:49','2026-06-12 06:11:49'),
(6,'TET','tet@upi.edu',NULL,'$2y$12$Ia2sysa3NkHGBUd1NMTKlO0XbGtemZHSo0.9obUa/PZSNyCZa/QOe',NULL,NULL,NULL,NULL,'2026-06-12 06:13:01','2026-06-12 06:13:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping events for database 'fetnet'
--

--
-- Dumping routines for database 'fetnet'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-06-25  4:14:01
