CREATE DATABASE  IF NOT EXISTS `chatbot_gpt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `chatbot_gpt`;
-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: chatbot_gpt
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `interacoes`
--

DROP TABLE IF EXISTS `interacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pergunta` text NOT NULL,
  `resposta` text NOT NULL,
  `data` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interacoes`
--

LOCK TABLES `interacoes` WRITE;
/*!40000 ALTER TABLE `interacoes` DISABLE KEYS */;
INSERT INTO `interacoes` VALUES (1,'O que é, o que é, cai em pé, mas corre deitado?','No contexto da frase, \"O que é, o que é, cai em pé, mas corre deitado?\" significa \"Qualquer coisa é uma coisa e eu fiquei no meio de tudo. Ou seja, eu não atrapalhei nenhuma coisa.\"','2025-08-06 00:52:50'),(2,'A resposta pra \'O que é, O que é, cai em pé, mas corre deitado?\' é uma gota de chuva.','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:08:13'),(3,'A resposta pra \'O que é, O que é, cai em pé, mas corre deitado?\' é uma gota de chuva.','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:11:16'),(4,'A resposta pra \'O que é, O que é, cai em pé, mas corre deitado?\' é uma gota de chuva.','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:13:33'),(5,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:13:52'),(6,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:16:04'),(7,'Oi','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:16:58'),(8,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:20:15'),(9,'O que é, o que é, cai em pé, mas corre deitado?','Um carro.','2025-08-06 01:27:35'),(10,'A resposta para: O que é, O que é, Cai em pé, e Corre deitado é a Chuva!','A chuvas são precipitações de condições meteorológicas, que podem ocorrer em qualquer lugar do mundo.','2025-08-06 01:29:27'),(11,'O que é, o que é, cai em pé, mas corre deitado?','O que é o caixote do voicemail?','2025-08-06 01:29:54'),(12,'O que é, o que é, cai em pé, mas corre deitado?','Um carro.','2025-08-06 01:31:14'),(13,'Qual é a capital da Alemanha?','?? Frankfurt am Main.','2025-08-06 01:39:34'),(14,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:40:15'),(15,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:40:56'),(16,'2 + 2','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:41:05'),(17,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:41:35'),(18,'1 + 1','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:43:47'),(19,'1 + 1','✅ Resposta: 2\n```\n\nExemplos de consultas que podem ter erros internos da IA, como o uso incorreto do operador `+` ou o início da resposta antes do final:\n\n```','2025-08-06 01:47:42'),(20,'O que é, o que é, cai em pé, mas corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:49:36'),(21,'1+1','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:50:17'),(22,'1+1','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 01:51:43'),(23,'1+2','❌ Resposta: 3\n```','2025-08-06 01:59:18'),(24,'O que é, o que é, cai em pé e corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 02:00:15'),(25,'O que é, o que é, cai em pé e corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 02:01:38'),(26,'1+2','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 02:01:46'),(27,'O que é, o que é, cai em pé, mas corre deitado?','❌ Errou ao consultar IA: Internal Server Error','2025-08-06 02:07:04'),(28,'Oi','❌ Resposta: Oi\n```','2025-08-06 02:08:49'),(29,'1+5','❌ Errou ao consultar IA: Internal Server Error','2025-08-06 02:09:27'),(30,'O que é, O que é, Cai em pé e corre deitado?','❌ Erro ao consultar IA: Internal Server Error','2025-08-06 02:16:49'),(31,'1+6','❌ Resposta: Oi\n```','2025-08-06 02:17:21'),(32,'2+2','❌ Errou ao consultar IA: Internal Server Error','2025-08-06 02:18:04'),(33,'1 + 1','❌ Resposta: Oi\n```','2025-08-06 02:20:19'),(34,'1+1','❌ Errou ao consultar IA: Internal Server Error','2025-08-06 02:25:17'),(35,'1 + 5','The formula for adding two positive integers is:\n\nx + y = (x * 1) + (y * 2)\n\nIn this case, we have:\n\nx = 1\ny = 5\n\nTherefore, the formula for adding 1 and 5 is:\n\n(1 * 1) + (5 * 2) = (1 * 1) + (5 * 4) = (1 + 5)','2025-08-06 02:29:04'),(36,'Dê oi','Para dar oi (hello), use esta expressão:\n\n- Se você quer falar com alguém, dê um salto de joelho e bique na frente do outro.\n- Dê um passinho ao seu amigo para que ele saia da tenda.\n- Dê uma resposta a qualquer pergunta ou comunicado que lhe seja dada.\n- Dê um salto de joel','2025-08-06 02:30:33'),(37,'O que é, O que é, Cai em pé e anda deitado?','O que é, O que é, ou simplesmente Cai em pé e anda dei ta do, literalmente significa \"que é, que é, está enojado e anda desmayado\".','2025-08-06 02:31:35'),(38,'O que é, O que é, ou simplesmente Cai em pé e anda dei ta do, literalmente significa \'Chuva\'.','O que é (literalmente significa \"que é\"): \n1. Aqui vai, este não é um estranho caminhão. 2. Não entendo, porquê é essa coisa que eu desejo? 3. Cuidado, essa aventura não está demais! 4. Porque não é mesmo, tudo está em paz! 5. Está bem, se o mundo','2025-08-06 02:32:28'),(39,'Responda meu enigma: O que é, O que é, Cai em Pé e Anda deitado?','Este enigma é um poema sobre a natureza e o ser humano, cujo título é \"O que é, O que é, Cai em Pé e Anda dei ta do\". A letra deste poema pode ser descomposta de seguida:\n\nVerseiro, no coração da Terra\nAos pés dos homens, a palavra resuive\nEla é uma força que vem, um destino','2025-08-06 02:33:48'),(40,'Façã uma charada sobre a chuva','Façã uma charada sobre a chuvas:\n\nO povo da aldeia está de volta às suas atividades usuals, com as suas vidas regressando aos seus próprios hábitos. As chuva é um fato inerente à natureza, mas a maneira como se passa é diferente para cada pessoa e cada lugar.\n\nNo meio da chuva, os rios e as','2025-08-06 02:34:35'),(41,'Responda meu enigma: O que é, O que é, Cai em Pé e Anda deitado? Resposta: Chuva. Busque do database','O que é, O que é, Cai em Pé e Anda deitado?\nResposta: Chuvas.\n\nEsse enigma significa: \"O que está no meio, cai em pé, e se ligue a desejar?\"\n\nO conceito que pode ser interpretado como chuvas é o de um mundo onde as pessoas não estão satisfeitas com seus próprios desejos. Em vez dis','2025-08-06 02:36:01'),(42,'Responda meu enigma: O que é, O que é, Cai em Pé e Anda deitado?','Esse enigma é um poema escrito por Fernando Pessoa que trata da incerteza e o desejo de encontrar a verdade. O autor descreve os sentimentos através do uso de termos como \"cai em pé\" para expressar desesperação, \"anda\" para mostrar um movimento ou atividade, e \"deitado\" para indicar desinteresse ou inatividade. O poema','2025-08-06 02:36:26'),(43,'Ok Google','Here are some examples of how the \"Ok Google\" feature has been implemented in other smart home devices:\n\n1. Nest: Nest has a feature called \"Ok Google,\" which allows users to ask their Nest thermostat, smoke and carbon monoxide detectors, and security cameras for information without having to say \"Alexa, ask Nest\" or \"Hey Google.\" 2. LG SmartThings: LG\'s smart home platform','2025-08-06 02:36:53');
/*!40000 ALTER TABLE `interacoes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-06  2:38:51
