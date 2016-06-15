# TP - PaaS - Azure App Service

Avec ces didacticiels, vous allez apprendre à utiliser le Portail Azure et Powershell pour :

## Prérequis
* Disposer d'un abonnement Azure
* Etre connecter au [portail azure](https://portal.azure.com/)
* Disposer des cmdlets [Powershell pour Azure](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
* Avoir effectuer le TP [Azure SQL Database](https://github.com/MaximeLaunay/AzureAssets/blob/dev/Cours/AzureSQLDatabase/readme.md)

## Paramètres générales à utiliser
* Si aucune valeur n'est précisée, utiliser les valeurs par défaut proposées par le portail ou dans les scripts Powershell
* Passer le portail en version Anglaise
* Avoir effectuer le TP Azure SQL Database

## Les tutoriaux à effectuer
### Créer une application Web + SQL (tuto from [Azure Documentations]( https://azure.microsoft.com/en-us/documentation/articles/web-sites-php-mysql-deploy-use-ftp/))
En suivant ce didacticiel, vous allez générer une application web d’inscription simple dans PHP. Cette application sera hébergée dans une application web. Voici une capture d'écran de l'application terminée :
![Azure PHP Web Site](./media/running_app_3.png)
* Connectez-vous au portail Azure
* Cliquez sur l’icône **+ New** dans le coin supérieur gauche du portail Azure.
* Dans la recherche, tapez Application web + MySQL, puis cliquez sur Application web + SQL
* Cliquez sur **Create**
* Click on each part (Resource Group, Web App, Database, and Subscription) and enter or select values for the required fields:
    * Enter a URL name of your choice
    * Configure database server credentials
    * Select the region closest to you
* When finished defining the web app, click Create.

    When the web app has been created, the Notifications button will flash a green SUCCESS and the resource group blade open to show both the web app and the SQL database in the group.

* Click the web app's icon in the resource group blade to open the web app's blade.
### Déployer une application Web avec FTP
