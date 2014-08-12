Installation
===

Copier coller cette ligne dans un terminal.

```bash
curl -sS https://raw.githubusercontent.com/pa-de-solminihac/clementine-framework-devtools/master/init_devroot.sh -o init_devroot.sh && chmod u+x init_devroot.sh && ./init_devroot.sh
```

Le script va créer l'arborescence nécessaire dans un dossier __clementine__ et y installer les outils nécessaires à la gestion de votre propre dépôt.

__Note__
Il est conseillé d'installer GNU parallel pour que le script puisse lancer les téléchargements en parallèle.

Explications sur l'arborescence
===

Structure attendue pour le dossier de dev de Clementine (contenant repository, devtools, installeur, arborescence, modules share...) :

```/devtools``` : contient les scripts de developpement

```/modules/*``` : chaque dossier module contient 2 dossiers : ```trunk``` pour la branche de dev, et ```repository/scripts``` pour les scripts d'upgrades et informations sur les dépendances du module. 

```/www/install``` : branche de dev de l'installeur

```/www/trunk``` : branche de dev de la structure du framework

```/releases``` : rempli automatiquement par le script ```/devtools/create_release.sh```. Il contient un zip de la dernière release du framework.

```/repository``` : rempli automatiquement par le script ```/devtools/update_repository.sh```


Publication d'une nouvelle version d'un module
===

Pour publier une nouvelle version du module ```users```, dont les sources sont dans le dossier ```/modules/users/trunk``` :

* préciser le numéro de version de la nouvelle version ```N.m``` dans ```etc/module.ini```. (TODO: comment choisir un numéro de version ? ```N``` et ```m``` sont des entiers)
* si la nouvelle version nécessite d'exécuter un script d'upgrade, il faut le créer dans ```/modules/users/repository/scripts/N.m/upgrade.php``` (où ```N.m``` est le numéro de version)
* aller dans le dossier devtools : ```cd ../../../devtools/```
* créer la nouvelle version : ```./create_package.sh users N.m``` (où ```N.m``` est le numéro de version)
* c'est presque fini, il suffit de suivre les indications...
