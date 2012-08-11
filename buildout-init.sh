#!/bin/bash

# Colors setup
c_reset=`tput sgr0`
c_set=`tput setaf 2; tput bold`

PROJECT_NAME=$1
if [ -z "$1" ] ; then
	echo "No project name provided\n"
	exit 1 
fi
#PROJECT=${PROJECT_NAME}_project
PROJECT=${PROJECT_NAME}
APP=${PROJECT_NAME}_app

echo "${c_set}#### Building project tree${c_reset}"
mkdir $PROJECT_NAME
cd $PROJECT_NAME
#touch LICENSE
#touch README
wget http://svn.zope.org/*checkout*/zc.buildout/trunk/bootstrap/bootstrap.py
echo "[buildout]" > buildout.cfg
echo "parts=" >> buildout.cfg
mkdir src
mkdir src/$PROJECT
mkdir src/$PROJECT/settings
touch src/$PROJECT/__init__.py
touch src/$PROJECT/settings/base.py
touch src/$PROJECT/settings/__init__.py

echo "${c_set}#### Initial buildout${c_reset}"
python bootstrap.py
./bin/buildout

echo "${c_set}#### Putting data to setup.py${c_reset}"
echo "from setuptools import setup, find_packages
import os

install_requires = [
    'setuptools',
]
data_files = []
root_dir = os.path.dirname(__file__)
if root_dir != '':
    os.chdir(root_dir + '/src')
else:
    os.chdir('./src')
for dirpath, dirnames, filenames in os.walk('.'):
    for i, dirname in enumerate(dirnames):
        if dirname.startswith('.') or dirname in ('build', 'dist'):
            del dirnames[i]
    if not '__init__.py' in filenames and filenames:
        data_files.append([dirpath, [os.path.join(dirpath, f) for f in filenames]])
setup(
    name = \"django-$PROJECT\",
    version = \"1.0\",
    license = 'BSD',
    description = \"Description goes here.\",
    author = 'Piotr Adamowicz',
    packages = find_packages('.'),
    package_dir = {'': '.'},
    data_files = data_files,
    install_requires = install_requires,
    zip_safe = False,
    dependency_links = [],
)" > setup.py

echo "${c_set}#### Inform buildout about egg we are working at.${c_reset}"
echo "[buildout]
parts = python
develop = .
eggs = django-$PROJECT

[python]
recipe = zc.recipe.egg
interpreter = python
eggs = \${buildout:eggs}
" > buildout.cfg
./bin/buildout

echo "${c_set}#### Setup git${c_reset}"
echo "/parts
/.installed.cfg
/develop-eggs
/bin
/eggs
/downloads
/lib
/build
/dist
*.pyc
/src/$PROJECT/*.sqlite
/src/$PROJECT/static_collected
/src/$PROJECT/media/*
/src/dist
/src/build
/.pydevproject
/.project
*.egg-info
.DS_Store
/src/$PROJECT/settings/development.py
.com.apple.timemachine.supported
.idea/
*.komodoproject
*.swp" > .gitignore

echo "${c_set}#### Doing minimal django setup${c_reset}"
echo "DATABASE_ENGINE = 'sqlite3'
DATABASE_NAME = '/tmp/$PROJECT.db'
INSTALLED_APPS = ['$PROJECT']
ROOT_URLCONF = ['$PROJECT.urls']" > src/$PROJECT/settings/base.py
touch src/$PROJECT/models.py

echo "${c_set}#### Preparing django recipe${c_reset}"
echo "[django]
recipe = djangorecipe
project = $PROJECT
projectegg = $PROJECT
settings = settings.base
extra-paths =
    \${buildout:extra-paths}
eggs = \${buildout:eggs}
" >> buildout.cfg

echo "${c_set}#### Reconfiguring buildout.cfg${c_reset}"
sed -e "2s/$/ django/" buildout.cfg > buildout2.cfg
sed -e "4aextra-paths = \${buildout:directory}/develop-eggs" buildout2.cfg > buildout.cfg

rm buildout2.cfg
echo "${c_set}#### Making buildout for django${c_reset}"
./bin/buildout

echo "${c_set}#### Installing project and app${c_reset}"
cd src
../bin/django startproject ${PROJECT}_project
../bin/django startapp ${APP}

mv ${PROJECT}_project ${PROJECT}_temp2
mv ${PROJECT}_temp2/* .
rm -rf ${PROJECT}_temp2
#mv ${PROJECT} ${PROJECT}_init
#mv ${PROJECT}_project ${PROJECT}
rm -rf ${PROJECT}
cd ${PROJECT}_project
mkdir settings
touch settings/__init__.py
mv settings.py settings/base.py
cd ../..

echo "${c_set}#### Finalizing buildout${c_reset}"
sed -e "14s/$/_project/" buildout.cfg > temp.cfg
rm buildout.cfg
mv temp.cfg buildout.cfg
sed -e "19s/.settings.base/_project.settings.base/" bin/django > bin/django2
rm bin/django
mv bin/django2 bin/django
./bin/buildout
