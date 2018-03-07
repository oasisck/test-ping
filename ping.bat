@echo off
::==============================================================================
::            FILE: ping.bat
::         VERSION: 1.3
::           USAGE: Lancer ping.bat autant de fois qu'il y a d'équipement à
::                  tester, des logs vont se créer à la racine du script
::     DESCRIPTION: Permet de tester le réseau d'un client en pinguant depuis le
::                  serveur vers les postes clients, vers les équipements
::                  réseaux, vers internet
::         OPTIONS: -
::    REQUIREMENTS: -
::            BUGS: Parfois la fenêtre n'affiche pas les commentaires mais le
::                  script tourne
::           NOTES: Fonctionne avec ping.exe en anglais ou en français. A
::                  savoir, dans la version française du ping.exe, l'affichage
::                  du résultat est différent quand ms est supérieur ou égal à 1
::          AUTHOR: KERBASTARD Clément
::         COMPANY: OPTI-IT
::         CREATED: 01/06/17
::        REVISION: 06/03/17
::==============================================================================

:: Déclaration des variables IP et MS, à saisir à l'exécution du script
set /p IP="Saisir une IP : "
set /p MS="Valeur de test (en ms) : "

:: Déclaration des variables
set LOG="log_%COMPUTERNAME%_%IP%.txt"
set HEURE=%time:~,8%
set JOUR=%date%
set CHECK=1800

cls

:: Bloque de commentaire dans un fichier log et affichage à l'écran
(echo Test Ping en cours
echo Commencer le %JOUR%, %HEURE%
echo De %COMPUTERNAME% vers %IP%
echo Valeur de test : %MS%ms
echo.
echo ===============================
echo = NE PAS FERMER CETTE FENETRE =
echo ===============================
echo.) >> %LOG% | type %LOG%

:: Boucle relancer x fois (CHECK) permettant de logguer une ligne
:: Si le script s'arrète, cela permet de savoir quand
:loop
set /a i=0
echo "====== %JOUR% %HEURE% ======" >> %LOG%

:: Commande ping avec 1 paquet et 1000ms (1s) d'attente
:: Si délai dépassé ou hôte introuvable alors "Ne repond pas" dans le log
:: Si dans le délai mais le résultat supérieur ou égal à la valeur de test en ms
:: alors log.
:: La mini-boucle se relance toutes les secondes
:miniloop
set /a i=i+1
set HEURE=%time:~,8%
set JOUR=%date%

for /f "tokens=1,8 delims=m=^< " %%a in ('ping.exe -w 1000 -n 1 %IP% ^| findstr "TTL" ^|^| echo "Ne repond Pas"') do (
 if "%%b" == "" (
  echo "%HEURE% Ne repond pas" >> %LOG%
 ) ELSE (
  if %%b GEQ %MS% (
   echo "%HEURE% ms=%%b" >> %LOG%
  )
 )
timeout /t 1 > NUL
if %i%==%CHECK% goto loop
)
goto miniloop
