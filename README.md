# API Engagement - Cas d'usage

Ce repository est une réponse au cas d'usage présenté ici :
https://jeveuxaider.notion.site/Developpeur-Senior-Full-Stack-Cas-Pratique-Exercice-Technique-API-Engagement-18c72a322d508013bcf3c3d1e1a6e7b1

## Réponse aux questions

### Comment t’y prends-tu pour comprendre l’ampleur du problème ?

- Interviews des personnes qui bossent sur le projet pour affiner la compréhension des problèmes

  - Quels sont les problèmes rencontrés, classés par ordre d'importance ?
  - Les problèmes sont-ils techniques (eg. perf) ou de maintenance (difficulté à maintenir, à trouver les bons setups, ...)
  - Questions sur ElasticSearch :
    - Quelle est la typologie des difficultés rencontrées ? Setup, perf, ...
  - Questions sur MongoDB :
    - Est-ce que ce sont des problèmes de perf en général ou sur certaines requêtes / collections en particulier ? Si oui lesquelles ?
  - Questions sur PostgreSQL :
    - Pourquoi ne pas avoir utiliser directement MongoDB et ElasticSearch comme data sources de metabase ?

- Analyse des problèmes MongoDB
  - Analyse avec les outils de profiling ex. `db.setProfilingLevel(2)`, `db.system.profile.find()`, `explain()`, ...
  - Vérification des indexes
    - Sur les requêtes problématiques, quels sont les indexes utilisés, est-ce que ce sont les bons, ...
  - Vérification du dimensionnement de l'infra

### Donnez ton avis sur cette architecture en citant les avantages et les inconvénients.

De prime abord, il me semble que la séparation des datas sur 3 bases est une optimisation prématurée, non nécessaire, et qui apporte plus de problèmes que de solutions.

#### Avantages de l'architecture actuelle

- Capacité de scaler sur des gros volumes de datas grâce aux capacités de MongoDB et ElasticSearch

#### Désavantages de l'architecture actuelle

- Complexité inhérente au setup : 3 DBs avec chacune leurs spécificités, mécanismes, langages, ... Ce qui entraîne une multiplication des points de faiblesse potentiels, une duplication des optimisations à setup, etc...
- Complexité au niveau de la synchro des bases, besoin de maintenir des scripts de mapping avec des points de failure potentiels (eg. pas le bon type de data, ...)

### Quelle architecture mets-tu en place ?

Je propose de rationnaliser l'archi en gérant tout (api & stats) dans une seule base PostgreSQL.

Je ne pense pas qu'il y ait de réel avantage à utiliser MongoDB et Elasticsearch. C'est une forte complexité supplémentaire qui n'est pas justifiée par les contraintes du projet :

- Schéma des données : le schéma semble assez stable, peu d'intérêt à utiliser une base NoSQL orientée document (MongoDB)
- Volume des données : en première approximation le volume des données semble relativement faible, même pour les statistiques (on n'est pas sur un domaine où il y a des millions d'impressions quotidiennes). Donc peu d'intérêt à utiliser une techno de type Elasticsearch ici. On pourrait éventuellement utiliser une base de données orientée colonne, optimisée pour ce type d'usage tout en étant questionnable en SQL, mais je ne pense pas que le volume de données le justifie.
- Recherche dans les données de stats : les capacités d'ElasticSearch ne sont pas utilisées, puisqu'il y a un export vers PostgreSQL. Pas d'intérêt particulier à utiliser ElasticSearch ici.
- Recherche géospatial : cela pourrait être un argument pour utiliser MongoDB, mais cela est aussi supportée par PostgreSQL avec PostGIS

### Décris les étapes de ton plan de migration

- Mise en place d'une nouvelle instance PostgreSQL qui sera la future instance de prod, contenant la dernière copie des data
- Modification du code pour écrire en // dans MongoDB/ElasticSearch (ce qui est fait actuellement) et dans la nouvelle instance PostgreSQL directement
- Vérification que les 2 bases PostgreSQL sont équivalentes : l'ajout au fil de l'eau devrait donner le même résultat que l'export nightly
- Switch Metabase vers la nouvelle base
- Décommissionnement de l'export nightly et d'ElasticSearch
- Modification du code pour lire depuis PostgreSQL plutôt que MongoDB. On loggue un warning s'il y a des diffs de data.
- Si pas de log pendant un temps donné, on switch la lecture des données totalement sur PostgreSQL
- Décommissionnement de MongoDB
