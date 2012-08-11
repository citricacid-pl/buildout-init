This script is basing on http://jacobian.org/writing/django-apps-with-buildout/

It is a dirty and tested only on my machine bash script creating buildout environment with django recipe.
Basic project and app are set.

**Tested on my computer only with Ubuntu 12.04**

Installation
============

With terminal navigate to the folder where this script is and type

<code>
sudo sh install.sh
</code>

This will install a symbolic link: /usr/bin/buildout-init

Usage
=====

With terminal navigate to your workspace folder where all your projects are, fe.

<code>
cd ~/Workspace
</code>

Then run the script

<code>
buildout-init MyProjectName
</code>

This will create a folder *MyProjectName*.
Inside there will be whole buildout environment.
The directory structure will look like this:

<pre>
~/Workspace/MyProjectName
├── bin
│   ├── buildout
│   ├── django
│   └── python
├── bootstrap.py
├── buildout.cfg
├── develop-eggs
│   └── django-MyProjectName.egg-link
├── eggs
│   ├── Django-1.4.1-py2.7.egg
│   ├── djangorecipe-1.2.1-py2.7.egg
│   ├── setuptools-0.6c12dev_r88846-py2.7.egg
│   ├── zc.buildout-1.5.2-py2.7.egg
│   └── zc.recipe.egg-1.3.2-py2.7.egg
├── parts
│   └── buildout
│       ├── sitecustomize.py
│       ├── sitecustomize.pyc
│       ├── sitecustomize.pyo
│       ├── site.py
│       ├── site.pyc
│       └── site.pyo
├── setup.py
└── src
    ├── django_MyProjectName.egg-info
    ├── manage.py
    ├── MyProjectName_app
    │   ├── __init__.py
    │   ├── models.py
    │   ├── tests.py
    │   └── views.py
    └── MyProjectName_project
        ├── __init__.py
        ├── settings
        ├── urls.py
        └── wsgi.py
</pre>
