Installation
===

Copier coller la ligne suivante dans un terminal :

```bash
curl -sS https://raw.githubusercontent.com/pa-de-solminihac/clementine-framework-devtools/master/init_devroot.sh -o init_devroot.sh && chmod u+x init_devroot.sh && ./init_devroot.sh
```

Le script va créer l'arborescence nécessaire dans un dossier __clementine__ et y installer les outils nécessaires à la gestion de votre propre dépôt.

__Performances__ : il est conseillé d'installer [GNU parallel](http://www.gnu.org/software/parallel/) pour que le script puisse lancer les téléchargements en parallèle.

Explications sur l'arborescence
===

Le développement du framework Clémentine est organisé selon une arborescence précise : 

```/repository``` : c'est le repository utilisé par l'installeur des projets Clémentine. Il sert à distribuer les modules share. Il est rempli automatiquement par le biais du script ```/devtools/update_repository.sh```

```/modules/*``` : contient les dépots des modules share. Chaque dossier `/modules/`_module_`/` contient 2 sous-dossiers : ```trunk``` pour le dépôt centralisant les développements du module (les releases sont créées parle biais de tags), et ```repository/scripts``` pour le dépôt contenant les scripts d'upgrades ainsi que les informations sur les dépendances du module. 

```/www/install``` : dépôt pour le dévelloppement de l'installeur

```/www/trunk``` : dépôt pour la structure du framework (ie. l'arborescence qu'on créée pour tout nouveau projet Clémentine)

```/devtools``` : contient les outils qu'on utilise lors du développement du framework, par exemple pour publier les packages (nouvelle release d'un module/du framework/de l'installeur, synchronisation du repository, et divers outils pour se faciliter la vie)

Publication d'une nouvelle version d'un module
===

Pour publier une nouvelle version du module ```users```, dont les sources sont dans le dossier ```/modules/users/trunk``` :

* préciser le numéro de version de la nouvelle version ```N.m``` dans ```etc/module.ini```. (TODO: comment choisir un numéro de version ? ```N``` et ```m``` sont des entiers)
* si la nouvelle version nécessite d'exécuter un script d'upgrade, il faut le créer dans ```/modules/users/repository/scripts/N.m/upgrade.php``` (où ```N.m``` est le numéro de version)
* aller dans le dossier devtools : ```cd ../../../devtools/```
* créer la nouvelle version : ```./create_package.sh users N.m``` (où ```N.m``` est le numéro de version)
* c'est presque fini, il suffit de suivre les indications...

