Clementine Framework Devtools
=============================

Structure attendue pour le dossier de dev de Clementine (contenant repository, devtools, installeur, arborescence, modules share...) :

```/devtools``` : contient les scripts de developpement

```/modules/*``` : chaque dossier module contient 2 dossiers : ```trunk``` pour la branche de dev, et ```repository/scripts``` pour les scripts d'upgrades et informations sur les dépendances du module. 

```/www/install``` : branche de dev de l'installeur

```/www/trunk``` : branche de dev de la structure du framework

```/releases``` : rempli automatiquement par le script ```/devtools/create_release.sh```. Il contient un zip de la dernière release du framework.

```/repository``` : rempli automatiquement par le script ```/devtools/update_repository.sh```
